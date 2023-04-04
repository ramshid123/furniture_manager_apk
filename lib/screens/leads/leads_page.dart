import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:wooodapp/controller/controller.dart';
import 'package:wooodapp/main.dart';
import 'package:wooodapp/model/get_user_list.dart';
import 'package:wooodapp/model/leads_model.dart';
import 'package:wooodapp/screens/leads/move_to_cust.dart';
import 'package:wooodapp/screens/leads/update_leads_page.dart';
import 'package:get/get.dart';

class LeadsPage extends StatelessWidget {
  LeadsPage({Key? key}) : super(key: key);

  final cont = Get.find<ViewController>(tag: 'viewcont');

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    getLeadsData(context);
    return NestedScrollView(
      headerSliverBuilder: ((context, innerBoxIsScrolled) => [
            SliverAppBar(
              pinned: true,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.grey[900],
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // isMobile
                  //     ? Container()
                  //     : Text(
                  //         'Leads',
                  //         style: TextStyle(
                  //             color: Colors.grey[500],
                  //             fontSize: 30,
                  //             fontWeight: FontWeight.bold),
                  //       ),
                  LeadsSearchField(context),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        cont.currentPageIndex.value = 9;
                                        Get.back();
                                      },
                                      label: Text('Add Data'),
                                      icon: Icon(Icons.add),
                                    ),
                                    SizedBox(height: 20),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        getLeadsData(context);
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
              ),
            )
          ]),
      body: Obx(() {
        avoidLeadsDuplicates();
        print(Get.find<ViewController>(tag: 'viewcont').leadI.value);
        return cont.isLoading.value
            ? Center(
                child: SizedBox(
                height: 150,
                width: 150,
                child: CircularProgressIndicator(),
              ))
            : (leads_model_list.length == 0
                ? Center(
                    child: Text('No Leads Data',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold)),
                  )
                : (ListView.builder(
                    itemBuilder: ((context, index) {
                      final item = leads_model_list[index];
                      return GestureDetector(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            children: [
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      Text(item.lead_source),
                                      SizedBox(height: 10),
                                      SizedBox(
                                        width: 250,
                                        child: Text(
                                          item.item,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
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
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Options',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 25),
                                                        ),
                                                        Divider(
                                                          color: Colors.white,
                                                        ),
                                                        Container(
                                                          width: Get.width / 2,
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .grey[900],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                          child:
                                                              TextButton.icon(
                                                            label: Text(
                                                              'Move To Customer',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 15),
                                                            ),
                                                            onPressed: () {
                                                              item.status ==
                                                                      'In Stock'
                                                                  ? Get.off(() => MoveToCustomer(
                                                                      doc_id: item
                                                                          .doc_id,
                                                                      name: item
                                                                          .name,
                                                                      mobile_no:
                                                                          item
                                                                              .mobile_no,
                                                                      address: item
                                                                          .address,
                                                                      item_desc:
                                                                          item
                                                                              .item_desc,
                                                                      item: item
                                                                          .item))
                                                                  : showDialog(
                                                                      context:
                                                                          context,
                                                                      builder: (context) =>
                                                                          GoToPurchaseOrNotContainer(
                                                                              item),
                                                                    );
                                                            },
                                                            icon: Icon(
                                                              Icons
                                                                  .move_up_rounded,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 20),
                                                        Container(
                                                          width: Get.width / 2,
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .blue[500],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                          child:
                                                              TextButton.icon(
                                                            label: Text(
                                                              'Edit Data',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 15),
                                                            ),
                                                            onPressed: () {
                                                              Get.off(() =>
                                                                  UpdateLeadsPage(
                                                                      doc_id: item
                                                                          .doc_id,
                                                                      lead_source:
                                                                          item
                                                                              .lead_source,
                                                                      name: item
                                                                          .name,
                                                                      mobile_no:
                                                                          item
                                                                              .mobile_no,
                                                                      address: item
                                                                          .address,
                                                                      item_desc:
                                                                          item
                                                                              .item_desc,
                                                                      // status: e.status,
                                                                      item: item
                                                                          .item));
                                                            },
                                                            icon: Icon(
                                                                Icons.edit,
                                                                color: Colors
                                                                    .blue[900]),
                                                          ),
                                                        ),
                                                        SizedBox(height: 20),
                                                        Container(
                                                          width: Get.width / 2,
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .red[500],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                          child:
                                                              TextButton.icon(
                                                            label: Text(
                                                              'Delete Data',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 15),
                                                            ),
                                                            onPressed: () {
                                                              deleteLeadsData(
                                                                  context,
                                                                  item.doc_id);
                                                              Get.back();
                                                            },
                                                            icon: Icon(
                                                                Icons.delete,
                                                                color: Colors
                                                                    .red[900]),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          icon: Icon(Icons.settings)),
                                      Container(
                                        child: Text(item.status),
                                        color: item.status == 'In Stock'
                                            ? Colors.green[700]
                                            : Colors.red[700],
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                      )
                                    ],
                                  )
                                ],
                              ),
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
                                        'Id', item.doc_id),
                                    SingleLeadsDataContainerTextMobileMode(
                                        'Leads', item.lead_source),
                                    SingleLeadsDataContainerTextMobileMode(
                                        'Name', item.name),
                                    SingleLeadsDataContainerTextMobileMode(
                                        'Mob No', item.mobile_no),
                                    SingleLeadsDataContainerTextMobileMode(
                                        'Address', item.address),
                                    SingleLeadsDataContainerTextMobileMode(
                                        'Item', item.item),
                                    SingleLeadsDataContainerTextMobileMode(
                                        'Item Code', item.item_code),
                                    SingleLeadsDataContainerTextMobileMode(
                                        'Item Description', item.item_desc),
                                    SingleLeadsDataContainerTextMobileMode(
                                        'Status', item.status),
                                    Visibility(
                                      visible: isAdmin,
                                      child:
                                          SingleLeadsDataContainerTextMobileMode(
                                              'Credit',
                                              target.name +
                                                  '\n(' +
                                                  target.email +
                                                  ')'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                    itemCount: leads_model_list.length,
                  )));
      }),
    );
  }
}

