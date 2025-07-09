import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';

class ApiEndpoints {
  static String get baseUrl => AppConfig.baseUrl;
  static String get webServiceReact => AppConfig.webServiceReact;
  static String get imageBaseUrl => AppConfig.imageBaseUrl;
  static String get catalogImageUrl => AppConfig.catalogImageUrl;
  
  // Legacy URLs (kept for backward compatibility)
  static const String authUrl = 'https://shopapk.cypherinfosolution.com/';
  static const String cardamomApi = 'http://nwbo1.jubilyhrm.in/api/WebServiceCardamom.aspx';
  
  // Encryption settings
  static bool get isEncrypted => AppConfig.isEncrypted;
  static String get encryptMode => AppConfig.encryptMode;
}

class AuthenticationService {
  static final Dio _dio = Dio();

  static Future<Map<String, dynamic>> authenticateUser(String username, String password) async {
    try {
      print("🔐 Starting authentication for user: $username");
      print("🌐 Using endpoint: https://cardamombe.magnussoftech.in/api/WebServiceCardamom.aspx");
      
      // Prepare credentials exactly like your Next.js app's successful login
      String processedPassword = password;
      
      // Apply Base64 encoding if encryption is enabled (currently false)
      if (ApiEndpoints.isEncrypted && ApiEndpoints.encryptMode == "B64") {
        processedPassword = base64.encode(utf8.encode(password));
        print("🔒 Password encrypted with Base64");
      }
      
      // Generate location data exactly like Next.js app
      final currentDate = DateTime.now();
      final dateStr = "${currentDate.day.toString().padLeft(2, '0')}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.year}";
      final timeStr = "${currentDate.hour.toString().padLeft(2, '0')}:${currentDate.minute.toString().padLeft(2, '0')}:${currentDate.second.toString().padLeft(2, '0')}";
      
      final locationData = json.encode([{
        "LocationString": "Location not allowed",
        "LocLatLong": "NA",
        "AccAutoID": 0,
        "LocPlace": "NA",
        "AprUser": username,
        "CDateStr": dateStr,
        "EntLocID": "0",
        "Module": "LOGIN",
        "Reason": "",
        "Remarks": timeStr
      }]);
      
      print("📍 Location data: $locationData");
      
      // Create FormData with EXACT format from successful Next.js login
      final FormData formData = FormData.fromMap({
        'title': 'UserLogin',
        'description': 'Request Login',
        'ReqUserID': username,
        'ReqPassWord': processedPassword,
        'ReqLocJason': locationData,
        'ReqAcastart': '2024'
      });
      
      print("📤 FormData created with keys: ${formData.fields.map((e) => e.key).join(', ')}");
      
      // Use the Cardamom API URL for login instead of the React service URL
      const String loginApiUrl = 'https://cardamombe.magnussoftech.in/api/WebServiceCardamom.aspx';
      print("🌐 Making POST request to: $loginApiUrl");
      
      final response = await _dio.post(
        loginApiUrl,
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
          },
          followRedirects: true,
          validateStatus: (status) => status! < 500,
        ),
      );
      
      print("📥 Response status: ${response.statusCode}");
      print("📥 Response headers: ${response.headers}");
      
