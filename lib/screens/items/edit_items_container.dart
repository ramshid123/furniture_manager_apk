import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:wooodapp/controller/controller.dart';
import 'package:wooodapp/model/item_model.dart';
import 'package:wooodapp/screens/leads/add_leads_page.dart';
import 'package:get/get.dart';

class EditItemDataContainer extends StatelessWidget {
  BuildContext ctx;
  String doc_id;
  Document doc;
  EditItemDataContainer(
      {super.key, required this.ctx, required this.doc_id, required this.doc});

  final item_name_cont = TextEditingController();
  final item_code_cont = TextEditingController();
  final supplier_cont = TextEditingController();
  final units_cont = TextEditingController();

  final cont = Get.find<ViewController>(tag: 'viewcont');

  final _fkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    init();
    return Container(
      height: (Get.height/3)*2,
      color: Colors.grey[900],
      child: Form(
        key: _fkey,
        child: Column(
          children: [
            SizedBox(height: 20),
            textField('Item Name', item_name_cont),
            textField('Item Code', item_code_cont),
            textField('Supplier', supplier_cont),
            textField('Units in stock', units_cont),
            SizedBox(height: 10),
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
                    'Update',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
              onTap: () async {
                if (_fkey.currentState!.validate()) {
                  final item = ItemModel(
                      item_name: item_name_cont.text,
                      item_code: item_code_cont.text,
                      supplier: supplier_cont.text,
                      img: doc.data['img'],
                      doc_id: doc.data['doc_id'],
                      units: units_cont.text);
                  await updateItemsData(context, doc_id, item);
                  Get.back();
                  cont.currentPageIndex.value = 7;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Data Updated Successfully'),
                    backgroundColor: Colors.blue,
                  ));
                  clearFields();
                  getItemsData(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void clearFields() {
    item_name_cont.clear();
    item_code_cont.clear();
    supplier_cont.clear();
    units_cont.clear();
  }

  void init() {
    item_name_cont.text = doc.data['item_name'];
    item_code_cont.text = doc.data['item_code'];
    supplier_cont.text = doc.data['supplier'];
    units_cont.text = doc.data['units'];
  }
}
