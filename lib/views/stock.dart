import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopapp/controllers/partycontroller.dart';
import 'package:shopapp/controllers/stockcontroller.dart';
// import 'package:shopapp/utils/dbhandler.dart'; // Commented out - using API-based data
class Stock extends StatefulWidget {
  const Stock({super.key});

  @override
  State<Stock> createState() => _StockState();
}

class _StockState extends State<Stock> {
  final StockController stockController = Get.put(StockController());
  // final PartyController partyController = Get.put(PartyController());
  bool _isLoading = false; // To show loading state
  List<Map<String, dynamic>> _fetchedData = []; // To store fetched data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Stock Data Management")),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator() // Show loading indicator if _isLoading is true
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              child: Text('Insert All'),
              color: Colors.blue,
              onPressed: () async {
                // Start loading
                setState(() {
                  _isLoading = true;
                });
                try {
                  var data = stockController.stockList.value;
                  // Convert each ItemMasterModel to Map<String, dynamic>
                  List<Map<String, dynamic>> dataToInsert = data
                      .map((item) => item.toMap())
                      .toList();
                  // Database operations commented out - using API-based data
                  // await DBHandler().insertItemData(dataToInsert);
                  print("Item data prepared (database insertion disabled): ${dataToInsert.length} items");
                  // Show success message





                  // var data = partyController.partyList.value;
                  // // Convert each ItemMasterModel to Map<String, dynamic>
                  // List<Map<String, dynamic>> dataToInsert = data
                  //     .map((item) => item.toMap())
                  //     .toList();
                  // // Insert the data into the database
                  // await DBHandler().insertPartyData(dataToInsert);
                  // Show success message
                  Get.snackbar('Success', 'Data inserted successfully!',
                      snackPosition: SnackPosition.BOTTOM);
                } catch (e) {
                  // Show error message
                  Get.snackbar('Error', 'Failed to insert data: $e',
                      snackPosition: SnackPosition.BOTTOM);
                } finally {
                  // Stop loading
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
            ),
            SizedBox(height: 20),
            MaterialButton(
              child: Text('Fetch Data'),
              color: Colors.blue,
              onPressed: () async {
                // Start loading
                setState(() {
                  _isLoading = true;
                });

                try {
                  // Database operations commented out - using API-based data
                  // final data = await DBHandler().readItemData();
                  // final data = await DBHandler().readPartyData();
                  print("Local data fetch disabled - using API-based data");
                  final data = <Map<String, dynamic>>[]; // Return empty list for now
                  setState(() {
                    _fetchedData = data; // Store fetched data
                  });

                  // Show success message
                  Get.snackbar('Success', 'Data fetched successfully!',
                      snackPosition: SnackPosition.BOTTOM);
                } catch (e) {
                  // Show error message
                  Get.snackbar('Error', 'Failed to fetch data: $e',
                      snackPosition: SnackPosition.BOTTOM);
                } finally {
                  // Stop loading
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
            ),
            SizedBox(height: 20),
            // Display data in ListView when _fetchedData is not empty
            // Text(stockController.stockList.length.toString()),
            // Obx(()=> Text(partyController.partyList.length.toString())),
            Obx(()=> Text(stockController.stockList.length.toString())),
            Text(_fetchedData.length.toString()),
            Expanded(
              child: ListView.builder(
                itemCount: _fetchedData.length,
                itemBuilder: (context, index) {
                  var item = _fetchedData[index];

                  // You can customize how you want to display each item
                  return Card(
                    margin: EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(item['itm_NAM'] ?? 'N/A'),
                      subtitle: Text('Sale Price: ${item['SalePrice'] ?? 'N/A'}'),
                      trailing: Text('Qty: ${item['ALQTY'] ?? 'N/A'}'),
                    ),
                  );
                },
              ),
            ),




            // Expanded(
            //   child: ListView.builder(
            //     itemCount: _fetchedData.length,
            //     itemBuilder: (context, index) {
            //       var item = _fetchedData[index];
            //
            //       // You can customize how you want to display each item
            //       return Card(
            //         margin: EdgeInsets.all(8),
            //         child: ListTile(
            //           title: Text(item['Byr_nam'] ?? 'N/A'),
            //           subtitle: Text('${item['PhoneNo'] ?? 'N/A'}'),
            //           trailing: Text('${item['CUSTYPE'] ?? 'N/A'}'),
            //         ),
            //       );
            //     },
            //   ),
            // ),

          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shopapp/controllers/stockcontroller.dart';
// import 'package:shopapp/utils/dbhandler.dart';
//
// class Dashboard extends StatefulWidget {
//   const Dashboard({super.key});
//
//   @override
//   State<Dashboard> createState() => _DashboardState();
// }
//
// class _DashboardState extends State<Dashboard> {
//
//   final StockController stockController=Get.put(StockController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             MaterialButton(
//               child: Text('Insert All'),
//               color: Colors.blue,
//               onPressed: () async {
//                 // Example data to insert.
//                 var data = stockController.stockList.value;
//                 // [
//                 //   {'id': 1, 'name': 'john', 'age': 1},
//                 //   {'id': 2, 'name': 'gon', 'age': 12},
//                 //   {'id': 3, 'name': 'vdvd', 'age': 15},
//                 // ];
//                 await DBHandler().insertData(data.cast<Map<String, dynamic>>());
//               },
//             ),
//             MaterialButton(
//               child: Text('Fetch'),
//               color: Colors.blue,
//               onPressed: () async {
//                 final data = await DBHandler().readData();
//                 print(data);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
