import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:wooodapp/main.dart';
import 'package:wooodapp/model/purchase_model.dart';
import 'package:wooodapp/screens/leads/add_leads_page.dart';
import 'package:get/get.dart';
import 'package:wooodapp/controller/controller.dart';
import 'package:intl/intl.dart';

class AddPurchasePage extends StatelessWidget {
  AddPurchasePage({super.key});

  final supplier_name_cont= TextEditingController();
  final arrival_date_cont = TextEditingController();
  final item_name_cont = TextEditingController();
  final item_code_cont = TextEditingController();
  final item_desc_cont = TextEditingController();
  final quantity_cont = TextEditingController();

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
                'Add Purchase Order',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              textField('Supplier Name', supplier_name_cont),
              textFieldWithDropDown('Item Name', item_name_cont),
              textField('Item Description', item_desc_cont),
              textField('Quantity', quantity_cont),
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
                              ? arrival_date_cont.text = DateFormat.yMMMMd().format(value)
                              : '');
                        },
                        icon: Icon(Icons.date_range),
                        label: Text('Arrival Date :-')),
                    SizedBox(
                      width: 300,
                      child: textField('Arrival Date', arrival_date_cont),
                    )
                  ],
                ),
              // textField('Delivery Date', delivery_date_cont),
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
                onTap: () async{
                  if (_fkey.currentState!.validate()) {
                    final user = await acc.get();
                    PurchaseOrderModel(
                            supplier_name: supplier_name_cont.text,
                            arrival_date: arrival_date_cont.text,
                            item_name: item_name_cont.text,
                            item_desc: item_desc_cont.text,
                            quantity: quantity_cont.text,
                            uploader: user.$id,
                            order_status: 'In Process')
                        .addPurchaseOrderData();
                    cont.currentPageIndex.value = 5;
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
    supplier_name_cont.clear();
    item_code_cont.clear();
    item_desc_cont.clear();
    item_name_cont.clear();
    arrival_date_cont.clear();
    quantity_cont.clear();
  }
}
