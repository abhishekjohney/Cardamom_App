import 'dart:math';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shopapp/model/PartyMasterModel.dart';
import 'dart:convert';

// import 'package:shopapp/utils/dbhandler.dart'; // Commented out - using API-based data
// import 'package:sqflite/sqflite.dart'; // Commented out - using API-based data

class PartyController extends GetxController {
  var partyList = <PartyMasterModel>[].obs;
  var filteredParty = <PartyMasterModel>[].obs; // Filtered list
  var fetchpartymaster=false.obs;
  var fetchparty=false.obs;
  var fetchedParty = <PartyMasterModel>[].obs;
  var selectedBuyer = Rx<PartyMasterModel?>(null);
  var partyAddress = ''.obs;
  var partyName = ''.obs;
  var partyId = ''.obs;
  var remarks = ''.obs;
  var deliveryDate = DateTime.now().obs;
  var todayDate = DateTime.now().obs;
  var updateadd=false.obs;

  var fullAddress = "".obs;  // To store the full address

  var locationMessage = "Press the button to get your location".obs;
  
  // Database-dependent method commented out - using API-based approach
  /*
  Future<int> generateUniqueOrderNo(Database db) async {
    List<Map<String, dynamic>> existingOrders = await db.query('CMS_Shop_OrderMaster', columns: ['OrderNo']);
    List<int> existingOrderNos = existingOrders.map((order) => order['OrderNo'] as int).toList();

    Random random = Random();
    int newOrderNo;

    do {
      newOrderNo = random.nextInt(9999) + 1;
    } while (existingOrderNos.contains(newOrderNo));

    return newOrderNo;
  }
  */
  
  // API-based unique order number generation
  Future<int> generateUniqueOrderNo() async {
    // For now, generate a random number
    // In a real implementation, this should call an API to get the next order number
    Random random = Random();
    return random.nextInt(9999) + 1;
  }


  @override
  void onInit() async{
    super.onInit();
    await fetchAndPartyData();
    await fetchpartyfromlocal();
    filteredParty.value=fetchedParty;
  }

  Future<void> fetchAndPartyData() async {
    try {
      final response = await http.post(
        Uri.parse('http://nwbo1.jubilyhrm.in/Api/WebSeriviceMobileAppSync.aspx'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {"title": 'GetPartyMasterFoMobileApp'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        print("Response body: ${response.body}");
        String jsonResponse = response.body;

        if (response.body.contains('||JasonEnd')) {
          jsonResponse = response.body.split('||JasonEnd')[0].trim();
          final decodedJson = json.decode(jsonResponse);

          var data = decodedJson[0]['JSONData1'];
          var dataa = jsonDecode(data);

          List<PartyMasterModel> items = List<PartyMasterModel>.from(
            dataa.map((item) => PartyMasterModel.fromMap(item)),
          );

          partyList.addAll(items);
          print("Stock List updated: ${partyList.length} items");
        }
      } else {
        print("Failed to fetch data: ${response.statusCode}");
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }


  Future<void> fetchpartyfromlocal() async {
    try {
      fetchparty.value = true;
      // Database operations commented out - using API-based data instead
      // final data = await DBHandler().readPartyData();
      // fetchedParty.value = data.map<PartyMasterModel>((item) => PartyMasterModel.fromMap(item)).toList();
      
      print("Local party fetch disabled - using API-based data from PartyService");
      // Use cached party data from PartyService if available
      fetchedParty.value = []; // Return empty list for now
      
      fetchparty.value = false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch data: $e', snackPosition: SnackPosition.BOTTOM);
      fetchparty.value = false;
    }
  }

  // Update address when a buyer is selected
  void updateBuyerAddress(PartyMasterModel selected) {
    partyAddress.value= selected.accAddress!.toString();
    partyName.value = selected.byrNam!.toString();
    partyId.value = selected.accAutoId!.toString();
    print("mhbmhmhm"+partyAddress.value);
  }

  // Format delivery date as dd-MM-yyyy
  String get formattedDate {
    return DateFormat('dd-MM-yyyy').format(deliveryDate.value);
  }
  // Format delivery date as dd-MM-yyyy
  String get todayDatee {
    return DateFormat('dd-MM-yyyy').format(todayDate.value);
  }

  void filterParty(String query) {
    if (query.isEmpty) {
      filteredParty.value = fetchedParty;
    } else {
      filteredParty.value = fetchedParty.where((party) {
        return (party.byrNam?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
            (party.phoneNo?.toLowerCase().contains(query.toLowerCase()) ?? false);
      }).toList();
    }
  }

  Future<void> getCurrentLocation() async {
    updateadd.value=true;
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      locationMessage.value = "Location services are disabled.";
      return;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        locationMessage.value = "Location permissions are denied.";
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      locationMessage.value = "Location permissions are permanently denied.";
      return;
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Call Google Maps Geocoding API for reverse geocoding
    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyCu0LIq8nZ3e1rLbucEgpmKki-tlow8RYs';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Parse the JSON response
        var data = jsonDecode(response.body);
        print("Dfdnfkjdnkfjfdfdfd"+data.toString());
        if (data['status'] == 'OK') {
          var results = data['results'] as List;
          var address = results.first['formatted_address'];

          // Extract postal code and address components
          String postalCode = '';
          for (var component in results.first['address_components']) {
            if (component['types'].contains('postal_code')) {
              postalCode = component['long_name'];
              break;
            }
          }

          // Construct the full address
          fullAddress.value = "$address, Postal Code: $postalCode";
          locationMessage.value =
          "Latitude: ${position.latitude}, Longitude: ${position.longitude}";

          print("dkjdbvkbdkvkdv"+fullAddress.value.toString());
        } else {
          fullAddress.value = "Address not found!";
        }
      } else {
        fullAddress.value = "Failed to get address!";
      }
    } catch (e) {
      fullAddress.value = "Error retrieving address: $e";
    }
    updateadd.value=false;
  }
}

