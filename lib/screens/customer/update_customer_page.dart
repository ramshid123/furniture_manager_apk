import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wooodapp/controller/controller.dart';
import 'package:wooodapp/main.dart';
import 'package:wooodapp/model/customer_model.dart';
import 'package:wooodapp/screens/leads/add_leads_page.dart';
import 'package:wooodapp/screens/login/login_screen.dart';
import 'package:wooodapp/screens/main_page.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UpdateCustomerPage extends StatelessWidget {
  String address;
  String delivery_date;
  String delivery_status;
  String item;
  String item_code;
  String item_desc;
  String mobile_no;
  String name;
  String ref_no;
  String stock;
  UpdateCustomerPage(
      {Key? key,
      required this.ref_no,
      required this.delivery_date,
      required this.name,
      required this.mobile_no,
      required this.item_code,
      required this.stock,
      required this.address,
      required this.item_desc,
      required this.item,
      required this.delivery_status})
      : super(key: key);

  final delivery_date_cont = TextEditingController();
  final delivery_status_cont = TextEditingController();
  final mobile_no_cont = TextEditingController();
  final address_cont = TextEditingController();
  final item_desc_cont = TextEditingController();
  final item_code_cont = TextEditingController();
  final stock_cont = TextEditingController();
  final name_cont = TextEditingController();
  final item_cont = TextEditingController();

  final _fkey = GlobalKey<FormState>();

  final cont = Get.find<ViewController>(tag: 'viewcont');

  void init() {
    name_cont.text = name;
    stock_cont.text = stock;
    cont.dropDownValue.value=delivery_status;
    mobile_no_cont.text = mobile_no;
    item_cont.text = item;
    address_cont.text = address;
    item_desc_cont.text = item_desc;
    item_code_cont.text = item;
    delivery_date_cont.text = delivery_date;
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[700],
        leading: IconButton(
          onPressed: () {
            Get.off(() => MainPage());
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 50),
        child: Form(
          key: _fkey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 30),
                Text(
                  'Update Customer Data',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                textField('Name', name_cont),
                textField('Address', address_cont),
                textField('Mobile No', mobile_no_cont),
                // textFieldWithDropDown(context,'Item', item_cont),
                textField('Item Description', item_desc_cont),
                // textField('Delivery Date', delivery_date_cont),
                 Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton.icon(
                        onPressed: () async {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2040),
                          ).then((value) => value != null
                              ? delivery_date_cont.text = DateFormat.yMMMMd().format(value)
                              : '');
                        },
                        icon: Icon(Icons.date_range),
                        label: Text('Delivery Date :-')),
                    SizedBox(
                      width: 300,
                      child: textField('Delivery Date', delivery_date_cont),
                    )
                  ],
                ),
                // textField('Delivery Status', delivery_status_cont),
                CustomerStatusDrdownfield(),
                GestureDetector(
                  child: Container(
                    height: 50,
                    width: 400,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        'Submit',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                  onTap: () async {
                    if (_fkey.currentState!.validate()) {
                      final user = await acc.get();
                      final item = CustomerModel(
                          delivery_date: delivery_date_cont.text,
                          name: name_cont.text,
                          mobile_no: mobile_no_cont.text,
                          address: address_cont.text,
                          item_desc: item_desc_cont.text,
                          uploader: user.$id,
                          item: item_cont.text,
                          item_code: item_code_cont.text,
                          stock: stock_cont.text,
                          delivery_status: cont.dropDownValue.value);
                      updateCustomerData(context, ref_no, item);
                      cont.currentPageIndex.value = 2;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Data Updated'),
                        backgroundColor: Colors.blue,
                      ));
                      clearFields();
                    }
                  },
                ),
                SizedBox(height: 30)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void clearFields() {
    delivery_date_cont.clear();
    name_cont.clear();
    mobile_no_cont.clear();
    address_cont.clear();
    item_desc_cont.clear();
    delivery_status_cont.clear();
    item_cont.clear();
    item_code_cont.clear();
    stock_cont.clear();
  }
}


Widget CustomerStatusDrdownfield() {
  final items = [
    'In Process',
    'Delivered',
    'Cancelled',
  ];
  final cont = Get.find<ViewController>(tag: 'viewcont');
  return Obx(() {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black45, borderRadius: BorderRadius.circular(50)),
        child: Row(
          children: [
            SizedBox(width: 20),
            DropdownButton(
              alignment: AlignmentDirectional.center,
              value: cont.dropDownValue.value,
              dropdownColor: Colors.black,
              borderRadius: BorderRadius.circular(20),
              items: items.map((e) {
                return DropdownMenuItem(
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                  value: e,
                );
              }).toList(),
              onChanged: (dynamic val) {
                cont.dropDownValue.value = val;
              },
            ),
            Container()
          ],
        ),
      ),
    );
  });
}
