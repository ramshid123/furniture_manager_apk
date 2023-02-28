import 'package:flutter/material.dart';
import 'package:wooodapp/controller/controller.dart';
import 'package:wooodapp/main.dart';
import 'package:wooodapp/model/visit_customer_model.dart';
import 'package:wooodapp/screens/leads/add_leads_page.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddGoCustomerPage extends StatelessWidget {
  AddGoCustomerPage({super.key});

  final name_cont = TextEditingController();
  final address_cont = TextEditingController();
  final visit_date_cont = TextEditingController();
  final visit_desc_cont = TextEditingController();
  final mobile_no_cont = TextEditingController();

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
                'Add Visiting Data',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              textField('Name', name_cont),
              textField('Address', address_cont),
              textField('Mobile No', mobile_no_cont),
              // textField('Visit Date', visit_date_cont),
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
                        label: Text('Visiting Date :-')),
                    SizedBox(
                      width: 300,
                      child: textField('Visiting Date', visit_date_cont),
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
                onTap: ()async {
                  if (_fkey.currentState!.validate()) {
                    final user = await acc.get();
                    GoCustomerModel(
                      uploader: user.$id,
                      visit_date: visit_date_cont.text,
                      name: name_cont.text,
                      address: address_cont.text,
                      visit_desc: visit_desc_cont.text,
                      mobile_no: mobile_no_cont.text,
                    ).addGoCustomerData();
                    cont.currentPageIndex.value = 3;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Data Added Successfully'),
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
    );
  }

  void clearFields() {
    name_cont.clear();
    address_cont.clear();
    visit_date_cont.clear();
    mobile_no_cont.clear();
    visit_desc_cont.clear();
  }
}
