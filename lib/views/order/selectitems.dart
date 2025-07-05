import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopapp/controllers/partycontroller.dart';
import 'package:shopapp/controllers/stockcontroller.dart';
import 'package:shopapp/model/cart.dart';
import 'package:shopapp/views/order/cart/cart.dart';


class SelectsItems extends StatefulWidget {
  String withimage, orderid, partyname, deldate, addeddate;

  SelectsItems({
    super.key,
    required this.withimage,
    required this.orderid,
    required this.partyname,
    required this.deldate,
    required this.addeddate,
  });

  @override
  _SelectsItemsState createState() => _SelectsItemsState();
}

class _SelectsItemsState extends State<SelectsItems> {
  final PartyController partyController = Get.put(PartyController());
  final StockController stockController = Get.put(StockController());
  CartScreen? cartScreen;
  //
  // Future<void> loadCartItems() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   List<String> cart = prefs.getStringList(
  //       'cart${widget.orderid.toString()}') ?? [];
  //
  //   print("dfdfdfdfd" + cart.toString());
  //   // Check if the stored data is valid
  //   try {
  //     setState(() {
  //       cartItems = cart.map((e) {
  //         try {
  //           return CartItem.fromJson(e); // Try parsing each item
  //         } catch (e) {
  //           print("Error parsing cart item: $e");
  //           return null; // Handle any invalid JSON items gracefully
  //         }
  //       })
  //           .whereType<CartItem>()
  //           .toList(); // Filter out null values and cast to List<CartItem>
  //     });
  //     stockController.cartLength.value = cartItems.length;
  //     print("dfdfdfdfd" + cartItems.first.OrderQty.toString());
  //   } catch (e) {
  //     print("Error loading cart items: $e");
  //   }
  // }

