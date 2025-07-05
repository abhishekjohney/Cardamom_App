import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:shopapp/model/receipt_model.dart' as ReceiptModel;

class ReceiptPrintScreen extends StatefulWidget {
  final ReceiptModel.Receipt? receipt;
  
  const ReceiptPrintScreen({Key? key, this.receipt}) : super(key: key);
  
  @override
  _ReceiptPrintScreenState createState() => _ReceiptPrintScreenState();
}

class _ReceiptPrintScreenState extends State<ReceiptPrintScreen> {
  // ESC/POS commands for thermal printer
  static const List<int> ESC_INIT = [0x1B, 0x40]; // Initialize printer
  static const List<int> ESC_ALIGN_CENTER = [0x1B, 0x61, 0x01]; // Center alignment
  static const List<int> ESC_ALIGN_LEFT = [0x1B, 0x61, 0x00]; // Left alignment
  static const List<int> ESC_BOLD_ON = [0x1B, 0x45, 0x01]; // Bold on
  static const List<int> ESC_BOLD_OFF = [0x1B, 0x45, 0x00]; // Bold off
  static const List<int> ESC_SIZE_NORMAL = [0x1B, 0x21, 0x00]; // Normal size
  static const List<int> ESC_SIZE_DOUBLE = [0x1B, 0x21, 0x30]; // Double size
  static const List<int> ESC_CUT = [0x1D, 0x56, 0x00]; // Cut paper
  static const List<int> ESC_NEWLINE = [0x0A]; // New line
  static const List<int> ESC_FEED = [0x1B, 0x64, 0x03]; // Feed paper

  // Method to clean and encode text for thermal printer
  String cleanText(String text) {
    // Replace special characters with safe alternatives
    return text
        .replaceAll('–', '-')
        .replaceAll('—', '-')
        .replaceAll('"', '"')
        .replaceAll('"', '"')
        .replaceAll(''', "'")
        .replaceAll(''', "'")
        .replaceAll('…', '...')
        .replaceAll('®', '(R)')
        .replaceAll('™', '(TM)')
        .replaceAll('©', '(C)')
        .replaceAll('°', ' deg')
        .replaceAll('₹', 'Rs.')
        .replaceAll('€', 'EUR')
        .replaceAll('£', 'GBP')
        .replaceAll('¥', 'JPY')
        .replaceAll('¢', 'cents')
        .replaceAll(RegExp(r'[^\x00-\x7F]'), '?'); // Replace non-ASCII with ?
  }

