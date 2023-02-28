import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:wooodapp/controller/controller.dart';
import 'package:wooodapp/main.dart';
import 'package:wooodapp/model/activities_model.dart';
import 'package:wooodapp/model/customer_model.dart';
import 'package:wooodapp/model/purchase_model.dart';
import 'package:wooodapp/model/visit_customer_model.dart';
import 'package:wooodapp/screens/leads/leads_page.dart';
import 'package:wooodapp/screens/side_menu/side_menu_screen.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.grey[900],
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 70,
            backgroundColor: Colors.grey[700],
            title: TabBar(
              indicatorColor: Colors.white,
              indicatorWeight: 10,
              tabs: [
                Tab(
                  icon: Icon(Icons.dashboard_outlined),
                  text: 'Menu',
                ),
                Tab(
                  icon: Icon(Icons.menu_book_sharp),
                  text: 'Activities',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Center(
                  child: SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'Hello $currentUserName',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                        SizedBox(height: 20),
                        Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            DashBoardElements(0, 1),
                            DashBoardElements(1, 2),
                            DashBoardElements(2, 3),
                            DashBoardElements(3, 5),
                            DashBoardElements(4, 7),
                            Visibility(
                                visible: isAdmin,
                                child: DashBoardElements(5, 8))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                child: ActivityContainer(context),
              )
            ],
          ),
        ));
  }
}

final dashboardColors = [
  Colors.blue,
  Colors.red,
  Colors.indigo,
  Colors.green,
  Colors.purple,
  Colors.orange
];

