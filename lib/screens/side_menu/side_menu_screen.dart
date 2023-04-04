import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:wooodapp/controller/controller.dart';
import 'package:wooodapp/main.dart';
import 'package:wooodapp/model/account_model.dart';
import 'package:wooodapp/services/auth.dart';
import 'package:get/get.dart';

final buttonsname = [
  'Dashboard',
  'Leads',
  'Customers',
  'Go Customer',
  'Sales',
  'Purchase Order',
  'Report',
  'Items',
  'Manage Accounts',
  'Logout'
];

final buttonsIcons = [
  Icons.dashboard,
  Icons.folder_shared_rounded,
  Icons.person,
  Icons.location_pin,
  Icons.business_center_rounded,
  Icons.outlined_flag_rounded,
  Icons.report,
  Icons.list_alt_sharp,
  Icons.manage_accounts,
  Icons.logout
];

class SideMenu extends StatelessWidget {
  SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return IntrinsicWidth(
      child: Container(
        height: double.infinity,
        color: Colors.grey[700],
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black26,
                    radius: 40,
                    child: Center(
                        // child: Text(
                        //   currentUserName[0].toUpperCase(),
                        //   style: TextStyle(fontSize: 50, color: Colors.white),
                        // ),
                        child: currentUserPic == 'default'
                            ? Text(
                                currentUserName[0].toUpperCase(),
                                style: TextStyle(
                                    fontSize: 50, color: Colors.white),
                              )
                            : CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage('$endPoint/storage/buckets/$profilePhotoBucketId/files/${currentUserPic}/view?project=64296421a251168288ea'),
                      )),
                  ),
                  SizedBox(height: 5),
                  SizedBox(
                    width: 250,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Center(
                        child: Text(
                          currentUserName,
                          overflow: TextOverflow.visible,
                          softWrap: true,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 50),
              for (int i = 0; i < buttonsname.length; i++)
                Visibility(
                  visible:
                      (buttonsname[i] == 'Manage Accounts') ? isAdmin : true,
                  child: SideMenuButton(
                    name: buttonsname[i],
                    width: size.width / 6,
                    index: i,
                    icon: buttonsIcons[i],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

class SideMenuButton extends StatelessWidget {
  final int index;
  final String name;
  final double width;
  final IconData icon;
  SideMenuButton(
      {Key? key,
      required this.name,
      required this.width,
      required this.index,
      required this.icon})
      : super(key: key);

  final cont = Get.find<ViewController>(tag: 'viewcont');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: GestureDetector(
        child: Container(
          padding: EdgeInsets.all(5),
          height: 40,
          decoration: BoxDecoration(
            color: cont.selectedButton.value == index
                ? Colors.blue
                : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              SizedBox(width: 10),
              Icon(
                icon,
                color: Colors.black54,
              ),
              SizedBox(width: 10),
              Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          if (name == 'Logout') {
            Get.back();
            showDialog(
              barrierDismissible: true,
              context: context,
              builder: (context) => Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 250),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Material(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: Column(
                    children: [
                      SizedBox(height: 50),
                      SizedBox(
                        height: 30,
                        child: 
                           Center(
                            child: Text(
                              'Do you want to Logout?',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                       
                      ),
                      SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () async {
                              await AuthService().Logout();
                            },
                            child: Text(
                              'Logout',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(width: 30),
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text(
                              'Go Back',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          } else {
            cont.currentPageIndex.value = index;
            cont.selectedButton.value = index;
            Get.back();
          }
        },
      ),
    );
  }
}
