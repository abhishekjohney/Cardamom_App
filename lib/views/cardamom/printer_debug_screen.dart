import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer.dart';
import 'package:shopapp/utils/thermal_printer_utils.dart';
import 'dart:convert';
import 'dart:typed_data';

class PrinterDebugScreen extends StatefulWidget {
  @override
  _PrinterDebugScreenState createState() => _PrinterDebugScreenState();
}

class _PrinterDebugScreenState extends State<PrinterDebugScreen> {
  BluetoothDevice? _selectedDevice;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _selectDevice() async {
    try {
      final device = await FlutterBluetoothPrinter.selectDevice(context);
      if (device != null) {
        setState(() {
          _selectedDevice = device;
        });
        _showSuccess('Device selected: ${device.name}');
      }
    } catch (e) {
      _showError('Error selecting device: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _testBasicPrint() async {
    if (_selectedDevice == null) {
      _showError('Please select a device first');
      return;
    }

    try {
      List<int> commands = [];
      commands.addAll([0x1B, 0x40]); // Initialize
      commands.addAll(utf8.encode('Test Print\n'));
      commands.addAll(utf8.encode('Special chars: àáâã\n'));
      commands.addAll(utf8.encode('Numbers: 1234567890\n'));
      commands.addAll([0x1B, 0x64, 0x03]); // Feed
      commands.addAll([0x1D, 0x56, 0x00]); // Cut

      await FlutterBluetoothPrinter.printBytes(
        address: _selectedDevice!.address,
        data: Uint8List.fromList(commands),
        keepConnected: false,
      );
      
      _showSuccess('Basic test printed successfully!');
    } catch (e) {
      _showError('Basic test failed: $e');
    }
  }

  Future<void> _testCleanedPrint() async {
    if (_selectedDevice == null) {
      _showError('Please select a device first');
      return;
    }

    try {
      List<int> commands = [];
      commands.addAll([0x1B, 0x40]); // Initialize
      commands.addAll(utf8.encode(ThermalPrinterUtils.cleanText('Test Print\n')));
      commands.addAll(utf8.encode(ThermalPrinterUtils.cleanText('Special chars: àáâã\n')));
      commands.addAll(utf8.encode(ThermalPrinterUtils.cleanText('Numbers: 1234567890\n')));
      commands.addAll([0x1B, 0x64, 0x03]); // Feed
      commands.addAll([0x1D, 0x56, 0x00]); // Cut

      await FlutterBluetoothPrinter.printBytes(
        address: _selectedDevice!.address,
        data: Uint8List.fromList(commands),
        keepConnected: false,
      );
      
      _showSuccess('Cleaned test printed successfully!');
    } catch (e) {
      _showError('Cleaned test failed: $e');
    }
  }

  Future<void> _testUtilityPrint() async {
    if (_selectedDevice == null) {
      _showError('Please select a device first');
      return;
    }

    try {
      List<int> commands = ThermalPrinterUtils.createReceipt(
        companyName: 'TEST COMPANY',
        companyAddress: 'Test Address Line 1\nTest Address Line 2',
        companyPhone: '123-456-7890',
        receiptTitle: 'Test Receipt',
        customerInfo: {
          'Date:': DateTime.now().toString().substring(0, 19),
          'Customer:': 'Test Customer',
          'Order#:': '12345',
        },
        items: [
          {
            'Item 1:': 'Test Item 1',
            'Qty:': '2',
            'Price:': '\$10.00',
          }
        ],
        footer: {
          'thank_you': 'Thank you for your business!'
        },
      );

      bool success = await ThermalPrinterUtils.printRawData(_selectedDevice!.address, commands);
      
      if (success) {
        _showSuccess('Utility test printed successfully!');
      } else {
        _showError('Utility test failed');
      }
    } catch (e) {
      _showError('Utility test failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Printer Debug'),
        backgroundColor: Colors.blue.shade700,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
        actions: [
          IconButton(
            icon: Icon(Icons.bluetooth),
            onPressed: _selectDevice,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bluetooth Printer',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Selected Device: ${_selectedDevice?.name ?? 'None'}'),
                    Text('Address: ${_selectedDevice?.address ?? 'None'}'),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _selectDevice,
                      child: Text('Select Printer'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Test Printing',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _testBasicPrint,
                      child: Text('Test Basic Print'),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _testCleanedPrint,
                      child: Text('Test Cleaned Print'),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _testUtilityPrint,
                      child: Text('Test Utility Print'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Debug Information',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Troubleshooting Tips:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('• Make sure printer is turned on'),
                    Text('• Check Bluetooth is enabled'),
                    Text('• Try pairing printer in Settings first'),
                    Text('• Ensure printer supports ESC/POS commands'),
                    Text('• Check if printer is 3-inch thermal printer'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
