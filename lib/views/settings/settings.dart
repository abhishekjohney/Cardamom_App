import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopapp/controllers/settingscontroller.dart';
import 'package:shopapp/controllers/partycontroller.dart';
import 'package:shopapp/controllers/settingscontroller.dart';
import 'package:shopapp/controllers/stockcontroller.dart';
// import 'package:shopapp/utils/dbhandler.dart'; // Commented out - using API-based data
class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  final Settingscontroller settingscontroller = Get.put(Settingscontroller());
  final StockController stockController = Get.put(StockController());
  final PartyController partyController = Get.put(PartyController());
  bool _isLoading = false; // To show loading state
  List<Map<String, dynamic>> _fetchedData = []; // To store fetched data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.orange.shade700,iconTheme: IconThemeData(color: Colors.white),
      title: Text("Sync Master",style: TextStyle(color: Colors.white),),
    ),
      body:Obx(()=>Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(() => GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: settingscontroller.items.length,
                itemBuilder: (context, index) {
                  final item = settingscontroller.items[index];
                  return GestureDetector(
                    onTap: ()async {
                      switch (item['name']) {
                        case 'Sync Item Master':
                          try {
                            stockController.fetchitemmaster.value=true;
                            var data = stockController.stockList.value;
                            List<Map<String, dynamic>> dataToInsert = data
                                .map((item) => item.toMap())
                                .toList();
                            // Database operations commented out - using API-based data
                            // await DBHandler().insertItemData(dataToInsert);
                            print("Item sync disabled - using API-based data: ${dataToInsert.length} items");
                            stockController.fetchitemmaster.value=false;
                            await stockController.fetchitemsfromlocal();
                            Get.snackbar('Success', 'Data Sync successfully!',
                                snackPosition: SnackPosition.BOTTOM,backgroundColor: Colors.green,colorText: Colors.white);
                          } catch (e) {
                            stockController.fetchitemmaster.value=false;
                            // Show error message
                            Get.snackbar('Error', 'Failed to Sync data: $e',
                                snackPosition: SnackPosition.BOTTOM,backgroundColor: Colors.orange.shade700,colorText: Colors.white);
                          } finally {stockController.fetchitemmaster.value=false;

                          }

                          break;
                        case 'Sync Party Master':
                          try {
                            partyController.fetchpartymaster.value=true;
                            var data = partyController.partyList.value;
                            // Convert each ItemMasterModel to Map<String, dynamic>
                            List<Map<String, dynamic>> dataToInsert = data
                                .map((item) => item.toMap())
                                .toList();
                            // Database operations commented out - using API-based data
                            // await DBHandler().insertPartyData(dataToInsert);
                            print("Party sync disabled - using API-based data: ${dataToInsert.length} parties");
                            partyController.fetchpartymaster.value=false;
                           await partyController.fetchpartyfromlocal();
                            Get.snackbar('Success', 'Data Sync successfully!',
                                snackPosition: SnackPosition.BOTTOM,backgroundColor: Colors.green,colorText: Colors.white);
                          } catch (e) {

                            partyController.fetchpartymaster.value=false;
                            // Show error message
                            Get.snackbar('Error', 'Failed to Sync data: $e',
                                snackPosition: SnackPosition.BOTTOM,backgroundColor: Colors.orange.shade700,colorText: Colors.white);
                          } finally {

                            partyController.fetchpartymaster.value=false;
                          }


                          break;
                        default:
                          Get.snackbar('Info', 'Page not implemented yet!');
                      }


                    },
                    child: Card(
                      elevation: 5,color: Colors.orange.shade300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            item['image']!,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 10),
                          Text(
                            item['name']!,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )),
            ),
            partyController.fetchpartymaster.value==true||stockController.fetchitemmaster.value==true?Container(height: double.infinity,width: double.infinity,color: Colors.black26,
            child: Center(
              child: CircularProgressIndicator(color: Colors.orange,),
            ),
            ):SizedBox(height: 0,width: 0,)
          ],
        ),
      ),
      
      
      // Center(
      //   child: _isLoading
      //       ? CircularProgressIndicator() // Show loading indicator if _isLoading is true
      //       : Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       MaterialButton(
      //         child: Text('Insert All'),
      //         color: Colors.blue,
      //         onPressed: () async {
      //           // Start loading
      //           setState(() {
      //             _isLoading = true;
      //           });
      //           try {
      //             var data = stockController.stockList.value;
      //             // Convert each ItemMasterModel to Map<String, dynamic>
      //             List<Map<String, dynamic>> dataToInsert = data
      //                 .map((item) => item.toMap())
      //                 .toList();
      //             // Insert the data into the database
      //             await DBHandler().insertItemData(dataToInsert);
      //             // Show success message
      //
      //
      //
      //
      //
      //             // var data = partyController.partyList.value;
      //             // // Convert each ItemMasterModel to Map<String, dynamic>
      //             // List<Map<String, dynamic>> dataToInsert = data
      //             //     .map((item) => item.toMap())
      //             //     .toList();
      //             // // Insert the data into the database
      //             // await DBHandler().insertPartyData(dataToInsert);
      //             // Show success message
      //             Get.snackbar('Success', 'Data inserted successfully!',
      //                 snackPosition: SnackPosition.BOTTOM);
      //           } catch (e) {
      //             // Show error message
      //             Get.snackbar('Error', 'Failed to insert data: $e',
      //                 snackPosition: SnackPosition.BOTTOM);
      //           } finally {
      //             // Stop loading
      //             setState(() {
      //               _isLoading = false;
      //             });
      //           }
      //         },
      //       ),
      //       SizedBox(height: 20),
      //       MaterialButton(
      //         child: Text('Fetch Data'),
      //         color: Colors.blue,
      //         onPressed: () async {
      //           // Start loading
      //           setState(() {
      //             _isLoading = true;
      //           });
      //
      //           try {
      //             final data = await DBHandler().readItemData();
      //             // final data = await DBHandler().readPartyData();
      //             setState(() {
      //               _fetchedData = data; // Store fetched data
      //             });
      //
      //             // Show success message
      //             Get.snackbar('Success', 'Data fetched successfully!',
      //                 snackPosition: SnackPosition.BOTTOM);
      //           } catch (e) {
      //             // Show error message
      //             Get.snackbar('Error', 'Failed to fetch data: $e',
      //                 snackPosition: SnackPosition.BOTTOM);
      //           } finally {
      //             // Stop loading
      //             setState(() {
      //               _isLoading = false;
      //             });
      //           }
      //         },
      //       ),
      //       SizedBox(height: 20),
      //       // Display data in ListView when _fetchedData is not empty
      //       // Text(stockController.stockList.length.toString()),
      //       // Obx(()=> Text(partyController.partyList.length.toString())),
      //       Obx(()=> Text(stockController.stockList.length.toString())),
      //       Text(_fetchedData.length.toString()),
      //       Expanded(
      //         child: ListView.builder(
      //           itemCount: _fetchedData.length,
      //           itemBuilder: (context, index) {
      //             var item = _fetchedData[index];
      //
      //             // You can customize how you want to display each item
      //             return Card(
      //               margin: EdgeInsets.all(8),
      //               child: ListTile(
      //                 title: Text(item['itm_NAM'] ?? 'N/A'),
      //                 subtitle: Text('Sale Price: ${item['SalePrice'] ?? 'N/A'}'),
      //                 trailing: Text('Qty: ${item['ALQTY'] ?? 'N/A'}'),
      //               ),
      //             );
      //           },
      //         ),
      //       ),
      //
      //
      //
      //
      //       // Expanded(
      //       //   child: ListView.builder(
      //       //     itemCount: _fetchedData.length,
      //       //     itemBuilder: (context, index) {
      //       //       var item = _fetchedData[index];
      //       //
      //       //       // You can customize how you want to display each item
      //       //       return Card(
      //       //         margin: EdgeInsets.all(8),
      //       //         child: ListTile(
      //       //           title: Text(item['Byr_nam'] ?? 'N/A'),
      //       //           subtitle: Text('${item['PhoneNo'] ?? 'N/A'}'),
      //       //           trailing: Text('${item['CUSTYPE'] ?? 'N/A'}'),
      //       //         ),
      //       //       );
      //       //     },
      //       //   ),
      //       // ),
      //
      //     ],
      //   ),
      // ),
    );
  }
}
