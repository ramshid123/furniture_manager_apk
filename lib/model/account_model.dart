import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:wooodapp/controller/controller.dart';
import 'package:wooodapp/main.dart';
import 'package:wooodapp/model/leads_model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

bool isEmailExist = false;

class AccountModel {
  String name;
  String email;
  String mobile_no;
  String password;
  String photo;
  String role;
  String address;
  String user_id;
  String doc_id;

  AccountModel(
      {required this.name,
      required this.email,
      required this.mobile_no,
      required this.password,
      required this.address,
      this.photo = 'default',
      this.doc_id = '',
      required this.role,
      this.user_id = ""});

  Future<void> addAccount({required XFile? file}) async {
    final userList = await db.listDocuments(
        databaseId: databaseId,
        collectionId: accountsCollectionId,
        queries: [Query.equal('email', email)]);
    isEmailExist = userList.documents.isEmpty ? false : true;

    if (!isEmailExist) {
      final value1 = await db.createDocument(
          databaseId: databaseId,
          collectionId: accountsCollectionId,
          documentId: 'unique()',
          data: {
            'name': name,
            'email': email,
            'mobile_no': mobile_no,
            'password': password,
            'photo': photo,
            'role': role,
            'address': address,
            'user_id': user_id
          });
      var value2;
      bool emailAlreadyTakenError = false;
      try {
        value2 = await acc.create(
            userId: 'unique()', email: email, password: password, name: name);
        emailAlreadyTakenError = false;
      } on AppwriteException catch (e) {
        value2 = await acc.createEmailSession(email: email, password: password);
        await acc.deleteSessions();
        await acc.createEmailSession(
            email: currentUserEmail, password: currentUserPass);
        emailAlreadyTakenError = true;
      }
      dynamic newFile = (file == null || file.path.isEmpty || file.name.isEmpty)
          ? 'default'
          : await storage.createFile(
              bucketId: profilePhotoBucketId,
              fileId: 'unique()',
              file: InputFile(path: file.path));
      await db.updateDocument(
          databaseId: databaseId,
          collectionId: accountsCollectionId,
          documentId: value1.$id,
          data: {
            // 'user_id': value2.$id.toString(),
            'user_id': emailAlreadyTakenError ? value2.userId : value2.$id,
            'photo': newFile == 'default' ? newFile : newFile.$id,
          });
    } else {
      Get.snackbar(
        'Email already exist.',
        'There is already an user with the given email.Try another email.',
        titleText: Text('Item Email already exist.',
            style: TextStyle(color: Colors.white, fontSize: 17)),
        messageText: Text(
          'There is already an user with the given email.Try another email.',
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
  }
}

void getAccountData(BuildContext context) async {
  accounts_model_list.clear();
  Get.find<ViewController>(tag: 'viewcont').isLoading.value = true;
  try {
    final docs = await db.listDocuments(
        databaseId: databaseId, collectionId: accountsCollectionId);
    docs.documents.forEach((element) {
      if (isAdmin) {
        accounts_model_list.add(AccountModel(
          name: element.data['name'],
          email: element.data['email'],
          mobile_no: element.data['mobile_no'],
          password: element.data['password'],
          photo: element.data['photo'],
          user_id: element.data['user_id'],
          address: element.data['address'],
          role: element.data['role'],
          doc_id: element.$id,
        ));
        Get.find<ViewController>(tag: 'viewcont').accI.value++;
      }
    });
  } on AppwriteException catch (e) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: ((context) => WarningBox(e)));
  } finally {
    Get.find<ViewController>(tag: 'viewcont').isLoading.value = false;
    Get.find<ViewController>(tag: 'viewcont').accI.value++;
  }
}

void deleteAccountData(BuildContext context, String doc_id, String img) async {
  try {
    await db.deleteDocument(
        databaseId: databaseId,
        collectionId: accountsCollectionId,
        documentId: doc_id);
    if (img != 'default') {
      await storage.deleteFile(bucketId: profilePhotoBucketId, fileId: img);
    }
    getAccountData(context);
  } on AppwriteException catch (e) {
    showDialog(context: context, builder: (context) => WarningBox(e));
  }
}

void searchAccountData(String query) async {
  accounts_model_list.clear();
  var docs = await db.listDocuments(
      databaseId: databaseId,
      collectionId: accountsCollectionId,
      queries: [Query.search('name', query)]);
  docs.documents.forEach((element) {
    accounts_model_list.add(AccountModel(
      name: element.data['name'],
      email: element.data['email'],
      mobile_no: element.data['mobile_no'],
      password: element.data['password'],
      address: element.data['address'],
      photo: element.data['photo'],
      role: element.data['role'],
      user_id: element.data['user_id'],
    ));
  });
  docs = await db.listDocuments(
      databaseId: databaseId,
      collectionId: accountsCollectionId,
      queries: [Query.search('email', query)]);
  docs.documents.forEach((element) {
    accounts_model_list.add(AccountModel(
      name: element.data['name'],
      email: element.data['email'],
      mobile_no: element.data['mobile_no'],
      password: element.data['password'],
      address: element.data['address'],
      photo: element.data['photo'],
      role: element.data['role'],
      user_id: element.data['user_id'],
    ));
  });
  docs = await db.listDocuments(
      databaseId: databaseId,
      collectionId: accountsCollectionId,
      queries: [Query.search('mobile_no', query)]);
  docs.documents.forEach((element) {
    accounts_model_list.add(AccountModel(
      name: element.data['name'],
      email: element.data['email'],
      mobile_no: element.data['mobile_no'],
      password: element.data['password'],
      address: element.data['address'],
      photo: element.data['photo'],
      role: element.data['role'],
      user_id: element.data['user_id'],
    ));
  });

  docs = await db.listDocuments(
      databaseId: databaseId,
      collectionId: accountsCollectionId,
      queries: [Query.search('role', query)]);
  docs.documents.forEach((element) {
    accounts_model_list.add(AccountModel(
      name: element.data['name'],
      email: element.data['email'],
      mobile_no: element.data['mobile_no'],
      password: element.data['password'],
      address: element.data['address'],
      photo: element.data['photo'],
      role: element.data['role'],
      user_id: element.data['user_id'],
    ));
  });

  docs = await db.listDocuments(
      databaseId: databaseId,
      collectionId: accountsCollectionId,
      queries: [Query.search('user_id', query)]);
  docs.documents.forEach((element) {
    accounts_model_list.add(AccountModel(
      name: element.data['name'],
      email: element.data['email'],
      mobile_no: element.data['mobile_no'],
      password: element.data['password'],
      address: element.data['address'],
      photo: element.data['photo'],
      role: element.data['role'],
      user_id: element.data['user_id'],
    ));
  });

  // accounts_model_list = [...{...accounts_model_list}];
  Get.find<ViewController>(tag: 'viewcont').accI.value++;
}

avoidAccountsDuplicates() {
  var seen = Set<String>();
  accounts_model_list =
      accounts_model_list.where((element) => seen.add(element.email)).toList();
}

List<AccountModel> accounts_model_list = [];

final accountsCollectionId = '64297d3fdb71206dcdfc';
final profilePhotoBucketId = '642987418972d512c5fe';
