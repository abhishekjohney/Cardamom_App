import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer.dart';


class ReceiptPrintScreen extends StatefulWidget {
  @override
  _ReceiptPrintScreenState createState() => _ReceiptPrintScreenState();
}

class _ReceiptPrintScreenState extends State<ReceiptPrintScreen> {
  ReceiptController? _receiptController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('3-Inch Receipt Printer')),
      body: Column(
        children: [
          Expanded(
            child: Receipt(
              builder: (context) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'RAJAKUMARY SPICES',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Text(
                        'PRODUCER COMPANY',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Reg.No.IDK/TC-532/2014',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Center(
                      child: Text(
                        'KULAPARACHAL, KURUVILACITY IDUKKI',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Kerala',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Center(
                      child: Text(
                        '8078013210, 9746593141',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Divider(thickness: 2),
                    Center(
                      child: Text(
                        'Cardamom Receipt',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Divider(thickness: 2),
                    SizedBox(height: 8),
                    Text('Date: ${DateTime.now()}', style: TextStyle(fontSize: 11)),
                    Divider(thickness: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('To:', style: TextStyle(fontSize: 11)),
                        Text('Biju George Vettuchirayil', style: TextStyle(fontSize: 11)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Address :', style: TextStyle(fontSize: 11)),
                        Text('N/A', style: TextStyle(fontSize: 11)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Computer Ref. No', style: TextStyle(fontSize: 11)),
                        Text('6900', style: TextStyle(fontSize: 11)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Dated', style: TextStyle(fontSize: 11)),
                        Text('11-06-2025', style: TextStyle(fontSize: 11)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Quantity Received', style: TextStyle(fontSize: 11)),
                        Text('56.0.00', style: TextStyle(fontSize: 11)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Rate Per KG', style: TextStyle(fontSize: 11)),
                        Text('10.0', style: TextStyle(fontSize: 11)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Processing Charges', style: TextStyle(fontSize: 11)),
                        Text('560.0', style: TextStyle(fontSize: 11)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Number Of Bags', style: TextStyle(fontSize: 11)),
                        Text('1', style: TextStyle(fontSize: 11)),
                      ],
                    ),
                    Divider(thickness: 2),

                    SizedBox(height: 10),
                    Divider(thickness: 2),
                    Center(child: Text('For', style: TextStyle(fontSize: 11))),
                    Center(child: Text('RAJAKUMARY SPICES PRODUCER', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                    Center(child: Text('COMPANY', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                    Center(child: Text('Auth. Signatory', style: TextStyle(fontSize: 11))),
                  ],
                ),
              ),
              onInitialized: (controller) {
                _receiptController = controller;
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final device = await FlutterBluetoothPrinter.selectDevice(context);
              if (device != null && _receiptController != null) {
                await _receiptController!.print(address: device.address);
              }
            },
            child: Text('Print on 3-Inch Printer'),
          ),
        ],
      ),
    );
  }
}
