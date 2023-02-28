import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:wooodapp/controller/controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final cont = Get.find<ViewController>(tag: 'viewcont');

  // void checkInternetConnection() async {
  //   try {
  //     final result = await InternetAddress.lookup('google.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       cont.isInternet.value = true;
  //     }
  //   } on SocketException catch (_) {
  //     cont.isInternet.value = false;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // checkInternetConnection();
    return Scaffold(
      body: Obx(() {
        return Center(
          child: cont.isInternet.value
              ? Image.asset(
                  'assets/woodCode2.png',
                  height: 300,
                  width: 300,
                  fit: BoxFit.cover,
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/no_con.jpg',
                      height: 300,
                      width: 300,
                      fit: BoxFit.cover,
                    ),
                    Text(
                      'No Connection',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Please connect to internet',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
        );
      }),
    );
  }
}
