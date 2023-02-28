import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wooodapp/controller/controller.dart';
import 'package:wooodapp/main.dart';
import 'package:wooodapp/model/activities_model.dart';
import 'package:wooodapp/model/item_model.dart';
import 'package:wooodapp/model/leads_model.dart';
import 'package:wooodapp/model/purchase_model_pdf_slip.dart';
import 'package:wooodapp/screens/main_page.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pd;
import 'package:printing/printing.dart';

class PurchaseOrderModel {
  String supplier_name;
  String arrival_date;
  String item_name;
  String item_code;
  String item_desc;
  String order_status;
  String quantity;
  String uploader;
  String ref_no;

  PurchaseOrderModel({
    required this.supplier_name,
    required this.arrival_date,
    required this.item_name,
    this.item_code = '',
    required this.item_desc,
    required this.quantity,
    required this.order_status,
    required this.uploader,
    this.ref_no = '',
  });

  void addPurchaseOrderData() async {
    final doc2s = await db.listDocuments(
        databaseId: databaseId,
        collectionId: itemCollectionId,
        queries: [Query.equal('item_name', item_name)]);
    item_code = doc2s.documents.first.data['item_code'];
    await db.createDocument(
        databaseId: databaseId,
        collectionId: purchaseCollectionId,
        documentId: 'unique()',
        data: {
          'supplier_name': supplier_name,
          'arrival_date': arrival_date,
          'item_name': item_name,
          'item_code': item_code,
          'item_desc': item_desc,
          'quantity': quantity,
          'order_status': order_status,
          'ref_no': ref_no,
          'uploader': uploader,
        });
    final docs = await db.listDocuments(
        databaseId: databaseId, collectionId: purchaseCollectionId);
    docs.documents.forEach((element) async {
      await db.updateDocument(
          databaseId: databaseId,
          collectionId: purchaseCollectionId,
          documentId: element.$id,
          data: {'ref_no': element.$id});
    });
    getItemsForListing();
    await db.updateDocument(
        databaseId: databaseId,
        collectionId: itemCollectionId,
        documentId: doc2s.documents.first.$id,
        data: {
          'units': (int.parse(doc2s.documents.first.data['units']) +
                  int.parse(quantity))
              .toString(),
        });
    Get.find<ViewController>(tag: 'viewcont').poI.value++;
  }
}

Future<void> getPurchaseData(BuildContext context) async {
  purchase_order_model_list.clear();
  Get.find<ViewController>(tag: 'viewcont').isLoading.value = true;
  try {
    final docs = await db.listDocuments(
        databaseId: databaseId, collectionId: purchaseCollectionId);
    docs.documents.forEach((element) async {
      final user = await acc.get();
      if (user.$id == element.data['uploader'] || isAdmin) {
        final d2c = await db.listDocuments(
            databaseId: databaseId,
            collectionId: itemCollectionId,
            queries: [Query.equal('item_name', element.data['item_name'])]);
        purchase_order_model_list.add(PurchaseOrderModel(
            supplier_name: element.data['supplier_name'],
            arrival_date: element.data['arrival_date'],
            order_status: element.data['order_status'],
            item_name: element.data['item_name'],
            item_desc: element.data['item_desc'],
            item_code: element.data['item_code'],
            quantity: element.data['quantity'],
            uploader: element.data['uploader'],
            ref_no: element.data['ref_no']));
        Get.find<ViewController>(tag: 'viewcont').poI.value++;
      }
    });
  } on AppwriteException catch (e) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => WarningBox(e));
  } finally {
    Get.find<ViewController>(tag: 'viewcont').isLoading.value = false;
    Get.find<ViewController>(tag: 'viewcont').poI.value++;
  }
}

void deletePOData(BuildContext context, String doc_id) async {
  try {
    await db.deleteDocument(
        databaseId: databaseId,
        collectionId: purchaseCollectionId,
        documentId: doc_id);
        getPurchaseData(context);
  } on AppwriteException catch (e) {
    showDialog(context: context, builder: (context) => WarningBox(e));
  }
}

void avoidPODuplicates() {
  var seen = Set<String>();
  purchase_order_model_list = purchase_order_model_list
      .where((element) => seen.add(element.ref_no))
      .toList();
}

Future<void> printDoc(PurchaseOrderModel element) async {
  final doc = pd.Document();
  doc.addPage(pd.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pd.Context context) {
        return buildpdf(element);
      }));
  await Printing.layoutPdf(
    name: 'slip.pdf',
    format: PdfPageFormat.a4,
    onLayout: (PdfPageFormat format) async => doc.save(),
  );
}

Future<Document?> getSinglePurchaseOrderData(
    BuildContext context, String doc_id) async {
  try {
    final data = await db.getDocument(
        databaseId: databaseId,
        collectionId: purchaseCollectionId,
        documentId: doc_id);
    return data;
  } on AppwriteException catch (e) {
    showDialog(context: context, builder: (context) => WarningBox(e));
    return null;
  }
}

void searchPurchaseData(String query) async {
  purchase_order_model_list.clear();
  var docs = await db.listDocuments(
      databaseId: databaseId,
      collectionId: purchaseCollectionId,
      queries: [Query.search('name', query)]);
  docs.documents.forEach((element) {
    purchase_order_model_list.add(PurchaseOrderModel(
      ref_no: element.$id,
      supplier_name: element.data['supplier_name'],
      arrival_date: element.data['arrival_date'],
      item_name: element.data['item_name'],
      item_code: element.data['item_code'],
      item_desc: element.data['item_desc'],
      quantity: element.data['quantity'],
      order_status: element.data['order_status'],
      uploader: element.data['uploader'],
    ));
  });
  docs = await db.listDocuments(
      databaseId: databaseId,
      collectionId: purchaseCollectionId,
      queries: [Query.search('mobile_no', query)]);
  docs.documents.forEach((element) {
    purchase_order_model_list.add(PurchaseOrderModel(
      ref_no: element.$id,
      supplier_name: element.data['supplier_name'],
      arrival_date: element.data['arrival_date'],
      item_name: element.data['item_name'],
      item_code: element.data['item_code'],
      item_desc: element.data['item_desc'],
      quantity: element.data['quantity'],
      order_status: element.data['order_status'],
      uploader: element.data['uploader'],
    ));
  });
  Get.find<ViewController>(tag: 'viewcont').poI.value++;
}

List<PurchaseOrderModel> purchase_order_model_list = [];

final purchaseCollectionId = '63c19bd5e132ce451c12';
