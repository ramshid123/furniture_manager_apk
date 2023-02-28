import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wooodapp/controller/controller.dart';
import 'package:wooodapp/main.dart';
import 'package:wooodapp/model/account_model.dart';
import 'package:wooodapp/screens/login/login_screen.dart';
import 'package:wooodapp/screens/main_page.dart';
import 'package:get/get.dart';

var user = '';
var pass = '';

class AuthService {
  Future<String?> Login(String email, String password,{bool isFromLoginPage = true}) async {
    Get.find<ViewController>(tag: 'viewcont').isLoading.value = true;
    try {
      await acc
          .createEmailSession(email: email, password: password)
          .then((value) async {

            final pref=await SharedPreferences.getInstance();
        pref.setString('email',email);
        pref.setString('password', password);

        final s = await acc.get();
        final detl = await db.listDocuments(
            databaseId: databaseId,
            collectionId: accountsCollectionId,
            queries: [Query.equal('user_id', s.$id)]);

        final userList = await db.listDocuments(
            databaseId: databaseId,
            collectionId: accountsCollectionId,
            queries: [Query.equal('email', email)]);

        if (userList.documents.isNotEmpty || email==superAdmin) {
          /////////////////////////////////////
          dynamic f = await acc.get();
          currentUserName = f.name.toString();
          currentUserEmail = email;
          currentUserPass = password;
          if (email != superAdmin) {
            isAdmin = (detl.documents.first.data['role'] == 'Admin' ||
                    email == superAdmin)
                ? true
                : false;
            currentUserPic = detl.documents.first.data['photo'];
          } else {
            isAdmin = true;
            currentUserPic = 'default';
          }
           if(isFromLoginPage){Get.off(()=>MainPage());}
        } else {
          await acc.deleteSessions();
          Get.snackbar(
            'This Email does not Exist.',
            'There is no account with this Email.Check you details or contact your admin.',
            titleText: Text('This Email does not Exist.',
                style: TextStyle(color: Colors.white, fontSize: 17)),
            messageText: Text(
              'There is no account with this Email.Check you details or contact your admin.',
              style: TextStyle(color: Colors.white),
            ),
            margin: EdgeInsets.all(30),
            backgroundColor: Colors.orange[700],
            snackPosition: SnackPosition.BOTTOM,
            borderColor: Colors.transparent,
            borderRadius: 20,
            borderWidth: 2,
            barBlur: 1,
          );
        }
      });
      return '';
    } on AppwriteException catch (e) {
      print(e.message);
      if (e.message!
          .contains('Rate limit for the current endpoint has been exceeded')) {
        return 'Too much Requests';
      } else {
        return e.message!.split(':')[0].split('.')[0];
      }
    } finally {
      Get.find<ViewController>(tag: 'viewcont').isLoading.value = false;
      Get.find<ViewController>(tag: 'viewcont').loginI.value++;
    }
  }

  void SignUp(String userId, String email, String password) async {
    try {
      await acc
          .create(userId: userId, email: email, password: password)
          .then((value) => Get.off(MainPage()));
    } on AppwriteException catch (e) {
      print(e.message);
    }
  }

  Future Logout() async {
    try {
      Get.off(() => LoginScreen());
      final pref = await SharedPreferences.getInstance();
      await pref.clear();
      await acc.deleteSessions();
    } on AppwriteException catch (e) {
      print(e.message);
    } finally {
      Get.find<ViewController>(tag: 'viewcont').currentPageIndex.value = 0;
      Get.find<ViewController>(tag: 'viewcont').selectedButton.value = 0;
      Get.find<ViewController>(tag: 'viewcont').isLoading.value=false;
    }
  }

  // void checkAuthStatus() async {
  //   realtime.subscribe(['account']).stream.listen((event) {
  //         final s = event.payload;
  //         if (s.containsKey('userId')) {
  //           Get.off(() => MainPage());
  //         } else {
  //           Get.off(() => LoginScreen());
  //         }
  //       });
  // }
}
