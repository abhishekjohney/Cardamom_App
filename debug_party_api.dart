import 'dart:convert';
import 'package:dio/dio.dart';

void main() async {
  print('🌐 === DEBUGGING PARTY LIST API ===');
  
  final dio = Dio();
  const String webServiceUrl = 'https://cardamombe.magnussoftech.in/WebDataProcessingReact.aspx';
  
  // Create payload exactly like React implementation
  final payload = {
    'title': 'GetPartyNBalanceList',
    'description': 'Request Bill By Code',
    'ReqType': '1',
    'ReqNofRcds': '',
    'ReqAcaStart': DateTime.now().year.toString(),
    'ReqGroups': 'Sundry Creditors',
    'ReqCodes': '',
    'ReqByrName': '',
    'ReqRoute': '',
  };

  print('📍 API URL: $webServiceUrl');
  print('📤 PAYLOAD:');
  print(json.encode(payload, null: 2));
  
  try {
    // Try FormData approach
    print('\n🔄 Trying FormData approach...');
    final formData = FormData.fromMap(payload);
    
    final response = await dio.post(
      webServiceUrl,
      data: formData,
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

    print('📥 RESPONSE STATUS: ${response.statusCode}');
    print('📥 RESPONSE HEADERS:');
    response.headers.forEach((key, value) {
      print('  $key: $value');
    });
    
    String responseBody = response.data.toString();
    print('📄 RESPONSE BODY LENGTH: ${responseBody.length}');
    print('📄 RESPONSE BODY (first 1000 chars):');
    print(responseBody.length > 1000 ? responseBody.substring(0, 1000) + '...' : responseBody);
    
    // Check if it's JSON
    try {
      final jsonData = json.decode(responseBody);
      print('✅ Valid JSON response');
      print('📊 JSON Keys: ${jsonData is Map ? jsonData.keys.toList() : 'Not a map'}');
    } catch (e) {
      print('❌ Not valid JSON: $e');
    }

  } catch (e) {
    print('❌ ERROR: $e');
    if (e is DioException) {
      print('🌐 DioException Type: ${e.type}');
      print('🌐 DioException Message: ${e.message}');
      if (e.response != null) {
        print('🌐 Response Status: ${e.response?.statusCode}');
        print('🌐 Response Data: ${e.response?.data}');
      }
    }
  }
  
  // Also try JSON approach
  print('\n🔄 Trying JSON approach...');
  try {
    final response = await dio.post(
      webServiceUrl,
      data: payload,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        followRedirects: false,
        validateStatus: (status) => status! < 500,
        receiveTimeout: Duration(milliseconds: 30000),
        sendTimeout: Duration(milliseconds: 30000),
      ),
    );

    print('📥 JSON RESPONSE STATUS: ${response.statusCode}');
    String responseBody = response.data.toString();
    print('📄 JSON RESPONSE BODY LENGTH: ${responseBody.length}');
    print('📄 JSON RESPONSE BODY (first 1000 chars):');
    print(responseBody.length > 1000 ? responseBody.substring(0, 1000) + '...' : responseBody);
    
  } catch (e) {
    print('❌ JSON ERROR: $e');
  }
}
