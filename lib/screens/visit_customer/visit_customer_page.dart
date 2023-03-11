import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:wooodapp/controller/controller.dart';
import 'package:wooodapp/main.dart';
import 'package:wooodapp/model/get_user_list.dart';
import 'package:wooodapp/model/visit_customer_model.dart';
import 'package:wooodapp/screens/leads/leads_page.dart';
import 'package:wooodapp/screens/visit_customer/move_from_go_to_cust_page.dart';
import 'package:wooodapp/screens/visit_customer/update_visit_customer_page.dart';
import 'package:get/get.dart';

class VisitCustomerPage extends StatelessWidget {
  VisitCustomerPage({super.key});

  final cont = Get.find<ViewController>(tag: 'viewcont');

  @override
  Widget build(BuildContext context) {
    getGoCustomerData(context);
    final size = MediaQuery.of(context).size;
    return NestedScrollView(
      headerSliverBuilder: (((context, innerBoxIsScrolled) => [
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
                      GoCustomerSearchField(context),
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
                                            cont.currentPageIndex.value = 11;
                                            Get.back();
                                          },
                                          label: Text('Add Data'),
                                          icon: Icon(Icons.add),
                                        ),
                                        SizedBox(height: 20),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            getGoCustomerData(context);
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
          ])),
      body: Obx(() {
        print(Get.find<ViewController>(tag: 'viewcont').visI.value);
        return (cont.isLoading.value
            ? Center(
                child: SizedBox(
                height: 150,
                width: 150,
                child: CircularProgressIndicator(),
              ))
            : go_customer_model_list.length == 0
                ? Center(
                    child: Text('No Customers to visit',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold)),
                  )
                : ListView.builder(
                    itemBuilder: ((context, index) {
                      avoidGoCustDuplicates();
                      final item = go_customer_model_list[index];
                      return GestureDetector(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item.name,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 10),
                                  Text(item.mobile_no),
                                  SizedBox(height: 10),
                                  Text(
                                    item.visit_date,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              IconButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) => Container(
                                        width: double.infinity,
                                        height: size.height / 2,
                                        color: Colors.black,
                                        child: Center(
                                          child: SizedBox(
                                            height: 250,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Options',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 25),
                                                ),
                                                Divider(
                                                  color: Colors.white,
                                                ),
                                                SizedBox(height: 20),
                                                Container(
                                                  width: Get.width / 2,
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[900],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: TextButton.icon(
                                                    label: Text(
                                                      'Move To Customer',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15),
                                                    ),
                                                    onPressed: () {
                                                      Get.off(() =>
                                                          MoveFromGoToCust(
                                                            doc_id: item.ref_no,
                                                            name: item.name,
                                                            mobile_no:
                                                                item.mobile_no,
                                                            address:
                                                                item.address,
                                                          ));
                                                    },
                                                    icon: Icon(
                                                      Icons.move_up_rounded,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                Container(
                                                  width: Get.width / 2,
                                                  decoration: BoxDecoration(
                                                      color: Colors.blue[500],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: TextButton.icon(
                                                    label: Text(
                                                      'Edit Data',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15),
                                                    ),
                                                    onPressed: () {
                                                      Get.off(
                                                        () =>
                                                            UpdateGoCustomerPage(
                                                                ref_no:
                                                                    item.ref_no,
                                                                visit_date: item
                                                                    .visit_date,
                                                                name: item.name,
                                                                mobile_no: item
                                                                    .mobile_no,
                                                                address: item
                                                                    .address,
                                                                visit_desc: item
                                                                    .visit_desc),
                                                      );
                                                    },
                                                    icon: Icon(Icons.edit,
                                                        color:
                                                            Colors.blue[900]),
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                Container(
                                                  width: Get.width / 2,
                                                  decoration: BoxDecoration(
                                                      color: Colors.red[500],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: TextButton.icon(
                                                    label: Text(
                                                      'Delete Data',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15),
                                                    ),
                                                    onPressed: () {
                                                      deleteGoCustomerData(
                                                          context, item.ref_no);
                                                      Get.back();
                                                    },
                                                    icon: Icon(Icons.delete,
                                                        color: Colors.red[900]),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.settings))
                            ],
                          ),
                        ),
                        onTap: () async {
                          final target =
                              await get_user_name_from_id(item.uploader);
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => Container(
                              padding: EdgeInsets.all(10),
                              height: size.height / 2,
                              color: Colors.black,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Text('Go Back')),
                                    SingleLeadsDataContainerTextMobileMode(
                                        'Reference No', item.ref_no),
                                    SingleLeadsDataContainerTextMobileMode(
                                        'Name', item.name),
                                    SingleLeadsDataContainerTextMobileMode(
                                        'Address', item.address),
                                    SingleLeadsDataContainerTextMobileMode(
                                        'Visit Date', item.visit_date),
                                    SingleLeadsDataContainerTextMobileMode(
                                        'Visit Description', item.visit_desc),
                                   Visibility(
                                      visible: isAdmin,
                                      child: SingleLeadsDataContainerTextMobileMode(
                                          'Credit', target.name+'\n('+target.email+')'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                    itemCount: go_customer_model_list.length,
                  ));
      }),
    );
  }
}

Widget GoCustomerSearchField(BuildContext context) {
  return SizedBox(
    width: 300,
    child: TextField(
      onSubmitted: (value) {
        if (value == '')
          getGoCustomerData(context);
        else
          searchGoCustomerData(value);
      },
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.red,
      cursorHeight: 25,
      cursorWidth: 5,
      cursorRadius: Radius.circular(20),
      decoration: InputDecoration(
        hintText: 'Search for Name..',
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

Widget SingleGoCustomerDataContainer(BuildContext context, Document? doc) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 200, vertical: 50),
    padding: EdgeInsets.only(left: 50, top: 50),
    decoration: BoxDecoration(
      color: Colors.grey[900],
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    child: Column(
      children: [
        Expanded(child: Container()),
        SingleGoCustomerDataContainerText('Name', doc!.data['name']),
        SingleGoCustomerDataContainerText('Reference No', doc.data['ref_no']),
        SingleGoCustomerDataContainerText('Address', doc.data['address']),
        SingleGoCustomerDataContainerText('Visit Date', doc.data['visit_date']),
        SingleGoCustomerDataContainerText(
            'Visit Description', doc.data['visit_desc']),
        Center(
          child: ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Go Back')),
        ),
        Expanded(child: Container()),
      ],
    ),
  );
}

Widget SingleGoCustomerDataContainerText(String title, String name) {
  return Column(
    children: [
      Row(
        children: [
          SizedBox(
            width: 170,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white54,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            ' : ',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: 600,
            child: Text(
              name,
              softWrap: true,
              overflow: TextOverflow.visible,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
      SizedBox(height: 20),
    ],
  );
}