      if (response.statusCode == 200) {
        String responseBody = response.data.toString();
        print("📥 Raw response: $responseBody");
        
        // Handle the same response format as other APIs in the project
        if (responseBody.contains('||JasonEnd')) {
          responseBody = responseBody.split('||JasonEnd')[0].trim();
          print("📥 Cleaned response: $responseBody");
        }
        
        try {
          final dynamic responseData = json.decode(responseBody);
          print("✅ Parsed JSON response: $responseData");
          
          // Handle the actual API response format: [{"ActionType":0,"InfoField":"1","InfoField1":"Login Successful. Login & Active Record Found","InfoField2":"10","InfoField3":"lamfAmB6kEIsBYwUIzzOrA==","ItemKeyName":"LoginStatus","ItemName":"autovision","RcdID":1,"SLno":0}]
          if (responseData is List && responseData.isNotEmpty) {
            print("📋 Received list response with ${responseData.length} items");
            final firstItem = responseData[0];
            
            if (firstItem is Map<String, dynamic>) {
              // Check for successful login based on API response structure
              final actionType = firstItem['ActionType'];
              final infoField = firstItem['InfoField'];
              final infoField1 = firstItem['InfoField1'];
              final itemKeyName = firstItem['ItemKeyName'];
              final itemName = firstItem['ItemName'];
              final rcdId = firstItem['RcdID'];
              
              print("� Login response details:");
              print("   ActionType: $actionType");
              print("   InfoField: $infoField");
              print("   InfoField1: $infoField1");
              print("   ItemKeyName: $itemKeyName");
              print("   ItemName: $itemName");
              print("   RcdID: $rcdId");
              
              // Check for successful login indicators
              if (itemKeyName == 'LoginStatus' && 
                  (infoField == '1' || infoField == 1)) {
                
                final userData = {
                  'success': true,
                  'message': infoField1 ?? 'Authentication successful',
                  'data': responseData,
                  'user': {
                    'username': itemName ?? username,
                    'userId': rcdId?.toString() ?? '1',
                    'role': 'admin', // Default role, can be enhanced based on API response
                    'name': itemName ?? username,
                    'email': '', // Not provided in this response format
                    'empcode': username,
                    'token': firstItem['InfoField3'], // Store the token if needed
                    'loginInfo': infoField1,
                  }
                };
                print("✅ Login successful: ${userData['user']}");
                return userData;
              } else if (itemKeyName == 'LoginStatus') {
                print("❌ Login failed based on response indicators");
                print("   Expected: InfoField='1' or 1 for success");
                print("   Got: InfoField='$infoField' (${infoField.runtimeType})");
                return {
                  'success': false,
                  'message': infoField1 ?? 'Authentication failed',
                  'data': responseData
                };
              }
            } else {
              print("❌ Invalid response structure: first item is not a map");
              return {
                'success': false,
                'message': 'Invalid response format from server',
                'data': null
              };
            }
          } 
          
          // Fallback: Check for Next.js style response format (for compatibility)
          else if (responseData is Map<String, dynamic> && responseData.containsKey('user')) {
            final userObj = responseData['user'];
            print("👤 Found Next.js style user object: $userObj");
            if (userObj != null && userObj is Map<String, dynamic>) {
              final userData = {
                'success': true,
                'message': 'Authentication successful',
                'data': responseData,
                'user': {
                  'username': userObj['name'] ?? username,
                  'userId': userObj['id']?.toString() ?? '1',
                  'role': userObj['role'] ?? 'admin',
                  'name': userObj['name'] ?? username,
                  'email': userObj['email'] ?? '',
                  'empcode': username,
                }
              };
              print("✅ Login successful (Next.js format): ${userData['user']}");
              return userData;
            } else {
              print("❌ Invalid user object in Next.js response");
              return {
                'success': false,
                'message': 'Invalid user data in response',
                'data': null
              };
            }
          } 
          
          // Another fallback for other response formats
          else if (responseData is Map<String, dynamic>) {
            print("📋 Received map response: $responseData");
            if (responseData.containsKey('success') && responseData['success'] == true) {
              final userData = {
                'success': true,
                'message': responseData['message'] ?? 'Authentication successful',
                'data': responseData['data'] ?? responseData,
                'user': responseData['user'] ?? {
                  'username': username,
                  'role': responseData['role'] ?? 'Employee',
                }
              };
              print("✅ Login successful (map format): ${userData['user']}");
              return userData;
            } else {
              print("❌ Login failed: ${responseData['message'] ?? 'Invalid credentials'}");
              return {
                'success': false,
                'message': responseData['message'] ?? 'Invalid credentials',
                'data': null
              };
            }
          } 
          
          else {
            // Empty array or null response indicates invalid credentials
            print("❌ Login failed: empty or unsupported response format");
            return {
              'success': false,
              'message': 'Invalid credentials - no valid response received',
              'data': null
            };
          }
        } catch (jsonError) {
          // If JSON parsing fails, treat as authentication failure
          print("❌ JSON parsing failed: $jsonError");
          print("📥 Raw response that failed parsing: $responseBody");
          return {
            'success': false,
            'message': 'Invalid response format from server',
            'data': null
          };
        }
      } else {
        print("❌ HTTP Error: ${response.statusCode}");
        return {
          'success': false,
          'message': 'Authentication failed: HTTP ${response.statusCode}',
          'data': null
        };
      }
    } catch (e) {
      print("❌ Authentication error: $e");
      return {
        'success': false,
        'message': 'Login error: $e',
        'data': null
      };
    }
    
    // This should never be reached, but added for null safety
    return {
      'success': false,
      'message': 'Unexpected error: method completed without returning',
      'data': null
    };
  }
}