Widget TableTitle(String name) {
  return Text(
    name,
    style: TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget TableItem(String name) {
  return SingleChildScrollView(
    child: Text(
      name,
      overflow: TextOverflow.visible,
      softWrap: true,
      style: TextStyle(
        color: Colors.white,
        fontSize: 13,
      ),
    ),
  );
}

Widget LeadsSearchField(BuildContext context) {
  return SizedBox(
    width: 300,
    child: TextField(
      onSubmitted: (value) {
        if (value == '')
          getLeadsData(context);
        else
          searchLeadsData(value);
      },
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.red,
      cursorHeight: 25,
      cursorWidth: 5,
      cursorRadius: Radius.circular(20),
      decoration: InputDecoration(
        hintText: 'Search for Name or Lead Source',
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

Widget SingleLeadsDataContainer(BuildContext context, Document? doc) {
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
        SingleLeadsDataContainerText('Lead Source', doc!.data['lead_source']),
        SingleLeadsDataContainerText('Name', doc.data['name']),
        SingleLeadsDataContainerText('Mobile No', doc.data['mobile_no']),
        SingleLeadsDataContainerText('Address', doc.data['address']),
        SingleLeadsDataContainerText('Item', doc.data['item']),
        SingleLeadsDataContainerText('Item Code', doc.data['item_code']),
        SingleLeadsDataContainerText('Item Description', doc.data['item_desc']),
        SingleLeadsDataContainerText('Status', doc.data['status']),
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

Widget SingleLeadsDataContainerText(String title, String name) {
  final size = Get.width;
  return Column(
    children: [
      Row(
        children: [
          SizedBox(
            width: size < 1000 ? 0 : 170,
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

Widget SingleLeadsDataContainerTextMobileMode(String title, String name) {
  final size = Get.width;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white54,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            ' :-',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      SizedBox(
        width: size - 10,
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
      SizedBox(height: 20)
    ],
  );
}

Widget GoToPurchaseOrNotContainer(LeadsModel e) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 250),
    color: Colors.white,
    child: Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'There is not enough stock for this order.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red, fontSize: 20),
          ),
          SizedBox(height: 20),
          Text(
            'Continue to purchase order?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(fontSize: 17),
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.off(() => MoveToCustomer(
                      doc_id: e.doc_id,
                      name: e.name,
                      mobile_no: e.mobile_no,
                      address: e.address,
                      item_desc: e.item_desc,
                      item: e.item));
                },
                child: Text(
                  'Add Anyway',
                  style: TextStyle(fontSize: 17),
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  Get.find<ViewController>(tag: 'viewcont')
                      .currentPageIndex
                      .value = 12;
                },
                child: Text(
                  'Purchase order',
                  style: TextStyle(fontSize: 17),
                ),
              )
            ],
          )
        ],
      ),
    ),
  );
}
