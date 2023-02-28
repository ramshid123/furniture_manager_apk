import 'dart:convert';
import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wooodapp/splash_screen.dart';
import 'package:wooodapp/controller/controller.dart';
import 'package:wooodapp/screens/dashboard/dashboard_screen.dart';
import 'package:wooodapp/screens/demo_pages.dart';
import 'package:wooodapp/screens/items/add_items_page.dart';
import 'package:wooodapp/screens/items/items_page.dart';
import 'package:wooodapp/screens/login/login_screen.dart';
import 'package:wooodapp/screens/main_page.dart';
import 'package:wooodapp/screens/manage_accounts_page.dart/add_account_page.dart';
import 'package:wooodapp/screens/manage_accounts_page.dart/manage_acc_page.dart';
import 'package:get/get.dart';
import 'package:wooodapp/screens/customer/add_customer_page.dart';
import 'package:wooodapp/screens/customer/customer_page.dart';
import 'package:wooodapp/screens/leads/add_leads_page.dart';
import 'package:wooodapp/screens/leads/leads_page.dart';
import 'package:wooodapp/screens/visit_customer/add_go_customer_page.dart';
import 'package:wooodapp/screens/visit_customer/visit_customer_page.dart';
import 'package:wooodapp/screens/Purchase_Order/add_purchase_page.dart';
import 'package:wooodapp/screens/Purchase_Order/purchase_page.dart';
import 'package:wooodapp/services/auth.dart';

void main(List<String> args) async {
  final cont = Get.put(ViewController(), tag: 'viewcont', permanent: true);
  initAppwrite();
  // await WindowManager.instance.setFullScreen(cont.isfullscreen.value);
  // await FullScreen.enterFullScreen(FullScreenMode.EMERSIVE);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cont = Get.find<ViewController>(tag: 'viewcont');
    return GetMaterialApp(
        title: 'WooodApp',
        home: Obx(
          () => cont.isInitialisingApp.value
              ? SplashScreen()
              : (isLoggedIn ? MainPage() : LoginScreen()),
        ));
  }
}

final databaseId = '63ab321c196cbdb3472d';
final bucketId = '63b9a8450f4654fba4a3';
final endPoint = 'https://115b-129-154-237-199.in.ngrok.io/v1';
// final endPoint = 'https://lemon-pants-vanish-129-154-237-199.loca.lt/v1';

late Databases db;
late Account acc;
late Realtime realtime;
RealtimeSubscription? subscription;
late Storage storage;

Future<void> initAppwrite() async {
  final cont = Get.find<ViewController>(tag: 'viewcont');
  cont.isInitialisingApp.value = true;
  WidgetsFlutterBinding.ensureInitialized();
  //  await windowManager.ensureInitialized();
  Client client = Client();
  client
      .setEndpoint(endPoint)
      .setProject('63ab320db49e5e71525f')
      .setSelfSigned(status: true);

  db = Databases(client);
  storage = Storage(client);
  acc = Account(client);
  realtime = Realtime(client);

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        cont.isInternet.value = true;
      }
    } on SocketException catch (_) {
      cont.isInternet.value = false;
    }

  

  final pref = await SharedPreferences.getInstance();
  final email = pref.getString('email');
  final password = pref.getString('password');
  if ((email != null) && (password != null)) {
    await AuthService().Login(email, password, isFromLoginPage: false);
    isLoggedIn = true;
  } else {
    isLoggedIn = false;
  }
  if(cont.isInternet.value)cont.isInitialisingApp.value = false;
}

// void subscribe() async {
//   subscription = realtime.subscribe(['account']);
//   subscription!.stream.listen((event) {
//     print(
//         '/\\\\\\\\\\\\\\\\\\\\\\\\\\\\ ${event.payload['userId']} \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\/');
//     if (event.payload['userId'] != null) {
//       Get.off(() => MainPage());
//     } else {
//       Get.off(() => LoginScreen());
//     }
//   });
// }

final screens = [
  DashBoardScreen(), //0
  LeadsPage(), //1
  CustomerPage(), //2
  VisitCustomerPage(), //3
  SalesPage(), //4
  PurchasePage(), //5
  ReportPage(), //6
  ItemsPage(), //7
  ManageAccountsPage(), //8
  ////////////////
  AddLeadsPage(), //9
  AddCustomerPage(), //10
  AddGoCustomerPage(), //11
  AddPurchasePage(), //12
  AddItemsPage(), //13
  AddAccountsPage(), //14
];

final superAdmin = 'admin@main.com';
bool isAdmin = false;
String currentUserName = '';
String currentUserPic = '';
String currentUserEmail = '';
String currentUserPass = '';
bool isLoggedIn = false;



// String apiKey = '60aceace919666b05c8b0e674f105127c8d6e900e63044e278c421c4b1db45cb08db4361a84199ff8d691a81b1e635717148af4f470ec2818bd504ad14e5086de4b7567f142ea1ebe6354c0b4ce892e969a9ecf8b87531dae216b4cfc336cbb0bda6abce1b0f8cb10d8e1ebd7c76e8cbdc996c8bb3c66f56f9b7b2fc60e59981';

// Future<void> getDocumentCount() async {
//     final response = await http.get(
//         Uri.parse('https://115b-129-154-237-199.in.ngrok.io/v1/databases/63ab321c196cbdb3472d/collections/$leadsCollectionId'),
//         headers: {
//             'x-appwrite-project': '63ab320db49e5e71525f',
//             'x-appwrite-key': apiKey,
//         },
//     );
//     final jsonResponse = jsonDecode(response.body);
//     print('\\\\\\\\\\\\\\\\\\\\\\\\\\\n\n\n${jsonResponse}\n\n\n\\\\\\\\\\\\\\\\\\\\\\\\\\\\');
// }