class SessionManager {
  static const String _keyIsLoggedIn = 'isLoggedIn';
  static const String _keyUsername = 'username';
  static const String _keyUserData = 'userData';
  static const String _keyLoginTime = 'loginTime';
  static const String _keyRememberMe = 'rememberMe';
  static const String _keyRole = 'role';
  static const String _keyUserId = 'userId';
  static const String _keyEmpCode = 'empcode';
  static const String _keyEmployeeName = 'employeeName';
  
  // Session timeout in hours
  static int get sessionTimeoutHours => AppConfig.sessionTimeoutHours;

  static Future<void> saveSession(Map<String, dynamic> userData, {bool rememberMe = false}) async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyUsername, userData['username'] ?? '');
    await prefs.setString(_keyUserData, json.encode(userData));
    await prefs.setString(_keyLoginTime, DateTime.now().toIso8601String());
    await prefs.setBool(_keyRememberMe, rememberMe);
    await prefs.setString(_keyRole, userData['role'] ?? 'Employee');
    await prefs.setString(_keyUserId, userData['userId']?.toString() ?? '');
    await prefs.setString(_keyEmpCode, userData['empcode'] ?? '');
    await prefs.setString(_keyEmployeeName, userData['name'] ?? '');
  }

  static Future<bool> isSessionValid() async {
    final prefs = await SharedPreferences.getInstance();
    
    final isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;
    if (!isLoggedIn) return false;
    
    final loginTimeStr = prefs.getString(_keyLoginTime);
    if (loginTimeStr == null) return false;
    
    final loginTime = DateTime.parse(loginTimeStr);
    final currentTime = DateTime.now();
    final difference = currentTime.difference(loginTime);
    
    // Check if session has expired
    if (difference.inHours >= sessionTimeoutHours) {
      await clearSession();
      return false;
    }
    
    return true;
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataStr = prefs.getString(_keyUserData);
    
    if (userDataStr != null) {
      try {
        return json.decode(userDataStr);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername) ?? '';
  }

  static Future<String> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRole) ?? 'Employee';
  }

  static Future<bool> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyRememberMe) ?? false;
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyUsername);
    await prefs.remove(_keyUserData);
    await prefs.remove(_keyLoginTime);
    await prefs.remove(_keyRole);
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyEmpCode);
    await prefs.remove(_keyEmployeeName);
    // Keep rememberMe preference for future logins
  }

  static Future<void> logout() async {
    await clearSession();
  }
}

class PartyService {
  static final Dio _dio = Dio();

