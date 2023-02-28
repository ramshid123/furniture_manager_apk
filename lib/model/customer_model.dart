import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wooodapp/controller/controller.dart';
import 'package:wooodapp/main.dart';
import 'package:wooodapp/model/activities_model.dart';
import 'package:wooodapp/model/item_model.dart';
import 'package:wooodapp/model/leads_model.dart';
import 'package:wooodapp/screens/main_page.dart';
import 'package:get/get.dart';

class CustomerModel {
  String name;
  String ref_no; //
  String address;
  String mobile_no;
  String item; //
  String item_code;
  String item_desc;
  String stock;
  // String arrival_date;
  String delivery_date; //
  String delivery_status; //

  String uploader;

  CustomerModel(
      {required this.address,
      required this.delivery_date,
      required this.delivery_status,
      required this.item,
      required this.item_desc,
      required this.mobile_no,
      required this.uploader,
      required this.name,
      this.item_code = '',
      this.stock = '',
      this.ref_no = ''});

  // void addCustomerData() {
  //   customer_model_list.add(CustomerModel(
  //       address: address,
  //       delivery_date: delivery_date,
  //       delivery_status: delivery_status,
  //       item: item,
  //       mobile_no: mobile_no,
  //       name: name,
  //       ref_no: ref_no));
  // }

  void addCustomerData() async {
    final doc2s = await db.listDocuments(
        databaseId: databaseId,
        collectionId: itemCollectionId,
        queries: [Query.equal('item_name', item)]);
    doc2s.documents.forEach((element) async {
      item_code = element.data['item_code'];
      stock =
          int.parse(element.data['units']) <= 0 ? 'Out Of Stock' : 'In Stock';
      await db.updateDocument(
          databaseId: databaseId,
          collectionId: itemCollectionId,
          documentId: element.$id,
          data: {'units': (int.parse(element.data['units']) - 1).toString()});
    });
    await db.createDocument(
        databaseId: databaseId,
        collectionId: customerCollectionId,
        documentId: 'unique()',
        data: {
          'address': address,
          'delivery_date': delivery_date,
          'delivery_status': delivery_status,
          'item': item,
          'item_desc': item_desc,
          'item_code': item_code,
          'stock': stock,
          'mobile_no': mobile_no,
          'name': name,
          'uploader': uploader,
          'ref_no': ref_no
        });
    final docs = await db.listDocuments(
        databaseId: databaseId, collectionId: customerCollectionId);
    docs.documents.forEach((element) async {
      await db.updateDocument(
          databaseId: databaseId,
          collectionId: customerCollectionId,
          documentId: element.$id,
          data: {'ref_no': element.$id});
    });
    Get.find<ViewController>(tag: 'viewcont').cusI.value++;
  }
}

Future<void> getCustomerData(BuildContext context) async {
  customer_model_list.clear();
  Get.find<ViewController>(tag: 'viewcont').isLoading.value = true;
  try {
    final docs = await db.listDocuments(
        databaseId: databaseId, collectionId: customerCollectionId);
    docs.documents.forEach((element) async {
      final user = await acc.get();
      if (user.$id == element.data['uploader'] || isAdmin) {
        final d2c = await db.listDocuments(
            databaseId: databaseId,
            collectionId: itemCollectionId,
            queries: [Query.equal('item_name', element.data['item'])]);
        customer_model_list.add(CustomerModel(
            address: element.data['address'],
            delivery_date: element.data['delivery_date'],
            delivery_status: element.data['delivery_status'],
            item: element.data['item'],
            item_desc: element.data['item_desc'],
            item_code: element.data['item_code'],
            stock: int.parse(d2c.documents.first.data['units']) <= 0
                ? 'Out Of Stock'
                : 'In Stock',
            mobile_no: element.data['mobile_no'],
            name: element.data['name'],
            uploader: element.data['uploader'],
            ref_no: element.data['ref_no']));
        Get.find<ViewController>(tag: 'viewcont').cusI.value++;
      }
    });
  } on AppwriteException catch (e) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => WarningBox(e));
  } finally {
    Get.find<ViewController>(tag: 'viewcont').isLoading.value = false;
    Get.find<ViewController>(tag: 'viewcont').cusI.value++;
  }
}

