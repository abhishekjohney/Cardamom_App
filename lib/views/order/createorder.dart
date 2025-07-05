import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopapp/controllers/ordercontroller.dart';
import 'package:shopapp/controllers/partycontroller.dart';
import 'package:shopapp/model/PartyMasterModel.dart';
import 'package:shopapp/utils/dbhandler.dart';
import 'package:shopapp/views/dashboard.dart';
import 'package:shopapp/views/order/cart/cart.dart';
import 'package:shopapp/views/order/selectitems.dart';
import 'package:sqflite/sqflite.dart';

class CreateOrder extends StatefulWidget {
  const CreateOrder({super.key});

  @override
  _CreateOrderState createState() => _CreateOrderState();
}

class _CreateOrderState extends State<CreateOrder> {
  final PartyController partyController = Get.put(PartyController());
  final TextEditingController addressController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();
  final TextEditingController partynameController = TextEditingController();
  final TextEditingController partyidController = TextEditingController();
  final OrderController orderController = OrderController();
  bool isChecked = false;
  @override
  void initState() {
    super.initState();
    partyController.fetchpartyfromlocal();
    clearAllFields();
    // Bind the addressController to buyerAddress
    partyController.partyAddress.listen((address) {
      addressController.text = address;
    });
    // Bind the addressController to buyerAddress
    partyController.partyName.listen((partyname) {
      partynameController.text = partyname;
    });
    // Bind the addressController to buyerAddress
    partyController.partyId.listen((partyid) {
      partyidController.text = partyid;
    });
  }
  void clearAllFields() {
    addressController.clear();
    remarkController.clear();
    partynameController.clear();
    partyidController.clear();
    partyController.remarks.value = '';
    partyController.selectedBuyer.value = null;
    partyController.deliveryDate.value = DateTime.now();
    setState(() {
      isChecked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.orange.shade700,iconTheme: IconThemeData(color: Colors.white),
        title: Text("Create Order",style: TextStyle(color: Colors.white),),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Buyer Dropdown with search functionality
              Obx(() {
                if (partyController.fetchparty.value) {
                  return CircularProgressIndicator();
                }

                return InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return BuyerSelectionBottomSheet();
                      },
                    );
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Select Buyer',
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            partyController.selectedBuyer.value?.byrNam ?? 'Select a Buyer',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                );
              }),

              SizedBox(height: 16),

