import 'dart:io';
import 'package:flutter/material.dart';
import 'lib/services/party_list_service.dart';
import 'lib/model/party_list_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('🧪 Testing Party List API...');
  
  try {
    final service = PartyListService();
    
    print('📞 Calling getPartyList with Sundry Debtors...');
    final response = await service.getPartyList(groups: 'Sundry Debtors');
    
    print('✅ Success! Got ${response.partyList.length} parties');
    
    if (response.partyList.isNotEmpty) {
      final firstParty = response.partyList.first;
      print('📋 First party details:');
      print('   - Name: ${firstParty.byrNam}');
      print('   - Code: ${firstParty.byrCd}');
      print('   - ID: ${firstParty.accAutoID}');
      print('   - Balance: ${firstParty.balance}');
      print('   - Color: ${firstParty.balColor}');
      print('   - Group: ${firstParty.groups}');
      print('   - Address: ${firstParty.fullAddress}');
    }
    
    print('🎉 API test completed successfully!');
    
  } catch (e) {
    print('❌ API test failed: $e');
  }
  
  exit(0);
}
