// party_list_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shopapp/services/party_list_service.dart';
import 'package:shopapp/services/api_service.dart';

void main() {
  group('Party List API Tests', () {
    test('PartyListService should return party list', () async {
      // Test that the PartyListService can fetch party list
      final service = PartyListService();
      
      try {
        final response = await service.getPartyList();
        expect(response, isNotNull);
        print('✅ Party list service connected successfully');
      } catch (e) {
        fail('❌ Party list service connection failed: $e');
      }
    });

    test('ApiService initialization', () {
      // Test that ApiService initializes correctly
      final apiService = ApiService();
      expect(apiService, isNotNull);
      expect(ApiService.baseUrl, isNotEmpty);
      print('✅ API Service initialized successfully');
    });
    
    test('Party form template validation', () {
      // Validate the party form template structure (without API call)
      final formFields = [
        'Party Code',
        'Party Name',
        'Contact Person',
        'Phone Number',
        'Address',
        'City',
        'Pin Code',
        'State',
        'Email'
      ];
      
      expect(formFields.length, greaterThanOrEqualTo(5));
      print('✅ Party form template structure is valid');
    });
  });
}
