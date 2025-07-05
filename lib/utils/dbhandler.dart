import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:path/path.dart';
import 'package:shopapp/model/orlderlistModel.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'dart:async';
// import 'package:path_provider/path_provider.dart';

class DBHandler {
  Database? _database;

  Future<Database?> get database async {
    // SQLite implementation commented out for web compatibility
    // The app now uses API-based authentication instead of local database
    
    /*
    if (_database != null && _database!.isOpen) {
      return _database;
    }
    try {
      // Initialize sqflite for web if running on web platform
      if (kIsWeb) {
        databaseFactory = databaseFactoryFfiWeb;
      }
      
      String path;
      if (kIsWeb) {
        // For web, use a simple database name
        path = 'mydb.db';
      } else {
        // For mobile platforms, use documents directory
        final directory = await getApplicationDocumentsDirectory();
        path = join(directory.path, 'mydb.db');
      }
      
      print("Database path: $path");

      _database = await openDatabase(path, version: 1, onCreate: (db, version) {
        // Table creation code commented out
      });
      await _ensureDefaultUser();
      return _database;
    } catch (e) {
      print("Error opening database: $e");
      return null;
    }
    */
    
    print("Database operations disabled - using API authentication");
    return null;
  }

  /*
  Future<void> _ensureDefaultUser() async {
    final db = await database;
    if (db == null) return;

    final result = await db.query('Shop_Stock_Users');

    if (result.isEmpty) {
      await db.insert(
        'Shop_Stock_Users',
        {
          'USERNAME': 'sadmin',
          'PASSWORD': '9656',
          'ROLE': 'Admin',
        },
      );
      print("Default user added: sadmin / 9656 / Admin");
    }
  }
  */

  Future<Map<String, dynamic>?> validateUser(
      String username, String password, String role) async {
    final db = await database;
    if (db == null) return null;

    final List<Map<String, dynamic>> result = await db.query(
      'Shop_Stock_Users',
      where: 'USERNAME = ? AND PASSWORD = ? AND ROLE = ?',
      whereArgs: [username, password, role],
    );

    return result.isNotEmpty ? result.first : null;
  }

  Future<List<String>> getAllTables(Database db) async {
    try {
      // Query the sqlite_master table to get all table names
      List<Map<String, dynamic>> tables = await db
          .rawQuery('SELECT name FROM sqlite_master WHERE type = "table"');

      // Filter out the 'android_metadata' table and system tables
      List<String> tableNames = tables
          .map((table) => table['name'] as String)
          .where((name) =>
              name != 'android_metadata' && !name.startsWith('sqlite_'))
          .toList();

      return tableNames;
    } catch (e) {
      print("Error fetching tables: $e");
      return [];
    }
  }

  Future<void> checkAllTables() async {
    Database? db = await database; // Open your database

    if (db != null) {
      // Fetch all tables excluding 'android_metadata' and SQLite system tables
      List<String> tableNames = await getAllTables(db);

      // Print the table names
      for (var table in tableNames) {
        print("Table: $table");
      }

      await db.close(); // Close the database
    }
  }

