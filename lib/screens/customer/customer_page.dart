import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:wooodapp/controller/controller.dart';
import 'package:wooodapp/main.dart';
import 'package:wooodapp/model/customer_model.dart';
import 'package:wooodapp/model/get_user_list.dart';
import 'package:wooodapp/screens/customer/update_customer_page.dart';
import 'package:get/get.dart';
import 'package:wooodapp/screens/leads/leads_page.dart';

class CustomerPage extends StatelessWidget {
  CustomerPage({super.key});

  final cont = Get.find<ViewController>(tag: 'viewcont');

  @override
  Widget build(BuildContext context) {
    getCustomerData(context);
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
                    CustomerSearchField(context),
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
                                          cont.currentPageIndex.value = 8;
                                          Get.back();
                                        },
                                        label: Text('Add Data'),
                                        icon: Icon(Icons.add),
                                      ),
                                      SizedBox(height: 20),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          getCustomerData(context);
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
            ])),
        body: Obx(
          () {
            avoidCustomerDuplciate();
            print(Get.find<ViewController>(tag: 'viewcont').cusI.value);
            return cont.isLoading.value
                ? Center(
                    child: SizedBox(
                    height: 150,
                    width: 150,
                    child: CircularProgressIndicator(),
                  ))
                : (customer_model_list.length == 0
                    ? Center(
                        child: Text('No Customer Data',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold)),
                      )
                    : ListView.builder(
                        itemBuilder: (((context, index) {
                          final item = customer_model_list[index];
                          return GestureDetector(
                            child: Container(
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(20)),
                              child: Row(
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
                                      Text(item.item),
                                      SizedBox(height: 10),
                                      Text(
                                        item.delivery_date,
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
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (context) => Container(
                                                width: double.infinity,
                                                height: size.height / 2,
                                                color: Colors.black,
                                                child: Center(
                                                  child: SizedBox(
                                                    height: 200,
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
                                                              Get.off(
                                                                () => UpdateCustomerPage(
                                                                    ref_no: item
                                                                        .ref_no,
                                                                    delivery_date:
                                                                        item
                                                                            .delivery_date,
                                                                    name: item
                                                                        .name,
                                                                    mobile_no: item
                                                                        .mobile_no,
                                                                    address: item
                                                                        .address,
                                                                    stock: item
                                                                        .stock,
                                                                    item_code: item
                                                                        .item_code,
                                                                    item_desc: item
                                                                        .item_desc,
                                                                    item: item
                                                                        .item,
                                                                    delivery_status:
                                                                        item.delivery_status),
                                                              );
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
                                                              deleteCustomerData(
                                                                  context,
                                                                  item.ref_no);
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        child: TableItem(item.delivery_status),
                                        color:
                                            item.delivery_status == 'In Process'
                                                ? Colors.orange[700]
                                                : (item.delivery_status ==
                                                        'Delivered'
                                                    ? Colors.green[700]
                                                    : Colors.red[700]),
                                      )
                                    ],
                                  )
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
                                            'Mob No', item.mobile_no),
                                        SingleLeadsDataContainerTextMobileMode(
                                            'Item', item.item),
                                        SingleLeadsDataContainerTextMobileMode(
                                            'Item Code', item.item_code),
                                        SingleLeadsDataContainerTextMobileMode(
                                            'Item Description', item.item_desc),
                                        SingleLeadsDataContainerTextMobileMode(
                                            'Stock', item.stock),
                                        SingleLeadsDataContainerTextMobileMode(
                                            'Delivery Date',
                                            item.delivery_date),
                                        SingleLeadsDataContainerTextMobileMode(
                                            'Delivery Status',
                                            item.delivery_status),
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
                        })),
                        itemCount: customer_model_list.length,
                      ));
          },
        ));
  }
}

Widget CustomerSearchField(BuildContext context) {
  return SizedBox(
    width: 300,
    child: TextField(
      onSubmitted: (value) {
        if (value == '')
          getCustomerData(context);
        else
          searchCustomerData(value);
      },
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.red,
      cursorHeight: 25,
      cursorWidth: 5,
      cursorRadius: Radius.circular(20),
      decoration: InputDecoration(
        hintText: 'Search for Name or Mobile No',
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

Widget SingleCustomerDataContainer(BuildContext context, Document? doc) {
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
        SingleCustomerDataContainerText('Name', doc!.data['name']),
        SingleCustomerDataContainerText('Reference No', doc.data['ref_no']),
        SingleCustomerDataContainerText('Address', doc.data['address']),
        SingleCustomerDataContainerText('Mobile No', doc.data['mobile_no']),
        SingleCustomerDataContainerText('Item', doc.data['item']),
        SingleCustomerDataContainerText('Item Code', doc.data['item_code']),
        SingleCustomerDataContainerText(
            'Item Description', doc.data['item_desc']),
        SingleCustomerDataContainerText('Stock', doc.data['stock']),
        SingleCustomerDataContainerText(
            'Delivery Date', doc.data['delivery_date']),
        SingleCustomerDataContainerText(
            'Delivery Status', doc.data['delivery_status']),
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

Widget SingleCustomerDataContainerText(String title, String name) {
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
