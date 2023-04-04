import 'dart:math';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:wooodapp/controller/controller.dart';
import 'package:wooodapp/main.dart';
import 'package:wooodapp/model/leads_model.dart';
import 'package:wooodapp/screens/main_page.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ItemModel {
  String item_name;
  String item_code;
  String supplier;
  String img;
  String units;
  String doc_id;

  ItemModel(
      {required this.item_name,
      required this.item_code,
      required this.supplier,
      this.img = '',
      this.doc_id = '',
      required this.units});

  Future<void> addItemData({required XFile? res}) async {
    try {
      bool noDuplicationAndContinue = false;
      final dcss = await db.listDocuments(
          databaseId: databaseId,
          collectionId: itemCollectionId,
          queries: [Query.equal('item_name', item_name)]);
      // dcss.documents.forEach((element) {
      dcss.documents.isEmpty
          ? noDuplicationAndContinue = true
          : noDuplicationAndContinue = false;
      // });

      if (noDuplicationAndContinue) {
        final newDoc = await db.createDocument(
            databaseId: databaseId,
            collectionId: itemCollectionId,
            documentId: 'unique()',
            data: {
              'item_name': item_name,
              'item_code': item_code,
              'supplier': supplier,
              'units': units,
            });

        final newFile = await storage.createFile(
          bucketId: bucketId,
          fileId: 'unique()',
          file: InputFile(path: res!=null?res.path:'no_image'),
        );

        await db.updateDocument(
            databaseId: databaseId,
            collectionId: itemCollectionId,
            documentId: newDoc.$id,
            data: {
              'doc_id': newDoc.$id,
              'img': res!=null?newFile.$id:'no_image'
              // 'https://ddf8-129-154-237-199.in.ngrok.io/v1/storage/buckets/$bucketId/files/${v2.$id}/view?project=64296421a251168288ea'
            });
        print(newDoc.$id);
      } else {
        Get.snackbar(
          'Item Name already exist.',
          'There is alread an item with the given item name.Try another name.',
          titleText: Text('Item Name already exist.',
              style: TextStyle(color: Colors.white, fontSize: 17)),
          messageText: Text(
            'There is alread an item with the given item name.Try another name.',
            style: TextStyle(color: Colors.white),
          ),
          margin: EdgeInsets.all(30),
          backgroundColor: Colors.red[700],
          snackPosition: SnackPosition.BOTTOM,
          borderColor: Colors.transparent,
          borderRadius: 20,
          borderWidth: 2,
          barBlur: 1,
        );
      }
    } on AppwriteException catch (e) {
      print(e);
    }
  }
}

// FilePickerResult(files: [PlatformFile(path /home/user/Downloads/10136775_17973908.jpg, name: 10136775_17973908.jpg, bytes: null, readStream: null, size: 1377175)])
Future<void> testitemsadd() async {
  for (int i = 0; i < 10; i++) {
    final newDoc = await db.createDocument(
        databaseId: databaseId,
        collectionId: itemCollectionId,
        documentId: 'unique()',
        data: {
          'item_name': 'item_name$i',
          'item_code': (Random.secure().nextInt(999999) + 100000).toString(),
          'supplier': 'supplier$i',
          'units': '$i',
        });

    final newFile = await storage.createFile(
      bucketId: bucketId,
      fileId: 'unique()',
      file:
          InputFile(path: '/home/user/Downloads/613098d448f1e30004910187.png'),
    );

    await db.updateDocument(
        databaseId: databaseId,
        collectionId: itemCollectionId,
        documentId: newDoc.$id,
        data: {
          'doc_id': newDoc.$id,
          'img': newFile.$id
          // 'https://ddf8-129-154-237-199.in.ngrok.io/v1/storage/buckets/$bucketId/files/${v2.$id}/view?project=64296421a251168288ea'
        });
  }
}

