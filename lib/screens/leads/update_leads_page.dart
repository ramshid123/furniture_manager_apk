import 'package:flutter/material.dart';
import 'package:wooodapp/controller/controller.dart';
import 'package:wooodapp/main.dart';
import 'package:wooodapp/model/leads_model.dart';
import 'package:wooodapp/model/account_model.dart';
import 'package:wooodapp/screens/leads/add_leads_page.dart';
import 'package:wooodapp/screens/login/login_screen.dart';
import 'package:wooodapp/screens/main_page.dart';
import 'package:wooodapp/screens/side_menu/side_menu_screen.dart';
import 'package:get/get.dart';

class UpdateLeadsPage extends StatelessWidget {
  String lead_source;
  String name;
  String mobile_no;
  String address;
  String item_desc;
  // String status;
  String item;
  String doc_id;
  UpdateLeadsPage({
    Key? key,
    required this.doc_id,
    required this.lead_source,
    required this.name,
    required this.mobile_no,
    required this.address,
    required this.item_desc,
    required this.item,
  }) : super(key: key);

  final lead_source_cont = TextEditingController();
  final name_cont = TextEditingController();
  final mobile_no_cont = TextEditingController();
  final address_cont = TextEditingController();
  final item_desc_cont = TextEditingController();
  final item_cont = TextEditingController();
  // final status_cont = TextEditingController();

  final _fkey = GlobalKey<FormState>();

  final cont = Get.find<ViewController>(tag: 'viewcont');

  void init() {
    cont.dropDownValue.value = lead_source;
    name_cont.text = name;
    mobile_no_cont.text = mobile_no;
    address_cont.text = address;
    item_desc_cont.text = item_desc;
    item_cont.text = item;
    // status_cont.text = status;
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
                  'Update Leads Data',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                // textField('Lead Source', lead_source_cont),
                Leadsdrdownfield(),
                textField('Name', name_cont),
                textField('Mobile No', mobile_no_cont),
                textField('Address', address_cont),
                // textField('Item', item_cont),
                // textFieldWithDropDown(context, 'Item', item_cont),
                textField('Item Description', item_desc_cont),
                // textField('Status', status_cont),
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
                      final item = LeadsModel(
                        lead_source: cont.dropDownValue.value,
                        name: name_cont.text,
                        mobile_no: mobile_no_cont.text,
                        address: address_cont.text,
                        item_desc: item_desc_cont.text,
                        item: item_cont.text,
                        uploader: user.$id,
                        status: '',
                      );
                      updateLeadsData(context, doc_id, item);
                      cont.currentPageIndex.value = 1;
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
    lead_source_cont.clear();
    name_cont.clear();
    mobile_no_cont.clear();
    address_cont.clear();
    item_desc_cont.clear();
    // status_cont.clear();
    item_cont.clear();
  }
}



