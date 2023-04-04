import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:wooodapp/controller/controller.dart';
import 'package:wooodapp/main.dart';
import 'package:wooodapp/model/account_model.dart';
import 'package:wooodapp/screens/items/items_page.dart';
import 'package:wooodapp/screens/leads/leads_page.dart';
import 'package:get/get.dart';

class ManageAccountsPage extends StatelessWidget {
  ManageAccountsPage({super.key});

  final cont = Get.find<ViewController>(tag: 'viewcont');

  @override
  Widget build(BuildContext context) {
    getAccountData(context);
    return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                pinned: true,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.grey[900],
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        accountSearchField(context),
                        IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                enableDrag: true,
                                context: context,
                                builder: ((context) => Container(
                                      color: Colors.black,
                                      width: double.infinity,
                                      height: 200,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              cont.currentPageIndex.value = 14;
                                              Get.back();
                                            },
                                            label: Text('Add Data'),
                                            icon: Icon(Icons.add),
                                          ),
                                          SizedBox(height: 20),
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              getAccountData(context);
                                              Get.back();
                                            },
                                            label: Text('Refresh'),
                                            icon: Icon(Icons.refresh),
                                          )
                                        ],
                                      ),
                                    )),
                              );
                            },
                            icon: Icon(Icons.settings))
                      ],
                    )
                  ],
                ),
              )
            ],
        body: Obx(() {
          print(Get.find<ViewController>(tag: 'viewcont').accI.value);
          avoidAccountsDuplicates();
          return cont.isLoading.value
              ? Center(
                  child: SizedBox(
                    height: 150,
                    width: 150,
                    child: CircularProgressIndicator(),
                  ),
                )
              : (accounts_model_list.length == 0
                  ? Center(
                      child: Text('No Accounts',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold)))
                  : ListView.builder(
                      itemBuilder: (context, index) {
                        final e = accounts_model_list[index];
                        return AccountContainer(context, e);
                      },
                      itemCount: accounts_model_list.length,
                    )
              // SingleChildScrollView(
              //     child: Wrap(
              //       alignment: WrapAlignment.center,
              //       children: accounts_model_list.map((e) {
              //         return AccountContainer(context, e);
              //       }).toList(),
              //     ),
              //   )
              );
        }));
  }
}

Widget AccountContainer(BuildContext context, AccountModel item) {
  bool isCurrentUser = false;
  item.email == currentUserEmail ? isCurrentUser = true : isCurrentUser = false;
  return IntrinsicHeight(
    child: GestureDetector(
      child: Container(
          width: Get.width - 50,
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.only(left: 20, top: 20, bottom: 20, right: 5),
          decoration: BoxDecoration(
            color: isCurrentUser
                ? Colors.green[400]
                : (item.role == 'Admin'
                    ? Colors.green[200]
                    : Colors.orange[200]),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                  radius: 40,
                  child: item.photo == 'default'
                      ? Icon(
                          Icons.person,
                          size: 60,
                        )
                      : CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                              '$endPoint/storage/buckets/$profilePhotoBucketId/files/${item.photo}/view?project=64296421a251168288ea'),
                        )
                  // Image.network(
                  //     '$endPoint/storage/buckets/$profilePhotoBucketId/files/${item.photo}/view?project=64296421a251168288ea',
                  //     loadingBuilder: (BuildContext context, Widget child,
                  //         ImageChunkEvent? loadingProgress) {
                  //       if (loadingProgress == null) return child;
                  //       return Center(
                  //         child: CircularProgressIndicator(
                  //           value: loadingProgress.expectedTotalBytes !=
                  //                   null
                  //               ? loadingProgress.cumulativeBytesLoaded /
                  //                   loadingProgress.expectedTotalBytes!
                  //               : null,
                  //         ),
                  //       );
                  //     },
                  //     fit: BoxFit.cover,
                  //     width: 290,
                  //     height: 160,
                  //   ),
                  ),
              SizedBox(width: 30),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 175,
                    child: Text(
                      item.name,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 175,
                    child: Text(
                      item.email,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    item.role,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Visibility(
                    visible: isCurrentUser,
                    child: Text(
                      '(You)',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: ((context) =>
                                SingleItemDataContainer(context, item)));
                      },
                      icon: Icon(Icons.view_timeline_outlined)),
                  Visibility(
                    visible: !isCurrentUser,
                    child: IconButton(
                      onPressed: () {
                        deleteAccountData(context, item.doc_id, item.photo);
                      },
                      icon: Icon(Icons.delete, color: Colors.red),
                    ),
                  ),
                  Expanded(child: Container())
                ],
              )
            ],
          )),
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: ((context) => SingleItemDataContainer(context, item)));
      },
    ),
  );
}

Widget SingleItemDataContainer(BuildContext context, AccountModel item) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.grey[900],
    ),
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 50),
      width: Get.width - 50,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            item.photo == 'default'
                ? CircleAvatar(
                    radius: 100,
                    child: Icon(
                      Icons.person,
                      size: 100,
                    ),
                  )
                : Image.network(
                    // doc!.data['img'],
                    '$endPoint/storage/buckets/$profilePhotoBucketId/files/${item.photo}/view?project=64296421a251168288ea',
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    height: 300,
                    width: 600,
                    fit: BoxFit.contain,
                  ),
            SizedBox(height: 10),
            SingleLeadsDataContainerTextMobileMode('Name', item.name),
            SingleLeadsDataContainerTextMobileMode('User Id', item.user_id),
            SingleLeadsDataContainerTextMobileMode('Mobile No', item.mobile_no),
            SingleLeadsDataContainerTextMobileMode('Address', item.address),
            SingleLeadsDataContainerTextMobileMode('Email', item.email),
            SingleLeadsDataContainerTextMobileMode('Password', item.password),
            SingleLeadsDataContainerTextMobileMode('Role', item.role),
            // Center(
            //   child: ElevatedButton(
            //       style: ElevatedButton.styleFrom(primary: Colors.red),
            //       onPressed: () {
            //         deleteItemsData(context, doc.data['doc_id'], doc.data['img']);
            //         Get.back();
            //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //           content: Text('Item Deleted'),
            //           backgroundColor: Colors.red,
            //         ));
            //       },
            //       child: Text('Delete')),
            // ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('Go Back')),
            ),
            SizedBox(height: 20)
          ],
        ),
      ),
    ),
  );
}

Widget accountSearchField(BuildContext context) {
  return SizedBox(
    width: 300,
    child: TextField(
      onSubmitted: (value) {
        if (value == '')
          getAccountData(context);
        else
          searchAccountData(value);
      },
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.red,
      cursorHeight: 25,
      cursorWidth: 5,
      cursorRadius: Radius.circular(20),
      decoration: InputDecoration(
        hintText: 'Name, Email, Mobile...',
        hintStyle: TextStyle(color: Colors.grey, letterSpacing: 1),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    ),
  );
}
