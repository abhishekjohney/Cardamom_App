// lib/services/api_service.dart

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shopapp/model/receipt_model.dart';
import 'package:shopapp/model/transaction_model.dart';
import 'dart:convert';

/// API Service for Cardamom Management System
/// 
/// This service handles all cardamom-related API calls including:
/// 1. Party List API - Get Party and Balance List
/// 2. Get Green Cardamom Receipt List API  
/// 3. Get Green Cardamom Receipt By Code API
/// 4. Update Green Cardamom Receipt API
/// 
/// All APIs follow the multipart/form-data pattern and use ||JasonEnd response parsing
/// 
/// IMPORTANT: URLs updated to match the working React app endpoints.
/// Previous URLs were returning 302 redirects, causing "Failed to process response" errors.
class ApiService {
  /// Base URL for Cardamom WebService API (Updated to match React app)
  static const String baseUrl =
      'https://cardamombe.magnussoftech.in/api/WebServiceCardamom.aspx';
  
  /// Alternative base URL for main WebService (used for party list)
  static const String webServiceUrl = 
      'https://cardamombe.magnussoftech.in/WebDataProcessingReact.aspx';
      
  final Dio _dio = Dio();

  static final ApiService _instance = ApiService._internal();




  factory ApiService() {
    return _instance;
  }