  Future<void> insertItemData(List<Map<String, dynamic>> data) async {
    Database? db = await database;
    if (db == null) {
      print("Database not initialized.");
      return;
    }

    try {
      Batch batch = db.batch();
      for (var record in data) {
        batch.insert('Shop_Stock_StockMaster', record,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit();
      print("Data inserted successfully.");
    } catch (e) {
      print("Error inserting data: $e");
    }
  }

  Future<void> insertPartyData(List<Map<String, dynamic>> data) async {
    Database? db = await database;
    if (db == null) {
      print("Database not initialized.");
      return;
    }

    try {
      Batch batch = db.batch();
      for (var record in data) {
        // Check if the record with the same AccAutoID already exists
        var existingRecord = await db.query(
          'ACC_AccountMaster',
          where: 'AccAutoID = ?',
          whereArgs: [record['AccAutoID']],
        );

        // If no record exists with the same AccAutoID, insert the new record
        if (existingRecord.isEmpty) {
          batch.insert('ACC_AccountMaster', record,
              conflictAlgorithm: ConflictAlgorithm.replace);
        } else {
          print("Record with AccAutoID ${record['AccAutoID']} already exists.");
        }
      }
      await batch.commit();
      print("Data inserted successfully.");
    } catch (e) {
      print("Error inserting data: $e");
    }
  }

  // Future<void> insertPartyData(List<Map<String, dynamic>> data) async {
  //   Database? db = await database;
  //   if (db == null) {
  //     print("Database not initialized.");
  //     return;
  //   }
  //
  //   try {
  //     Batch batch = db.batch();
  //     for (var record in data) {
  //       batch.insert('ACC_AccountMaster', record, conflictAlgorithm: ConflictAlgorithm.replace);
  //     }
  //     await batch.commit();
  //     print("Data inserted successfully.");
  //   } catch (e) {
  //     print("Error inserting data: $e");
  //   }
  // }

  Future<void> insertOrderData(Map<String, dynamic> data) async {
    Database? db = await database;
    if (db == null) {
      print("Database not initialized.");
      return;
    }

    try {
      await db.insert('CMS_Shop_OrderMaster', data,
          conflictAlgorithm: ConflictAlgorithm.replace);
      print("Order data inserted successfully.");
    } catch (e) {
      print("Error inserting order data: $e");
    }
  }


  // Future<void> insertOrderlistData(Map<String, dynamic> data) async {
  //   Database? db = await database;
  //   if (db == null) {
  //     print("Database not initialized.");
  //     return;
  //   }
  //
  //   try {
  //     await db.insert('CMS_Shop_OrderDetails', data, conflictAlgorithm: ConflictAlgorithm.replace);
  //     print("Order data inserted successfully.");
  //   } catch (e) {
  //     print("Error inserting order data: $e");
  //   }
  // }
  //
  // Future<void> insertOrderlistData(List<Map<String, dynamic>> data) async {
  //   Database? db = await database;
  //   if (db == null) {
  //     print("Database not initialized.");
  //
  //     return;
  //   }
  //
  //   try {
  //     // Insert multiple items into the table using a batch insert
  //     Batch batch = db.batch();
  //     for (var item in data) {
  //       batch.insert('CMS_Shop_OrderDetails', item, conflictAlgorithm: ConflictAlgorithm.replace);
  //     }
  //     await batch.commit();
  //     print("Order data inserted successfully.");
  //   } catch (e) {
  //     print("Error inserting order data: $e");
  //   }
  // }

  // ...existing code...

  Future<void> addIsSyncedColumn() async {
    final db = await database;
    if (db == null) return;

    try {
      // Attempt to add the column
      await db.execute(
          'ALTER TABLE CMS_Shop_OrderMaster ADD COLUMN IsSynced INTEGER DEFAULT 0');
      print('IsSynced column added successfully');
    } catch (e) {
      print('Error adding IsSynced column: $e');
    }
  }

  Future<int> updateOrderSyncStatus(int orderId, int syncStatus) async {
    await addIsSyncedColumn(); // Ensure column exists before updating

    final db = await database;
    if (db == null) {
      throw Exception("Database not initialized.");
    }

    return await db.update(
      'CMS_Shop_OrderMaster',
      {'IsSynced': syncStatus},
      where: 'OrderID = ?',
      whereArgs: [orderId],
    );
  }

// ...existing code...

  Future<void> insertOrderlistData(
      List<Map<String, dynamic>> data, orderid) async {
    Database? db = await database;
    if (db == null) {
      print("Database not initialized.");
      return;
    }

    try {
      // Delete existing records where OrderID == 4
      await db.delete(
        'CMS_Shop_OrderDetails',
        where: 'OrderID = ?',
        whereArgs: [orderid],
      );
      print("Records with OrderID == 4 deleted successfully.");

      // Insert multiple items into the table using a batch insert
      Batch batch = db.batch();
      for (var item in data) {
        batch.insert('CMS_Shop_OrderDetails', item,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit();
      print("Order data inserted successfully.");
    } catch (e) {
      print("Error inserting order data: $e");
    }
  }

  Future<List<Map<String, dynamic>>> readItemData() async {
    Database? db = await database;
    if (db == null) {
      print("Database not initialized.");
      return [];
    }

    try {
      List<Map<String, dynamic>> result =
          await db.query('Shop_Stock_StockMaster');
      print("Dfdfdfdfdf" + result.toString());
      return result;
    } catch (e) {
      print("Error reading data: $e");
      return [];
    }
  }



  Future<List<Map<String, dynamic>>> readScannertransactionData() async {
    Database? db = await database;
    if (db == null) {
      print("Database not initialized.");
      return [];
    }


    try {
      List<Map<String, dynamic>> result =
          await db.query('Shop_StockScanTrans');
      print("Dfdfdffdfdfdfddfdf" + result.toString());
      return result;
    } catch (e) {
      print("Error reading data: $e");
      return [];
    }
  }



  Future<List<Map<String, dynamic>>> readScannerproductnData() async {
    Database? db = await database;
    if (db == null) {
      print("Database not initialized.");
      return [];
    }


    try {
      List<Map<String, dynamic>> result =
          await db.query('Shop_StockScanMaster');
      print("Dfdfdffdfdfsdsdsdfddfdf" + result.toString());
      return result;
    } catch (e) {
      print("Error reading data: $e");
      return [];
    }
  }



  Future<List<Map<String, dynamic>>> readPartyData() async {
    Database? db = await database;
    if (db == null) {
      print("Database not initialized.");
      return [];
    }

    try {
      List<Map<String, dynamic>> result = await db.query('ACC_AccountMaster');
      return result;
    } catch (e) {
      print("Error reading data: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> readOrderData() async {
    Database? db = await database;
    if (db == null) {
      print("Database not initialized.");
      return [];
    }

    try {
      List<Map<String, dynamic>> result =
          await db.query('CMS_Shop_OrderMaster');
      return result;
    } catch (e) {
      print("Error reading order data: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> readAllOrderlistData() async {
    Database? db = await database;
    if (db == null) {
      print("Database not initialized.");
      return [];
    }

    try {
      List<Map<String, dynamic>> result =
          await db.query('CMS_Shop_OrderDetails');
      return result;
    } catch (e) {
      print("Error reading order data: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> readOrderlistData({int? OrderID}) async {
    Database? db = await database;
    if (db == null) {
      print("Database not initialized.");
      return [];
    }

    try {
      // Build the query conditionally based on the provided OrderID
      String query = 'SELECT * FROM CMS_Shop_OrderDetails';
      if (OrderID != null) {
        query += ' WHERE OrderID = $OrderID';
      }

      // Execute the query
      List<Map<String, dynamic>> result = await db.rawQuery(query);
      return result;
    } catch (e) {
      print("Error reading order data: $e");
      return [];
    }
  }

  // Close database connection
  Future<void> closeDatabase() async {
    if (_database != null && _database!.isOpen) {
      await _database!.close();
      _database = null; // Reset the database reference
      print("Database closed.");
    }
  }

  Future<List<Map<String, dynamic>>> userdata() async {
    Database? db = await database;
    if (db == null) {
      print("Database not initialized.");
      return [];
    }

    try {
      String query = 'SELECT * FROM Shop_Stock_Users';
      List<Map<String, dynamic>> result = await db.rawQuery(query);
      print("User data: $result");
      return result;
    } catch (e) {
      print("Error reading user data: $e");
      return [];
    }
  }

  Future<int> deleteOrder(int orderId) async {
    Database? db = await database;
    if (db == null) {
      print("Database not initialized.");
      return 0;
    }

    try {
      return await db.delete(
        'CMS_Shop_OrderMaster',
        where: 'OrderID = ?',
        whereArgs: [orderId],
      );
    } catch (e) {
      print("Error deleting order: $e");
      return 0; // Return 0 to indicate failure
    }
  }

  Future<void> updateAccountAddress(int id, String newAccAddress) async {
    // Get a reference to the database
    final db = await database;

    // Update the record with the new AccAddress for the specific id
    await db!.update(
      'ACC_AccountMaster', // Table name
      {'AccAddress': newAccAddress}, // Fields to update
      where: 'id = ?', // WHERE condition to match the record
      whereArgs: [id], // The id to match
    );
  }




  Future<void> insertScannedData(Map<String, dynamic> data) async {
    Database? db = await database;
    if (db == null) {
      print("Database not initialized.");
      return;
    }

    try {
      await db.insert('Shop_StockScanTrans', data,
          conflictAlgorithm: ConflictAlgorithm.replace);
      print("scanner data inserted successfully.");
    } catch (e) {
      print("Error inserting order data: $e");
    }
  }

}
