import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:wooodapp/controller/controller.dart';
import 'package:wooodapp/main.dart';
import 'package:wooodapp/model/customer_model.dart';
import 'package:wooodapp/model/leads_model.dart';
import 'package:wooodapp/model/visit_customer_model.dart';
import 'package:wooodapp/screens/leads/add_leads_page.dart';
import 'package:wooodapp/screens/login/login_screen.dart';
import 'package:wooodapp/screens/main_page.dart';
import 'package:wooodapp/screens/side_menu/side_menu_screen.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UpdateGoCustomerPage extends StatelessWidget {
  String address;
  String visit_date;
  String visit_desc;
  String mobile_no;
  String name;
  String ref_no;
  UpdateGoCustomerPage({
    Key? key,
    required this.ref_no,
    required this.visit_date,
    required this.name,
    required this.visit_desc,
    required this.address,
    required this.mobile_no,
  }) : super(key: key);

  final visit_date_cont = TextEditingController();
  final visit_desc_cont = TextEditingController();
  final mobile_no_cont = TextEditingController();
  final address_cont = TextEditingController();
  final name_cont = TextEditingController();

  final _fkey = GlobalKey<FormState>();

  final cont = Get.find<ViewController>(tag: 'viewcont');

  void init() {
    name_cont.text = name;
    visit_desc_cont.text = visit_desc;
    mobile_no_cont.text = mobile_no;
    address_cont.text = address;

    visit_date_cont.text = visit_date;
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
                  'Update Visit Customer Data',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                textField('Name', name_cont),
                textField('Address', address_cont),
                textField('Move Option', mobile_no_cont),
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
                              ? visit_date_cont.text = DateFormat.yMMMMd().format(value)
                              : '');
                        },
                        icon: Icon(Icons.date_range),
                        label: Text('Visit Date :-')),
                    SizedBox(
                      width: 300,
                      child: textField('Visit Date', visit_date_cont),
                    )
                  ],
                ),
                textField('Visit Description', visit_desc_cont),
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
                      final item = GoCustomerModel(
                          uploader: user.$id,
                          visit_date: visit_date_cont.text,
                          name: name_cont.text,
                          mobile_no: mobile_no_cont.text,
                          address: address_cont.text,
                          visit_desc: visit_desc_cont.text);
                      updateGoCustomerData(context, ref_no, item);
                      cont.currentPageIndex.value = 3;
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
    visit_date_cont.clear();
    name_cont.clear();
    mobile_no_cont.clear();
    address_cont.clear();
    visit_desc_cont.clear();
  }
}