  ApiService._internal() {
    _dio.options.headers = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
    };
    _dio.options.followRedirects = true;
    _dio.options.validateStatus = (status) {
      return status! < 500;
    };
  }

  Future<Map<String, dynamic>> getFormattedResponse(FormData formData) async {
    try {
      print("📤 Making API request to: $baseUrl");
      print("📤 FormData fields: ${formData.fields.map((e) => '${e.key}: ${e.value}').join(', ')}");
      
      final response = await _dio.post(
        baseUrl,
        data: formData,
      );

      print("📥 Response status: ${response.statusCode}");
      print("📥 Response data type: ${response.data.runtimeType}");

      if (response.statusCode == 200) {
        String jsonString = response.data.toString();
        print("📥 Raw response length: ${jsonString.length}");
        print("📥 Raw response preview: ${jsonString.length > 500 ? jsonString.substring(0, 500) + '...' : jsonString}");
        
        // Check for common response patterns
        bool hasJasonEnd = jsonString.contains("||JasonEnd");
        bool hasJSONData1 = jsonString.contains("JSONData1");
        bool startsWithBracket = jsonString.trim().startsWith('[');
        bool startsWithBrace = jsonString.trim().startsWith('{');
        
        print("📊 Response analysis:");
        print("  - Has ||JasonEnd: $hasJasonEnd");
        print("  - Has JSONData1: $hasJSONData1");
        print("  - Starts with '[': $startsWithBracket");
        print("  - Starts with '{': $startsWithBrace");
        
        int endIndex = jsonString.indexOf("||JasonEnd");

        if (endIndex == -1) {
          print("⚠️ No ||JasonEnd delimiter found, treating as direct JSON response");
          
          // Try to parse as direct JSON response
          try {
            final directData = json.decode(jsonString);
            print("✅ Direct JSON parsing successful: ${directData.runtimeType}");
            
            // Check if it's already a list or contains data directly
            if (directData is List) {
              return {
                'success': true,
                'data': directData
              };
            } else if (directData is Map && directData.containsKey('data')) {
              return {
                'success': true,
                'data': directData['data']
              };
            } else {
              return {
                'success': true,
                'data': directData
              };
            }
          } catch (e) {
            print("❌ Direct JSON parsing failed: $e");
            return {
              'success': false,
              'error': 'Invalid response format - not valid JSON',
              'data': null
            };
          }
        }

        // Handle ||JasonEnd delimiter format
        jsonString = jsonString.substring(0, endIndex);
        print("📥 Cleaned response: ${jsonString.length > 300 ? jsonString.substring(0, 300) + '...' : jsonString}");
        
        try {
          final userData = json.decode(jsonString);
          print("✅ JSON parsing successful: ${userData.runtimeType}");

          // Handle different response formats
          if (userData is List && userData.isNotEmpty) {
            // Check if first item has JSONData1 field
            if (userData[0] is Map && userData[0]['JSONData1'] != null) {
              final nestedData = json.decode(userData[0]['JSONData1']);
              print("✅ Extracted JSONData1: ${nestedData.runtimeType}");
              return {
                'success': true,
                'data': nestedData
              };
            } else {
              // Return the list directly
              print("✅ Returning list directly");
              return {
                'success': true,
                'data': userData
              };
            }
          } else if (userData is Map) {
            // Handle map response
            print("✅ Returning map response");
            return {
              'success': true,
              'data': userData
            };
          } else {
            print("⚠️ Unexpected response format: ${userData.runtimeType}");
            return {
              'success': false,
              'error': 'Unexpected response format',
              'data': null
            };
          }
        } catch (jsonError) {
          print("❌ JSON parsing error: $jsonError");
          print("📥 Failed to parse: $jsonString");
          return {
            'success': false,
            'error': 'JSON parsing failed: $jsonError',
            'data': null
          };
        }
      } else {
        print("❌ HTTP Error: ${response.statusCode} - ${response.statusMessage}");
        return {
          'success': false,
          'error': 'HTTP ${response.statusCode}: ${response.statusMessage}',
          'data': null
        };
      }
    } on DioException catch (e) {
      print("❌ Dio Exception: ${e.type} - ${e.message}");
      return {
        'success': false,
        'error': 'Network error: ${e.message}',
        'data': null
      };
    } catch (e) {
      print("❌ Unexpected error: $e");
      return {'success': false, 'error': e.toString(), 'data': null};
    }
  }


  /// 1. Party List API - Get Party and Balance List
  /// Equivalent to: listAPI.getPartyList()
  /// Backend: WebDataProcessingReact.aspx
  Future<List<dynamic>> getPartyList({String? route}) async {
    try {
      // Get year from storage or use current year
      final currentYear = DateTime.now().year.toString();
      
      print("🎭 PARTY LIST API CALL STARTING");
      print("   URL: $webServiceUrl");
      print("   Route parameter: ${route ?? 'Not specified'}");
      print("   Current year: $currentYear");
      
      final formData = FormData.fromMap({
        'title': 'GetPartyNBalanceList',
        'description': 'Request Bill By Code',
        'ReqType': '1',
        'ReqNofRcds': '',
        'ReqAcaStart': currentYear,
        'ReqGroups': 'Sundry Debtors',
        'ReqCodes': '',
        'ReqByrName': '',
        'ReqRoute': route ?? '',
      });

      print("📤 Party List Request FormData:");
      for (var field in formData.fields) {
        print("   ${field.key}: '${field.value}'");
      }

      // Use webServiceReact endpoint for party list
      final response = await _dio.post(
        webServiceUrl,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Accept': 'application/json',
          },
          followRedirects: true,
          validateStatus: (status) => status! < 500,
        ),
      );

      print("📥 Party List Response Status: ${response.statusCode}");
      print("📥 Party List Response Headers: ${response.headers}");

      if (response.statusCode == 200) {
        String jsonString = response.data.toString();
        print("📥 Party List Raw Response Length: ${jsonString.length}");
        print("📥 Party List Raw Response Preview: ${jsonString.length > 300 ? jsonString.substring(0, 300) + '...' : jsonString}");
        
        int endIndex = jsonString.indexOf("||JasonEnd");
        print("📥 Party List ||JasonEnd found at index: $endIndex");

        if (endIndex != -1) {
          jsonString = jsonString.substring(0, endIndex);
          print("📥 Party List Cleaned JSON: ${jsonString.length > 200 ? jsonString.substring(0, 200) + '...' : jsonString}");
          
          final userData = json.decode(jsonString);
          print("📥 Party List Parsed Data Type: ${userData.runtimeType}");
          print("📥 Party List Parsed Data: ${userData.toString().length > 500 ? userData.toString().substring(0, 500) + '...' : userData.toString()}");

          // Check for direct PartyList structure (as seen in debug output)
          if (userData is Map && userData.containsKey('PartyList')) {
            final partyList = userData['PartyList'];
            print("✅ Party List Found in Direct Structure:");
            print("   Type: ${partyList.runtimeType}");
            print("   Length: ${partyList is List ? partyList.length : 'Not a list'}");
            
            if (partyList is List) {
              print("   First few parties:");
              for (int i = 0; i < 3 && i < partyList.length; i++) {
                final party = partyList[i];
                print("     [$i] ID: ${party['AccAutoID']}, Name: '${party['Byr_nam']}', Code: '${party['Byr_Cd']}'");
              }
              
              // Convert to expected format with ByrNam and ID fields
              final convertedParties = partyList.map((party) => {
                'ID': party['AccAutoID'],
                'ByrNam': party['Byr_nam'],
                'AccAddress': party['AccAddress'] ?? '',
                'Balance': party['Balance'] ?? 0.0,
                'Byr_Cd': party['Byr_Cd'],
                'Groups': party['Groups'],
                'PhoneNo': party['PhoneNo'] ?? '',
              }).toList();
              
              print("✅ Converted ${convertedParties.length} parties to expected format");
              return convertedParties;
            }
          }
          // Legacy check for JSONData1 structure
          else if (userData is List && userData.isNotEmpty && userData[0]['JSONData1'] != null) {
            final partyData = json.decode(userData[0]['JSONData1']);
            print("✅ Party List JSONData1 Extracted:");
            print("   Type: ${partyData.runtimeType}");
            print("   Length: ${partyData is List ? partyData.length : 'Not a list'}");
            if (partyData is List && partyData.isNotEmpty) {
              print("   First Party: ${partyData[0]}");
              print("   Sample parties: ${partyData.take(3).map((p) => p['PartyName'] ?? p['Name'] ?? 'Unknown').join(', ')}");
            }
            return partyData;
          } else {
            print("⚠️ Party List: No PartyList or JSONData1 found");
            print("   UserData type: ${userData.runtimeType}");
            print("   UserData keys: ${userData is Map ? userData.keys.toList() : 'Not a map'}");
          }
        } else {
          print("⚠️ Party List: No ||JasonEnd delimiter found in response");
        }
      } else {
        print("❌ Party List HTTP Error: ${response.statusCode} - ${response.statusMessage}");
      }

      print("🎭 PARTY LIST API CALL RETURNING EMPTY LIST");
      return [];
    } catch (e) {
      print("❌ Party List API Exception: $e");
      print("❌ Party List Stack Trace: ${StackTrace.current}");
      throw Exception('Failed to load party list: $e');
    }
  }

  /// 2. Get Green Cardamom Receipt List API
  /// Equivalent to: listAPI.GetGreenCardamomReceiptList(dateFrom, dateUpto, partyName, refNo)
  /// Backend: WebServiceCardamom.aspx
  Future<List<Transaction>> getGreenCardamomReceiptList({
    required String dateFrom,
    String? dateUpto,
    String? partyName,
    String? refNo,
  }) async {
    try {
      print("🔍 Getting Cardamom Receipt List with params:");
      print("   dateFrom: $dateFrom");
      print("   dateUpto: ${dateUpto ?? dateFrom}");
      print("   partyName: ${partyName ?? 'Not specified'}");
      print("   refNo: ${refNo ?? 'Not specified'}");
      
      final formData = FormData.fromMap({
        'title': 'GetGreenCardamomReceiptList',
        'Reqdate1': dateFrom,
        'Reqdate2': dateUpto ?? '',  // Send empty string if not provided (matching React app)
        'Reqparty': partyName ?? '',
        'ReqRefNo': refNo ?? '',
      });

      final result = await getFormattedResponse(formData);
      print("📋 API Result: ${result['success']} - ${result['error'] ?? 'Success'}");

      if (result['success'] == true) {
        final data = result['data'];
        print("📋 Data type: ${data.runtimeType}");
        
        if (data is List) {
          print("📋 Converting ${data.length} items to Transaction objects");
          try {
            final transactions = data
                .map<Transaction>((item) {
                  print("   Converting item: ${item.runtimeType} - ${item.toString().length > 100 ? item.toString().substring(0, 100) + '...' : item.toString()}");
                  return Transaction.fromJson(item);
                })
                .toList();
            print("✅ Successfully converted ${transactions.length} transactions");
            return transactions;
          } catch (conversionError) {
            print("❌ Error converting to Transaction objects: $conversionError");
            print("   Sample data item: ${data.isNotEmpty ? data[0] : 'No data'}");
            throw Exception('Data conversion error: $conversionError');
          }
        } else {
          print("⚠️ Expected List but got: ${data.runtimeType}");
          return [];
        }
      }

      if (result['error'] != null) {
        print("❌ API Error: ${result['error']}");
        throw Exception(result['error']);
      }

      print("⚠️ No data returned from API");
      return [];
    } catch (e) {
      print("❌ Exception in getGreenCardamomReceiptList: $e");
      throw Exception('Failed to load cardamom receipt list: $e');
    }
  }

  /// Legacy method for backward compatibility
  Future<List<Transaction>> getCardamomData(String reqDate) async {
    return getGreenCardamomReceiptList(dateFrom: reqDate);
  }

  /// 3. Get Green Cardamom Receipt By Code API
  /// Equivalent to: listAPI.GetGreenCardamomReceiptByCode(GCRID)
  /// Backend: WebServiceCardamom.aspx
  Future<Receipt?> getGreenCardamomReceiptByCode(int gcrid) async {
    try {
      var formData = FormData.fromMap({
        'title': 'GetGreenCardamomReceiptByCode',
        'description': '',
        'ReqGCRID': gcrid,
      });

      final result = await getFormattedResponse(formData);

      if (result['success'] &&
          result['data'] is List &&
          result['data'].isNotEmpty) {
        return Receipt.fromJson(result['data'][0]);
      }

      if (result['error'] != null) {
        throw Exception(result['error']);
      }

      return null;
    } catch (e) {
      throw Exception('Failed to load receipt details: $e');
    }
  }


  /// 4. Update Green Cardamom Receipt API
  /// Equivalent to: updateAPI.UpdateGreenCardamomReceipt(data)
  /// Backend: WebServiceCardamom.aspx
  Future<bool> updateGreenCardamomReceipt(Receipt receipt) async {
    print(
      "📋 Updating Green Cardamom Receipt:\n"
      "CdateStr: ${receipt.date}\n"
      "CompRefNo: ${receipt.compRefNo}\n"
      "GCRID: ${receipt.gcrid}\n"
      "GCRecQty: ${receipt.qty}\n"
      "GCRecRemarks: ${receipt.remark}\n"
      "PartyID: ${receipt.partyId}\n"
      "PartyName: ${receipt.party}\n"
      "ProcAmount: ${receipt.processingCharges}\n"
      "Rate: ${receipt.rate}\n"
      "ReceiptAmount: ${receipt.processingCharges}\n"
      "ReceiptRemarks: ${receipt.remark}\n"
      "RefNo: ${receipt.refNo}\n"
    );
    try {
      // Convert date to the expected format with milliseconds
      DateTime parsedDate = DateTime.now();
      try {
        List<String> dateParts = receipt.date.split('-');
        if (dateParts.length == 3) {
          parsedDate = DateTime(
            int.parse(dateParts[2]), // year
            int.parse(dateParts[1]), // month
            int.parse(dateParts[0])  // day
          );
        }
      } catch (e) {
        print("⚠️ Date parsing error, using current date: $e");
      }
      
      int timestamp = parsedDate.millisecondsSinceEpoch;
      String formattedDate = "/Date($timestamp+0530)/";
      
      final reqData = [
        {
          "ActionType": 1,
          "COMemID": 0,
          "COMemName": "",
          "Cdate": formattedDate,
          "CdateStr": receipt.date,
          "CompRefNo": int.tryParse(receipt.compRefNo) ?? 0,
          "DelDate": formattedDate,
          "DelDateStr": "",
          "DelQty": 0,
          "DelRemarks": "",
          "DelYN": false,
          "DriedYN": false,
          "GCRID": receipt.gcrid,
          "GCRecQty": receipt.qty,
          "GCRecRemarks": receipt.remark,
          "Ndx": 0,
          "PaidYn": false,
          "PartyID": receipt.partyId,
          "PartyName": receipt.party,
          "ProcAmount": receipt.processingCharges,
          "ProcRatio": "",
          "Rate": receipt.rate,
          "ReceiptAmount": 0,
          "ReceiptRemarks": "",
          "RefNo": receipt.refNo,
          "StkDate": formattedDate,
          "StkDateStr": "",
          "StkQty": 0,
          "StockLocation": "",
          "Works": 1
        }
      ];

      var formData = FormData.fromMap({
        'title': 'UpdateGreenCardamomReceipt',
        'description': 'Request For EmployeeMaster Update',
        'ReqJSonData': json.encode(reqData)
      });

      print("🚀 Sending request with data: ${json.encode(reqData)}");

      final result = await getFormattedResponse(formData);
      print("✅ Update result: ${result.toString()}");
      return result['success'] ?? false;
    } catch (e) {
      print("❌ Update error: $e");
      throw Exception('Failed to update receipt: $e');
    }
  }

  /// Create new Green Cardamom Receipt (uses same API with GCRID = 0)
  /// Equivalent to: updateAPI.UpdateGreenCardamomReceipt(data) with new record
  Future<bool> createGreenCardamomReceipt(Receipt receipt) async {
    // Create a new receipt object with GCRID = 0 for new records
    final newReceipt = Receipt(
      gcrid: 0, // 0 indicates new record
      compRefNo: receipt.compRefNo,
      date: receipt.date,
      refNo: receipt.refNo,
      party: receipt.party,
      partyId: receipt.partyId,
      qty: receipt.qty,
      rate: receipt.rate,
      processingCharges: receipt.processingCharges,
      numberOfBags: receipt.numberOfBags,
      remark: receipt.remark,
    );
    return updateGreenCardamomReceipt(newReceipt);
  }


  void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  String formatDateForApi(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.year}';
  }

  DateTime? parseDateFromApi(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;

    try {
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        return DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      }
    } catch (e) {
      print('Error parsing date: $e');
    }
    return null;
  }

  /// Utility method to validate and format date for API
  String validateAndFormatDate(String dateStr) {
    try {
      // If already in DD-MM-YYYY format, validate and return
      if (RegExp(r'^\d{2}-\d{2}-\d{4}$').hasMatch(dateStr)) {
        final parts = dateStr.split('-');
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        
        // Basic validation
        if (day >= 1 && day <= 31 && month >= 1 && month <= 12 && year >= 2000) {
          return dateStr;
        }
      }
      
      // Try to parse other common formats and convert to DD-MM-YYYY
      DateTime? date;
      
      // Try YYYY-MM-DD format
      if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(dateStr)) {
        date = DateTime.parse(dateStr);
      }
      // Try MM/DD/YYYY format
      else if (RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(dateStr)) {
        final parts = dateStr.split('/');
        date = DateTime(int.parse(parts[2]), int.parse(parts[0]), int.parse(parts[1]));
      }
      // Try DD/MM/YYYY format
      else if (RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(dateStr)) {
        final parts = dateStr.split('/');
        date = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
      }
      
      if (date != null) {
        return formatDateForApi(date);
      }
      
      // If all parsing fails, return current date
      print("⚠️ Date parsing failed for: $dateStr, using current date");
      return formatDateForApi(DateTime.now());
      
    } catch (e) {
      print("❌ Date validation error: $e");
      return formatDateForApi(DateTime.now());
    }
  }

  /// Debug method to test API connectivity and response format
  Future<void> testApiConnection() async {
    try {
      print("🧪 Testing API connection...");
      
      final formData = FormData.fromMap({
        'title': 'GetGreenCardamomReceiptList',
        'Reqdate1': '18-06-2025',  // Using same date as React app for consistency
        'Reqdate2': '',            // Empty string like React app
        'Reqparty': '',
        'ReqRefNo': '',
      });

      print("🌐 Making test request to: $baseUrl");
      
      final response = await _dio.post(
        baseUrl,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Accept': 'application/json',
          },
          followRedirects: true,
          validateStatus: (status) => true, // Accept all status codes for debugging
        ),
      );

      print("📊 Test Results:");
      print("   Status Code: ${response.statusCode}");
      print("   Status Message: ${response.statusMessage}");
      print("   Headers: ${response.headers}");
      
      if (response.data != null) {
        String responseStr = response.data.toString();
        print("   Response Length: ${responseStr.length}");
        print("   Response Preview: ${responseStr.length > 200 ? responseStr.substring(0, 200) + '...' : responseStr}");
        print("   Contains ||JasonEnd: ${responseStr.contains('||JasonEnd')}");
        
        if (responseStr.contains('||JasonEnd')) {
          int endIndex = responseStr.indexOf("||JasonEnd");
          String cleanResponse = responseStr.substring(0, endIndex);
          print("   Clean Response Length: ${cleanResponse.length}");
          print("   Clean Response Preview: ${cleanResponse.length > 200 ? cleanResponse.substring(0, 200) + '...' : cleanResponse}");
        }
      }
      
      print("✅ API connection test completed");
    } catch (e) {
      print("❌ API connection test failed: $e");
    }
  }
}

