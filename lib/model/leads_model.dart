import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:wooodapp/controller/controller.dart';
import 'package:wooodapp/main.dart';
import 'package:wooodapp/model/item_model.dart';
import 'package:wooodapp/screens/main_page.dart';
import 'package:get/get.dart';

class LeadsModel {
  String lead_source;
  String name;
  String mobile_no;
  String address;
  String item;
  String item_desc; //
  String status;
  String doc_id; //
  String uploader;
  String item_code;

  LeadsModel(
      {required this.lead_source,
      required this.name,
      required this.mobile_no,
      required this.address,
      required this.item,
      required this.item_desc,
      required this.status,
      required this.uploader,
      this.item_code = '',
      this.doc_id = ''});

  Future<void> addLeadsData() async {
    final docs = await db.listDocuments(
        databaseId: databaseId,
        collectionId: itemCollectionId,
        queries: [Query.equal('item_name', item)]);
    docs.documents.forEach((element) {
      item_code = element.data['item_code'];
      status =
          int.parse(element.data['units']) <= 0 ? 'Out Of Stock' : 'In Stock';
    });
    await db.createDocument(
        databaseId: databaseId,
        collectionId: leadsCollectionId,
        documentId: 'unique()',
        data: {
          'lead_source': lead_source,
          'name': name,
          'mobile_no': mobile_no,
          'address': address,
          'item_desc': item_desc,
          'status': status,
          'uploader': uploader,
          'item': item,
          'item_code': item_code
        });
  }
}

void testfunadd() async {
  for (int i = 0; i < 30; i++) {
    await db.createDocument(
        databaseId: databaseId,
        collectionId: leadsCollectionId,
        documentId: 'unique()',
        data: {
          'lead_source': 'leadSource$i',
          'name': ' name$i',
          'mobile_no': 'mobile_no $i',
          'item_code': 'item code $i',
          'address': 'address $i',
          'item_desc': 'item_desc $i',
          'status': 'status $i',
          'uploader': '63ab4094ec33e218b8cd',
          'item': 'item $i'
        });
  }
}

void deletetest() async {
  final docs = await db.listDocuments(
      databaseId: databaseId, collectionId: leadsCollectionId);
  docs.documents.forEach((element) async {
    await db.deleteDocument(
        databaseId: databaseId,
        collectionId: leadsCollectionId,
        documentId: element.$id);
  });
}

void getLeadsData(BuildContext context) async {
  leads_model_list.clear();
  Get.find<ViewController>(tag: 'viewcont').isLoading.value = true;
  try {
    final docs = await db.listDocuments(
        databaseId: databaseId,
        collectionId: leadsCollectionId,
        queries: [Query.limit(100)]);
    docs.documents.forEach((element) async {
      final user = await acc.get();
      if (user.$id == element.data['uploader'] || isAdmin) {
        final d2c = await db.listDocuments(
            databaseId: databaseId,
            collectionId: itemCollectionId,
            queries: [Query.equal('item_name', element.data['item'])]);
        leads_model_list.add(LeadsModel(
            doc_id: element.$id,
            lead_source: element.data['lead_source'],
            name: element.data['name'],
            mobile_no: element.data['mobile_no'],
            address: element.data['address'],
            item_desc: element.data['item_desc'],
            item: element.data['item'],
            item_code: element.data['item_code'],
            uploader: element.data['uploader'],
            status: int.parse(d2c.documents.first.data['units']) <= 0
                ? 'Out Of Stock'
                : 'In Stock'));
        Get.find<ViewController>(tag: 'viewcont').leadI.value++;
      }
    });
  } on AppwriteException catch (e) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: ((context) => WarningBox(e)));
  } finally {
    Get.find<ViewController>(tag: 'viewcont').isLoading.value = false;
    Get.find<ViewController>(tag: 'viewcont').leadI.value++;
  }
}

