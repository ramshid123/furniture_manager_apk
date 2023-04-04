import 'package:flutter/material.dart';
import 'package:wooodapp/main.dart';
import 'package:wooodapp/model/customer_model.dart';
import 'package:wooodapp/model/item_model.dart';
import 'package:wooodapp/screens/leads/add_leads_page.dart';
import 'package:get/get.dart';
import 'package:wooodapp/controller/controller.dart';
import 'package:image_picker/image_picker.dart';

class AddItemsPage extends StatelessWidget {
  AddItemsPage({super.key});

  final item_name_cont = TextEditingController();
  final item_code_cont = TextEditingController();
  final supplier_cont = TextEditingController();
  final units_cont = TextEditingController();

  XFile? file;

  final _fkey = GlobalKey<FormState>();

  final cont = Get.find<ViewController>(tag: 'viewcont');

  @override
  Widget build(BuildContext context) {
    if (file != null) file = null;
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
                'Add Item Data',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              textField('Item Name', item_name_cont),
              textField('Item Code', item_code_cont),
              textField('Supplier', supplier_cont),
              textField('Units', units_cont),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final _picker = ImagePicker();
                  file = await _picker.pickImage(source: ImageSource.gallery,imageQuality: 10);
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
                      file != null &&
                      file!.name != '' &&
                      file!.name.isNotEmpty) {
                    await ItemModel(
                      item_name: item_name_cont.text,
                      item_code: item_code_cont.text,
                      supplier: supplier_cont.text,
                      units: units_cont.text,
                    ).addItemData(res: file);
                    cont.currentPageIndex.value = 5;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Data Added Successfully'),
                      backgroundColor: Colors.blue,
                    ));
                    clearFields();
                  } else if (file == null ||
                      file!.name == '' ||
                      file!.name.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Please Select a valid file'),
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
    item_code_cont.clear();
    item_name_cont.clear();
    supplier_cont.clear();
    units_cont.clear();
  }
}