void getItemsData(BuildContext context) async {
  item_model_list.clear();
  Get.find<ViewController>(tag: 'viewcont').isLoading.value = true;
  try {
    final docs = await db.listDocuments(
        databaseId: databaseId, collectionId: itemCollectionId);
    docs.documents.forEach((element) {
      item_model_list.add(ItemModel(
        doc_id: element.data['doc_id'],
        item_name: element.data['item_name'],
        item_code: element.data['item_code'],
        supplier: element.data['supplier'],
        units: element.data['units'],
        img: element.data['img'],
      ));
      Get.find<ViewController>(tag: 'viewcont').itemI.value++;
    });
  } on AppwriteException catch (e) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: ((context) => WarningBox(e)));
  } finally {
    Get.find<ViewController>(tag: 'viewcont').isLoading.value = false;
    Get.find<ViewController>(tag: 'viewcont').itemI.value++;
  }
}

Future<void> getItemsForListing() async {
  item_model_list.clear();
  try {
    final docs = await db.listDocuments(
        databaseId: databaseId, collectionId: itemCollectionId);
    docs.documents.forEach((element) {
      item_model_list.add(ItemModel(
        doc_id: element.data['doc_id'],
        item_name: element.data['item_name'],
        item_code: element.data['item_code'],
        supplier: element.data['supplier'],
        units: element.data['units'],
        img: element.data['img'],
      ));
      Get.find<ViewController>(tag: 'viewcont').itemI.value++;
    });
  } on AppwriteException catch (e) {
    print(e);
  } finally {Get.find<ViewController>(tag: 'viewcont').itemI.value++;}
  
}

void searchItemsData(String query) async {
  item_model_list.clear();
  var docs = await db.listDocuments(
      databaseId: databaseId,
      collectionId: itemCollectionId,
      queries: [Query.search('item_name', query)]);
  docs.documents.forEach((element) {
    item_model_list.add(ItemModel(
      item_name: element.data['item_name'],
      item_code: element.data['item_code'],
      doc_id: element.data['doc_id'],
      supplier: element.data['supplier'],
      units: element.data['units'],
      img: element.data['img'],
    ));
  });
  docs = await db.listDocuments(
      databaseId: databaseId,
      collectionId: itemCollectionId,
      queries: [Query.search('item_code', query)]);
  docs.documents.forEach((element) {
    item_model_list.add(ItemModel(
      item_name: element.data['item_name'],
      doc_id: element.data['doc_id'],
      item_code: element.data['item_code'],
      supplier: element.data['supplier'],
      units: element.data['units'],
      img: element.data['img'],
    ));
  });
}

avoidItemsDuplicates() {
  var seen = Set<String>();
  item_model_list =
      item_model_list.where((element) => seen.add(element.doc_id)).toList();
}

void deleteItemsData(BuildContext context, String doc_id, String img) async {
  try {
    await db.deleteDocument(
        databaseId: databaseId,
        collectionId: itemCollectionId,
        documentId: doc_id);
    await storage.deleteFile(bucketId: bucketId, fileId: img);
    getItemsData(context);
  } on AppwriteException catch (e) {
    showDialog(context: context, builder: (context) => WarningBox(e));
  }
}

Future<void> updateItemsData(
    BuildContext context, String doc_id, ItemModel item) async {
  try {
    await db.updateDocument(
        databaseId: databaseId,
        collectionId: itemCollectionId,
        documentId: doc_id,
        data: {
          'item_name': item.item_name,
          'item_code': item.item_code,
          'supplier': item.supplier,
          'doc_id': item.doc_id,
          'img': item.img,
          'units': item.units,
        });
    Get.off(() => MainPage());
  } on AppwriteException catch (e) {
    Get.off(() => MainPage());
    showDialog(context: context, builder: (context) => WarningBox(e));
  }
}

Future<Document?> getSingleItemsData(
    BuildContext context, String doc_id) async {
  try {
    final data = await db.getDocument(
        databaseId: databaseId,
        collectionId: itemCollectionId,
        documentId: doc_id);
    return data;
  } on AppwriteException catch (e) {
    showDialog(context: context, builder: (context) => WarningBox(e));
    return null;
  }
}

final itemCollectionId = '642984aa89bf68ab0b91';
List<ItemModel> item_model_list = [];