  var searchQuery = ''.obs;
  Map<int, int> quantities = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCartItems();
    stockController.loadCartItems(widget.orderid.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,
        title: Text("Add Items"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Obx(() {
              var filteredItems = stockController.fetchItemsData.where((item) {
                String itemName = (item.itmNam ?? '').toLowerCase();
                String salePrice =
                (item.salePrice ?? '').toString().toLowerCase();
                String productCode = (item.productGroup ?? '').toLowerCase();
                return itemName.contains(searchQuery.value) ||
                    salePrice.contains(searchQuery.value) ||
                    productCode.contains(searchQuery.value);
              }).toList();

              for (int i = 0; i < filteredItems.length; i++) {
                if (!quantities.containsKey(i)) {
                  quantities[i] = 0; // Default quantity
                }
              }

              return Text('Total Items: ${filteredItems.length}');
            }),
          ),
          Text("${widget.orderid}"),
          SizedBox(width: 20),
          Text("${widget.partyname}"),
          // SizedBox(width: 20),
          InkWell(
            onTap: () async {
              await stockController.loadCartItems(widget.orderid.toString());
              Get.back();
              // Get.to(()=>CartScreen(withimage: widget.withimage, orderid: widget.orderid, partyname: widget.partyname, deldate: widget.deldate, addeddate: widget.addeddate));
            },
            child: Stack(
              children: [
                Icon(Icons.card_travel, size: 40),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Obx(() =>
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1000),
                          color: Colors.black,
                        ),
                        height: 20,
                        width: 20,
                        child: Center(
                          child: Text(
                            stockController.cartItems.length.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )),
                ),
              ],
            ),
          ),

          SizedBox(
            width: 20,
          )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                searchQuery.value = value.toLowerCase();
              },
              decoration: InputDecoration(
                labelText: 'Search Items',
                hintText: 'Search by name, price or code',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(alignment: Alignment.topRight,
                child: InkWell(
                    onTap: () {
                      if (widget.withimage == 'yes') {
                        setState(() {
                          widget.withimage = 'no';
                        });
                      } else {
                        setState(() {
                          widget.withimage = 'yes';
                        });
                      }
                    },
                    child: Icon(widget.withimage == 'yes'
                        ? Icons.grid_view_rounded
                        : Icons.list, size: 30,)),
              ),
            ),
            Expanded(
              child: Obx(() {
                var filteredItems = stockController.fetchItemsData.where((
                    item) {
                  String itemName = (item.itmNam ?? '').toLowerCase();
                  String salePrice = (item.salePrice ?? '')
                      .toString()
                      .toLowerCase();
                  String productCode = (item.productGroup ?? '').toLowerCase();
                  return itemName.contains(searchQuery.value) ||
                      salePrice.contains(searchQuery.value) ||
                      productCode.contains(searchQuery.value);
                }).toList();

                return widget.withimage == 'yes' ? GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns in the grid
                    crossAxisSpacing: 16, // Spacing between columns
                    mainAxisSpacing: 16, // Spacing between rows
                    childAspectRatio: 1, // Aspect ratio of grid items
                  ),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    var item = filteredItems[index];

                    var cartItem = stockController.cartItems.firstWhere(
                          (cart) => cart.SVRSTKID == item.svrstkid.toString(),
                      orElse: () => CartItem(OrderQty: '0'),
                    );

                    TextEditingController alqty = TextEditingController();
                    alqty.text = cartItem.OrderQty!;

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: Center(child: Image.asset(
                                'assets/images/itempic.png'))),
                            Text(item.itmNam ?? 'N/A',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text('Sale Price: ${item.salePrice ?? 'N/A'}'),
                            Text('Final Stock: ${item.finalStock ?? 'N/A'}'),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: '${alqty.text}',
                                      isDense: true,
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        item.alQty = int.tryParse(value) ?? 1;
                                        stockController.quantity.value = value;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '${(item.alQty == 0 ? 1 : item.alQty ?? 1) *
                                      (item.salePrice ?? 1)}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () async {
                                    addToCart(
                                      index,
                                      (item.alQty == 0 ? 1 : item.alQty ?? 1) *
                                          (item.salePrice ?? 1),
                                      item.salePrice,
                                      item.svrstkid,
                                      item.alQty,
                                    );
                                    await
                                    stockController.loadCartItems(widget.orderid.toString());
                                  },
                                  child: Container(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Add',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ) : ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    var item = filteredItems[index];

                    // Check if item exists in cartItems
                    var cartItem = stockController.cartItems.firstWhere(
                          (cart) => cart.SVRSTKID == item.svrstkid.toString(),
                      orElse: () => CartItem(
                          OrderQty: '0'), // Default to '0' if not found
                    );

                    TextEditingController alqty = TextEditingController();
                    alqty.text = cartItem
                        .OrderQty!; // Use the quantity from cartItems if available

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.itmNam ?? 'N/A', style: TextStyle(
                                      fontWeight: FontWeight.bold)),
                                  SizedBox(height: 4),
                                  Text(
                                      'Sale Price: ${item.salePrice ?? 'N/A'}'),
                                  Text('Final Stock: ${item.finalStock ??
                                      'N/A'}'),
                                ],
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              flex: 1,
                              child: TextField(
                                // controller: alqty,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: '${alqty.text}',
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    item.alQty = int.tryParse(value) ?? 1;
                                    stockController.quantity.value = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 16),
                            Text(
                              '${(item.alQty == 0 ? 1 : item.alQty ?? 1) *
                                  (item.salePrice ?? 1)}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 16),
                            GestureDetector(
                              onTap: () async {
                                addToCart(
                                    index,
                                    (item.alQty == 0 ? 1 : item.alQty ?? 1) *
                                        (item.salePrice ?? 1),
                                    item.salePrice,
                                    item.svrstkid,
                                    item.alQty);
                                await
                                stockController.loadCartItems(widget.orderid.toString());
                              },
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Add',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),

            // Expanded(
            //   child: Obx(() {
            //     var filteredItems = stockController.fetchItemsData.where((item) {
            //       String itemName = (item.itmNam ?? '').toLowerCase();
            //       String salePrice = (item.salePrice ?? '').toString().toLowerCase();
            //       String productCode = (item.productGroup ?? '').toLowerCase();
            //       return itemName.contains(searchQuery.value) ||
            //           salePrice.contains(searchQuery.value) ||
            //           productCode.contains(searchQuery.value);
            //     }).toList();
            //
            //     return widget.withimage == 'yes'
            //         ? GridView.builder(
            //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //               crossAxisCount: 2,
            //               crossAxisSpacing: 8,
            //               mainAxisSpacing: 8,
            //               // childAspectRatio: 1.1,
            //             ),
            //             itemCount: filteredItems.length,
            //             itemBuilder: (context, index) {
            //               var item = filteredItems[index];
            //               TextEditingController alqty = TextEditingController();
            //               alqty.text = item.alQty.toString();
            //               return Card(
            //                 margin: EdgeInsets.all(8),
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(8.0),
            //                   child: Column(
            //                     crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center,
            //                     children: [
            //                       Expanded(child: Center(child: Image.asset('assets/images/itempic.png'))),
            //                       Text(
            //                         item.itmNam ?? 'N/A',
            //                         style: TextStyle(fontWeight: FontWeight.bold),
            //                       ),
            //                       SizedBox(height: 4),
            //                       Text('Cost Price: ${item.costPrice ?? 'N/A'}'),
            //                       SizedBox(height: 4),
            //                       Text('Sale Price: ${item.salePrice ?? 'N/A'}'),
            //                       SizedBox(height: 4),
            //                       // Text('Qty: ${item.alQty ?? 'N/A'}'),
            //                       Row(
            //
            //                         children: [
            //                           SizedBox(width: 16),
            //                           Expanded(
            //                             flex: 1,
            //                             child: TextField(
            //                               // controller: alqty,
            //                               keyboardType: TextInputType.number,
            //                               decoration: InputDecoration(
            //                                 hintText: alqty.text.toString(),
            //                                 isDense: true,
            //                                 border: OutlineInputBorder(),
            //                               ),
            //                               onChanged: (value) {
            //                                 setState(() {
            //                                   item.alQty = int.tryParse(value) ?? 1;
            //                                   stockController.quantity.value = value;
            //                                 });
            //                               },
            //                             ),
            //                           ),
            //                           SizedBox(width: 16),
            //                           Text(
            //                             '${(item.alQty == 0 ? 1 : item.alQty ?? 1) * (item.salePrice ?? 1)}',
            //                             style: TextStyle(fontWeight: FontWeight.bold),
            //                           ),
            //                           SizedBox(width: 16),
            //                           GestureDetector(
            //                             onTap: () => addToCart(
            //                                 index,
            //                                 (item.alQty == 0 ? 1 : item.alQty ?? 1) *
            //                                     (item.salePrice ?? 1),item.salePrice,item.svrstkid,item.alQty),
            //                             child: Container(
            //                               color: Colors.white,
            //                               child: Padding(
            //                                 padding: const EdgeInsets.all(8.0),
            //                                 child: Text(
            //                                   'Add',
            //                                   style:
            //                                   TextStyle(fontWeight: FontWeight.bold),
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //                           SizedBox(width: 16),
            //                         ],
            //                       )
            //                     ],
            //                   ),
            //                 ),
            //               );
            //             },
            //           )
            //         : ListView.builder(
            //             shrinkWrap: true,
            //             itemCount: filteredItems.length,
            //             itemBuilder: (context, index) {
            //               var item = filteredItems[index];
            //               TextEditingController alqty = TextEditingController();
            //               alqty.text = item.alQty.toString();
            //               return Card(
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(8.0),
            //                   child: Row(
            //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                     children: [
            //                       Expanded(
            //                         flex: 2,
            //                         child: Column(
            //                           crossAxisAlignment: CrossAxisAlignment.start,
            //                           children: [
            //                             Text(item.itmNam ?? 'N/A',
            //                                 style: TextStyle(
            //                                     fontWeight: FontWeight.bold)),
            //                             SizedBox(height: 4),
            //                             Text(
            //                                 'Sale Price: ${item.salePrice ?? 'N/A'}'),
            //                             Text(
            //                                 'Sale Price: ${item.finalStock ?? 'N/A'}'),
            //                           ],
            //                         ),
            //                       ),
            //                       SizedBox(width: 16),
            //                       Expanded(
            //                         flex: 1,
            //                         child: TextField(
            //                           // controller: alqty,
            //                           keyboardType: TextInputType.number,
            //                           decoration: InputDecoration(
            //                             hintText: alqty.text.toString(),
            //                             isDense: true,
            //                             border: OutlineInputBorder(),
            //                           ),
            //                           onChanged: (value) {
            //                             setState(() {
            //                               item.alQty = int.tryParse(value) ?? 1;
            //                               stockController.quantity.value = value;
            //                             });
            //                           },
            //                         ),
            //                       ),
            //                       SizedBox(width: 16),
            //                       Text(
            //                         '${(item.alQty == 0 ? 1 : item.alQty ?? 1) * (item.salePrice ?? 1)}',
            //                         style: TextStyle(fontWeight: FontWeight.bold),
            //                       ),
            //                       SizedBox(width: 16),
            //                       GestureDetector(
            //                         onTap: () => addToCart(
            //                             index,
            //                             (item.alQty == 0 ? 1 : item.alQty ?? 1) *
            //                                 (item.salePrice ?? 1),item.salePrice,item.svrstkid,item.alQty),
            //                         child: Container(
            //                           color: Colors.white,
            //                           child: Padding(
            //                             padding: const EdgeInsets.all(8.0),
            //                             child: Text(
            //                               'Add',
            //                               style:
            //                                   TextStyle(fontWeight: FontWeight.bold),
            //                             ),
            //                           ),
            //                         ),
            //                       ),
            //                       SizedBox(width: 16),
            //                     ],
            //                   ),
            //                 ),
            //               );
            //             },
            //           );
            //   }),
            // ),
          ],
        ),
      ),
    );
  }

  void incrementQuantity(int index) {
    setState(() {
      quantities[index] = (quantities[index] ?? 0) + 1;
    });
  }

  void addToCart(int index, orderRate, SaleRate, SVRSTKID, OrderQty) async {
    CartItem cartItem = CartItem(
        OrderTransID: 'OrderTransID',
        OrderID: widget.orderid.toString(),
        SVRSTKID: SVRSTKID.toString() ?? '',
        itm_CD: 'itm_CD',
        OrderQty: '$OrderQty',
        OrderRate: orderRate.toString() ?? '',
        SaleRate: '$SaleRate',
        OrderAmount: 'OrderAmount',
        OrderRemarks: 'OrderRemarks',
        TrnAmount: 'TrnAmount',
        Disper: 'Disper',
        ItemDisAmount: 'ItemDisAmount',
        TrnGrossAmt: 'TrnGrossAmt',
        TrnCGSTAmt: 'TrnCGSTAmt',
        TrnSGSTAmt: 'TrnSGSTAmt',
        TrnIGSTAmt: 'TrnIGSTAmt',
        TrnGSTAmt: 'TrnGSTAmt',
        TrnNetAmount: 'TrnNetAmount',
        FreeQty: 'FreeQty',
        TotQty: 'TotQty',
        TrnGSTPer: 'TrnGSTPer',
        TrnCessPer: 'TrnCessPer',
        TrnCGSTPer: 'TrnCGSTPer',
        TrnSGSTPer: 'TrnSGSTPer',
        TrnIGSTPer: 'TrnIGSTPer',
        TrnCessAmt: 'TrnCessAmt');

    await addToCartt(cartItem);
    await
    stockController.loadCartItems(widget.orderid.toString());
    stockController.cartLength.value =stockController.cartItems.length;
    // Optionally show confirmation message
    ScaffoldMessenger.of(context)

        .showSnackBar(SnackBar(content: Text('Item added to cart')));
  }

  Future<void> addToCartt(CartItem cartItem) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cart = prefs.getStringList(
        'cart${widget.orderid.toString()}') ?? [];

    bool itemExists = false;

    // Iterate through the cart items to check for the same itm_CD
    for (int i = 0; i < cart.length; i++) {
      CartItem existingItem = CartItem.fromJson(cart[i]);

      // If an item with the same itm_CD exists, update its values
      if (existingItem.SVRSTKID == cartItem.SVRSTKID) {
        cart[i] = cartItem.toJson(); // Update the item in the cart
        itemExists = true;
        break;
      }
    }

    // If the item doesn't exist, add it to the cart
    if (!itemExists) {
      cart.add(cartItem.toJson());
    }

    // Save the updated cart list to SharedPreferences
    await prefs.setStringList('cart${widget.orderid.toString()}', cart);
  }

  List<String> cart = [];

  Future<void> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      cart =
          prefs.getStringList('cart${widget.orderid}') ?? [];
    });


    print("carrrrrrrrtttttttt" + cart.toString());
  }

// IconButton(
  //   icon: Icon(Icons.remove, color: Colors.orange.shade700),
  //   onPressed: () => decrementQuantity(index),
  // ),
  // Text(
  //   '${quantities[index] ?? 1}',
  //   style: TextStyle(fontSize: 16),
  // ),
  // IconButton(
  //   icon: Icon(Icons.add, color: Colors.green),
  //   onPressed: () => incrementQuantity(index),
  // ),
  void decrementQuantity(int index) {
    setState(() {
      if (quantities[index] != null && quantities[index]! > 0) {
        quantities[index] = quantities[index]! - 1;
      }
    });
  }
}