  // Method to create ESC/POS commands for the receipt without line numbers
  List<int> createReceiptCommands() {
    List<int> commands = [];
    
    // Get receipt data or use defaults
    final receiptData = widget.receipt;
    final companyName = 'RAJAKUMARY SPICES';
    
    // Initialize printer
    commands.addAll(ESC_INIT);
    
    // Header
    commands.addAll(ESC_ALIGN_CENTER);
    commands.addAll(ESC_BOLD_ON);
    commands.addAll(ESC_SIZE_DOUBLE);
    commands.addAll(utf8.encode(cleanText(companyName)));
    commands.addAll(ESC_NEWLINE);
    
    commands.addAll(utf8.encode(cleanText('PRODUCER COMPANY')));
    commands.addAll(ESC_NEWLINE);
    
    commands.addAll(ESC_BOLD_OFF);
    commands.addAll(ESC_SIZE_NORMAL);
    commands.addAll(utf8.encode(cleanText('Reg.No.IDK/TC-532/2014')));
    commands.addAll(ESC_NEWLINE);
    
    commands.addAll(utf8.encode(cleanText('KULAPARACHAL, KURUVILACITY IDUKKI')));
    commands.addAll(ESC_NEWLINE);
    
    commands.addAll(utf8.encode(cleanText('Kerala')));
    commands.addAll(ESC_NEWLINE);
    
    commands.addAll(utf8.encode(cleanText('8078013210, 9746593141')));
    commands.addAll(ESC_NEWLINE);
    
    commands.addAll(ESC_NEWLINE);
    
    // Line separator - optimized for 3-inch thermal printer (32 chars)
    commands.addAll(utf8.encode(cleanText('--------------------------------')));
    commands.addAll(ESC_NEWLINE);
    
    // Receipt title
    commands.addAll(ESC_BOLD_ON);
    commands.addAll(utf8.encode(cleanText('Cardamom Receipt')));
    commands.addAll(ESC_BOLD_OFF);
    commands.addAll(ESC_NEWLINE);
    
    // Line separator
    commands.addAll(utf8.encode(cleanText('--------------------------------')));
    commands.addAll(ESC_NEWLINE);
    
    commands.addAll(ESC_NEWLINE);
    
    // Receipt details
    commands.addAll(ESC_ALIGN_LEFT);
    
    // Date
    String currentDate = DateTime.now().toString().substring(0, 19);
    commands.addAll(utf8.encode(cleanText('Date: $currentDate')));
    commands.addAll(ESC_NEWLINE);
    commands.addAll(ESC_NEWLINE);
    
    // Customer info - optimized for 3-inch thermal printer (32 chars width)
    String customerName = receiptData?.party ?? 'Biju George Vettuchirayil';
    // Truncate long customer names to fit 3-inch paper
    if (customerName.length > 20) {
      customerName = customerName.substring(0, 20) + '...';
    }
    String toLine = 'To:'.padRight(15) + customerName;
    commands.addAll(utf8.encode(cleanText(toLine)));
    commands.addAll(ESC_NEWLINE);
    
    commands.addAll(ESC_NEWLINE);
    
    String addressLine = 'Address:'.padRight(15) + 'N/A';
    commands.addAll(utf8.encode(cleanText(addressLine)));
    commands.addAll(ESC_NEWLINE);
    
    String compRefNo = receiptData?.compRefNo ?? '6900';
    String compRefLine = 'Ref No:'.padRight(15) + compRefNo;
    commands.addAll(utf8.encode(cleanText(compRefLine)));
    commands.addAll(ESC_NEWLINE);
    
    String receiptDate = receiptData?.date ?? '11-06-2025';
    String dateLine = 'Date:'.padRight(15) + receiptDate;
    commands.addAll(utf8.encode(cleanText(dateLine)));
    commands.addAll(ESC_NEWLINE);
    
    commands.addAll(ESC_NEWLINE);
    
    // Transaction details - optimized for 3-inch printer
    String qty = receiptData?.qty.toString() ?? '56.0.00';
    String qtyLine = 'Qty Received:'.padRight(15) + '$qty KG';
    commands.addAll(utf8.encode(cleanText(qtyLine)));
    commands.addAll(ESC_NEWLINE);
    
    String rate = receiptData?.rate.toString() ?? '10.0';
    String rateLine = 'Rate/KG:'.padRight(15) + 'Rs. $rate';
    commands.addAll(utf8.encode(cleanText(rateLine)));
    commands.addAll(ESC_NEWLINE);
    
    String processingCharges = receiptData?.processingCharges.toString() ?? '560.0';
    commands.addAll(ESC_BOLD_ON);
    String chargesLine = 'Proc Charges:'.padRight(15) + 'Rs. $processingCharges';
    commands.addAll(utf8.encode(cleanText(chargesLine)));
    commands.addAll(ESC_BOLD_OFF);
    commands.addAll(ESC_NEWLINE);
    
    String numberOfBags = receiptData?.numberOfBags.toString() ?? '1';
    String bagsLine = 'No of Bags:'.padRight(15) + numberOfBags;
    commands.addAll(utf8.encode(cleanText(bagsLine)));
    commands.addAll(ESC_NEWLINE);
    
    commands.addAll(ESC_NEWLINE);
    
    // Line separator
    commands.addAll(utf8.encode(cleanText('--------------------------------')));
    commands.addAll(ESC_NEWLINE);
    
    commands.addAll(ESC_NEWLINE);
    
    // Footer
    commands.addAll(ESC_ALIGN_CENTER);
    commands.addAll(utf8.encode(cleanText('For')));
    commands.addAll(ESC_NEWLINE);
    
    commands.addAll(ESC_BOLD_ON);
    commands.addAll(utf8.encode(cleanText('RAJAKUMARY SPICES PRODUCER')));
    commands.addAll(ESC_NEWLINE);
    
    commands.addAll(utf8.encode(cleanText('COMPANY')));
    commands.addAll(ESC_NEWLINE);
    
    commands.addAll(ESC_BOLD_OFF);
    commands.addAll(utf8.encode(cleanText('Auth. Signatory')));
    commands.addAll(ESC_NEWLINE);
    
    // Feed and cut
    commands.addAll(ESC_FEED);
    commands.addAll(ESC_CUT);
    
    return commands;
  }

