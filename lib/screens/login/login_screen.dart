import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wooodapp/controller/controller.dart';
import 'package:wooodapp/model/account_model.dart';
import 'package:wooodapp/services/auth.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final username = TextEditingController();
  final password = TextEditingController();

  final _fkey = GlobalKey<FormState>();

  dynamic msg = '';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: ()async{
        return false;
      },
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(color: Color.fromARGB(179, 181, 181, 181)),
          child: Center(
            child: Container(
              height: (size.height / 8) * 6,
              width: (size.width / 8) * 7,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.transparent),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.only(topRight: Radius.circular(150))),
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Form(
                    key: _fkey,
                    child: Column(
                      children: [
                        SizedBox(height: 40),
                        Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Please enter your details',
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                        SizedBox(height: 50),
                        LoginTextField(name: 'Username', cont: username),
                        SizedBox(height: 20),
                        LoginTextField(
                            name: 'Password', cont: password, isPassword: true),
                        SizedBox(height: 10),
                        Obx(() {
                          print(Get.find<ViewController>(tag: 'viewcont')
                              .loginI
                              .value);
                          return Text(
                            msg,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                            ),
                          );
                        }),
                        TextButton(
                          onPressed: () {
                            Get.showSnackbar(GetSnackBar(
                              message: 'Please contact your supervisor or admin',
                              backgroundColor: Colors.green,
                              isDismissible: true,
                              duration: Duration(seconds: 3),
                              margin: EdgeInsets.symmetric(vertical: 100),
                              icon: Icon(Icons.admin_panel_settings_rounded),
                              maxWidth: 300,
                              overlayBlur: 2,
                              borderRadius: 20,
                              padding: EdgeInsets.all(30),
                              overlayColor: Colors.black26,
                              snackPosition: SnackPosition.TOP,
                            ));
                          },
                          child: Text(
                            'Forgot password',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.blue),
                          ),
                        ),
                        SizedBox(height: 20),
                        Obx(() {
                          return Get.find<ViewController>(tag: 'viewcont')
                                  .isLoading
                                  .value
                              ? Center(child: CircularProgressIndicator())
                              : GestureDetector(
                                  child: Container(
                                    height: 50,
                                    width: 300,
                                    decoration: BoxDecoration(
                                      color: Colors.blue[800],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  onTap: () async {
                                    if (_fkey.currentState!.validate()) {
                                      user = username.text;
                                      pass = password.text;
                                      msg = await AuthService()
                                          .Login(username.text, password.text);
                                      print(msg);
                                    }
                                  },
                                );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget LoginTextField(
    {bool isPassword = false,
    required String name,
    required TextEditingController cont}) {
  return TextFormField(
    style: TextStyle(color: Colors.black),
    obscureText: isPassword,
    controller: cont,
    decoration: InputDecoration(
        hintText: 'Enter $name',
        labelText: name,
        labelStyle: TextStyle(color: Colors.blue[500]),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        )),
    validator: (val) {
      return val!.isEmpty || val.contains(' ')
          ? 'Please Enter Valid Details'
          : null;
    },
  );
}
