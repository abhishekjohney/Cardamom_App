import 'dart:convert';
import 'package:dio/dio.dart';

/// A simple API debugger utility to help diagnose response format issues
class ApiDebugger {
  static const String baseUrl = 'http://nwbo1.jubilyhrm.in/api/WebServiceCardamom.aspx';
  
  static Future<void> debugCardamomReceiptListApi() async {
    final dio = Dio();
    
    print("🧪 === API DEBUGGER FOR CARDAMOM RECEIPT LIST ===");
    print("🌐 Base URL: $baseUrl");
    
    try {
      // Prepare test data
      final formData = FormData.fromMap({
        'title': 'GetGreenCardamomReceiptList',
        'description': '',
        'Reqdate1': '01-06-2025',
        'Reqdate2': '01-06-2025',
        'Reqparty': '',
        'ReqRefNo': '',
      });
      
      print("\n📤 REQUEST DETAILS:");
      print("   Method: POST");
      print("   Content-Type: multipart/form-data");
      print("   FormData fields:");
      for (var field in formData.fields) {
        print("     ${field.key}: ${field.value}");
      }
      
      // Make the request
      print("\n🔄 Making API request...");
      
      final stopwatch = Stopwatch()..start();
      final response = await dio.post(
        baseUrl,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Accept': 'application/json',
          },
          followRedirects: true,
          validateStatus: (status) => true,
        ),
      );
      stopwatch.stop();
      
      print("\n📥 RESPONSE DETAILS:");
      print("   Status Code: ${response.statusCode}");
      print("   Status Message: ${response.statusMessage ?? 'None'}");
      print("   Response Time: ${stopwatch.elapsedMilliseconds}ms");
      print("   Data Type: ${response.data.runtimeType}");
      
      if (response.headers.map.isNotEmpty) {
        print("   Response Headers:");
        response.headers.forEach((key, values) {
          print("     $key: ${values.join(', ')}");
        });
      }
      
      // Analyze response data
      if (response.data != null) {
        String responseStr = response.data.toString();
        
        print("\n📄 RESPONSE CONTENT ANALYSIS:");
        print("   Raw Length: ${responseStr.length} characters");
        print("   Starts with: '${responseStr.length > 50 ? responseStr.substring(0, 50) : responseStr}${responseStr.length > 50 ? '...' : ''}'");
        print("   Ends with: '${responseStr.length > 50 ? '...' + responseStr.substring(responseStr.length - 50) : responseStr}'");
        
        // Check for common patterns
        bool hasJasonEnd = responseStr.contains('||JasonEnd');
        bool hasJSONData1 = responseStr.contains('JSONData1');
        bool startsWithArray = responseStr.trim().startsWith('[');
        bool startsWithObject = responseStr.trim().startsWith('{');
        bool containsHTML = responseStr.toLowerCase().contains('<html');
        bool containsError = responseStr.toLowerCase().contains('error');
        
        print("\n🔍 PATTERN ANALYSIS:");
        print("   Contains ||JasonEnd: $hasJasonEnd");
        print("   Contains JSONData1: $hasJSONData1");
        print("   Starts with '[': $startsWithArray");
        print("   Starts with '{': $startsWithObject");
        print("   Contains HTML: $containsHTML");
        print("   Contains 'error': $containsError");
        
        // Try parsing if it looks like JSON
        if (hasJasonEnd) {
          print("\n🔧 PARSING ||JasonEnd FORMAT:");
          int endIndex = responseStr.indexOf("||JasonEnd");
          String cleanJson = responseStr.substring(0, endIndex);
          print("   Clean JSON length: ${cleanJson.length}");
          print("   Clean JSON preview: ${cleanJson.length > 200 ? cleanJson.substring(0, 200) + '...' : cleanJson}");
          
          try {
            final parsed = json.decode(cleanJson);
            print("   ✅ JSON parsing successful!");
            print("   Parsed type: ${parsed.runtimeType}");
            
            if (parsed is List) {
              print("   Array with ${parsed.length} items");
              if (parsed.isNotEmpty) {
                print("   First item type: ${parsed[0].runtimeType}");
                if (parsed[0] is Map) {
                  print("   First item keys: ${(parsed[0] as Map).keys.toList()}");
                  
                  if ((parsed[0] as Map).containsKey('JSONData1')) {
                    print("   Found JSONData1 field!");
                    try {
                      final nestedData = json.decode(parsed[0]['JSONData1']);
                      print("   ✅ Nested JSON parsing successful!");
                      print("   Nested type: ${nestedData.runtimeType}");
                      if (nestedData is List) {
                        print("   Nested array with ${nestedData.length} items");
                      }
                    } catch (e) {
                      print("   ❌ Failed to parse JSONData1: $e");
                    }
                  }
                }
              }
            } else if (parsed is Map) {
              print("   Object with keys: ${parsed.keys.toList()}");
            }
          } catch (e) {
            print("   ❌ JSON parsing failed: $e");
          }
        } else if (startsWithArray || startsWithObject) {
          print("\n🔧 PARSING DIRECT JSON:");
          try {
            final parsed = json.decode(responseStr);
            print("   ✅ Direct JSON parsing successful!");
            print("   Type: ${parsed.runtimeType}");
            
            if (parsed is List) {
              print("   Array with ${parsed.length} items");
            } else if (parsed is Map) {
              print("   Object with keys: ${parsed.keys.toList()}");
            }
          } catch (e) {
            print("   ❌ Direct JSON parsing failed: $e");
          }
        }
        
        // Show full response if it's short
        if (responseStr.length <= 1000) {
          print("\n📄 FULL RESPONSE:");
          print(responseStr);
        } else {
          print("\n📄 RESPONSE TOO LONG TO DISPLAY (${responseStr.length} chars)");
          print("   First 500 characters:");
          print(responseStr.substring(0, 500));
          print("   ...");
          print("   Last 500 characters:");
          print(responseStr.substring(responseStr.length - 500));
        }
      }
      
      print("\n✅ Debug analysis completed!");
      
    } catch (e) {
      print("\n❌ ERROR DURING DEBUG:");
      print("   Error type: ${e.runtimeType}");
      print("   Error message: $e");
      
      if (e is DioException) {
        print("   Dio error type: ${e.type}");
        print("   Dio error message: ${e.message}");
        if (e.response != null) {
          print("   Error response status: ${e.response!.statusCode}");
          print("   Error response data: ${e.response!.data}");
        }
      }
    }
    
    print("\n🧪 === END API DEBUGGER ===");
  }
}
