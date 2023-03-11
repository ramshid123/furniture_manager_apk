import 'package:flutter/material.dart';
import 'package:wooodapp/main.dart';
import 'package:wooodapp/model/account_model.dart';
import 'package:wooodapp/model/customer_model.dart';
import 'package:wooodapp/model/item_model.dart';
import 'package:wooodapp/screens/leads/add_leads_page.dart';
import 'package:get/get.dart';
import 'package:wooodapp/controller/controller.dart';
import 'package:image_picker/image_picker.dart';

class AddAccountsPage extends StatelessWidget {
  AddAccountsPage({super.key});

  final name_cont = TextEditingController();
  final email_cont = TextEditingController();
  final mobile_no_cont = TextEditingController();
  final password_cont = TextEditingController();
  final address_cont = TextEditingController();

  XFile? file;

  final _fkey = GlobalKey<FormState>();

  final cont = Get.find<ViewController>(tag: 'viewcont');

  @override
  Widget build(BuildContext context) {
    if (file != null) file=null;
    print(file);
    cont.fileName.value = '';
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Form(
        key: _fkey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30),
              Text(
                'Add Account Data',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              textField('Full Name', name_cont),
              textField('Mobile No', mobile_no_cont),
              textField('Address', address_cont),
              textField('Email', email_cont),
              textField('Password', password_cont),
              AccountTypeDropDownList(),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final _picker = ImagePicker();
                  file = await _picker.pickImage(source: ImageSource.gallery);
                  print(file);
                  Get.find<ViewController>(tag: 'viewcont').fileName.value =
                      file!.name;
                },
                child: Text('Select Image'),
              ),
              Obx(() {
                // print(Get.find<ViewController>(tag: 'viewcont'));
                return Text(
                  Get.find<ViewController>(tag: 'viewcont').fileName.value,
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                );
              }),
              SizedBox(height: 30),
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
                      cont.dropDownValue.value != '(Select Account Type)') {
                    await AccountModel(
                      name: name_cont.text,
                      role: cont.dropDownValue.value,
                      email: email_cont.text.trim(),
                      password: password_cont.text,
                      mobile_no: mobile_no_cont.text,
                      address: address_cont.text,
                    ).addAccount(file: file);
                    if (!isEmailExist) {
                      cont.currentPageIndex.value = 8;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Data Added Successfully'),
                        backgroundColor: Colors.blue,
                      ));
                      clearFields();
                    }
                  } else if (cont.dropDownValue.value ==
                      '(Select Account Type)') {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Please Select a Account Type'),
                      backgroundColor: Colors.red,
                    ));
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
    email_cont.clear();
    mobile_no_cont.clear();
    password_cont.clear();
    address_cont.clear();
  }
}

Widget AccountTypeDropDownList() {
  final items = [
    '(Select Account Type)',
    'Admin',
    'Sales Man',
  ];
  final cont = Get.find<ViewController>(tag: 'viewcont');
  cont.dropDownValue.value = items[0];
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
            Container(),
          ],
        ),
      ),
    );
  });
}
