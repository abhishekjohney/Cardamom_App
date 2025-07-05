import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopapp/controllers/partycontroller.dart';
import 'package:shopapp/utils/dbhandler.dart';
import 'package:shopapp/views/partymaster/partyview.dart';

class Partymaster extends StatefulWidget {
  const Partymaster({super.key});

  @override
  State<Partymaster> createState() => _PartymasterState();
}

class _PartymasterState extends State<Partymaster> {

  final PartyController partyController = Get.put(PartyController());

  // Controller for the search input
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    partyController.fetchpartyfromlocal();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.orange.shade700,iconTheme: IconThemeData(color: Colors.white),
        title: Text("Party",style: TextStyle(color: Colors.white),),
        actions: [
          Obx(() => Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text('Total Party: ${partyController.filteredParty.length}'),
          )),
        ],
      ),
      body: Obx(()=>Stack(
          children: [
            Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      partyController.filterParty(value); // Dynamically filter the list
                    },
                    decoration: InputDecoration(
                      hintText: 'Search by name or group',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                // Party List
                Expanded(
                  child: Obx(
                        () => ListView.builder(
                      itemCount: partyController.filteredParty.length,
                      itemBuilder: (context, index) {
                        var item = partyController.filteredParty[index];
                        return InkWell(
                          onTap: (){
                            Get.to(()=>PartyView(party: item,
                              
                            ));
                          },
                          child: Card(
                            margin: EdgeInsets.all(8),
                            child: ListTile(
                              title: Text(item.byrNam ?? 'N/A'),
                              subtitle: Text('${item.impCode ?? 'N/A'}'),
                              trailing: SizedBox(
                                width: 100, // Set a fixed width for the trailing widget
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        await partyController.getCurrentLocation();
                                        _showPopup(
                                          context,
                                          partyController.fullAddress.toString(),
                                          item.id,
                                          partyController.fullAddress.toString(),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.blue, shape: BoxShape.circle),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Icon(
                                            Icons.location_on_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        '${item.accAddress ?? 'N/A'}',
                                        style: TextStyle(overflow: TextOverflow.fade),
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,  // Limit to 1 line
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )

                ),
              ],
            ),
            partyController.updateadd.value==true?Container(child: Center(child: CircularProgressIndicator())):SizedBox()
          ],
        ),
      ),
    );
  }

  void _showPopup(BuildContext context,String text,id,
  newAccAddress) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update the location'),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Adjusts the size of the content
            children: [
              Text('$text'),
              // You can add text fields here if required
            ],
          ),
          actions: [
            // Cancel Button to close the dialog
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            // Submit Button
            ElevatedButton(
              onPressed: () async{
                DBHandler dbHandler = DBHandler();
                await dbHandler.updateAccountAddress(id, newAccAddress);
                await partyController.fetchpartyfromlocal();
                Navigator.of(context).pop(); // Close the dialog after submission
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