  static void _configureDio() {
    _dio.options.connectTimeout = Duration(milliseconds: AppConfig.connectTimeout);
    _dio.options.receiveTimeout = Duration(milliseconds: AppConfig.receiveTimeout);
    _dio.options.sendTimeout = Duration(milliseconds: AppConfig.sendTimeout);
    
    if (AppConfig.enableLogging) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: AppConfig.enableDebugMode,
        responseBody: AppConfig.enableDebugMode,
        logPrint: (o) => print(o),
      ));
    }
  }

  static Future<Map<String, dynamic>> fetchPartyList() async {
    _configureDio();
    
    try {
      if (AppConfig.enableLogging) {
        print('📋 Fetching party list from API...');
      }

      // Create FormData for party list API
      final FormData formData = FormData.fromMap({
        'tblname': 'partymaster',
        'columnname': 'partycode',
        'partycode': '',  // Empty to get all parties
        'methodname': 'select'
      });
      
      final response = await _dio.post(
        ApiEndpoints.webServiceReact,
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'User-Agent': '${AppConfig.appName}/${AppConfig.appVersion}',
          },
          followRedirects: true,
          validateStatus: (status) => status! < 500,
        ),
      );
      
      if (response.statusCode == 200) {
        String responseBody = response.data.toString();
        
        // Handle response format
        if (responseBody.contains('||JasonEnd')) {
          responseBody = responseBody.split('||JasonEnd')[0].trim();
        }
        
        try {
          final dynamic responseData = json.decode(responseBody);
          
          if (responseData is List) {
            if (AppConfig.enableLogging) {
              print('✅ Party list fetched successfully: ${responseData.length} parties');
            }
            return {
              'success': true,
              'message': 'Party list fetched successfully',
              'data': responseData,
              'count': responseData.length
            };
          } else {
            if (AppConfig.enableLogging) {
              print('❌ Invalid party list response format');
            }
            return {
              'success': false,
              'message': 'Invalid party list response format',
              'data': []
            };
          }
        } catch (jsonError) {
          if (AppConfig.enableLogging) {
            print('❌ Error parsing party list response: $jsonError');
          }
          return {
            'success': false,
            'message': 'Error parsing party list response',
            'data': []
          };
        }
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.statusMessage}');
      }
    } on DioException catch (dioError) {
      String errorMessage = 'Network error occurred while fetching party list';
      
      switch (dioError.type) {
        case DioExceptionType.connectionTimeout:
          errorMessage = 'Connection timeout while fetching party list';
          break;
        case DioExceptionType.receiveTimeout:
          errorMessage = 'Response timeout while fetching party list';
          break;
        case DioExceptionType.connectionError:
          errorMessage = 'Connection error while fetching party list';
          break;
        default:
          errorMessage = 'Network error fetching party list: ${dioError.message}';
      }
      
      if (AppConfig.enableLogging) {
        print('🔴 Party list fetch error: $errorMessage');
      }
      
      return {
        'success': false,
        'message': errorMessage,
        'data': []
      };
    } catch (e) {
      if (AppConfig.enableLogging) {
        print('🔴 Unexpected error fetching party list: $e');
      }
      return {
        'success': false,
        'message': 'Network error fetching party list: $e',
        'data': []
      };
    }
  }

  static Future<void> cachePartyList(List<dynamic> partyList) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cachedPartyList', json.encode(partyList));
      await prefs.setString('partyListCacheTime', DateTime.now().toIso8601String());
      
      if (AppConfig.enableLogging) {
        print('💾 Party list cached successfully: ${partyList.length} parties');
      }
    } catch (e) {
      if (AppConfig.enableLogging) {
        print('❌ Error caching party list: $e');
      }
    }
  }

  static Future<List<dynamic>?> getCachedPartyList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('cachedPartyList');
      final cacheTimeStr = prefs.getString('partyListCacheTime');
      
      if (cachedData != null && cacheTimeStr != null) {
        final cacheTime = DateTime.parse(cacheTimeStr);
        final currentTime = DateTime.now();
        
        // Cache valid for configured hours
        if (currentTime.difference(cacheTime).inHours < AppConfig.partyCacheTimeoutHours) {
          try {
            final List<dynamic> cachedList = json.decode(cachedData);
            if (AppConfig.enableLogging) {
              print('📋 Using cached party list: ${cachedList.length} parties');
            }
            return cachedList;
          } catch (e) {
            if (AppConfig.enableLogging) {
              print('❌ Error parsing cached party list: $e');
            }
            return null;
          }
        } else {
          if (AppConfig.enableLogging) {
            print('⏰ Party list cache expired');
          }
        }
      }
      return null;
    } catch (e) {
      if (AppConfig.enableLogging) {
        print('❌ Error getting cached party list: $e');
      }
      return null;
    }
  }

  static Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('cachedPartyList');
      await prefs.remove('partyListCacheTime');
      
      if (AppConfig.enableLogging) {
        print('🗑️ Party list cache cleared');
      }
    } catch (e) {
      if (AppConfig.enableLogging) {
        print('❌ Error clearing party list cache: $e');
      }
    }
  }
}
