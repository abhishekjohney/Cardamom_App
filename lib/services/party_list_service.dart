import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shopapp/model/party_list_model.dart';

class PartyListService {
  static Dio? _sharedDio;
  
  // Use a shared Dio instance to maintain session cookies
  Dio get _dio {
    if (_sharedDio == null) {
      _sharedDio = Dio();
      // Configure the shared Dio instance
      _sharedDio!.options.connectTimeout = Duration(milliseconds: 30000);
      _sharedDio!.options.receiveTimeout = Duration(milliseconds: 30000);
      _sharedDio!.options.sendTimeout = Duration(milliseconds: 30000);
      
      print('🔧 Created shared Dio instance for session management');
    }
    return _sharedDio!;
  }
  
  /// Use the correct URL from React implementation
  static const String webServiceUrl = 
      'https://cardamombe.magnussoftech.in/WebDataProcessingReact.aspx';

  static final PartyListService _instance = PartyListService._internal();
  factory PartyListService() => _instance;
  PartyListService._internal();

  Future<PartyListResponse> getPartyList({
    String route = "",
    String groups = "Sundry Creditors", // Changed to match working React payload
  }) async {
    try {
      // Get current year
      final year = DateTime.now().year.toString();
      
      // Create payload exactly like React implementation
      final payload = {
        'title': 'GetPartyNBalanceList',
        'description': 'Request Bill By Code',
        'ReqType': '1',
        'ReqNofRcds': '',
        'ReqAcaStart': year,
        'ReqGroups': groups,
        'ReqCodes': '',
        'ReqByrName': '',
        'ReqRoute': route,
      };

      print('🌐 === 🚀 UPDATED PARTY LIST API DEBUG 🚀 ===');
      print('📍 URL: $webServiceUrl');
      print('📤 Payload: ${json.encode(payload)}');
      print('🔄 UPDATED SERVICE: Fetching party list with route: "$route", groups: "$groups"');
      
      // Try FormData instead of JSON since server might expect that
      final formData = FormData.fromMap(payload);
      
      final response = await _dio.post(
        webServiceUrl,
        data: formData, // Use FormData like working API
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Accept': 'application/json',
          },
          followRedirects: false, // Disable redirects to see exact response
          validateStatus: (status) => status! < 500,
          receiveTimeout: Duration(milliseconds: 30000), // 30 seconds
          sendTimeout: Duration(milliseconds: 30000), // 30 seconds
        ),
      );

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Headers: ${response.headers}');

