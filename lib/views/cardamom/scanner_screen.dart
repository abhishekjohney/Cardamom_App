import 'package:downloadsfolder/downloadsfolder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shopapp/controllers/stockcontroller.dart';
import 'package:shopapp/model/scanneditemsfetch.dart';
import 'package:shopapp/utils/dbhandler.dart';
import 'package:sqflite/sqflite.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  bool _isScanned = false;

  late final MobileScannerController _controller;

  DBHandler dbHandler = DBHandler();

  String todaydate = '';
  String todaytime = '';


  @override
  void initState() {
    super.initState();
    final now = DateTime.now();

    // Format date as dd-MM-yyyy
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);

    // Format time as HH:mm:ss
    String formattedTime = DateFormat('HH:mm:ss').format(now);


    setState(() {
      todaydate=formattedDate;
      todaytime=formattedTime;
    });
    print('Date: $formattedDate');
    print('Time: $formattedTime');
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal, // or DetectionSpeed.unrestricted
      facing: CameraFacing.back,
    );
  }


  Future<void> insertScanTransaction({
    required Database db,
    required String ScanDate,
    required String AddedTime,
  }) async {
    await db.insert(
      'Shop_StockScanTrans',
      {
        'ScanDate': ScanDate,
        'AddedTime': AddedTime,
      },
      conflictAlgorithm: ConflictAlgorithm.replace, // Use replace or ignore as needed
    );
    print("inserted succesfulllly");
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async{
    if (_isScanned) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final String? code = barcodes.first.rawValue;
      if (code != null && code.isNotEmpty) {
        _isScanned = true;
        _controller.stop();

        final directory = await getApplicationDocumentsDirectory();
        String path = join(directory.path, 'mydb.db');

        final db = await openDatabase(path);

        await insertScanTransaction(db: db, ScanDate: todaydate, AddedTime: todaytime);
        Get.off(() => BarcodeResultScreen(code: code));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.orange.shade700,iconTheme: IconThemeData(color: Colors.white),
        title: Text("Scan Barcode",style: TextStyle(color: Colors.white),),
      ),
      body: MobileScanner(
        controller: _controller,
        onDetect: _onDetect,
      ),
    );
  }
}

class BarcodeResultScreen extends StatefulWidget {
  final String code;

  const BarcodeResultScreen({super.key, required this.code});

  @override
  State<BarcodeResultScreen> createState() => _BarcodeResultScreenState();
}

class _BarcodeResultScreenState extends State<BarcodeResultScreen> {

  final StockController stockController = Get.put(StockController());
  String todaydate = '';
  String todaytime = '';
  DBHandler dbHandler = DBHandler();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final now = DateTime.now();

    // Format date as dd-MM-yyyy
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);

    // Format time as HH:mm:ss
    String formattedTime = DateFormat('HH:mm:ss').format(now);


    setState(() {
      todaydate=formattedDate;
      todaytime=formattedTime;
    });



    dbHandler.readScannerproductnData();
    dbHandler.readScannertransactionData();
  }



  Future<void> insertStockScanMaster({
    required Database db,
    required int stkTkRcdID,
    required int svrStkID,
    required String stockItemName,
    required String totStock,
    required String ScanCount,
  }) async {
    await db.insert(
      'Shop_StockScanMaster',
      {
        'StkTkRcdID': stkTkRcdID,
        'SvrStkID': svrStkID,
        'StockItemName': stockItemName,
        'StkDate': todaydate,
        'TotStock': totStock,
        'ScanCount': '$ScanCount',
        'AddedTime': todaytime,
      },
      conflictAlgorithm: ConflictAlgorithm.replace, // Use replace or ignore as needed
    );

    await dbHandler.readScannerproductnData();
    print("product added successfully");
  }int stockCount = 1;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scanned Barcode")),
      body: Center(
        child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Scanned Barcode:\n${widget.code}",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 20),

          // Stock control row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Stock: ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () {
                  if (stockCount > 1) {
                    setState(() {
                      stockCount--;
                    });
                  }
                },
              ),
              Text(
                '$stockCount',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () {
                  setState(() {
                    stockCount++;
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          MaterialButton(
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: () async {

              await stockController.fetchScannedItemdatabycode(widget.code);


              print('fddsfdsfsdfdsf+${stockController.fetchsacitemlist.first.itmNam}');
              //
              final directory = await getApplicationDocumentsDirectory();
              String path = join(directory.path, 'mydb.db');


              final db = await openDatabase(path);
              await insertStockScanMaster(
                db: db,
                stkTkRcdID: 1,
                svrStkID: stockController.fetchsacitemlist.first.svrstkID,
                stockItemName: stockController.fetchsacitemlist.first.itmNam.toString(),
                totStock: stockController.fetchsacitemlist.first.stksvrStock.toString(),
                ScanCount: '1', // use selected stock count
              );

              // await getScanCount(db); // refresh if needed
            },
            child: const Text("Add Product"),
          ),
        ],
      ),

    ),
    );
  }
}
