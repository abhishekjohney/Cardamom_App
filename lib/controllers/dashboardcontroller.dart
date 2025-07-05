import 'package:get/get.dart';

class Dashboardcontroller extends GetxController {
  var items = <Map<String, String>>[
    {'name': 'Create Order', 'image': 'assets/images/create_order.png'},
    {'name': 'Item Master', 'image': 'assets/images/itemmaster.png'},
    {'name': 'Party Master', 'image': 'assets/images/partymaster.png'},
    {'name': 'Order List', 'image': 'assets/images/order_list.png'},
    {'name': 'Sync Master', 'image': 'assets/images/setting.png'},
    {'name': 'Cardamom Dashboard', 'image': 'assets/images/cardamom.png'},
    // {'name': 'Stock Taking', 'image': 'assets/images/addstock.png'},
    // {'name': 'Scanned Products', 'image': 'assets/images/scannedproduct.png'},
  ].obs;

  var cardamomitems = <Map<String, String>>[
    {'name': 'Stock Taking', 'image': 'assets/images/addstock.png'},
    {'name': 'Scanned Products', 'image': 'assets/images/scannedproduct.png'},
    {'name': 'Cardamom Management', 'image': 'assets/images/setting.png'},
  ].obs;
}