void avoidLeadsDuplicates() {
  var seen = Set<String>();
  leads_model_list =
      leads_model_list.where((element) => seen.add(element.doc_id)).toList();
}

void searchLeadsData(String query) async {
  leads_model_list.clear();
  var docs = await db.listDocuments(
      databaseId: databaseId,
      collectionId: leadsCollectionId,
      queries: [Query.search('lead_source', query)]);
  docs.documents.forEach((element) {
    leads_model_list.add(LeadsModel(
        doc_id: element.$id,
        lead_source: element.data['lead_source'],
        name: element.data['name'],
        mobile_no: element.data['mobile_no'],
        address: element.data['address'],
        item_desc: element.data['item_desc'],
        item: element.data['item'],
        item_code: element.data['item_code'],
        uploader: element.data['uploader'],
        status: element.data['status']));
  });
  docs = await db.listDocuments(
      databaseId: databaseId,
      collectionId: leadsCollectionId,
      queries: [Query.search('name', query)]);
  docs.documents.forEach((element) {
    leads_model_list.add(LeadsModel(
        doc_id: element.$id,
        lead_source: element.data['lead_source'],
        name: element.data['name'],
        mobile_no: element.data['mobile_no'],
        address: element.data['address'],
        item_desc: element.data['item_desc'],
        item: element.data['item'],
        item_code: element.data['item_code'],
        uploader: element.data['uploader'],
        status: element.data['status']));
  });

  Get.find<ViewController>(tag: 'viewcont').leadI.value++;
}



void deleteLeadsData(BuildContext context, String doc_id) async {
  try {
    await db.deleteDocument(
        databaseId: databaseId,
        collectionId: leadsCollectionId,
        documentId: doc_id);
    getLeadsData(context);
  } on AppwriteException catch (e) {
    showDialog(context: context, builder: (context) => WarningBox(e));
  }
}

void updateLeadsData(
    BuildContext context, String doc_id, LeadsModel item) async {
  try {
    final docs = await db.listDocuments(
        databaseId: databaseId,
        collectionId: itemCollectionId,
        queries: [Query.equal('item_name', item.item)]);
    docs.documents.forEach((element) {
      item.item_code = element.data['item_code'];
      item.status =
          int.parse(element.data['units']) == 0 ? 'Out Of Stock' : 'In Stock';
    });
    await db.updateDocument(
        databaseId: databaseId,
        collectionId: leadsCollectionId,
        documentId: doc_id,
        data: {
          'lead_source': item.lead_source,
          'name': item.name,
          'mobile_no': item.mobile_no,
          'address': item.address,
          'item_desc': item.item_desc,
          'item_code': item.item_code,
          'status': item.status,
          'item': item.item
        });
    Get.off(() => MainPage());
  } on AppwriteException catch (e) {
    Get.off(() => MainPage());
    showDialog(context: context, builder: (context) => WarningBox(e));
  }
}

Future<Document?> getSingleLeadsData(
    BuildContext context, String doc_id) async {
  try {
    final data = await db.getDocument(
        databaseId: databaseId,
        collectionId: leadsCollectionId,
        documentId: doc_id);
    return data;
  } on AppwriteException catch (e) {
    showDialog(context: context, builder: (context) => WarningBox(e));
    return null;
  }
}

Widget WarningBox(AppwriteException e) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 300),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    child: SizedBox(
      width: Get.width-50,
      child: Center(
        child: SizedBox(
          width:Get.width-40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning),
              Text(
                e.message.toString().split(':').first.split('.').first ==
                        'Failed host lookup'
                    ? 'No Connection!!'
                    : e.message.toString().split(':').first.split('.').first + '!!',
                style: TextStyle(fontSize: 20),
              ),
              Icon(Icons.warning),
            ],
          ),
        ),
      ),
    ),
  );
}

final leadsCollectionId = '63ab3240c0d23224e6d5';

List<LeadsModel> leads_model_list = [];
