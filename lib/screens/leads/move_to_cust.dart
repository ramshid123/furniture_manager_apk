import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wooodapp/controller/controller.dart';
import 'package:wooodapp/main.dart';
import 'package:wooodapp/model/customer_model.dart';
import 'package:wooodapp/model/leads_model.dart';
import 'package:wooodapp/screens/leads/add_leads_page.dart';
import 'package:wooodapp/screens/login/login_screen.dart';
import 'package:wooodapp/screens/main_page.dart';
import 'package:wooodapp/screens/side_menu/side_menu_screen.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MoveToCustomer extends StatelessWidget {
  String name;
  String mobile_no;
  String address;
  String item_desc;
  String item;
  String doc_id;
  MoveToCustomer(
      {Key? key,
      required this.doc_id,
      required this.name,
      required this.mobile_no,
      required this.address,
      required this.item_desc,
      required this.item})
      : super(key: key);

  final name_cont = TextEditingController();
  final mobile_no_cont = TextEditingController();
  final address_cont = TextEditingController();
  final item_desc_cont = TextEditingController();
  final item_cont = TextEditingController();
  final delivery_status_cont = TextEditingController();
  final delivery_date_cont = TextEditingController();

  final _fkey = GlobalKey<FormState>();

  final cont = Get.find<ViewController>(tag: 'viewcont');

  void init() {
    name_cont.text = name;
    mobile_no_cont.text = mobile_no;
    address_cont.text = address;
    item_desc_cont.text = item_desc;
    item_cont.text = item;
    delivery_status_cont.text = 'In Process';
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
                  'Move To Customer Data',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                textField('Name', name_cont),
                textField('Mobile No', mobile_no_cont),
                textField('Address', address_cont),
                // textFieldWithDropDown(context,'Item', item_cont),
                textField('Item Description', item_desc_cont),
                // textField('Delivery Status', delivery_status_cont),
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
                    if (_fkey.currentState!.validate() &&
                        item_cont.text.isNotEmpty) {
                      final user = await acc.get();
                      CustomerModel(
                              ref_no: doc_id,
                              name: name_cont.text,
                              mobile_no: mobile_no_cont.text,
                              address: address_cont.text,
                              item_desc: item_desc_cont.text,
                              uploader: user.$id,
                              item: item_cont.text,
                              delivery_status: delivery_status_cont.text,
                              delivery_date: delivery_date_cont.text)
                          .addCustomerData();
                      deleteLeadsData(context, doc_id);
                      Get.off(() => MainPage());
                      cont.currentPageIndex.value = 2;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Moved To Customer'),
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
    name_cont.clear();
    mobile_no_cont.clear();
    address_cont.clear();
    item_desc_cont.clear();
    delivery_date_cont.clear();
    delivery_status_cont.clear();
    item_cont.clear();
  }
}
