import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopapp/controllers/stockcontroller.dart';
import 'package:shopapp/model/cart.dart';
import 'package:shopapp/model/itemmastermodel.dart';
import 'package:shopapp/model/orlderlistModel.dart';
import 'package:shopapp/utils/dbhandler.dart';
import 'package:shopapp/views/dashboard.dart';
import 'package:shopapp/views/order/cart/orderrecipt.dart';
import 'package:shopapp/views/order/selectitems.dart';

class CartScreen extends StatefulWidget {
  final String withimage;
  final String orderid;
  final String partyname;
  final String deldate;
  final String addeddate;

  CartScreen({
    super.key,
    required this.withimage,
    required this.orderid,
    required this.partyname,
    required this.deldate,
    required this.addeddate,
  });

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // List<CartItem> cartItems = [];
  bool showcart = false;

  final StockController stockController = Get.put(StockController());
  List<OrderListModel> _orders = [];

  double calculateSubtotal(List<OrderListModel> orders) {
    return orders.fold(0.0, (subtotal, order) => subtotal + order.itemTotal);
  }

  bool _isLoading = true;

  Future<void> _fetchOrders() async {
    DBHandler dbHandler = DBHandler();

    // Fetch orders where SVRSTKID == 2 and convert them into OrderListModel objects
    List<Map<String, dynamic>> ordersData =
        await dbHandler.readOrderlistData(OrderID: int.parse(widget.orderid));

    // Convert the List<Map<String, dynamic>> to List<OrderListModel>
    List<OrderListModel> orders =
        ordersData.map((order) => OrderListModel.fromMap(order)).toList();

    // Print the filtered orders for debugging
    print("Filtered Orders: " + ordersData.toString());

    setState(() {
      _orders = orders; // Now _orders is a List<OrderListModel>
      _isLoading = false;
    });

    // Handle showing or hiding the cart based on the number of orders
    if (_orders.isNotEmpty) {
      setState(() {
        showcart = false;
      });
    } else {
      setState(() {
        showcart = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchOrders();
    stockController.loadCartItems(widget.orderid
        .toString()); // Load cart items when the screen is initialized
  }

  // Calculate total amount
  double calculateTotalAmount() {
    double total = 0;
    for (var cartItem in stockController.cartItems) {
      total += double.parse(cartItem.OrderRate!);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = calculateSubtotal(_orders);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.orange.shade700,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            showcart == true ? "Order Items" : "Order Details",
            style: TextStyle(color: Colors.white),
          )),
      body: RefreshIndicator(
        onRefresh: () async {
          await stockController.loadCartItems(widget.orderid.toString());
          await _fetchOrders();
        },
        child: showcart == false
            ? Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: MaterialButton(
                          color: Colors.blue,
                          onPressed: () {
                            Get.to(() => OrderRecipt(
                                orderid: widget.orderid.toString(),
                                partyname: widget.partyname.toString(),
                                deldate: widget.deldate.toString(),
                                addeddate: widget.addeddate.toString(),orderlist: _orders,));
                          },
                          child: Text(
                            "Order Receipt",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: MaterialButton(
                          color: Colors.blue,
                          onPressed: () async {
                            await _fetchOrders();
                          },
                          child: Text(
                            "Refresh",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: MaterialButton(
                          color: Colors.blue,
                          onPressed: () {
                            setState(() {
                              showcart = true;
                            });
                          },
                          child: Text(
                            "Edit Order",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: Colors.blue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            color: Colors.blue,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Order id: ${widget.orderid.toString()}",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            color: Colors.blue,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Party Name: ${widget.partyname.toString()}",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.blue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            color: Colors.blue,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Added Date: ${widget.addeddate.toString()}",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            color: Colors.blue,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Delivery Date: ${widget.deldate.toString()}",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(height: 20,),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      color: Colors.blue,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "All Items",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              "no of Items: ${_orders.length}",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : _orders.isEmpty
                          ? Center(child: Text('No orders found.'))
                          : Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: _orders.length,
                                      itemBuilder: (context, index) {
                                        final order = _orders[index];
                                        final ItemMasterModel matchedItem =
                                            stockController.fetchItemsData
                                                .firstWhere(
                                          (item) =>
                                              item.svrstkid.toString() ==
                                              order.SVRSTKID.toString(),
                                          orElse: () => ItemMasterModel(
                                              itmNam: "No match",
                                              svrstkid:
                                                  0), // return a default value instead of null
                                        );

                                        return Column(
                                          children: [
                                            ListTile(
                                              dense: true,
                                              title: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      'Item name: ${matchedItem.itmNam}'),
                                                  Text(
                                                      'Item name: ${(double.parse(matchedItem.salePrice.toString() ?? '0.00') * double.parse(order.OrderQty.toString() ?? '0.00')).toString()}'),
                                                ],
                                              ),
                                              // subtitle: Text('Party Name: ${order.TotQty}'),
                                              trailing: Text(
                                                  'Quantity: ${order.OrderQty}'),
                                            ),
                                            Divider(
                                              color: Colors
                                                  .black, // Color of the divider
                                              height:
                                                  1, // Adjust the height if needed
                                              thickness: 0.5, // Thinner divider
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),

                  Container(
                    color: Colors.orange.shade700,
                    width: MediaQuery.sizeOf(context).width,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Subtotal:',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Text('..............'),
                          Text(
                            '₹${subtotal.toStringAsFixed(2)}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: MaterialButton(
                          color: Colors.blue,
                          onPressed: () async {
                            await stockController
                                .loadCartItems(widget.orderid.toString());
                          },
                          child: Text(
                            "Refresh",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: MaterialButton(
                          onPressed: () {
                            Get.to(() => SelectsItems(
                                  withimage: widget.withimage,
                                  orderid: widget.orderid,
                                  partyname: widget.partyname,
                                  deldate: widget.deldate,
                                  addeddate: widget.addeddate,
                                ));
                          },
                          child: Text(
                            stockController.cartItems.length > 0
                                ? "Edit"
                                : "Add Items",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Obx(() => stockController.cartItems.isEmpty
                        ? Center(child: Text("No items in cart"))
                        : ListView.builder(
                            itemCount: stockController.cartItems.length,
                            itemBuilder: (context, index) {
                              var cartItem = stockController.cartItems[index];
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Text(cartItem.itm_CD??'', style: TextStyle(fontWeight: FontWeight.bold)),
                                            SizedBox(height: 4),
                                            Text(
                                                'Qty: ${cartItem.OrderQty ?? ''}'),
                                            SizedBox(height: 4),
                                            Text(
                                                'Sale Rate: ${cartItem.SaleRate ?? ''}'),
                                            SizedBox(height: 4),
                                            Text(
                                                'Total: ${cartItem.OrderRate ?? ''}'),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      GestureDetector(
                                        onTap: () {
                                          stockController.cartItems
                                              .removeAt(index);

                                          // Optionally, remove the item from SharedPreferences
                                          saveUpdatedCart();
                                        },
                                        child: Container(
                                          color: Colors.orange.shade700,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Remove',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )),
                  ),
                  Obx(() => stockController.cartItems.length < 1
                      ? SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: MaterialButton(
                            color: Colors.blue,
                            onPressed: () {
                              // Show the bottom sheet when the floating action button is pressed
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                // Ensure the bottom sheet takes up only part of the screen
                                builder: (context) {
                                  return Container(
                                    width: MediaQuery.sizeOf(context).width,
                                    decoration: BoxDecoration(
                                        color: Colors.orange.shade700,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            topLeft: Radius.circular(10))),
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      // To avoid taking full screen
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Total: ₹${calculateTotalAmount().toStringAsFixed(2)}',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        SizedBox(height: 10),
                                        ElevatedButton(
                                          onPressed: () {
                                            // Submit action (e.g., proceed to checkout)
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text('Submit Cart'),
                                                  content: Text(
                                                      'Are you sure you want to submit the cart?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        if (stockController
                                                                .cartItems
                                                                .length >
                                                            0) {
                                                          DBHandler dbHandler =
                                                              DBHandler();
                                                          List<
                                                                  Map<String,
                                                                      dynamic>>
                                                              orderData =
                                                              stockController
                                                                  .cartItems
                                                                  .map((cartItem) =>
                                                                      cartItem
                                                                          .toMap())
                                                                  .toList();
                                                          await dbHandler
                                                              .insertOrderlistData(
                                                                  orderData,
                                                                  widget
                                                                      .orderid);
                                                          Get.snackbar(
                                                              "Success",
                                                              "Order Placed Successfully",
                                                              backgroundColor:
                                                                  Colors.green,
                                                              colorText:
                                                                  Colors.white);
                                                          Get.offAll(() =>
                                                              Dashboard());
                                                        } else {
                                                          Get.snackbar("Failed",
                                                              "Add atleast one item in cart",
                                                              backgroundColor:
                                                                  Colors.orange
                                                                      .shade700,
                                                              colorText:
                                                                  Colors.white);
                                                        }
                                                      },
                                                      child: Text(
                                                        'Submit',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Text('Submit',
                                              style: TextStyle(
                                                  color: Colors.black)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: Text('Submit',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ))
                ],
              ),
      ),
    );
  }

  // Save the updated cart to SharedPreferences after removing an item
  Future<void> saveUpdatedCart() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cart = stockController.cartItems
        .map((e) => e.toJson())
        .toList(); // Convert CartItem to JSON string
    await prefs.setStringList('cart${widget.orderid}', cart);
  }
}