  // Alternative method using manual ESC/POS commands with line numbers
  Future<void> printManualReceipt() async {
    try {
      final device = await FlutterBluetoothPrinter.selectDevice(context);
      if (device != null) {
        // Generate ESC/POS commands manually with line numbers
        List<int> commands = createReceiptCommands();
        
        // Convert to Uint8List
        Uint8List data = Uint8List.fromList(commands);
        
        // Print the raw data with proper named parameters
        await FlutterBluetoothPrinter.printBytes(
          address: device.address,
          data: data,
          keepConnected: false,
        );
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Receipt printed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Printing error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Printing failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get receipt data for display
    final receiptData = widget.receipt;
    final customerName = receiptData?.party ?? 'Biju George Vettuchirayil';
    final compRefNo = receiptData?.compRefNo ?? '6900';
    final receiptDate = receiptData?.date ?? '11-06-2025';
    final qty = receiptData?.qty.toString() ?? '56.0.00';
    final rate = receiptData?.rate.toString() ?? '10.0';
    final processingCharges = receiptData?.processingCharges.toString() ?? '560.0';
    final numberOfBags = receiptData?.numberOfBags.toString() ?? '1';
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Print on 3 Inch'),
        backgroundColor: Colors.orange.shade700,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header - Optimized for thermal printer
                      Center(
                        child: Text(
                          'RAJAKUMARY SPICES',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Center(
                        child: Text(
                          'PRODUCER COMPANY',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 4),
                      Center(
                        child: Text(
                          'Reg.No.IDK/TC-532/2014',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Center(
                        child: Text(
                          'KULAPARACHAL, KURUVILACITY IDUKKI',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Kerala',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Center(
                        child: Text(
                          '8078013210, 9746593141',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Divider(thickness: 2, color: Colors.black),
                      Center(
                        child: Text(
                          'Cardamom Receipt',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Divider(thickness: 2, color: Colors.black),
                      SizedBox(height: 12),
                      // Customer and receipt details - right-aligned values
                      Container(
                        width: double.infinity,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('To:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                Expanded(
                                  child: Text(
                                    customerName,
                                    style: TextStyle(fontSize: 14),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Address:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                Text('N/A', style: TextStyle(fontSize: 14)),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Ref No:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                Text(compRefNo, style: TextStyle(fontSize: 14)),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Date:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                Text(receiptDate, style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      Divider(thickness: 1, color: Colors.grey),
                      SizedBox(height: 8),
                      // Transaction details with right-aligned values
                      Container(
                        width: double.infinity,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Qty Received:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                Text('$qty KG', style: TextStyle(fontSize: 14)),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Rate/KG:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                Text('Rs. $rate', style: TextStyle(fontSize: 14)),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Proc Charges:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                Text('Rs. $processingCharges', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('No of Bags:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                Text(numberOfBags, style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      Divider(thickness: 2, color: Colors.black),
                      SizedBox(height: 12),
                      Center(child: Text('For', style: TextStyle(fontSize: 14))),
                      SizedBox(height: 4),
                      Center(child: Text('RAJAKUMARY SPICES PRODUCER', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                      Center(child: Text('COMPANY', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                      SizedBox(height: 8),
                      Center(child: Text('Auth. Signatory', style: TextStyle(fontSize: 14))),
                      SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: printManualReceipt,
                    icon: Icon(Icons.print, size: 24),
                    label: Text(
                      'Print Receipt',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