Widget DashBoardElements(
  int no,
  int index,
) {
  final cont = Get.find<ViewController>(tag: 'viewcont');
  return GestureDetector(
    child: Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      height: (Get.width / 2) - 50,
      width: (Get.width / 2) - 50,
      decoration: BoxDecoration(
          color: dashboardColors[no][300],
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            buttonsIcons[index],
            color: dashboardColors[no][900],
            size: 50,
          ),
          Text(
            buttonsname[index],
            textAlign: TextAlign.center,
            style: TextStyle(
                color: dashboardColors[no][900],
                fontSize: 22,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    ),
    onTap: () {
      cont.currentPageIndex.value = index;
      cont.selectedButton.value = index;
    },
  );
}

Widget ActivityContainer(BuildContext context) {
  final cont = Get.find<ViewController>(tag: 'viewcont');
  getActivities(context);
  return Obx(() {
    avoidActivitiesDuplicates();
    print(Get.find<ViewController>(tag: 'viewcont').actI.value);
    return cont.isLoading.value
        ? Stack(
            children: [
              Center(
                child: SizedBox(
                  height: 150,
                  width: 150,
                  child: CircularProgressIndicator(),
                ),
              ),
              Center(
                child: IconButton(
                  onPressed: () {
                    getActivities(context);
                  },
                  icon: Icon(
                    Icons.refresh,
                    size: 30,
                  ),
                ),
              ),
            ],
          )
        : (activities_list.length == 0
            ? Center(
                child: Text("No Activities Today",
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 40,
                        fontWeight: FontWeight.bold)),
              )
            : ListView.builder(
                physics: BouncingScrollPhysics(),
                itemBuilder: ((context, index) {
                  final item = activities_list[index];
                  return GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[900],
                          boxShadow: [
                            BoxShadow(
                                color: Colors.blue,
                                blurRadius: 5,
                                spreadRadius: 2)
                          ],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20))),
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                          title: Text(
                            item.section == ActivityType.go_cust
                                ? "Customer to visit"
                                : (item.section == ActivityType.po
                                    ? "Item to arrival"
                                    : "Delivery to customer"),
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            item.info,
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: item.section == ActivityType.go_cust
                              ? Icon(
                                  Icons.home,
                                  color: Colors.amber,
                                )
                              : (item.section == ActivityType.po
                                  ? Icon(
                                      Icons.badge,
                                      color: Colors.indigo,
                                    )
                                  : Icon(
                                      Icons.person,
                                      color: Colors.green,
                                    ))),
                    ),
                    onTap: () async {
                      if (item.section == ActivityType.go_cust) {
                        final e =
                            await getSingleGoCustomerData(context, item.ref_no);
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Container(
                            padding: EdgeInsets.all(10),
                            height: Get.height / 2,
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
                                      'Reference No', e!.data['ref_no']),
                                  SingleLeadsDataContainerTextMobileMode(
                                      'Name', e.data['name']),
                                  SingleLeadsDataContainerTextMobileMode(
                                      'Address', e.data['address']),
                                  SingleLeadsDataContainerTextMobileMode(
                                      'Visit Date', e.data['visit_date']),
                                  SingleLeadsDataContainerTextMobileMode(
                                      'Visit Description',
                                      e.data['visit_desc']),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else if (item.section == ActivityType.po) {
                        final e = await getSinglePurchaseOrderData(
                            context, item.ref_no);
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Container(
                            padding: EdgeInsets.all(10),
                            height: Get.height / 2,
                            color: Colors.black,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text('Go Back')),
                                  SizedBox(height: 20),
                                  Visibility(
                                    visible: e!.data['order_status']=='In Process'?true:false,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green),
                                      onPressed: () async {
                                        await db.updateDocument(
                                          databaseId: databaseId,
                                          collectionId: purchaseCollectionId,
                                          documentId: e.data['ref_no'],
                                          data: {
                                            'order_status':'Arrived'
                                          }
                                        );
                                        Get.back();
                                      },
                                      child: Text('Arrived'),
                                    ),
                                  ),
                                  SingleLeadsDataContainerTextMobileMode(
                                      'Id', e.data['ref_no']),
                                  SingleLeadsDataContainerTextMobileMode(
                                      'Supplier', e.data['supplier_name']),
                                  SingleLeadsDataContainerTextMobileMode(
                                      'Item', e.data['item_name']),
                                  SingleLeadsDataContainerTextMobileMode(
                                      'Item code', e.data['item_code']),
                                  SingleLeadsDataContainerTextMobileMode(
                                      'Item Description', e.data['item_desc']),
                                  SingleLeadsDataContainerTextMobileMode(
                                      'Quantity', e.data['quantity']),
                                  SingleLeadsDataContainerTextMobileMode(
                                      'Arrival Date', e.data['arrival_date']),
                                  SingleLeadsDataContainerTextMobileMode(
                                      'Order Status', e.data['order_status']),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        final e =
                            await getSingleCustomerData(context, item.ref_no);
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Container(
                            padding: EdgeInsets.all(10),
                            height: Get.height / 2,
                            color: Colors.black,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text('Go Back')),
                                  SizedBox(height: 30),
                                  Visibility(
                                    visible: e!.data['delivery_status'] ==
                                            'In Process'
                                        ? true
                                        : false,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green),
                                          onPressed: () async {
                                            await db.updateDocument(
                                                databaseId: databaseId,
                                                collectionId:
                                                    customerCollectionId,
                                                documentId: item.ref_no,
                                                data: {
                                                  'delivery_status': 'Delivered'
                                                });
                                            Get.back();
                                          },
                                          child: Text('Delivered'),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red),
                                          onPressed: () async {
                                            await db.updateDocument(
                                                databaseId: databaseId,
                                                collectionId:
                                                    customerCollectionId,
                                                documentId: item.ref_no,
                                                data: {
                                                  'delivery_status': 'Cancelled'
                                                });
                                            Get.back();
                                          },
                                          child: Text('Cancelled'),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  SingleLeadsDataContainerTextMobileMode(
                                      'Reference No', e.data['ref_no']),
                                  SingleLeadsDataContainerTextMobileMode(
                                      'Name', e.data['name']),
                                  SingleLeadsDataContainerTextMobileMode(
                                      'Address', e.data['address']),
                                  SingleLeadsDataContainerTextMobileMode(
                                      'Mob No', e.data['mobile_no']),
                                  SingleLeadsDataContainerTextMobileMode(
                                      'Item', e.data['item']),
                                  SingleLeadsDataContainerTextMobileMode(
                                      'Item Code', e.data['item_code']),
                                  SingleLeadsDataContainerTextMobileMode(
                                      'Item Description', e.data['item_desc']),
                                  SingleLeadsDataContainerTextMobileMode(
                                      'Stock', e.data['stock']),
                                  SingleLeadsDataContainerTextMobileMode(
                                      'Delivery Date', e.data['delivery_date']),
                                  SingleLeadsDataContainerTextMobileMode(
                                      'Delivery Status',
                                      e.data['delivery_status']),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  );
                }),
                itemCount: activities_list.length,
              ));
  });
}