      if (response.statusCode == 200) {
        String responseBody = response.data.toString();
        print('📄 Raw Response Length: ${responseBody.length}');
        print('📄 Raw Response (first 500 chars): ${responseBody.length > 500 ? responseBody.substring(0, 500) + "..." : responseBody}');
        
        // Remove the marker if present
        final endMarkerPos = responseBody.indexOf('||JasonEnd');
        if (endMarkerPos != -1) {
          print('✂️ Found JasonEnd marker at position $endMarkerPos, trimming response');
          responseBody = responseBody.substring(0, endMarkerPos);
        }
        
        try {
          final userData = json.decode(responseBody);
          print('✅ JSON Parsed Successfully');
          print('📊 Response Type: ${userData.runtimeType}');
          
          if (userData is Map) {
            print('🔍 Response Keys: ${userData.keys.toList()}');
          }
          
          // Check for the correct API response structure: userdata.PartyList
          if (userData is Map && userData.containsKey('userdata')) {
            final userDataObj = userData['userdata'];
            print('📦 Found userdata object: ${userDataObj.runtimeType}');
            if (userDataObj is Map && userDataObj.containsKey('PartyList')) {
              final partyList = userDataObj['PartyList'];
              print('✅ Found userdata.PartyList structure with ${partyList.length} parties');
              return PartyListResponse.fromJson({'PartyList': partyList});
            }
          }
          // Fallback: Check for direct PartyList structure
          else if (userData is Map && userData.containsKey('PartyList')) {
            final partyList = userData['PartyList'];
            print('✅ Found direct PartyList structure with ${partyList.length} parties');
            return PartyListResponse.fromJson(Map<String, dynamic>.from(userData));
          }
          
          // If no valid structure found
          print('⚠️ Unexpected response structure: ${userData.runtimeType}');
          if (userData is Map) {
            print('📄 Available keys: ${userData.keys.toList()}');
          }
          throw Exception('Unexpected response format - no PartyList found');
        } catch (e) {
          print('❌ JSON Parse Error: $e');
          print('📄 Raw Response Body: $responseBody');
          throw Exception('Failed to parse party list response: $e');
        }
      } else {
        print('❌ HTTP Error: ${response.statusCode}');
        print('📄 Error Response: ${response.data}');
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ CRITICAL ERROR in getPartyList: $e');
      if (e is DioException) {
        print('🌐 DioException Type: ${e.type}');
        print('🌐 DioException Message: ${e.message}');
        if (e.response != null) {
          print('🌐 Response Status: ${e.response?.statusCode}');
          print('🌐 Response Data: ${e.response?.data}');
        }
      }
      rethrow;
    }
  }

  Future<bool> addNewParty(Map<String, dynamic> partyData) async {
    try {
      final payload = {
        'title': 'UpdateAccountBook',
        'description': 'Request For Party Display List',
        'ReqJSonData': json.encode([partyData]),
      };

      print('🌐 === ADD PARTY API DEBUG ===');
      print('📍 URL: $webServiceUrl');
      print('📤 Payload: ${json.encode(payload)}');

      final response = await _dio.post(
        webServiceUrl,
        data: payload,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
          receiveTimeout: Duration(milliseconds: 30000),
          sendTimeout: Duration(milliseconds: 30000),
        ),
      );

      print('📥 Add Party Response Status: ${response.statusCode}');
      print('📄 Add Party Response: ${response.data}');

      if (response.statusCode == 200) {
        final responseBody = response.data.toString();
        return responseBody.contains('||JasonEnd');
      } else {
        throw Exception('Failed to add party: HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error adding party: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getPartyTemplate() async {
    try {
      final payload = {
        'title': 'GetPartyMasterByCode',
        'description': 'Request For Party Display List',
        'ReqPartyCode': '0',
      };

      print('🌐 === GET PARTY TEMPLATE API DEBUG ===');
      print('📍 URL: $webServiceUrl');
      print('📤 Payload: ${json.encode(payload)}');

      final response = await _dio.post(
        webServiceUrl,
        data: payload,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
          receiveTimeout: Duration(milliseconds: 30000),
          sendTimeout: Duration(milliseconds: 30000),
        ),
      );

      print('📥 Party Template Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        String responseBody = response.data.toString();
        print('📄 Party Template Response Length: ${responseBody.length}');
        
        final endMarkerPos = responseBody.indexOf('||JasonEnd');
        if (endMarkerPos != -1) {
          responseBody = responseBody.substring(0, endMarkerPos);
        }
        
        final responseData = json.decode(responseBody);
        print('✅ Party Template Parsed Successfully');
        return responseData as Map<String, dynamic>;
      } else {
        throw Exception('Failed to get party template: HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error getting party template: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getPartyPaymentDetails({
    required String accName,
    required int accCode,
    String fromDate = '',
    String toDate = '',
  }) async {
    try {
      print('🔐 === ENSURING SESSION FOR PAYMENT DETAILS ===');
      
      // First, ensure we have a valid session by calling the Party List API
      // This is important because the server requires an active session
      try {
        print('🔄 Calling Party List API first to establish session...');
        await getPartyList(); // This establishes the session
        print('✅ Session established successfully');
      } catch (sessionError) {
        print('⚠️ Session establishment failed, but continuing: $sessionError');
        // Continue anyway, maybe the session is already valid
      }
      
      final year = DateTime.now().year.toString();
      
      // Create payload exactly like React implementation
      final payload = {
        'title': 'GetPartyPaymentDetails',
        'description': '',
        'ReqYear': year,
        'ReqAccName': accName,
        'ReqAccCode': accCode,
        'ReqFDate': fromDate,
        'ReqToDate': toDate,
      };

      print('🌐 === GET PARTY PAYMENT DETAILS API DEBUG ===');
      print('📍 URL: $webServiceUrl');
      print('📤 Payload: ${json.encode(payload)}');
      print('🧾 Party Details: $accName (Code: $accCode)');

      // Use the same approach as the working Party List API (FormData)
      final formData = FormData.fromMap(payload);
      
      final response = await _dio.post(
        webServiceUrl,
        data: formData, // Use FormData like the working Party List API
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Accept': 'application/json',
          },
          followRedirects: false,
          validateStatus: (status) => status! < 500,
          receiveTimeout: Duration(milliseconds: 30000),
          sendTimeout: Duration(milliseconds: 30000),
        ),
      );

      print('📥 Payment Details Response Status: ${response.statusCode}');
      print('📥 Payment Details Response Headers: ${response.headers}');

      if (response.statusCode == 200) {
        String responseBody = response.data.toString();
        print('📄 Payment Details Response Length: ${responseBody.length}');
        print('📄 Payment Details Response (first 1000 chars): ${responseBody.length > 1000 ? responseBody.substring(0, 1000) + "..." : responseBody}');
        
        // Check if response is HTML (authentication error)
        if (responseBody.trim().toLowerCase().startsWith('<!doctype html') || 
            responseBody.trim().toLowerCase().startsWith('<html')) {
          print('❌ Still receiving HTML response - session issue persists');
          throw Exception('Authentication session issue: Server returned HTML login page instead of JSON data');
        }
        
        final endMarkerPos = responseBody.indexOf('||JasonEnd');
        if (endMarkerPos != -1) {
          print('✂️ Found JasonEnd marker, trimming response');
          responseBody = responseBody.substring(0, endMarkerPos);
        }
        
        try {
          final responseData = json.decode(responseBody);
          print('✅ Payment Details Parsed Successfully');
          print('📊 Response Type: ${responseData.runtimeType}');
          if (responseData is List) {
            print('📊 Number of records: ${responseData.length}');
          }
          return List<Map<String, dynamic>>.from(responseData);
        } catch (jsonError) {
          print('❌ JSON Parse Error: $jsonError');
          print('📄 Raw Response for debugging: $responseBody');
          throw Exception('Failed to parse payment details response: $jsonError');
        }
      } else if (response.statusCode == 302) {
        print('❌ 302 Redirect - authentication session expired or invalid');
        throw Exception('Session expired: Server returned 302 redirect to login page');
      } else {
        print('❌ HTTP Error: ${response.statusCode}');
        print('📄 Error Response: ${response.data}');
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error getting payment details: $e');
      rethrow;
    }
  }
}
