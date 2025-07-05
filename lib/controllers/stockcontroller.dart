import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopapp/model/cart.dart';
import 'package:shopapp/model/itemmastermodel.dart';
import 'package:shopapp/model/partymastermodel.dart';
import 'package:shopapp/model/scanneditemsfetch.dart';
import 'dart:convert';
// import 'package:shopapp/utils/dbhandler.dart'; // Commented out - using API-based data

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class StockController extends GetxController {
  var stockList = <ItemMasterModel>[].obs;
  var fetchsacitemlist = <ScannedItemFetch>[].obs;
  var fetchitemmaster=false.obs;
  var fetchitems=false.obs;
  var cartLength = 0.obs;
  var quantity = '0'.obs;
  var changeitemtogrid=false.obs;

  // List<Map<String, dynamic>> fetchItemsData = [].obs as List<Map<String, dynamic>>;
  // var fetchItemsData = <Map<String, dynamic>>[].obs; // Use RxList<Map<String, dynamic>>
  var fetchItemsData = <ItemMasterModel>[].obs;
  var filteredItems = <ItemMasterModel>[].obs;
  var cartItems = <CartItem>[].obs;
  @override
  void onInit() async{
    super.onInit();
    await fetchAndStoreStockData();
    await fetchitemsfromlocal();
    filteredItems.value = fetchItemsData;
  }
  void filterItems(String query) {
    if (query.isEmpty) {
      filteredItems.value = fetchItemsData;
    } else {
      query = query.toLowerCase();
      filteredItems.value = fetchItemsData.where((item) {
        return (item.itmNam?.toLowerCase().contains(query) ?? false) ||
            (item.productGroup?.toLowerCase().contains(query) ?? false) ||
            (item.salePrice?.toString().contains(query) ?? false);
      }).toList();
    }
  }
  Future<void> fetchAndStoreStockData() async {
    try {
      final response = await http.post(
        Uri.parse('http://nwbo1.jubilyhrm.in/Api/WebSeriviceMobileAppSync.aspx'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {"title": 'GetItemMasterFoMobileApp'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        print("Response body: ${response.body}");
        String jsonResponse = response.body;

        if (response.body.contains('||JasonEnd')) {
          jsonResponse = response.body.split('||JasonEnd')[0].trim();
          final decodedJson = json.decode(jsonResponse);

          var data = decodedJson[0]['JSONData1'];
          var dataa = jsonDecode(data);

          List<ItemMasterModel> items = List<ItemMasterModel>.from(
            dataa.map((item) => ItemMasterModel.fromMap(item)),
          );
          stockList.addAll(items);
          print("Stock List updated: ${stockList.length} items");
        }
      } else {
        print("Failed to fetch data: ${response.statusCode}");
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }

  Future<void> fetchitemsfromlocal()async{
    try {
      fetchitems.value=true;
      // Database operations commented out - using API-based data instead
      // final data = await DBHandler().readItemData();
      // fetchItemsData.value = data.map<ItemMasterModel>((item) => ItemMasterModel.fromMap(item)).toList();
      
      print("Local item fetch disabled - using API-based data");
      fetchItemsData.value = []; // Return empty list for now
      
      fetchitems.value=false;
    } catch (e) {
      // Show error message
      Get.snackbar('Error', 'Failed to fetch data: $e',
          snackPosition: SnackPosition.BOTTOM);
      fetchitems.value=false;
    } finally {
      fetchitems.value=false;
    }
  }

  Future<void> loadCartItems(String orderid) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cart = prefs.getStringList('cart${orderid.toString()}') ?? [];

    print("dfdfdfdfd"+cart.toString());
    // Check if the stored data is valid
    try {
        cartItems.value = cart.map((e) {
          try {
            return CartItem.fromJson(e); // Try parsing each item
          } catch (e) {
            print("Error parsing cart item: $e");
            return null; // Handle any invalid JSON items gracefully
          }
        }).whereType<CartItem>().toList(); // Filter out null values and cast to List<CartItem>

    } catch (e) {
      print("Error loading cart items: $e");
    }
  }



  Future<void> fetchScannedItemdatabycode(String ReqItemCode) async {
    try {
      final response = await http.post(
        Uri.parse('https://facebojyothi.magnussoftech.in/WebDataProcessingReact.aspx'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          "title":"GetItemMasterByCode",
          "description":"Request For Stock Item Display List",
          "ReqItemCode":"$ReqItemCode",
          "ReqPartyCode":"4715",
          "ReqWithStock":"yes"
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        print("Response bodydddd: ${response.body}");
        String jsonResponse = response.body;

        if (response.body.contains('||JasonEnd')) {
          jsonResponse = response.body.split('||JasonEnd')[0].trim();
          final decodedJson = json.decode(jsonResponse);

          var data = decodedJson[0]['JSONData1'];
          var dataa = jsonDecode(data);

          List<ScannedItemFetch> items = List<ScannedItemFetch>.from(
            dataa.map((item) => ScannedItemFetch.fromMap(item)),
          );

          //
          fetchsacitemlist.addAll(items);
          print("fetchsacitemlist List updated: ${fetchsacitemlist.length} items");
        }
      } else {
        print("Failed to fetch data: ${response.statusCode}");
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }




}


// class StockController extends GetxController {
//   var stockList = <ItemMasterModel>[].obs;
//
//     @override
//   void onInit() {
//     super.onInit();
//     fetchAndStoreStockData();
//   }
//
//
//   Future<void> fetchAndStoreStockData() async {
//     try {
//       final response = await http.post(
//         Uri.parse('http://nwbo1.jubilyhrm.in/Api/WebSeriviceMobileAppSync.aspx'),
//         headers: {'Content-Type': 'application/x-www-form-urlencoded'},
//         body: {
//           "title": 'GetItemMasterFoMobileApp'
//         },
//       ).timeout(const Duration(seconds: 10));
//
//       if (response.statusCode == 200) {
//         print("Response body: ${response.body}");
//         String jsonResponse = response.body;
//
//         if (response.body.contains('||JasonEnd')) {
//           jsonResponse = response.body.split('||JasonEnd')[0].trim();
//           final decodedJson = json.decode(jsonResponse);
//
//
//           // Assuming 'decodedJson[0]['JSONData1']' is a list of items
//           var data = decodedJson[0]['JSONData1'];
//           var dataa=jsonDecode(data);
//           // Convert the data to a list of ItemMasterModel objects
//           List<ItemMasterModel> items = List<ItemMasterModel>.from(
//               dataa.map((item) => ItemMasterModel.fromMap(item))
//           );
//
//           // Add the items to the stockList
//           stockList.addAll(items);
//           print("Stock List updated: ${stockList.first.itmNam} items");
//
//         }
//       } else {
//         // Get.snackbar('Error', 'Failed to fetch data: ${response.statusCode}');
//       }
//     } catch (e) {
//       print("An error occurred: $e");
//       Get.snackbar('Error', 'An error occurred: $e');
//     }
//   }
//
// }
// class AccountController extends GetxController {
//   var accountList = <PartyMasterModel>[].obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchAllAccounts();
//   }
//
//   void fetchAllAccounts() async {
//     List<Map<String, dynamic>> rows = await DatabaseHelper.instance.queryAllRows(DatabaseHelper.accountTable);
//     accountList.value = rows.map((e) => PartyMasterModel.frommap(e)).toList();
//   }
//
//   // void fetchAndStoreAccountData() async {
//   //   final response = await http.get(Uri.parse('https://api.example.com/account')); // Replace with your API URL
//   //   if (response.statusCode == 200) {
//   //     List<dynamic> data = jsonDecode(response.body);
//   //     for (var item in data) {
//   //       await DatabaseHelper.instance.insert(DatabaseHelper.accountTable, PartyMasterModel.frommap(item).toMap());
//   //     }
//   //     fetchAllAccounts(); // Refresh local data
//   //   } else {
//   //     Get.snackbar('Error', 'Failed to fetch account data');
//   //   }
//   // }
//
//   Future<void> fetchAndStoreAccountData() async {
//     try {
//       final response = await http.post(
//         Uri.parse('http://nwbo1.jubilyhrm.in/Api/WebSeriviceMobileAppSync.aspx'),
//         headers: {'Content-Type': 'application/x-www-form-urlencoded'},
//         body: {
//           "title": 'GetPartyMasterFoMobileApp'
//         },
//       ).timeout(const Duration(seconds: 10));
//
//       if (response.statusCode == 200) {
//         print("Response body: ${response.body}");
//         String jsonResponse = response.body;
//
//         if (response.body.contains('||JasonEnd')) {
//           jsonResponse = response.body.split('||JasonEnd')[0].trim();
//           final decodedJson = json.decode(jsonResponse);
//
//           // Ensure JSONData1 is parsed as a List<dynamic>
//           var data = decodedJson[0]['JSONData1'];
//
//           if (data is String) {
//             // If JSONData1 is a string, decode it as a list
//             data = json.decode(data);
//           }
//
//           print("Decoded data: $data");
//
//           // Assuming you are inserting data into ACC_AccountMaster table
//           var dbHelper = DatabaseHelper.instance;
//           for (var row in data) {
//             await dbHelper.insert(DatabaseHelper.accountTable, row);
//           }
//         }
//       } else {
//         print("Request failed with status: ${response.statusCode}");
//       }
//     } catch (e) {
//       print('Error fetching and storing account data: $e');
//     }
//   }
// }



