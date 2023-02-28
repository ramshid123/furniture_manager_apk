import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:wooodapp/controller/controller.dart';
import 'package:wooodapp/main.dart';
import 'package:wooodapp/model/item_model.dart';
import 'package:wooodapp/model/leads_model.dart';
import 'package:get/get.dart';

class AddLeadsPage extends StatelessWidget {
  AddLeadsPage({Key? key}) : super(key: key);

  final lead_source_cont = TextEditingController();
  final name_cont = TextEditingController();
  final mobile_no_cont = TextEditingController();
  final address_cont = TextEditingController();
  final item_desc_cont = TextEditingController();
  // final status_cont = TextEditingController();
  final item_cont = TextEditingController();

  final _fkey = GlobalKey<FormState>();

  final cont = Get.find<ViewController>(tag: 'viewcont');

  @override
  Widget build(BuildContext context) {
    // getItemsData(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Form(
        key: _fkey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30),
              Text(
                'Add Leads Data',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Leadsdrdownfield(isNew: true)],
              ),
              // textField('Lead Source', lead_source_cont),
              textField('Name', name_cont),
              textField('Mobile No', mobile_no_cont),
              textFieldWithDropDown('Item', item_cont),
              textField('Address', address_cont),
              // textFieldWithDropDown(context, 'Item', item_cont),
              // textField('Item', item_cont),
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
                  if (_fkey.currentState!.validate() &&
                      cont.dropDownValue.value != '(Select Lead Source)' &&
                      item_cont.text.isNotEmpty) {
                    final user = await acc.get();
                    await LeadsModel(
                            lead_source: cont.dropDownValue.value,
                            name: name_cont.text,
                            mobile_no: mobile_no_cont.text,
                            address: address_cont.text,
                            item_desc: item_desc_cont.text,
                            item: item_cont.text,
                            uploader: user.$id,
                            status: '')
                        .addLeadsData();
                    cont.currentPageIndex.value = 1;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Data Added Successfully'),
                      backgroundColor: Colors.blue,
                    ));
                    clearFields();
                  } else if (cont.dropDownValue.value ==
                      '(Select Lead Source)') {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Please Select a Lead Source'),
                      backgroundColor: Colors.red,
                    ));
                  } else if (item_cont.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Item field is required'),
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
    lead_source_cont.clear();
    name_cont.clear();
    mobile_no_cont.clear();
    address_cont.clear();
    item_desc_cont.clear();
    // status_cont.clear();
    item_cont.clear();
  }
}

Widget textField(String name, TextEditingController cont) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 10),
    child: TextFormField(
      controller: cont,
      style: TextStyle(color: Colors.white),
      keyboardType:(name.contains('Quantity') || name.contains('Units') || name.contains('Mobile'))?TextInputType.number:TextInputType.text ,
      textAlign: name.contains('Date') ? TextAlign.center : TextAlign.start,
      readOnly: name.contains('Date') ? true : false,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.black45,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(30)),
          labelText: name,
          labelStyle: TextStyle(color: Colors.grey)),
      validator: (val) {
        return val!.isEmpty
            ? 'Please Enter Valid Data'
            : ((name.contains('Quantity') || name.contains('Units')) &&
                    val.contains(RegExp(r'[A-Za-z]'))
                ? 'Value must be numeric'
                : (name.contains('Mobile') &&
                        (val.contains(RegExp(r'[A-Za-z]')) ||
                            (val.length < 10 || val.length > 10))
                    ? 'Invalid Phone Number'
                    : (name == 'Email' &&
                            (!val.contains('@') || !val.contains('.')))
                        ? 'Please Enter a valid Email'
                        : (name == "Password" && val.length < 8)
                            ? 'Password should be atleast 8 charecters'
                            : null));
      },
    ),
  );
}

Widget Leadsdrdownfield({bool isNew = false}) {
  final items = [
    '(Select Lead Source)',
    'Social Media',
    'Advertisement',
    'Previous Customers',
    'Other'
  ];
  final cont = Get.find<ViewController>(tag: 'viewcont');
  if (isNew) cont.dropDownValue.value = items[0];
  return Obx(() {
    return IntrinsicWidth(
      child: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.black45, borderRadius: BorderRadius.circular(50)),
          child: Row(
            children: [
              SizedBox(width: 20),
              DropdownButton(
                underline: Container(),
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
      ),
    );
  });
}

Widget textFieldWithDropDown(String name, TextEditingController cont) {
  final getcont = Get.find<ViewController>(tag: 'viewcont');
  List<String> cacheList = [];
  void init() async {
    getcont.suggestions.value.clear();
    await getItemsForListing();
    getcont.suggestions.value.clear();
    item_model_list.forEach((element) {
      cacheList.add(int.parse(element.units) <= 0 ? 'red' : 'green');
      getcont.suggestions.value.add(element.item_name);
    });
  }

  init();
  return Theme(
    data: ThemeData(
        textTheme: TextTheme(subtitle1: TextStyle(color: Colors.white))),
    child: DropdownSearch(
      mode: Mode.MENU,
      popupBackgroundColor: Colors.black,
      showSearchBox: true,
      showSelectedItem: true,
      validator: (val) {
        return val == null ? 'Please Enter Valid Data' : null;
      },
      showClearButton: true,
      items: getcont.suggestions.value,
      label: name,
      popupItemBuilder: (context, item, isSelected) => IntrinsicWidth(
        child: Container(
          color:
              cacheList[getcont.suggestions.value.indexOf(item.toString())] ==
                      'red'
                  ? Colors.red[900]
                  : Colors.green[900],
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Text(
            item.toString(),
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      searchBoxDecoration: InputDecoration(
          label: Text(
            'Search a Item',
            style: TextStyle(color: Colors.grey),
          ),
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white))),
      dropdownSearchDecoration: InputDecoration(
          filled: true,
          fillColor: Colors.black45,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(30)),
          labelText: name,
          labelStyle: TextStyle(color: Colors.grey)),
      onChanged: (val) {
        cont.text = val.toString();
      },
    ),
  );
}
