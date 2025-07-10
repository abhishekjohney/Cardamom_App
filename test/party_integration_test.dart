import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopapp/models/party.dart';
import 'package:shopapp/services/api_service.dart';
import 'package:shopapp/services/party_list_service.dart';
import 'package:shopapp/controllers/party_list_controller.dart';

void main() {
  // This is an end-to-end test script to verify the Party List functionality

  group('Party API Integration Tests', () {
    final apiService = ApiService();
    final partyListService = PartyListService();
    
    test('Session Management - Get Party List', () async {
      // Test session establishment through party list
      try {
        final response = await partyListService.getPartyList();
        expect(response.parties, isNotNull);
        expect(response.parties.isNotEmpty, true);
        print('✅ Successfully fetched ${response.parties.length} parties');
      } catch (e) {
        fail('❌ API connection failed: $e');
      }
    });
    
    test('Get Party Template', () async {
      // Test getting a blank party template
      try {
        final template = await apiService.getBlankPartyTemplate();
        expect(template, isNotNull);
        expect(template.partyCode, '');
        print('✅ Successfully fetched party template');
      } catch (e) {
        fail('❌ Failed to get party template: $e');
      }
    });
    
    test('Session Maintenance and Party Payment Details', () async {
      // Test that session is maintained across calls
      try {
        // First establish session with party list
        final parties = await partyListService.getPartyList();
        expect(parties.parties.isNotEmpty, true);
        
        if (parties.parties.isNotEmpty) {
          final partyCode = parties.parties[0].partyCode;
          
          // Now get payment details for the first party
          final paymentDetails = await partyListService.getPartyPaymentDetails(partyCode);
          expect(paymentDetails, isNotNull);
          print('✅ Successfully fetched payment details for party $partyCode');
        }
      } catch (e) {
        fail('❌ Session maintenance test failed: $e');
      }
    });
    
    test('Add Party Modal Form Test', () async {
      // This test would normally require widget testing with a test harness
      // Here we're just testing the underlying API logic
      
      // Get a template first
      final template = await apiService.getBlankPartyTemplate();
      
      // Create a test party from the template
      final testParty = Party(
        partyCode: 'TEST${DateTime.now().millisecondsSinceEpoch}',
        partyName: 'Test Party ${DateTime.now().day}-${DateTime.now().hour}:${DateTime.now().minute}',
        contactPerson: 'Test Contact',
        phoneNumber: '9876543210',
        address: 'Test Address',
        city: 'Test City',
        pinCode: '123456'
      );
      
      try {
        // Try to add the party
        final result = await apiService.addParty(testParty);
        expect(result['success'], isTrue);
        print('✅ Successfully added test party: ${testParty.partyName}');
      } catch (e) {
        fail('❌ Add party test failed: $e');
      }
    });
  });
}
