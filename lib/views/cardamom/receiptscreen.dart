import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer.dart';
import 'dart:convert';
import 'dart:typed_data';

class ReceiptPrintScreen extends StatefulWidget {
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

  // Method to create ESC/POS commands for the receipt with line numbers
  List<int> createReceiptCommands() {
    List<int> commands = [];
    int lineNumber = 1;
    
    // Initialize printer
    commands.addAll(ESC_INIT);
    
    // Header
    commands.addAll(ESC_ALIGN_CENTER);
    commands.addAll(ESC_BOLD_ON);
    commands.addAll(ESC_SIZE_DOUBLE);
    commands.addAll(utf8.encode(cleanText('L$lineNumber: RAJAKUMARY SPICES')));
    commands.addAll(ESC_NEWLINE);
    lineNumber++;
    
    commands.addAll(utf8.encode(cleanText('L$lineNumber: PRODUCER COMPANY')));
    commands.addAll(ESC_NEWLINE);
    lineNumber++;
    
    commands.addAll(ESC_BOLD_OFF);
    commands.addAll(ESC_SIZE_NORMAL);
    commands.addAll(utf8.encode(cleanText('L$lineNumber: Reg.No.IDK/TC-532/2014')));
    commands.addAll(ESC_NEWLINE);
    lineNumber++;
    
    commands.addAll(utf8.encode(cleanText('L$lineNumber: KULAPARACHAL, KURUVILACITY IDUKKI')));
    commands.addAll(ESC_NEWLINE);
    lineNumber++;
    
    commands.addAll(utf8.encode(cleanText('L$lineNumber: Kerala')));
    commands.addAll(ESC_NEWLINE);
    lineNumber++;
    
    commands.addAll(utf8.encode(cleanText('L$lineNumber: 8078013210, 9746593141')));
    commands.addAll(ESC_NEWLINE);
    lineNumber++;
    
    commands.addAll(ESC_NEWLINE);
    
    // Line separator
    commands.addAll(utf8.encode(cleanText('L$lineNumber: --------------------------------')));
    commands.addAll(ESC_NEWLINE);
    lineNumber++;
    
    // Receipt title
    commands.addAll(ESC_BOLD_ON);
    commands.addAll(utf8.encode(cleanText('L$lineNumber: Cardamom Receipt')));
    commands.addAll(ESC_BOLD_OFF);
    commands.addAll(ESC_NEWLINE);
    lineNumber++;
    
    // Line separator
    commands.addAll(utf8.encode(cleanText('L$lineNumber: --------------------------------')));
    commands.addAll(ESC_NEWLINE);
    lineNumber++;
    
    commands.addAll(ESC_NEWLINE);
    
    // Receipt details
    commands.addAll(ESC_ALIGN_LEFT);
    commands.addAll(utf8.encode(cleanText('L$lineNumber: Date: ${DateTime.now().toString().substring(0, 19)}')));
    commands.addAll(ESC_NEWLINE);
    lineNumber++;
    
    commands.addAll(ESC_NEWLINE);
    
    // Customer info
    commands.addAll(utf8.encode(cleanText('L$lineNumber: To: Biju George Vettuchirayil')));
    commands.addAll(ESC_NEWLINE);
    lineNumber++;
    
    commands.addAll(utf8.encode(cleanText('L$lineNumber: Address: N/A')));
    commands.addAll(ESC_NEWLINE);
    lineNumber++;
    
    commands.addAll(utf8.encode(cleanText('L$lineNumber: Computer Ref. No: 6900')));
    commands.addAll(ESC_NEWLINE);
    lineNumber++;
    
    commands.addAll(utf8.encode(cleanText('L$lineNumber: Dated: 11-06-2025')));
    commands.addAll(ESC_NEWLINE);
    lineNumber++;
    
    commands.addAll(ESC_NEWLINE);
    
    // Transaction details
    commands.addAll(utf8.encode(cleanText('L$lineNumber: Quantity Received: 56.0.00')));
    commands.addAll(ESC_NEWLINE);
    lineNumber++;
    
    commands.addAll(utf8.encode(cleanText('L$lineNumber: Rate Per KG: 10.0')));
    commands.addAll(ESC_NEWLINE);
    lineNumber++;
    
    commands.addAll(utf8.encode(cleanText('L$lineNumber: Processing Charges: 560.0')));
    commands.addAll(ESC_NEWLINE);
    lineNumber++;
    
    commands.addAll(utf8.encode(cleanText('L$lineNumber: Number Of Bags: 1')));
    commands.addAll(ESC_NEWLINE);
    lineNumber++;
    
    commands.addAll(ESC_NEWLINE);
    
    // Line separator
    commands.addAll(utf8.encode(cleanText('L$lineNumber: --------------------------------')));
    commands.addAll(ESC_NEWLINE);
    lineNumber++;
    
    commands.addAll(ESC_NEWLINE);
    
    // Footer
    commands.addAll(ESC_ALIGN_CENTER);
    commands.addAll(utf8.encode(cleanText('L$lineNumber: For')));
    commands.addAll(ESC_NEWLINE);
    lineNumber++;
    
    commands.addAll(ESC_BOLD_ON);
    commands.addAll(utf8.encode(cleanText('L$lineNumber: RAJAKUMARY SPICES PRODUCER')));
    commands.addAll(ESC_NEWLINE);
    lineNumber++;
    
    commands.addAll(utf8.encode(cleanText('L$lineNumber: COMPANY')));
    commands.addAll(ESC_NEWLINE);
    lineNumber++;
    
    commands.addAll(ESC_BOLD_OFF);
    commands.addAll(utf8.encode(cleanText('L$lineNumber: Auth. Signatory')));
    commands.addAll(ESC_NEWLINE);
    lineNumber++;
    
    commands.addAll(ESC_NEWLINE);
    
    // Debug info
    commands.addAll(ESC_ALIGN_LEFT);
    commands.addAll(utf8.encode(cleanText('L$lineNumber: DEBUG: Total lines printed: ${lineNumber-1}')));
    commands.addAll(ESC_NEWLINE);
    lineNumber++;
    
    commands.addAll(utf8.encode(cleanText('L$lineNumber: DEBUG: Print time: ${DateTime.now().millisecondsSinceEpoch}')));
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
            content: Text('Receipt printed successfully with line numbers!'),
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
                      // Header with line numbers shown in preview
                      Center(
                        child: Text(
                          'L1: RAJAKUMARY SPICES',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ),
                      Center(
                        child: Text(
                          'L2: PRODUCER COMPANY',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ),
                      Center(
                        child: Text(
                          'L3: Reg.No.IDK/TC-532/2014',
                          style: TextStyle(fontSize: 12, color: Colors.blue),
                        ),
                      ),
                      Center(
                        child: Text(
                          'L4: KULAPARACHAL, KURUVILACITY IDUKKI',
                          style: TextStyle(fontSize: 12, color: Colors.blue),
                        ),
                      ),
                      Center(
                        child: Text(
                          'L5: Kerala',
                          style: TextStyle(fontSize: 12, color: Colors.blue),
                        ),
                      ),
                      Center(
                        child: Text(
                          'L6: 8078013210, 9746593141',
                          style: TextStyle(fontSize: 12, color: Colors.blue),
                        ),
                      ),
                      Divider(thickness: 2),
                      Center(
                        child: Text(
                          'L7: Cardamom Receipt',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ),
                      Divider(thickness: 2),
                      SizedBox(height: 8),
                      Text('L8: Date: ${DateTime.now().toString().substring(0, 19)}', style: TextStyle(fontSize: 11, color: Colors.blue)),
                      Divider(thickness: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('L9: To:', style: TextStyle(fontSize: 11, color: Colors.blue)),
                          Text('Biju George Vettuchirayil', style: TextStyle(fontSize: 11)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('L10: Address :', style: TextStyle(fontSize: 11, color: Colors.blue)),
                          Text('N/A', style: TextStyle(fontSize: 11)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('L11: Computer Ref. No', style: TextStyle(fontSize: 11, color: Colors.blue)),
                          Text('6900', style: TextStyle(fontSize: 11)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('L12: Dated', style: TextStyle(fontSize: 11, color: Colors.blue)),
                          Text('11-06-2025', style: TextStyle(fontSize: 11)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('L13: Quantity Received', style: TextStyle(fontSize: 11, color: Colors.blue)),
                          Text('56.0.00', style: TextStyle(fontSize: 11)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('L14: Rate Per KG', style: TextStyle(fontSize: 11, color: Colors.blue)),
                          Text('10.0', style: TextStyle(fontSize: 11)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('L15: Processing Charges', style: TextStyle(fontSize: 11, color: Colors.blue)),
                          Text('560.0', style: TextStyle(fontSize: 11)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('L16: Number Of Bags', style: TextStyle(fontSize: 11, color: Colors.blue)),
                          Text('1', style: TextStyle(fontSize: 11)),
                        ],
                      ),
                      Divider(thickness: 2),
                      SizedBox(height: 10),
                      Divider(thickness: 2),
                      Center(child: Text('L17: For', style: TextStyle(fontSize: 11, color: Colors.blue))),
                      Center(child: Text('L18: RAJAKUMARY SPICES PRODUCER', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue))),
                      Center(child: Text('L19: COMPANY', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue))),
                      Center(child: Text('L20: Auth. Signatory', style: TextStyle(fontSize: 11, color: Colors.blue))),
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
                  child: ElevatedButton(
                    onPressed: printManualReceipt,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      '🖨️ Print on 3 Inch',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
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
