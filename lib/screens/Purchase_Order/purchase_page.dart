import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:wooodapp/controller/controller.dart';
import 'package:wooodapp/main.dart';
import 'package:wooodapp/model/purchase_model.dart';
import 'package:get/get.dart';
import 'package:wooodapp/screens/leads/leads_page.dart';

class PurchasePage extends StatelessWidget {
  PurchasePage({super.key});

  final cont = Get.find<ViewController>(tag: 'viewcont');

  @override
  Widget build(BuildContext context) {
    getPurchaseData(context);
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
                    children: [
                      // ElevatedButton(onPressed: (){testfunadd();}, child: Text('test')),
                      ElevatedButton.icon(
                        onPressed: () {
                          cont.currentPageIndex.value = 12;
                        },
                        label: Text('Add Data'),
                        icon: Icon(Icons.add),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () {
                          getPurchaseData(context);
                        },
                        label: Text('Refresh'),
                        icon: Icon(Icons.refresh),
                      )
                    ],
                  ),
                ],
              ),
            )
          ])),
      body: Obx(() {
        print(cont.poI.value);
        return cont.isLoading.value
            ? Center(
                child: SizedBox(
                height: 150,
                width: 150,
                child: CircularProgressIndicator(),
              ))
            : (purchase_order_model_list.length == 0
                ? Center(
                    child: Text('No Purchase Orders',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold)),
                  )
                : ListView.builder(
                    itemBuilder: ((context, index) {
                      avoidPODuplicates();
                      final item = purchase_order_model_list[index];
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
                                    item.item_name,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 10),
                                  Text(item.supplier_name),
                                  SizedBox(height: 10),
                                  Text(
                                    item.arrival_date,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      printDoc(item);
                                    },
                                    icon: Icon(
                                      Icons.print,
                                      color: Colors.indigo,
                                    ),
                                  ),
                                  Container(
                                    child: TableItem(item.order_status),
                                    color: item.order_status == 'In Process'
                                        ? Colors.orange[700]
                                        : Colors.green[700],
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        onTap: () {
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
                                        'Id', item.ref_no),
                                    SingleLeadsDataContainerTextMobileMode(
                                        'Supplier', item.supplier_name),
                                    SingleLeadsDataContainerTextMobileMode(
                                        'Item', item.item_name),
                                    SingleLeadsDataContainerTextMobileMode(
                                        'Item code', item.item_code),
                                    SingleLeadsDataContainerTextMobileMode(
                                        'Item Description', item.item_desc),
                                    SingleLeadsDataContainerTextMobileMode(
                                        'Quantity', item.quantity),
                                    SingleLeadsDataContainerTextMobileMode(
                                        'Arrival Date', item.arrival_date),
                                    SingleLeadsDataContainerTextMobileMode(
                                        'Order Status', item.order_status),
                                    Visibility(
                                      visible: isAdmin,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 20,
                                                  vertical: 300),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(height: 50),
                                                  Text(
                                                    'Are you sure to delete?',
                                                    style:
                                                        TextStyle(fontSize: 22),
                                                  ),
                                                  SizedBox(height: 30),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {
                                                          deletePOData(context,
                                                              item.ref_no);
                                                          Get.back();
                                                          Get.back();
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  SnackBar(
                                                            content: Text(
                                                                'Purchase Order Deleted'),
                                                            backgroundColor:
                                                                Colors.red,
                                                          ));
                                                        },
                                                        child: Text(
                                                          'Yes',
                                                          style: TextStyle(
                                                              fontSize: 22),
                                                        ),
                                                      ),
                                                      SizedBox(width: 50),
                                                      TextButton(
                                                        onPressed: () {
                                                          Get.back();
                                                        },
                                                        child: Text(
                                                          'No',
                                                          style: TextStyle(
                                                              fontSize: 22),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red),
                                        child: Text('Delete'),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                    itemCount: purchase_order_model_list.length,
                  ));
      }),
    );
  }
}
