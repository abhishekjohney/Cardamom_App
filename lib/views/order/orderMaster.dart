import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopapp/model/ordermastermodel.dart';
// import 'package:shopapp/utils/dbhandler.dart'; // Commented out - using API-based data
import 'package:shopapp/views/order/cart/cart.dart';
import 'package:shopapp/views/order/new_order_service.dart';
import 'package:shopapp/views/order/selectitems.dart';

class OrderMaster extends StatefulWidget {
  @override
  _OrderMasterState createState() => _OrderMasterState();
}

class _OrderMasterState extends State<OrderMaster> {
  List<OrderMasterModel> _syncedOrders = [];
  List<OrderMasterModel> _unsyncedOrders = [];
  bool _isLoading = true;
  bool _isSyncing = false;
  final NewOrderService _orderService = NewOrderService();
  // final DBHandler _dbHandler = DBHandler(); // Commented out - using API-based data

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() {
      _isLoading = true;
    });

    // Database operations commented out - using API-based data
    // List<Map<String, dynamic>> orderMaps = await _dbHandler.readOrderData();
    List<Map<String, dynamic>> orderMaps = []; // Return empty list for now

    setState(() {
      _syncedOrders = orderMaps
          .where((map) => map['IsSynced'] == 1)
          .map((map) => OrderMasterModel.fromMap(map))
          .toList();

      _unsyncedOrders = orderMaps
          .where((map) => map['IsSynced'] != 1)
          .map((map) => OrderMasterModel.fromMap(map))
          .toList();

      _isLoading = false;
    });
  }

  Future<void> _syncSingleOrder(OrderMasterModel order) async {
    try {
      await _orderService.submitOrder(
        partyId: order.PartyID.toString(),
        remarks: order.Remarks ?? '',
        deliveryDate: order.DelDate,
        position: null,
        locationDetails: null,
      );

      // Database operations commented out - using API-based data
      // await _dbHandler.updateOrderSyncStatus(order.OrderID, 1);
      print("Order sync status update disabled - using API-based data");

      await _fetchOrders();

      Get.snackbar(
        'Sync Successful',
        'Order ${order.OrderID} has been synced',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Sync Failed',
        'No internet connection',
        // 'Unable to sync order ${order.OrderID}: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _syncAllOrders() async {
    setState(() {
      _isSyncing = true;
    });

    try {
      for (var order in _unsyncedOrders) {
        await _syncSingleOrder(order);
      }
    } finally {
      setState(() {
        _isSyncing = false;
      });
    }
  }

  void _confirmDelete(int orderId, bool isSynced) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this order?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Database operations commented out - using API-based data
              // await _dbHandler.deleteOrder(orderId);
              print("Order deletion disabled - using API-based data");
              await _fetchOrders();
              Get.back();
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList(List<OrderMasterModel> orders, bool isSynced) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.orange.shade700),
                borderRadius: BorderRadius.circular(10)),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              splashColor: Colors.orange.shade700,
              onTap: () {
                Get.to(
                  CartScreen(
                    withimage: 'no',
                    orderid: order.OrderID.toString(),
                    partyname: order.PartyName,
                    deldate: order.DelDate,
                    addeddate: order.AddedDate,
                  ),
                );
              },
              child: ListTile(
                title: Text('Order Id: ${order.OrderID}'),
                subtitle: Text('Party Name: ${order.PartyName}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isSynced)
                      IconButton(
                        icon: Icon(Icons.sync, color: Colors.orange.shade700),
                        onPressed: () => _syncSingleOrder(order),
                      ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.orange.shade700),
                      onPressed: () => _confirmDelete(order.OrderID, isSynced),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade700,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Order List', style: TextStyle(color: Colors.white)),
        actions: [
          if (!_isLoading && _unsyncedOrders.isNotEmpty)
            IconButton(
              icon: _isSyncing
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : Icon(Icons.sync),
              onPressed: _isSyncing ? null : _syncAllOrders,
            ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : (_syncedOrders.isEmpty && _unsyncedOrders.isEmpty)
              ? Center(child: Text('No orders found.'))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_unsyncedOrders.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'Unsynced Orders (${_unsyncedOrders.length})',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        _buildOrderList(_unsyncedOrders, false),
                      ],
                      if (_syncedOrders.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Synced Orders (${_syncedOrders.length})',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        _buildOrderList(_syncedOrders, true),
                      ],
                    ],
                  ),
                ),
    );
  }
}
