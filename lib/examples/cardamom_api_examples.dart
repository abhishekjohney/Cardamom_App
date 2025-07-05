// Example usage of Cardamom Management APIs
// This file demonstrates how to use all 4 APIs in the ApiService

import 'package:shopapp/services/api_service.dart';
import 'package:shopapp/model/receipt_model.dart';
import 'package:shopapp/model/transaction_model.dart';

class CardamomApiExamples {
  final ApiService _apiService = ApiService();

  /// Example 1: Get Party List
  /// Equivalent to: listAPI.getPartyList()
  Future<void> exampleGetPartyList() async {
    try {
      print('📋 Fetching Party List...');
      
      final partyList = await _apiService.getPartyList(route: 'ROUTE01');
      
      print('✅ Party List Retrieved: ${partyList.length} parties found');
      for (var party in partyList) {
        print('   - ${party['PartyName']} (${party['PartyCode']})');
      }
    } catch (e) {
      print('❌ Error fetching party list: $e');
    }
  }

  /// Example 2: Get Green Cardamom Receipt List with Filters
  /// Equivalent to: listAPI.GetGreenCardamomReceiptList(dateFrom, dateUpto, partyName, refNo)
  Future<void> exampleGetReceiptList() async {
    try {
      print('📋 Fetching Cardamom Receipt List...');
      
      final transactions = await _apiService.getGreenCardamomReceiptList(
        dateFrom: '01-06-2025',
        dateUpto: '30-06-2025',
        partyName: 'ABC Traders',
        refNo: 'REF123',
      );
      
      print('✅ Receipt List Retrieved: ${transactions.length} transactions found');
      for (var transaction in transactions) {
        print('   - GCRID: ${transaction.gcrid}, Party: ${transaction.partyName}, Qty: ${transaction.receivedQty}');
      }
    } catch (e) {
      print('❌ Error fetching receipt list: $e');
    }
  }

  /// Example 3: Get Specific Receipt by Code
  /// Equivalent to: listAPI.GetGreenCardamomReceiptByCode(GCRID)
  Future<void> exampleGetReceiptByCode() async {
    try {
      print('📋 Fetching Receipt by Code...');
      
      final receipt = await _apiService.getGreenCardamomReceiptByCode(123);
      
      if (receipt != null) {
        print('✅ Receipt Retrieved: ${receipt.compRefNo}');
        print('   - Party: ${receipt.party}');
        print('   - Quantity: ${receipt.qty}');
        print('   - Rate: ${receipt.rate}');
        print('   - Amount: ${receipt.processingCharges}');
      } else {
        print('❌ Receipt not found');
      }
    } catch (e) {
      print('❌ Error fetching receipt: $e');
    }
  }

  /// Example 4: Update Existing Receipt
  /// Equivalent to: updateAPI.UpdateGreenCardamomReceipt(data)
  Future<void> exampleUpdateReceipt() async {
    try {
      print('📝 Updating Cardamom Receipt...');
      
      final receipt = Receipt(
        gcrid: 123, // Existing record
        compRefNo: 'GCR001',
        date: '26-06-2025',
        refNo: 'REF123',
        party: 'ABC Traders',
        partyId: 45,
        qty: 75.5,
        rate: 50.0,
        processingCharges: 3775.0,
        numberOfBags: 2,
        remark: 'Updated quantity and remarks',
      );
      
      final success = await _apiService.updateGreenCardamomReceipt(receipt);
      
      if (success) {
        print('✅ Receipt updated successfully');
      } else {
        print('❌ Failed to update receipt');
      }
    } catch (e) {
      print('❌ Error updating receipt: $e');
    }
  }

  /// Example 5: Create New Receipt
  /// Equivalent to: updateAPI.UpdateGreenCardamomReceipt(data) with GCRID = 0
  Future<void> exampleCreateReceipt() async {
    try {
      print('📝 Creating New Cardamom Receipt...');
      
      final newReceipt = Receipt(
        gcrid: 0, // This will be ignored and set to 0 for new records
        compRefNo: 'GCR002',
        date: '26-06-2025',
        refNo: 'REF456',
        party: 'XYZ Spices',
        partyId: 67,
        qty: 100.0,
        rate: 55.0,
        processingCharges: 5500.0,
        numberOfBags: 3,
        remark: 'New high-quality batch',
      );
      
      final success = await _apiService.createGreenCardamomReceipt(newReceipt);
      
      if (success) {
        print('✅ New receipt created successfully');
      } else {
        print('❌ Failed to create receipt');
      }
    } catch (e) {
      print('❌ Error creating receipt: $e');
    }
  }

  /// Run all examples
  Future<void> runAllExamples() async {
    print('🚀 Running Cardamom API Examples...\n');
    
    await exampleGetPartyList();
    print('');
    
    await exampleGetReceiptList();
    print('');
    
    await exampleGetReceiptByCode();
    print('');
    
    await exampleUpdateReceipt();
    print('');
    
    await exampleCreateReceipt();
    print('');
    
    print('🎉 All examples completed!');
  }
}

/*
=============================================================================
API USAGE SUMMARY
=============================================================================

1. PARTY LIST API
   URL: https://cardamombe.magnussoftech.in/WebDataProcessingReact.aspx
   Method: getPartyList({String? route})
   Purpose: Get list of parties for selection in receipts

2. GET RECEIPT LIST API
   URL: http://nwbo1.jubilyhrm.in/api/WebServiceCardamom.aspx
   Method: getGreenCardamomReceiptList({dateFrom, dateUpto, partyName, refNo})
   Purpose: Fetch cardamom transactions with date range and filters

3. GET RECEIPT BY CODE API
   URL: http://nwbo1.jubilyhrm.in/api/WebServiceCardamom.aspx
   Method: getGreenCardamomReceiptByCode(int gcrid)
   Purpose: Fetch specific receipt details for editing

4. UPDATE/CREATE RECEIPT API
   URL: http://nwbo1.jubilyhrm.in/api/WebServiceCardamom.aspx
   Method: updateGreenCardamomReceipt(Receipt receipt) // GCRID > 0 = update
   Method: createGreenCardamomReceipt(Receipt receipt) // GCRID = 0 = create
   Purpose: Create new or update existing cardamom receipt records

All APIs:
- Use POST method with multipart/form-data
- Parse responses using ||JasonEnd delimiter
- Extract data from JSONData1 field when present
- Include comprehensive error handling
=============================================================================
*/