void avoidCustomerDuplciate() {
  customer_model_list.sort((b,a)=>DateFormat("MMMM dd, yyyy").parse(a.delivery_date).millisecondsSinceEpoch.compareTo(DateFormat("MMMM dd, yyyy").parse(b.delivery_date).millisecondsSinceEpoch));
  var seen = Set<String>();
  customer_model_list =
      customer_model_list.where((element) => seen.add(element.ref_no)).toList();
}

void searchCustomerData(String query) async {
  customer_model_list.clear();
  var docs = await db.listDocuments(
      databaseId: databaseId,
      collectionId: customerCollectionId,
      queries: [Query.search('name', query)]);
  docs.documents.forEach((element) {
    customer_model_list.add(CustomerModel(
        ref_no: element.$id,
        name: element.data['name'],
        mobile_no: element.data['mobile_no'],
        address: element.data['address'],
        item_desc: element.data['item_desc'],
        item: element.data['item'],
        item_code: element.data['item_code'],
        stock: element.data['stock'],
        uploader: element.data['uploader'],
        delivery_date: element.data['delivery_date'],
        delivery_status: element.data['delivery_status']));
  });
  docs = await db.listDocuments(
      databaseId: databaseId,
      collectionId: customerCollectionId,
      queries: [Query.search('mobile_no', query)]);
  docs.documents.forEach((element) {
    customer_model_list.add(CustomerModel(
        ref_no: element.$id,
        name: element.data['name'],
        mobile_no: element.data['mobile_no'],
        address: element.data['address'],
        item_desc: element.data['item_desc'],
        item: element.data['item'],
        item_code: element.data['item_code'],
        stock: element.data['stock'],
        uploader: element.data['uploader'],
        delivery_date: element.data['delivery_date'],
        delivery_status: element.data['delivery_status']));
  });

  Get.find<ViewController>(tag: 'viewcont').cusI.value++;
}

void deleteCustomerData(BuildContext context, String doc_id) async {
  try {
    final item = await db.getDocument(
        databaseId: databaseId,
        collectionId: customerCollectionId,
        documentId: doc_id);
    final doc2s = await db.listDocuments(
        databaseId: databaseId,
        collectionId: itemCollectionId,
        queries: [Query.equal('item_name', item.data['item'])]);
    doc2s.documents.forEach((element) async {
      await db.updateDocument(
          databaseId: databaseId,
          collectionId: itemCollectionId,
          documentId: element.$id,
          data: {'units': (int.parse(element.data['units']) + 1).toString()});
    });
    await db.deleteDocument(
        databaseId: databaseId,
        collectionId: customerCollectionId,
        documentId: doc_id);
    getCustomerData(context);
  } on AppwriteException catch (e) {
    showDialog(context: context, builder: (context) => WarningBox(e));
  }
}

void updateCustomerData(
    BuildContext context, String doc_id, CustomerModel item) async {
  try {
    final doc2s = await db.listDocuments(
        databaseId: databaseId,
        collectionId: itemCollectionId,
        queries: [Query.equal('item_name', item.item)]);
    doc2s.documents.forEach((element) {
      item.item_code = element.data['item_code'];
      item.stock =
          int.parse(element.data['units']) == 0 ? 'Out Of Stock' : 'In Stock';
    });
    await db.updateDocument(
        databaseId: databaseId,
        collectionId: customerCollectionId,
        documentId: doc_id,
        data: {
          'address': item.address,
          'delivery_date': item.delivery_date,
          'delivery_status': item.delivery_status,
          'item': item.item,
          'uploader': item.uploader,
          'item_desc': item.item_desc,
          'item_code': item.item_code,
          'stock': item.stock,
          'mobile_no': item.mobile_no,
          'name': item.name,
          'ref_no': doc_id
        });
    Get.off(() => MainPage());
  } on AppwriteException catch (e) {
    Get.off(() => MainPage());
    showDialog(context: context, builder: (context) => WarningBox(e));
  } finally {
    Get.find<ViewController>(tag: 'viewcont').currentPageIndex.value = 2;
  }
}

Future<Document?> getSingleCustomerData(
    BuildContext context, String doc_id) async {
  try {
    final data = await db.getDocument(
        databaseId: databaseId,
        collectionId: customerCollectionId,
        documentId: doc_id);
    return data;
  } on AppwriteException catch (e) {
    showDialog(context: context, builder: (context) => WarningBox(e));
    return null;
  }
}

final customerCollectionId = '63ab38240d99b2f10e34';

List<CustomerModel> customer_model_list = [];