/*
=============================================================================
CARDAMOM MANAGEMENT API SUMMARY
=============================================================================

This ApiService class provides 4 main APIs for cardamom management:

1. Party List API
   - Method: getPartyList({String? route})
   - Endpoint: WebDataProcessingReact.aspx
   - Purpose: Fetch party and balance list for selection
   - Parameters: title, description, ReqType, ReqAcaStart, ReqGroups, etc.

2. Get Green Cardamom Receipt List API  
   - Method: getGreenCardamomReceiptList({dateFrom, dateUpto, partyName, refNo})
   - Endpoint: WebServiceCardamom.aspx
   - Purpose: Fetch cardamom transactions by date range and filters
   - Parameters: title, Reqdate1, Reqdate2, Reqparty, ReqRefNo

3. Get Green Cardamom Receipt By Code API
   - Method: getGreenCardamomReceiptByCode(int gcrid)
   - Endpoint: WebServiceCardamom.aspx  
   - Purpose: Fetch specific receipt details by ID
   - Parameters: title, ReqGCRID

4. Update Green Cardamom Receipt API
   - Method: updateGreenCardamomReceipt(Receipt receipt)
   - Method: createGreenCardamomReceipt(Receipt receipt) // GCRID = 0
   - Endpoint: WebServiceCardamom.aspx
   - Purpose: Create or update cardamom receipt records
   - Parameters: title, description, ReqJSonData (JSON encoded receipt data)

All APIs use:
- POST method with multipart/form-data
- ||JasonEnd response delimiter parsing
- JSONData1 field extraction for nested responses
- Comprehensive error handling

Response Format Pattern:
{ResponseData}||JasonEnd -> Parse first part as JSON -> Extract JSONData1 if present
=============================================================================
*/
