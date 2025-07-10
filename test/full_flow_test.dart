import 'package:flutter_test/flutter_test.dart';
import 'package:shopapp/services/api_service.dart';
import 'package:shopapp/services/party_list_service.dart';

/// A simplified test for API connectivity
void main() {
  // Define variables
  late ApiService apiService;

  setUp(() {
    // Initialize services
    apiService = ApiService();
  });

  group('API Connectivity Tests', () {    
    test('Party List Service - Get Party List', () async {
      // This test verifies that the party list service can connect to the API
      try {
        final partyListService = PartyListService();
        final response = await partyListService.getPartyList();
        
        // Just verify we got a response - we don't care about the structure here
        expect(response, isNotNull);
        print('✅ Successfully connected to party list API');
      } catch (e) {
        fail('❌ Party list API connection failed: $e');
      }
    });
    
    test('API Service Connectivity', () async {
      // This test simply verifies that the API service instance exists
      expect(apiService, isNotNull);
      print('✅ API Service instance created successfully');
      
      // Try to access a static property that should exist
      expect(ApiService.baseUrl, isNotNull);
      print('✅ API Service has baseUrl property');
    });
  });
}
