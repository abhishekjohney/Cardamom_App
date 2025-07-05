import 'dart:typed_data';  // For Uint8List
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For rootBundle
import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:shopapp/controllers/partycontroller.dart';
import 'package:shopapp/controllers/stockcontroller.dart';
import 'package:shopapp/model/itemmastermodel.dart';
import 'package:shopapp/model/orlderlistModel.dart'; // To print or save the PDF

class OrderRecipt extends StatefulWidget {
  final String orderid;
  final String partyname;
  final String deldate;
  final String addeddate;
  var orderlist;

  OrderRecipt({
    super.key,
    required this.orderid,
    required this.partyname,
    required this.deldate,
    required this.addeddate,
    required this.orderlist,
  });

  @override
  State<OrderRecipt> createState() => _OrderReciptState();
}

class _OrderReciptState extends State<OrderRecipt> {
  List<OrderListModel> orders = [];

  final StockController stockController = Get.put(StockController());
  final PartyController partyController = Get.put(PartyController());

  @override
  void initState() {
    super.initState();
    orders = widget.orderlist;
  }

  // Function to generate the PDF
  Future<void> printReceipt() async {
    final pdf = pw.Document();

    // Load image bytes from asset
    final ByteData bytes = await rootBundle.load('assets/images/itempic.png');
    final Uint8List imgBytes = bytes.buffer.asUint8List();

    // Create a PdfImage from the loaded bytes
    final image = pw.MemoryImage(imgBytes);

    // Add page to the PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              // Shop Header
              pw.Center(
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Image(image, width: 30, height: 30),
                    pw.SizedBox(width: 10),
                    pw.Text(
                      "SHOP APP",
                      style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 5),
              pw. Text("------------------------------------------------------------------------------------------------------------------------------------------------------------------",maxLines: 1,),
              pw.SizedBox(height: 5),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Order ID: ${widget.orderid}"),
                  pw.Text("Del. Date: ${widget.deldate}"),
                ],
              ),
              pw.SizedBox(height: 5),
              pw. Text("------------------------------------------------------------------------------------------------------------------------------------------------------------------",maxLines: 1,),

              // Order items
              pw.ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  final ItemMasterModel matchedItem = stockController.fetchItemsData.firstWhere(
                        (item) => item.svrstkid.toString() == order.SVRSTKID.toString(),
                    orElse: () => ItemMasterModel(itmNam: "No match", svrstkid: 0),
                  );

                  final double totalPrice = double.parse(order.OrderQty.toString()) * double.parse(matchedItem.salePrice.toString());

                  return pw.Column(
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Expanded(child: pw.Text("Item: ${matchedItem.itmNam}")),
                          pw.Expanded(child: pw.Align(alignment: pw.Alignment.topRight,child: pw.Text("Qty: ${order.OrderQty}")),),
                          pw.Expanded(child: pw.Align(alignment: pw.Alignment.topRight,child: pw.Text("Total: \$${totalPrice.toStringAsFixed(2)}")),),

                        ],
                      ),
                      pw.Divider(),
                    ],
                  );
                },
              ),

              pw.SizedBox(height: 20),
              // Footer Section
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Print Date: ${partyController.todayDatee}"),
                  pw.Text("Authorized by: SHOP APP"),
                ],
              ),
              pw.Text("------------------------------------------------------------------------------------------------------------------------------------------------------------------",maxLines: 1,),
            ],
          );
        },
      ),
    );

    // Send the generated PDF to the printer or view
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
      return pdf.save();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade700,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Order Receipt",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/itempic.png",
                  scale: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    "SHOP APP",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Text("------------------------------------------------------------------------------------------------------------------------------------------------------------------",maxLines: 1,),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Order ID: ${widget.orderid}"),
                  Text("Del. Date: ${widget.deldate}"),
                ],
              ),
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final ItemMasterModel matchedItem =
                stockController.fetchItemsData.firstWhere(
                      (item) =>
                  item.svrstkid.toString() == order.SVRSTKID.toString(),
                  orElse: () =>
                      ItemMasterModel(itmNam: "No match", svrstkid: 0),
                );

                return Column(
                  children: [
                    ListTile(
                      dense: true,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Item name: ${matchedItem.itmNam}'),
                          Text(
                              'Sale price: ${(double.parse(matchedItem.salePrice.toString() ?? '0.00') * double.parse(order.OrderQty.toString() ?? '0.00')).toString()}'),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Quantity: ${order.OrderQty}'),
                          Text(
                              'Total: ${(double.parse(order.OrderQty) * double.parse(matchedItem.salePrice.toString())).toString()}'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Divider(
                        color: Colors.black,
                        height: 1,
                        thickness: 0.5,
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 20),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Print Date: ${partyController.todayDatee}"),
                  Text("Authorized by: SHOP APP"),
                ],
              ),
            ),SizedBox(height: 20),
            MaterialButton(
              onPressed: printReceipt,
              child: Text('Print Receipt',style: TextStyle(color: Colors.white),),color: Colors.orange.shade700,
            ),
          ],
        ),
      ),
    );
  }
}
