import 'package:flutter/material.dart';

class BarcodeDetailScreen extends StatelessWidget {
  final String code;

  const BarcodeDetailScreen({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scanned Result")),
      body: Center(
        child: Text(
          "Scanned Code:\n$code",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
