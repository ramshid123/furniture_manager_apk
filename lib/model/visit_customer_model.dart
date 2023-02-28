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

class GoCustomerModel {
  String name;
  String mobile_no;
  String ref_no;
  String address;
  String visit_date;
  String visit_desc;
  String uploader;
  // String move_option;

  GoCustomerModel(
      {required this.address,
      required this.mobile_no,
      required this.name,
      required this.visit_date,
      required this.visit_desc,
      required this.uploader,
      this.ref_no = ''});

  // void addGoCustomerData() {
  //   go_customer_model_list.add(GoCustomerModel(
  //       address: address,
  //       item_desc: item_desc,
  //       move_option: move_option,
  //       name: name,
  //       visit_date: visit_date,
  //       visit_desc: visit_desc));
  // }

  void addGoCustomerData() async {
    await db.createDocument(
        databaseId: databaseId,
        collectionId: goCustomerCollectionId,
        documentId: 'unique()',
        data: {
          'address': address,
          'mobile_no': mobile_no,
          'uploader': uploader,
          'name': name,
          'visit_date': visit_date,
          'visit_desc': visit_desc,
          'ref_no': ref_no,
        });
    final docs = await db.listDocuments(
        databaseId: databaseId, collectionId: goCustomerCollectionId);
    docs.documents.forEach((element) async {
      await db.updateDocument(
          databaseId: databaseId,
          collectionId: goCustomerCollectionId,
          documentId: element.$id,
          data: {'ref_no': element.$id});
    });
    Get.find<ViewController>(tag: 'viewcont').visI.value++;
  }
}

Future<void> getGoCustomerData(BuildContext context) async {
  go_customer_model_list.clear();
  activities_list.clear();
  Get.find<ViewController>(tag: 'viewcont').isLoading.value = true;
  try {
    final docs = await db.listDocuments(
        databaseId: databaseId, collectionId: goCustomerCollectionId);
    docs.documents.forEach((element) async {
      final user = await acc.get();
      if (user.$id == element.data['uploader'] || isAdmin) {
        go_customer_model_list.add(GoCustomerModel(
            address: element.data['address'],
            mobile_no: element.data['mobile_no'],
            name: element.data['name'],
            ref_no: element.data['ref_no'],
            visit_date: element.data['visit_date'],
            uploader: element.data['uploader'],
            visit_desc: element.data['visit_desc']));
        Get.find<ViewController>(tag: 'viewcont').visI.value++;
      }
    });
  } on AppwriteException catch (e) {
    showDialog(context: context, builder: (context) => WarningBox(e));
  } finally {
    Get.find<ViewController>(tag: 'viewcont').isLoading.value = false;
    Get.find<ViewController>(tag: 'viewcont').visI.value++;
  }
}

void searchGoCustomerData(String query) async {
  go_customer_model_list.clear();
  var docs = await db.listDocuments(
      databaseId: databaseId,
      collectionId: goCustomerCollectionId,
      queries: [Query.search('name', query)]);
  docs.documents.forEach((element) {
    go_customer_model_list.add(GoCustomerModel(
        ref_no: element.$id,
        name: element.data['name'],
        address: element.data['address'],
        mobile_no: element.data['mobile_no'],
        uploader: element.data['uploader'],
        visit_date: element.data['visit_date'],
        visit_desc: element.data['visit_desc']));
  });
  docs = await db.listDocuments(
      databaseId: databaseId,
      collectionId: goCustomerCollectionId,
      queries: [Query.search('mobile_no', query)]);
  docs.documents.forEach((element) {
    go_customer_model_list.add(GoCustomerModel(
        ref_no: element.$id,
        name: element.data['name'],
        address: element.data['address'],
        mobile_no: element.data['mobile_no'],
        uploader: element.data['uploader'],
        visit_date: element.data['visit_date'],
        visit_desc: element.data['visit_desc']));
  });
  Get.find<ViewController>(tag: 'viewcont').visI.value++;
}

void avoidGoCustDuplicates() {
  go_customer_model_list.sort((b,a) => DateFormat("MMMM dd, yyyy")
        .parse(a.visit_date)
        .millisecondsSinceEpoch
        .compareTo(DateFormat("MMMM dd, yyyy")
            .parse(b.visit_date)
            .millisecondsSinceEpoch));
  var seen = Set<String>();
  go_customer_model_list = go_customer_model_list
      .where((element) => seen.add(element.ref_no))
      .toList();
}

void deleteGoCustomerData(BuildContext context, String doc_id) async {
  try {
    await db.deleteDocument(
        databaseId: databaseId,
        collectionId: goCustomerCollectionId,
        documentId: doc_id);
    getGoCustomerData(context);
  } on AppwriteException catch (e) {
    showDialog(context: context, builder: (context) => WarningBox(e));
  }
}

void updateGoCustomerData(
    BuildContext context, String doc_id, GoCustomerModel item) async {
  try {
    await db.updateDocument(
        databaseId: databaseId,
        collectionId: goCustomerCollectionId,
        documentId: doc_id,
        data: {
          'address': item.address,
          'name': item.name,
          'ref_no': doc_id,
          'visit_date': item.visit_date,
          'visit_desc': item.visit_desc,
          'mobile_no': item.mobile_no,
        });
    Get.off(() => MainPage());
  } on AppwriteException catch (e) {
    Get.off(() => MainPage());
    showDialog(context: context, builder: (context) => WarningBox(e));
  } finally {
    Get.find<ViewController>(tag: 'viewcont').currentPageIndex.value = 2;
  }
}

Future<Document?> getSingleGoCustomerData(
    BuildContext context, String doc_id) async {
  try {
    final data = await db.getDocument(
        databaseId: databaseId,
        collectionId: goCustomerCollectionId,
        documentId: doc_id);
    return data;
  } on AppwriteException catch (e) {
    showDialog(context: context, builder: (context) => WarningBox(e));
    return null;
  }
}

final goCustomerCollectionId = '63ab3b904bf7d25150a5';

List<GoCustomerModel> go_customer_model_list = [];
