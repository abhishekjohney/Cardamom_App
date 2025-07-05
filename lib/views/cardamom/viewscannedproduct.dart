import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopapp/utils/dbhandler.dart';

class ScannedProductsScreen extends StatefulWidget {
  const ScannedProductsScreen({super.key});

  @override
  State<ScannedProductsScreen> createState() => _ScannedProductsScreenState();
}

class _ScannedProductsScreenState extends State<ScannedProductsScreen> {
  final DBHandler dbHandler = DBHandler();
  List<Map<String, dynamic>> scannedProducts = [];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final data = await dbHandler.readScannerproductnData();
    setState(() {
      scannedProducts = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.orange.shade700,iconTheme: IconThemeData(color: Colors.white),
        title: Text("Scanned Products",style: TextStyle(color: Colors.white),),
      ),
      body: scannedProducts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: scannedProducts.length,
        itemBuilder: (context, index) {
          final item = scannedProducts.reversed.toList()[index];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                item['StockItemName'] ?? '',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text("Date: ${item['StkDate'] ?? ''}"),
                  Text("Stock: ${item['TotStock'] ?? ''}"),
                  Text("Scanned: ${item['ScanCount'] ?? ''}"),
                  Text("Time: ${item['AddedTime'] ?? ''}"),
                ],
              ),
              // trailing: const Icon(Icons.qr_code, color: Colors.blue),
            ),
          );
        },
      ),
    );
  }
}
