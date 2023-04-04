import 'package:flutter/material.dart';
import 'package:wooodapp/controller/controller.dart';
import 'package:wooodapp/main.dart';
import 'package:wooodapp/screens/login/login_screen.dart';
import 'package:wooodapp/screens/side_menu/side_menu_screen.dart';
import 'package:wooodapp/services/auth.dart';
import 'package:get/get.dart';

final adminCollectionId = '63b8db00b6515f9792d5';

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  final cont = Get.find<ViewController>(tag: 'viewcont');
  @override
  Widget build(BuildContext context) {
    // AuthService().checkAuthStatus();
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        cont.currentPageIndex.value = 0;
        cont.selectedButton.value = 0;
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[700],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.grey[700],
          title: Obx(() {
            return Text(
              cont.currentPageIndex.value > 6
                  ? ''
                  : buttonsname[cont.currentPageIndex.value],
              style: TextStyle(
                  color: Colors.grey[100],
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            );
          }),
          centerTitle: true,
        ),
        drawer: SideMenu(),
        body: Obx(() {
          return Container(
            color: Colors.grey[900],
            child: Center(
                child: /*size.width <= 1000
                    ? Center(
                        child: Text(
                          'Please Change to Full Screen',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25
                          ),
                        ),
                      )
                    : */
                    screens[cont.currentPageIndex.value]),
          );
        }),
      ),
    );
  }
}
