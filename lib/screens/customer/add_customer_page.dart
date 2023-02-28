import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wooodapp/main.dart';
import 'package:wooodapp/model/customer_model.dart';
import 'package:wooodapp/screens/leads/add_leads_page.dart';
import 'package:get/get.dart';
import 'package:wooodapp/controller/controller.dart';
import 'package:intl/intl.dart';

class AddCustomerPage extends StatelessWidget {
  AddCustomerPage({super.key});

  final name_cont = TextEditingController();
  final address_cont = TextEditingController();
  final mobile_no_cont = TextEditingController();
  final item_cont = TextEditingController();
  final item_desc_cont = TextEditingController();
  final delivery_date_cont = TextEditingController();
  final delivery_status_cont = TextEditingController();

  final _fkey = GlobalKey<FormState>();

  final cont = Get.find<ViewController>(tag: 'viewcont');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Form(
        key: _fkey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30),
              Text(
                'Add Customer Data',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              textField('Name', name_cont),
              textField('Address', address_cont),
              textField('Mobile No', mobile_no_cont),
              textFieldWithDropDown( 'Item', item_cont),
              textField('Item Description', item_desc_cont),
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
                            name: name_cont.text,
                            mobile_no: mobile_no_cont.text,
                            address: address_cont.text,
                            item: item_cont.text,
                            item_desc: item_desc_cont.text,
                            uploader: user.$id,
                            delivery_date: delivery_date_cont.text,
                            delivery_status: 'In Process')
                        .addCustomerData();
                    cont.currentPageIndex.value = 2;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Data Added Successfully'),
                      backgroundColor: Colors.blue,
                    ));
                    clearFields();
                  }
                  else if(item_cont.text.isEmpty){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Item field is required'),backgroundColor: Colors.red,));
                  }
                },
              ),
              SizedBox(height: 30)
            ],
          ),
        ),
      ),
    );
  }

  void clearFields() {
    item_desc_cont.clear();
    name_cont.clear();
    mobile_no_cont.clear();
    address_cont.clear();
    item_cont.clear();
    delivery_date_cont.clear();
    delivery_status_cont.clear();
  }
}
