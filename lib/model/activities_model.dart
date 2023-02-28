import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wooodapp/controller/controller.dart';
import 'package:wooodapp/main.dart';
import 'package:wooodapp/model/customer_model.dart';
import 'package:wooodapp/model/leads_model.dart';
import 'package:wooodapp/model/purchase_model.dart';
import 'package:wooodapp/model/visit_customer_model.dart';

class ActivityModel {
  ActivityType section;
  String info;
  String ref_no;

  ActivityModel(
      {required this.section, required this.info, required this.ref_no});
}

enum ActivityType { go_cust, po, del_cust }

void getActivities(BuildContext context) async {
  try {
    var docs = await db.listDocuments(
        databaseId: databaseId,
        collectionId: customerCollectionId,
        queries: [
          Query.equal(
              'delivery_date', DateFormat.yMMMMd().format(DateTime.now()))
        ]);
    docs.documents.forEach((element) {
      activities_list.add(ActivityModel(
          section: ActivityType.del_cust,
          info: element.data['name'],
          ref_no: element.data['ref_no']));
      // Get.find<ViewController>(tag: 'viewcont').actI.value++;
    });

    docs = await db.listDocuments(
        databaseId: databaseId,
        collectionId: purchaseCollectionId,
        queries: [
          Query.equal(
              'arrival_date', DateFormat.yMMMMd().format(DateTime.now()))
        ]);
    docs.documents.forEach((element) {
      activities_list.add(ActivityModel(
          section: ActivityType.po,
          info: element.data['item_name'],
          ref_no: element.data['ref_no']));
      // Get.find<ViewController>(tag: 'viewcont').actI.value++;
    });

    docs = await db.listDocuments(
        databaseId: databaseId,
        collectionId: goCustomerCollectionId,
        queries: [
          Query.equal('visit_date', DateFormat.yMMMMd().format(DateTime.now()))
        ]);
    docs.documents.forEach((element) {
      activities_list.add(ActivityModel(
          section: ActivityType.go_cust,
          info: element.data['name'],
          ref_no: element.data['ref_no']));
      // Get.find<ViewController>(tag: 'viewcont').actI.value++;
    });
  } on AppwriteException catch (e) {
    showDialog(context: context, builder: (context) => WarningBox(e));
  } finally {
    Get.find<ViewController>(tag: 'viewcont').actI.value++;
  }
}

void avoidActivitiesDuplicates() {
  var seen = Set<String>();
  activities_list =
      activities_list.where((element) => seen.add(element.ref_no)).toList();
}

List<ActivityModel> activities_list = [];
