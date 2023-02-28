import 'package:get/get.dart';

class ViewController extends GetxController{
  var currentPageIndex = 0.obs;
  var selectedButton = 0.obs;
  var isfullscreen = true.obs;
  var fileName = ''.obs;
  var isLoading = false.obs;
  var suggestions = [''].obs;
  var dropDownValue = ''.obs;
  var isInitialisingApp = false.obs;
  var isInternet = false.obs;

  var leadI = 0.obs;
  var cusI = 0.obs;
  var visI = 0.obs;
  var poI = 0.obs;
  var itemI = 0.obs;
  var accI = 0.obs;
  var loginI = 0.obs;
  var actI = 0.obs;
}