              TextFormField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Buyer Address',
                  border: OutlineInputBorder(),
                ),
                enabled: false,
              ),

              SizedBox(height: 16),

              // Remarks TextField
              TextFormField(maxLines: null,controller: remarkController,
                decoration: InputDecoration(
                  labelText: 'Remarks',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  partyController.remarks.value = value;
                },
              ),

              SizedBox(height: 16),

              // Delivery Date Picker
              Obx(() {
                return TextFormField(
                  controller: TextEditingController(text: partyController.formattedDate),
                  decoration: InputDecoration(
                    labelText: 'Delivery Date',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: partyController.deliveryDate.value,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null && pickedDate != partyController.deliveryDate.value) {
                      partyController.deliveryDate.value = pickedDate;
                    }
                  },
                );
              }),
              Row(
                children: [
                  // Checkbox
                  Checkbox(
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                  ),
                  SizedBox(width: 8),

                  // Text
                  Text(
                    "with image",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),

              Spacer(),
              // Create Order Button
              ElevatedButton(
                onPressed: () async{
                  if (partynameController.text.isEmpty ||
                      partyidController.text.isEmpty ||
                      addressController.text.isEmpty ||
                      partyController.remarks.value.isEmpty) {
                    Get.snackbar(
                      "Error Fields",
                      "Please fill all fields",
                      backgroundColor: Colors.orange.shade700,
                      colorText: Colors.white,
                    );
                  }else{
                  // Database operations commented out - using API-based approach
                  // DBHandler dbHandler = DBHandler();
                  // Database db = (await dbHandler.database)!;
                  int orderid = await partyController.generateUniqueOrderNo();
                  print('Generated Unique OrderNo: $orderid');
                  Map<String, dynamic> orderData = {
                    'OrderID': orderid,
                    'OrderNo': 1003,
                    'OrderDate': '${partyController.todayDatee.toString()}',
                    'PartyID': '${partyidController.text}',
                    'PartyClientID': 'C001',
                    'PartyName': '${partynameController.text}',
                    'UserCode': 'U123',
                    'UserAutoID': '12345',
                    'Remarks': '${remarkController.text}',
                    'AddedDate': '${partyController.todayDatee.toString()}',
                    'VehicleNo': 'MH12AB1234',
                    'DelDate': '${partyController.formattedDate}',
                    'AccPartyID': 'AP001',
                    'AccPartyName': 'Doe & Co.',
                    'EntryDateTime': '2025-01-11 10:00:00',
                    'TotAmount': '1000.00',
                    'DiscountAmt': '50.00',
                    'GrossAmount': '950.00',
                    'CGSTAmt': '47.50',
                    'SGSTAmt': '47.50',
                    'IGSTAmt': '0.00',
                    'GSTAmt': '95.00',
                    'RofAmt': '0.00',
                    'NetAmount': '950.00',
                    'OrderSource': 'Online',
                    'FullOrderAmount': '1000.00',
                    'FlatDiscount': '50.00',
                    'TotItemDiscount': '0.00',
                    'CessAmt': '0.00',
                  };
                  // Database insertion commented out - using API-based approach
                  // await dbHandler.insertOrderData(orderData);
                  
                  print("Order data prepared (database insertion disabled): $orderData");

                  Get.snackbar("Success", "Order created successfully");
                  // Get.to(()=>SelectsItems(withimage:  isChecked==true?'yes':'no', orderid: orderid.toString(), partyname: partynameController.text));
                  Get.to(()=>CartScreen(withimage:  isChecked==true?'yes':'no', orderid: orderid.toString(), partyname: partynameController.text, deldate:'${partyController.formattedDate}', addeddate:'${partyController.todayDatee.toString()}',),);
                  }
                 //
                 // await orderController.insertOrder(
                 //      'cscscsc',
                 //      12,
                 //      '12-02-2025',
                 //      123,
                 //      311,
                 //      'PartyName',
                 //      'UserCode',
                 //      15151,
                 //      'fefefefefefe',
                 //      'efefefe',
                 //      'efefefef',
                 //      'efefefefefefdffdfdf',
                 //      32515,
                 //      'eeflkmekfe',
                 //      'flkemfkef ef',
                 //      20.0,
                 //      360.0,
                 //      251.0,
                 //      515681.0,
                 //      5815.0,
                 //      548.00,
                 //      655.00,
                 //      5158.00,
                 //      51651.00,
                 //      21.00,
                 //      51651.00,
                 //      515861.30,
                 //      551.00,
                 //      415.00);
                  // Get.to(()=>SelectsItems(withimage: isChecked==true?'yes':'no'));
                  // Get.snackbar("Success", "Order created successfully!",
                  //     snackPosition: SnackPosition.BOTTOM);
                }, // Disable button if checkbox is not checked
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Center(child: Text("Create Order")),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class BuyerSelectionBottomSheet extends StatefulWidget {
  @override
  _BuyerSelectionBottomSheetState createState() => _BuyerSelectionBottomSheetState();
}

class _BuyerSelectionBottomSheetState extends State<BuyerSelectionBottomSheet> {
  final PartyController partyController = Get.find();
  TextEditingController searchController = TextEditingController();
  late List<PartyMasterModel> filteredParties;

  @override
  void initState() {
    super.initState();
    // Initially, show all parties
    filteredParties = partyController.fetchedParty;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Search bar inside bottom sheet
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'Search Buyer',
              border: OutlineInputBorder(),
            ),
            onChanged: (query) {
              setState(() {
                // Filter the buyer list as per the search query
                filteredParties = partyController.fetchedParty
                    .where((buyer) => buyer.byrNam!.toLowerCase().contains(query.toLowerCase()))
                    .toList();
              });
            },
          ),
          SizedBox(height: 16),
          // Buyer list
          Expanded(
            child: ListView.builder(
              itemCount: filteredParties.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredParties[index].byrNam!),
                  onTap: ()async  {
                    // Set the selected buyer and close the bottom sheet
                    partyController.selectedBuyer.value = filteredParties[index];
                    partyController.updateBuyerAddress(filteredParties[index]);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
