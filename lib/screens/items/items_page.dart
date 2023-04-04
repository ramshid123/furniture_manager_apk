import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:wooodapp/controller/controller.dart';
import 'package:wooodapp/main.dart';
import 'package:wooodapp/model/item_model.dart';
import 'package:wooodapp/model/leads_model.dart';
import 'package:wooodapp/screens/items/edit_items_container.dart';
import 'package:wooodapp/screens/leads/leads_page.dart';
import 'package:get/get.dart';

class ItemsPage extends StatelessWidget {
  ItemsPage({super.key});

  final cont = Get.find<ViewController>(tag: 'viewcont');

  @override
  Widget build(BuildContext context) {
    getItemsData(context);
    final size = MediaQuery.of(context).size;
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverAppBar(
          pinned: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.grey[900],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ItemSearchField(context),
              IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      enableDrag: true,
                      context: context,
                      builder: ((context) => Container(
                            color: Colors.black,
                            width: double.infinity,
                            height: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    cont.currentPageIndex.value = 11;
                                    Get.back();
                                  },
                                  label: Text('Add Data'),
                                  icon: Icon(Icons.add),
                                ),
                                SizedBox(height: 20),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    getItemsData(context);
                                    Get.back();
                                  },
                                  label: Text('Refresh'),
                                  icon: Icon(Icons.refresh),
                                )
                              ],
                            ),
                          )),
                    );
                  },
                  icon: Icon(Icons.settings))
            ],
          ),
        ),
      ],
      body: Obx(() {
        print(Get.find<ViewController>(tag: 'viewcont').itemI.value);
        avoidItemsDuplicates();
        return cont.isLoading.value
            ? Center(
                child: SizedBox(
                  height: 150,
                  width: 150,
                  child: CircularProgressIndicator(),
                ),
              )
            : (item_model_list.length == 0
                ? Center(
                    child: Text('No Items',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold)))
                : ListView.builder(
                    itemBuilder: (context, index) {
                      final e = item_model_list[index];
                      return ImageContainer(context, e.item_name, e.item_code,
                          e.units, e.img, e.doc_id);
                    },
                    itemCount: item_model_list.length,
                  )
            // SingleChildScrollView(
            //     child: Wrap(
            //       alignment: WrapAlignment.center,
            //       children: item_model_list
            //           .map((e) => ImageContainer(context, e.item_name,
            //               e.item_code, e.units, e.img, e.doc_id))
            //           .toList(),
            //     ),
            //   )
            );
      }),
    );
  }
}

Widget ImageContainer(BuildContext context, String name, String code,
    String count, String img, String doc_id) {
  return IntrinsicHeight(
    child: GestureDetector(
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        color: Colors.black54,
        width: Get.width - 50,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                '$endPoint/storage/buckets/$bucketId/files/$img/view?project=64296421a251168288ea',
                filterQuality: FilterQuality.low,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                fit: BoxFit.cover,
                width: Get.width - 50,
                height: 160,
              ),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 300,
                  child: Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final doc = await db.getDocument(
                        databaseId: databaseId,
                        collectionId: itemCollectionId,
                        documentId: doc_id);
                    showBottomSheet(
                      context: context,
                      builder: ((context) => EditItemDataContainer(
                          ctx: context, doc_id: doc_id, doc: doc)),
                    );
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                )
              ],
            ),
            Divider(
              color: Colors.grey,
            ),
            Text(
              'code : $code',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Text(
                  '$count in Stock',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 17,
                  ),
                ),
                SizedBox(width: 10),
                CircleAvatar(
                  radius: 10,
                  backgroundColor:
                      int.parse(count) <= 0 ? Colors.red : Colors.green,
                )
              ],
            ),
          ],
        ),
      ),
      onTap: () async {
        final data = await getSingleItemsData(context, doc_id);
        showModalBottomSheet(
            context: context,
            builder: ((context) => SingleItemDataContainer(context, data)));
      },
    ),
  );
}

Widget ItemSearchField(BuildContext context) {
  return SizedBox(
    width: 300,
    child: TextField(
      onSubmitted: (value) {
        if (value == '')
          getItemsData(context);
        else
          searchItemsData(value);
      },
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.red,
      cursorHeight: 25,
      cursorWidth: 5,
      cursorRadius: Radius.circular(20),
      decoration: InputDecoration(
        hintText: 'Search for Name or Code',
        hintStyle: TextStyle(color: Colors.grey, letterSpacing: 1),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    ),
  );
}

Widget SingleItemDataContainer(BuildContext context, Document? doc) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.grey[900],
    ),
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 50),
      width: Get.width - 50,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Image.network(
              // doc!.data['img'],
              '$endPoint/storage/buckets/$bucketId/files/${doc!.data['img']}/view?project=64296421a251168288ea',
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              height: 300,
              width: 600,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 10),
            SingleLeadsDataContainerTextMobileMode(
                'Name', doc.data['item_name']),
            SingleLeadsDataContainerTextMobileMode(
                'Code', doc.data['item_code']),
            SingleLeadsDataContainerTextMobileMode(
                'Supplier', doc.data['supplier']),
            SingleLeadsDataContainerTextMobileMode('Units', doc.data['units']),
            Visibility(
              visible: isAdmin,
              child: Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 300),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 50),
                              Text(
                                'Are you sure to delete?',
                                style: TextStyle(fontSize: 22),
                              ),
                              SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      deleteItemsData(context, doc.data['doc_id'],
                                          doc.data['img']);
                                      Get.back();
                                      Get.back();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text('Item Deleted'),
                                        backgroundColor: Colors.red,
                                      ));
                                    },
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(fontSize: 22),
                                    ),
                                  ),
                                  SizedBox(width: 50),
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text(
                                      'No',
                                      style: TextStyle(fontSize: 22),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    child: Text('Delete')),
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('Go Back')),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget SingleItemDataContainerText(String title, String name) {
  return Column(
    children: [
      Row(
        children: [
          SizedBox(
            width: 170,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white54,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            ' : ',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: 600,
            child: Text(
              name,
              softWrap: true,
              overflow: TextOverflow.visible,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
      SizedBox(height: 20),
    ],
  );
}
