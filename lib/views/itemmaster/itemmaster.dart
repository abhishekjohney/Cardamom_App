import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopapp/controllers/stockcontroller.dart';
import 'package:shopapp/views/itemmaster/itemview.dart';

class Itemmaster extends StatefulWidget {
  const Itemmaster({super.key});

  @override
  State<Itemmaster> createState() => _ItemmasterState();
}

class _ItemmasterState extends State<Itemmaster> {
  final StockController stockController = Get.put(StockController());
  final TextEditingController searchController = TextEditingController();


  Future<void> GetItenms()async{
   await stockController.fetchitemsfromlocal();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetItenms();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade700,iconTheme: IconThemeData(color: Colors.white),
        title: Text("ITEMS",style: TextStyle(color: Colors.white),),
        actions: [
          Obx(() => Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text('Total Items: ${stockController.filteredItems.length}',style: TextStyle(color: Colors.white),),
          )),
        ],
      ),
      body: GestureDetector(
        onTap: (){ FocusScope.of(context).unfocus();},
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15,top: 10,bottom: 10),
              child: Align(
                  alignment: Alignment.topRight,
                  child: Obx(()=>stockController.changeitemtogrid.value==false?InkWell(
                      onTap: (){
                        stockController.changeitemtogrid.value=true;
                      },
                      child: Icon(Icons.list,size: 30,color: Colors.orange.shade700,)):InkWell(
                      onTap: (){
                        stockController.changeitemtogrid.value=false;
                      },
                      child: Icon(Icons.grid_view_rounded,size: 30,color: Colors.orange.shade700)))),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                onChanged: (value) => stockController.filterItems(value),
                decoration: InputDecoration(
                  labelText: 'Search',
                  hintText: 'Search by name, group, or price',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Obx(
                    () => stockController.changeitemtogrid.value==false?ListView.builder(
                  itemCount: stockController.filteredItems.length,
                  itemBuilder: (context, index) {
                    var item = stockController.filteredItems[index];
                    return InkWell(
                      onTap: (){
                        Get.to(()=>ItemView(item: item));
                      },
                      child: Card(
                        margin: EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(item.itmNam ?? 'N/A'),
                          subtitle: Text('Sale Price: ${item.salePrice ?? 'N/A'}'),
                          // trailing: Text(item.svrstkid?.toString() ?? ''),
                        ),
                      ),
                    );
                  },
                ):
                    Obx(
                          () => GridView.builder(
                        itemCount: stockController.filteredItems.length,
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Number of columns in the grid
                              crossAxisSpacing: 8, // Spacing between columns
                              mainAxisSpacing: 8, // Spacing between rows
                              childAspectRatio: 1, // Aspect ratio of grid items
                            ),
                        itemBuilder: (context, index) {
                          var item = stockController.filteredItems[index];
                          // return Card(
                          //   margin: const EdgeInsets.all(8),
                          //   child: Column(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Image.asset("assets/images/itempic.png"),
                          //       Padding(
                          //         padding: const EdgeInsets.all(8.0),
                          //         child: Text(
                          //           item.itmNam ?? 'N/A',
                          //           style: const TextStyle(fontWeight: FontWeight.bold),
                          //         ),
                          //       ),
                          //       Padding(
                          //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          //         child: Text('Sale Price: ${item.salePrice ?? 'N/A'}'),
                          //       ),
                          //       Padding(
                          //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          //         child: Text(item.svrstkid?.toString() ?? ''),
                          //       ),
                          //     ],
                          //   ),
                          // );
                          return InkWell(
                            onTap: (){
                              Get.to(()=>ItemView(item: item));
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(child: Center(child: Image.asset(
                                        'assets/images/itempic.png'))),
                                    Text(
                                      item.itmNam ?? 'N/A',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 4),
                                    Text('Sale Price: ${item.salePrice ?? 'N/A'}'),
                                    SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )

              ),
            ),
          ],
        ),
      ),
    );
  }
}
