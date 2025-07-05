// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shopapp/utils/dbhandler.dart';
// import 'package:shopapp/views/order/selectitems.dart';
//
// class OrderList extends StatefulWidget {
//   @override
//   _OrderListState createState() => _OrderListState();
// }
//
// class _OrderListState extends State<OrderList> {
//   List<Map<String, dynamic>> _orders = [];
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchOrders();
//   }
//
//   Future<void> _fetchOrders() async {
//     DBHandler dbHandler = DBHandler();
//     List<Map<String, dynamic>> orders = await dbHandler.readOrderlistData();
//
//     setState(() {
//       _orders = orders;
//       _isLoading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Order List'),
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : _orders.isEmpty
//           ? Center(child: Text('No orders found.'))
//           : ListView.builder(
//         itemCount: _orders.length,
//         itemBuilder: (context, index) {
//           final order = _orders[index];
//           return Card(
//             margin: EdgeInsets.all(8.0),
//             child: InkWell(
//               onTap: (){
//                 Get.to(SelectsItems(withimage: 'no', orderid: order['OrderNo'].toString(), partyname: order['PartyName'].toString(),));
//               },
//               child: ListTile(
//                 title: Text('Order No: ${order['SVRSTKID']}'),
//                 subtitle: Text(
//                   'Party Name: ${order['OrderRate']}}',
//                 ),
//                 trailing: Text('Date: ${order['OrderID'].toString()}'),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
