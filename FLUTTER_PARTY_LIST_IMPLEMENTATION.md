# Flutter Android Party List Implementation

This guide covers the implementation of a Party List feature with "Add New" functionality in a Flutter Android app that interacts with the updated Cardamom backend.

## Overview

The Party List feature displays existing parties (customers/suppliers) and provides the ability to add new parties through a floating action button. This implementation uses the updated API endpoint for party management.

## API Endpoints

### Base URL
```
https://cardamombe.magnussoftech.in/api/WebServiceAccounts.aspx
```

### 1. Get Party List

**Endpoint:** `POST https://cardamombe.magnussoftech.in/api/WebServiceAccounts.aspx`

**Content-Type:** `multipart/form-data`

**Payload:**
```json
{
  "title": "GetPartyNBalanceList",
  "description": "Request For Party List",
  "ReqPartyCode": "" // Optional filter by party code
}
```

**Response Format:**
```json
[
  {
    "AccAutoID": 123,
    "Byr_Cd": "001",
    "Byr_nam": "Party Name",
    "CONTACTPERSON": "Contact Person",
    "PhoneNo": "9876543210",
    "AccAddress": "Address Line",
    "AccCity": "City Name",
    "AccState": "State",
    "PinCode": "682022",
    "CLBalance": 1500.00,
    "EMAIL": "email@example.com",
    "EMAIL2": "alternate@example.com",
    "VATNO": "GST12345678",
    "PANNO": "ABCDE1234F",
    "CSTNO": "CST123456",
    "MaxCreditAmount": 50000,
    "MaxCreditDays": 30,
    "GROUPS": "Sundry Debtors",
    "RELID": 0,
    "OrgAutoid": 1,
    "CONTACTTITLE": "Mr",
    "TRANSPORT": "Transport Info",
    "AccAddress1": "Additional Address Line 1",
    "AccAddress2": "Additional Address Line 2"
  },
  // More party entries...
]
```

### 2. Get Party Template (Blank Party Object)

**Endpoint:** `POST https://cardamombe.magnussoftech.in/api/WebServiceAccounts.aspx`

**Content-Type:** `multipart/form-data`

**Payload:**
```json
{
  "title": "GetPartyMasterByCode",
  "description": "Request For Party Display List",
  "ReqPartyCode": "0"
}
```

**Response Format:**
```json
[
  {
    "ACCORGAUTOID": 1,
    "ACCOUNTNO": "",
    "ACCQRYSTR": "",
    "ACTYP": "LED",
    "AccAddress": "",
    "AccAddress1": "",
    "AccAddress2": "",
    "AccAutoID": 0,
    "AccCity": "",
    "AccState": "",
    "AccountLedger": null,
    "ActionType": 1,
    "BALTYPE": 0,
    "Byr_Cd": "",
    "Byr_nam": "",
    "CLBalColor": "",
    "CLBalance": 0,
    "CLIENTPRFIX": "",
    "CLIENTTRANSID": "",
    "CMNT": "",
    "CNTRY1": "",
    "CONTACTPERSON": "",
    "CONTACTTITLE": "",
    "COPBLS": 0,
    "CSTNO": "",
    "CUSTYPE": "",
    "EMAIL": "",
    "EMAIL2": "",
    "FOB1": "",
    "GROUPS": "Sundry Debtors",
    "GRPHANDLE": "",
    "GRPUNDER": "",
    "ISDROPPED": false,
    "ImpCode": 0,
    "LCNO": "",
    "LEDTYPE": "",
    "LTYPE": "",
    "LateBillsAmount": 0,
    "MNGRP": "",
    "MSSB": 0,
    "MaxCreditAmount": 0,
    "MaxCreditDays": 0,
    "NATURE": "",
    "NofLateBills": 0,
    "NofPendingBills": 0,
    "OPBLS": 0,
    "OPCRBLC": 0,
    "OPDRBLC": 0,
    "ORDERBY": "",
    "Old_Byr_nam": "",
    "OrgAutoid": 1,
    "PANNO": "",
    "PLBAL": "",
    "PhoneNo": "",
    "PinCode": "",
    "REFNO1": "0",
    "REFNO2": "",
    "REFNO3": "",
    "RELID": 0,
    "RELTYPE": "",
    "STNO": "",
    "SVRUPDYN": 0,
    "TDSYN": false,
    "TRANSPORT": "",
    "VATNO": "",
    "WORKTYPE": "",
    "pcap": 0,
    "sbgrp": ""
  }
]
```

### 3. Add New Party

**Endpoint:** `POST https://cardamombe.magnussoftech.in/api/WebServiceAccounts.aspx`

**Content-Type:** `multipart/form-data`

**Payload:**
```json
{
  "title": "UpdateAccountBook",
  "description": "Request For Party Creation",
  "ReqJSonData": "[{\"ACCORGAUTOID\":1,\"ACCOUNTNO\":\"\",\"ACCQRYSTR\":\"\",\"ACTYP\":\"LED\",\"AccAddress\":\"Address line\",\"AccAddress1\":\"\",\"AccAddress2\":\"\",\"AccAutoID\":0,\"AccCity\":\"City\",\"AccState\":\"\",\"AccountLedger\":null,\"ActionType\":1,\"BALTYPE\":0,\"Byr_Cd\":\"code\",\"Byr_nam\":\"Party Name\",\"CLBalColor\":\"\",\"CLBalance\":0,\"CLIENTPRFIX\":\"\",\"CLIENTTRANSID\":\"\",\"CMNT\":\"\",\"CNTRY1\":\"\",\"CONTACTPERSON\":\"Contact Person\",\"CONTACTTITLE\":\"\",\"COPBLS\":0,\"CSTNO\":\"\",\"CUSTYPE\":\"\",\"EMAIL\":\"\",\"EMAIL2\":\"\",\"FOB1\":\"\",\"GROUPS\":\"Sundry Debtors\",\"GRPHANDLE\":\"\",\"GRPUNDER\":\"\",\"ISDROPPED\":false,\"ImpCode\":0,\"LCNO\":\"\",\"LEDTYPE\":\"\",\"LTYPE\":\"\",\"LateBillsAmount\":0,\"MNGRP\":\"\",\"MSSB\":0,\"MaxCreditAmount\":0,\"MaxCreditDays\":0,\"NATURE\":\"\",\"NofLateBills\":0,\"NofPendingBills\":0,\"OPBLS\":0,\"OPCRBLC\":0,\"OPDRBLC\":0,\"ORDERBY\":\"\",\"Old_Byr_nam\":\"\",\"OrgAutoid\":1,\"PANNO\":\"\",\"PLBAL\":\"\",\"PhoneNo\":\"Phone number\",\"PinCode\":\"Pin code\",\"REFNO1\":\"0\",\"REFNO2\":\"\",\"REFNO3\":\"\",\"RELID\":0,\"RELTYPE\":\"\",\"STNO\":\"\",\"SVRUPDYN\":0,\"TDSYN\":false,\"TRANSPORT\":\"\",\"VATNO\":\"VAT Number\",\"WORKTYPE\":\"\",\"pcap\":0,\"sbgrp\":\"\"}]"
}
```

**Response Format:**
```json
[
  {
    "ActionType": 1,
    "ErrorCode": "",
    "ErrorMessage": "",
    "SuccessMessage": "Party saved successfully",
    "JSONData1": "",
    // Other response fields...
  }
]
```

## API Endpoints for Party Operations

The following API endpoints are used for party management:

| Operation | Endpoint | Request Parameter | Description |
|-----------|---------|-----------------|-------------|
| List Parties | `/parent/card/CardAPI.aspx` | `title: 'GetPartyList'` | Retrieves the list of parties |
| Get Party Template | `/parent/card/CardAPI.aspx` | `title: 'GetPartyMasterByCode', ReqPartyCode: '0'` | Gets a blank template for new party |
| Get Party Details | `/parent/card/CardAPI.aspx` | `title: 'GetPartyMasterByCode', ReqPartyCode: '{code}'` | Gets details of an existing party |
| Add/Update Party | `/parent/card/CardAPI.aspx` | `title: 'UpdateAccountBook'` | Creates or updates a party |

## Flutter Implementation

### 1. Project Setup

Add the following dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  provider: ^6.0.5
  shared_preferences: ^2.2.0
  flutter_dotenv: ^5.1.0
```

Create a `.env` file in your project root:

```
API_BASE_URL=https://cardamombe.magnussoftech.in/api/WebServiceAccounts.aspx
```

### 2. Create Models

Create `lib/models/party.dart`:

```dart
class Party {
  final int? id;
  final String partyCode;
  final String partyName;
  final String contactPerson;
  final String contactTitle;
  final String phoneNumber;
  final String address;
  final String address1;
  final String address2;
  final String city;
  final String state;
  final String pinCode;
  final double balance;
  final String email;
  final String email2;
  final String vatNo;
  final String panNo;
  final String cstNo;
  final double maxCreditAmount;
  final int maxCreditDays;
  final String groups;
  final int relId;
  final int orgAutoId;
  final String transport;

  Party({
    this.id,
    required this.partyCode,
    required this.partyName,
    this.contactPerson = '',
    this.contactTitle = '',
    this.phoneNumber = '',
    this.address = '',
    this.address1 = '',
    this.address2 = '',
    this.city = '',
    this.state = '',
    this.pinCode = '',
    this.balance = 0.0,
    this.email = '',
    this.email2 = '',
    this.vatNo = '',
    this.panNo = '',
    this.cstNo = '',
    this.maxCreditAmount = 0.0,
    this.maxCreditDays = 0,
    this.groups = 'Sundry Debtors',
    this.relId = 0,
    this.orgAutoId = 1,
    this.transport = '',
  });

  factory Party.fromJson(Map<String, dynamic> json) {
    return Party(
      id: json['AccAutoID'],
      partyCode: json['Byr_Cd'] ?? '',
      partyName: json['Byr_nam'] ?? '',
      contactPerson: json['CONTACTPERSON'] ?? '',
      contactTitle: json['CONTACTTITLE'] ?? '',
      phoneNumber: json['PhoneNo'] ?? '',
      address: json['AccAddress'] ?? '',
      address1: json['AccAddress1'] ?? '',
      address2: json['AccAddress2'] ?? '',
      city: json['AccCity'] ?? '',
      state: json['AccState'] ?? '',
      pinCode: json['PinCode'] ?? '',
      balance: json['CLBalance'] != null 
        ? double.tryParse(json['CLBalance'].toString()) ?? 0.0
        : 0.0,
      email: json['EMAIL'] ?? '',
      email2: json['EMAIL2'] ?? '',
      vatNo: json['VATNO'] ?? '',
      panNo: json['PANNO'] ?? '',
      cstNo: json['CSTNO'] ?? '',
      maxCreditAmount: json['MaxCreditAmount'] != null
        ? double.tryParse(json['MaxCreditAmount'].toString()) ?? 0.0
        : 0.0,
      maxCreditDays: json['MaxCreditDays'] != null
        ? int.tryParse(json['MaxCreditDays'].toString()) ?? 0
        : 0,
      groups: json['GROUPS'] ?? 'Sundry Debtors',
      relId: json['RELID'] != null
        ? int.tryParse(json['RELID'].toString()) ?? 0
        : 0,
      orgAutoId: json['OrgAutoid'] != null
        ? int.tryParse(json['OrgAutoid'].toString()) ?? 1
        : 1,
      transport: json['TRANSPORT'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ACCORGAUTOID": orgAutoId,
      "ACCOUNTNO": "",
      "ACCQRYSTR": "",
      "ACTYP": "LED",
      "AccAddress": address,
      "AccAddress1": address1,
      "AccAddress2": address2,
      "AccAutoID": id ?? 0,
      "AccCity": city,
      "AccState": state,
      "AccountLedger": null,
      "ActionType": 1,
      "BALTYPE": 0,
      "Byr_Cd": partyCode,
      "Byr_nam": partyName,
      "CLBalColor": "",
      "CLBalance": balance,
      "CLIENTPRFIX": "",
      "CLIENTTRANSID": "",
      "CMNT": "",
      "CNTRY1": "",
      "CONTACTPERSON": contactPerson,
      "CONTACTTITLE": contactTitle,
      "COPBLS": 0,
      "CSTNO": cstNo,
      "CUSTYPE": "",
      "EMAIL": email,
      "EMAIL2": email2,
      "FOB1": "",
      "GROUPS": groups,
      "GRPHANDLE": "",
      "GRPUNDER": "",
      "ISDROPPED": false,
      "ImpCode": 0,
      "LCNO": "",
      "LEDTYPE": "",
      "LTYPE": "",
      "LateBillsAmount": 0,
      "MNGRP": "",
      "MSSB": 0,
      "MaxCreditAmount": maxCreditAmount,
      "MaxCreditDays": maxCreditDays,
      "NATURE": "",
      "NofLateBills": 0,
      "NofPendingBills": 0,
      "OPBLS": 0,
      "OPCRBLC": 0,
      "OPDRBLC": 0,
      "ORDERBY": "",
      "Old_Byr_nam": "",
      "OrgAutoid": orgAutoId,
      "PANNO": panNo,
      "PLBAL": "",
      "PhoneNo": phoneNumber,
      "PinCode": pinCode,
      "REFNO1": "0",
      "REFNO2": "",
      "REFNO3": "",
      "RELID": relId,
      "RELTYPE": "",
      "STNO": "",
      "SVRUPDYN": 0,
      "TDSYN": false,
      "TRANSPORT": transport,
      "VATNO": vatNo,
      "WORKTYPE": "",
      "pcap": 0,
      "sbgrp": ""
    };
  }
}
```

### 3. API Service

Create `lib/services/api_service.dart`:

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/party.dart';

class ApiService {
  final String baseUrl;
  
  ApiService({String? customUrl}) : 
    baseUrl = customUrl ?? dotenv.env['API_BASE_URL'] ?? 'https://cardamombe.magnussoftech.in/api/WebServiceAccounts.aspx';

  Future<List<Party>> getPartyList() async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
      
      request.fields['title'] = 'GetPartyNBalanceList';
      request.fields['description'] = 'Request For Party List';
      request.fields['ReqPartyCode'] = '';
      
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        final String responseBody = response.body;
        final String cleanedData = responseBody.substring(0, 
          responseBody.indexOf('||JasonEnd') > 0 
            ? responseBody.indexOf('||JasonEnd') 
            : responseBody.length);
            
        final List<dynamic> jsonData = json.decode(cleanedData);
        return jsonData.map((data) => Party.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load parties: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Party> getBlankPartyTemplate() async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
      
      request.fields['title'] = 'GetPartyMasterByCode';
      request.fields['description'] = 'Request For Party Display List';
      request.fields['ReqPartyCode'] = '0';
      
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        final String responseBody = response.body;
        final String cleanedData = responseBody.substring(0, 
          responseBody.indexOf('||JasonEnd') > 0 
            ? responseBody.indexOf('||JasonEnd') 
            : responseBody.length);
            
        final List<dynamic> jsonData = json.decode(cleanedData);
        if (jsonData.isNotEmpty) {
          return Party.fromJson(jsonData[0]);
        } else {
          // Create a default empty party if no template is returned
          return Party(partyCode: '', partyName: '');
        }
      } else {
        throw Exception('Failed to load party template: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error when fetching party template: $e');
    }
  }

  Future<Map<String, dynamic>> addParty(Party party) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
      
      request.fields['title'] = 'UpdateAccountBook';
      request.fields['description'] = 'Request For Party Creation';
      request.fields['ReqJSonData'] = jsonEncode([party.toJson()]);
      
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        final String responseBody = response.body;
        final String cleanedData = responseBody.substring(0, 
          responseBody.indexOf('||JasonEnd') > 0 
            ? responseBody.indexOf('||JasonEnd') 
            : responseBody.length);
            
        final List<dynamic> jsonData = json.decode(cleanedData);
        
        if (jsonData.isNotEmpty) {
          final Map<String, dynamic> result = jsonData[0];
          
          if (result['ErrorCode'] != null && result['ErrorCode'].toString().isNotEmpty) {
            return {
              'success': false,
              'message': result['ErrorMessage'] ?? 'Unknown error occurred',
              'data': null
            };
          } else {
            return {
              'success': true,
              'message': result['SuccessMessage'] ?? 'Party added successfully',
              'data': result
            };
          }
        } else {
          return {
            'success': false,
            'message': 'Empty response received',
            'data': null
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
          'data': null
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
        'data': null
      };
    }
  }
}
```

### 4. Party List Screen

Create `lib/screens/party_list_screen.dart`:

```dart
import 'package:flutter/material.dart';
import '../models/party.dart';
import '../services/api_service.dart';
import 'add_party_screen.dart';

class PartyListScreen extends StatefulWidget {
  @override
  _PartyListScreenState createState() => _PartyListScreenState();
}

class _PartyListScreenState extends State<PartyListScreen> {
  final ApiService _apiService = ApiService();
  List<Party> _parties = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchParties();
  }

  Future<void> _fetchParties() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final parties = await _apiService.getPartyList();
      setState(() {
        _parties = parties;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Party List'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchParties,
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddParty,
        child: Icon(Icons.add),
        tooltip: 'Add New Party',
      ),
    );
  }

  Future<void> _navigateToAddParty() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPartyScreen()),
    );
    
    if (result == true) {
      _fetchParties();
    }
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48),
            SizedBox(height: 16),
            Text(
              'Error loading parties',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                _errorMessage!,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _fetchParties,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }
    
    if (_parties.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No parties found',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Icon(Icons.add),
              label: Text('Add New Party'),
              onPressed: _navigateToAddParty,
            ),
          ],
        ),
      );
    }
    
    return RefreshIndicator(
      onRefresh: _fetchParties,
      child: ListView.builder(
        itemCount: _parties.length,
        itemBuilder: (context, index) {
          final party = _parties[index];
          return Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(
                  party.partyName.isNotEmpty ? party.partyName[0].toUpperCase() : '?',
                ),
                backgroundColor: Colors.green,
              ),
              title: Text(
                party.partyName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (party.contactPerson.isNotEmpty)
                    Text('Contact: ${party.contactPerson}'),
                  if (party.phoneNumber.isNotEmpty)
                    Text('Phone: ${party.phoneNumber}'),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹ ${party.balance.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: party.balance >= 0 ? Colors.green : Colors.red,
                    ),
                  ),
                  Text(party.partyCode),
                  if (party.maxCreditDays > 0) 
                    Text(
                      'Credit: ${party.maxCreditDays} days',
                      style: TextStyle(fontSize: 11),
                    ),
                ],
              ),
              onTap: () {
                // Navigate to party details (to be implemented)
              },
            );
        },
      );
  }
}
```

### 5. Add Party Screen

Create `lib/screens/add_party_screen.dart`:

```dart
import 'package:flutter/material.dart';
import '../models/party.dart';
import '../services/api_service.dart';

class AddPartyScreen extends StatefulWidget {
  @override
  _AddPartyScreenState createState() => _AddPartyScreenState();
}

class _AddPartyScreenState extends State<AddPartyScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  bool _isProcessing = false;
  bool _isLoadingTemplate = true;

  // Text controllers
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _pinCodeController = TextEditingController();
  final _contactTitleController = TextEditingController();
  final _emailController = TextEditingController();
  final _email2Controller = TextEditingController();
  final _stateController = TextEditingController();
  final _vatNoController = TextEditingController();
  final _panNoController = TextEditingController();
  final _cstNoController = TextEditingController();
  final _maxCreditAmountController = TextEditingController(text: "0");
  final _maxCreditDaysController = TextEditingController(text: "0");
  final _transportController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPartyTemplate();
  }
  
  Future<void> _loadPartyTemplate() async {
    setState(() {
      _isLoadingTemplate = true;
    });
    
    try {
      final Party template = await _apiService.getBlankPartyTemplate();
      
      // Pre-fill form with template values
      _codeController.text = template.partyCode;
      _nameController.text = template.partyName;
      _contactPersonController.text = template.contactPerson;
      _contactTitleController.text = template.contactTitle;
      _phoneController.text = template.phoneNumber;
      _addressController.text = template.address;
      _cityController.text = template.city;
      _stateController.text = template.state;
      _pinCodeController.text = template.pinCode;
      _emailController.text = template.email;
      _email2Controller.text = template.email2;
      _vatNoController.text = template.vatNo;
      _panNoController.text = template.panNo;
      _cstNoController.text = template.cstNo;
      _maxCreditAmountController.text = template.maxCreditAmount.toString();
      _maxCreditDaysController.text = template.maxCreditDays.toString();
      _transportController.text = template.transport;
      
      setState(() {
        _isLoadingTemplate = false;
      });
    } catch (e) {
      print('Error loading template: $e');
      setState(() {
        _isLoadingTemplate = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not load party template: $e'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  Future<void> _saveParty() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isProcessing = true;
    });
    
    final newParty = Party(
      partyCode: _codeController.text,
      partyName: _nameController.text,
      contactPerson: _contactPersonController.text,
      contactTitle: _contactTitleController.text,
      phoneNumber: _phoneController.text,
      address: _addressController.text,
      city: _cityController.text,
      state: _stateController.text,
      pinCode: _pinCodeController.text,
      email: _emailController.text,
      email2: _email2Controller.text,
      vatNo: _vatNoController.text,
      panNo: _panNoController.text,
      cstNo: _cstNoController.text,
      maxCreditAmount: double.tryParse(_maxCreditAmountController.text) ?? 0.0,
      maxCreditDays: int.tryParse(_maxCreditDaysController.text) ?? 0,
      transport: _transportController.text,
    );
    
    try {
      final result = await _apiService.addParty(newParty);
      
      if (!mounted) return;
      
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        
        // Return true to indicate success to the previous screen
        Navigator.pop(context, true);
      } else {
        setState(() {
          _isProcessing = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Party'),
      ),
      body: _isLoadingTemplate 
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading party template...'),
              ],
            ),
          )
        : Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              _buildTextField(
                controller: _codeController,
                label: 'Party Code',
                hint: 'Enter unique party code',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Party code is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _nameController,
                label: 'Party Name',
                hint: 'Enter party name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Party name is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _contactPersonController,
                label: 'Contact Person',
                hint: 'Enter contact person name',
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _phoneController,
                label: 'Phone Number',
                hint: 'Enter phone number',
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _addressController,
                label: 'Address',
                hint: 'Enter address',
                maxLines: 3,
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _cityController,
                label: 'City',
                hint: 'Enter city',
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _pinCodeController,
                label: 'Pin Code',
                hint: 'Enter pin code',
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _stateController,
                label: 'State',
                hint: 'Enter state',
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                hint: 'Enter email address',
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _email2Controller,
                label: 'Alternate Email',
                hint: 'Enter alternate email address (optional)',
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _contactTitleController,
                label: 'Contact Title',
                hint: 'E.g. Mr, Mrs, Dr, etc.',
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _vatNoController,
                label: 'GST/VAT Number',
                hint: 'Enter GST/VAT registration number',
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _panNoController,
                label: 'PAN Number',
                hint: 'Enter PAN number',
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _cstNoController,
                label: 'CST Number',
                hint: 'Enter CST number',
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _maxCreditAmountController,
                label: 'Max Credit Amount',
                hint: 'Enter maximum credit amount',
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _maxCreditDaysController,
                label: 'Max Credit Days',
                hint: 'Enter maximum credit days',
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _transportController,
                label: 'Transport',
                hint: 'Enter transport information',
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isProcessing ? null : _saveParty,
                child: _isProcessing
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text('Save Party'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ],
          ),
        ),
      );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}
```

### 6. App Integration

Update your `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/party_list_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cardamom App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: PartyListScreen(),
    );
  }
}
```

## Party Model Implementation

The Party model is designed to handle both template data retrieval and form submission. The model includes all fields needed by the API:

```dart
class Party {
  String partyCode;
  String partyName;
  String groupName;
  String address;
  String city;
  String state;
  String country;
  String pincode;
  String contactPerson;
  String mobileNo;
  String emailId;
  String gstNo;
  String panNo;
  String bankName;
  String accountNo;
  String ifscCode;
  String openingBalance;
  String drCr;
  
  // Constructor with default values matching the template
  Party({
    this.partyCode = '',
    this.partyName = '',
    this.groupName = '',
    this.address = '',
    this.city = '',
    this.state = '',
    this.country = '',
    this.pincode = '',
    this.contactPerson = '',
    this.mobileNo = '',
    this.emailId = '',
    this.gstNo = '',
    this.panNo = '',
    this.bankName = '',
    this.accountNo = '',
    this.ifscCode = '',
    this.openingBalance = '0.00',
    this.drCr = 'Dr',
  });
  
  // Create a Party object from JSON template
  factory Party.fromJson(Map<String, dynamic> json) {
    return Party(
      partyCode: json['PartyCode'] ?? '',
      partyName: json['PartyName'] ?? '',
      groupName: json['GroupName'] ?? '',
      address: json['Address'] ?? '',
      city: json['City'] ?? '',
      state: json['State'] ?? '',
      country: json['Country'] ?? '',
      pincode: json['Pincode'] ?? '',
      contactPerson: json['ContactPerson'] ?? '',
      mobileNo: json['MobileNo'] ?? '',
      emailId: json['EmailId'] ?? '',
      gstNo: json['GSTNo'] ?? '',
      panNo: json['PANNo'] ?? '',
      bankName: json['BankName'] ?? '',
      accountNo: json['AccountNo'] ?? '',
      ifscCode: json['IFSCCode'] ?? '',
      openingBalance: json['OpeningBalance']?.toString() ?? '0.00',
      drCr: json['DrCr'] ?? 'Dr',
    );
  }
  
  // Convert Party object to JSON for API submission
  Map<String, dynamic> toJson() {
    return {
      'PartyCode': partyCode,
      'PartyName': partyName,
      'GroupName': groupName,
      'Address': address,
      'City': city,
      'State': state,
      'Country': country,
      'Pincode': pincode,
      'ContactPerson': contactPerson,
      'MobileNo': mobileNo,
      'EmailId': emailId,
      'GSTNo': gstNo,
      'PANNo': panNo,
      'BankName': bankName,
      'AccountNo': accountNo,
      'IFSCCode': ifscCode,
      'OpeningBalance': openingBalance,
      'DrCr': drCr,
    };
  }
}
```

## Template-Based Party Addition Workflow

The implementation follows this workflow for adding a new party:

1. **Fetch Blank Template:** When the Add Party screen is loaded, the app calls `GetPartyMasterByCode` with `ReqPartyCode: "0"` to get a blank party template with all required fields and default values
2. **Pre-fill Form:** The form fields are initialized with default values from the template
3. **User Edits:** User fills in required fields and modifies other fields as needed
4. **Validation:** Form is validated before submission
5. **Submission:** The completed form data is sent using `UpdateAccountBook` endpoint with all template fields preserved
6. **Confirmation:** User is notified of success/failure and returned to the party list

This template-based approach ensures that all required fields are properly included in the request and that the structure matches what the server expects. It also allows the server to provide default values or constraints that should be applied to new parties.

### Template Fetching Implementation Details

The key to this approach is fetching the party template first:

```dart
// Fetch the blank party template using GetPartyMasterByCode
Future<Party> getBlankPartyTemplate() async {
  try {
    var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
    
    request.fields['title'] = 'GetPartyMasterByCode';
    request.fields['description'] = 'Request For Party Display List';
    request.fields['ReqPartyCode'] = '0';  // "0" returns a blank template
    
    final response = await request.send().then(http.Response.fromStream);
    
    if (response.statusCode == 200) {
      final String responseBody = response.body;
      // Clean the response if needed
      final String cleanedData = responseBody.contains('||JasonEnd')
          ? responseBody.substring(0, responseBody.indexOf('||JasonEnd'))
          : responseBody;
          
      final List<dynamic> jsonData = json.decode(cleanedData);
      if (jsonData.isNotEmpty) {
        // Convert JSON template to Party object
        return Party.fromJson(jsonData[0]);
      }
    }
    // Fallback to empty template if server doesn't return one
    return Party(partyCode: '', partyName: '');
  } catch (e) {
    print('Error fetching template: $e');
    throw Exception('Failed to load party template');
  }
}
```

When editing an existing party, you can use the same endpoint with the actual party code:

```dart
// To edit an existing party, fetch its data as a template
// request.fields['ReqPartyCode'] = existingPartyCode;
```

### Why Use Templates?

1. **Complete Field Set:** Ensures all required fields from the server are included
2. **Default Values:** Server can provide default values for fields
3. **Consistency:** Form matches the exact structure expected by the API
4. **Future-proofing:** If the API adds new required fields, they'll be included automatically
5. **Reduced Errors:** Minimizes the chance of missing required fields

## Testing Implementation

### 1. API Integration Test

Create a simple test to verify API connectivity:

```dart
// lib/tests/api_test.dart
import 'package:flutter_test/flutter_test.dart';
import '../services/api_service.dart';

void main() {
  test('API Connection Test', () async {
    final apiService = ApiService(
      customUrl: 'https://cardamombe.magnussoftech.in/api/WebServiceAccounts.aspx'
    );
    
    try {
      final parties = await apiService.getPartyList();
      expect(parties, isNotNull);
    } catch (e) {
      fail('API connection failed: $e');
    }
  });
}
```

## Security Considerations

1. Always use HTTPS for API requests
2. Implement proper authentication (JWT, OAuth, etc.)
3. Store sensitive information in secure storage, not in SharedPreferences
4. Implement proper error handling with user-friendly messages
5. Add timeout handling for slow connections

## Troubleshooting

Common issues and solutions:

1. **Network Errors**: Add proper error handling and retry mechanisms
2. **Data Parsing Errors**: Ensure proper null checking in model classes
3. **API Format Changes**: Keep model parsers flexible to handle API changes
4. **Performance Issues**: Implement pagination for large lists

## Offline Support Recommendations

1. Use SQLite or Hive for local storage
2. Implement background sync when connection is restored
3. Show offline indicator when working in offline mode

## Session Management

All API calls must maintain session cookies to ensure authentication. This is handled automatically if you use a shared Dio instance or HttpClient across API calls. If you encounter HTML responses instead of JSON, it typically indicates a session issue.

## Error Handling and Session Management

### Detecting Session Errors

A common issue with the API is session expiration, which often results in HTML responses instead of JSON. To detect this:

```dart
bool _isHtmlResponse(String response) {
  // Check if response starts with HTML tags
  return response.trim().startsWith('<') || 
         response.contains('<!DOCTYPE html>') ||
         response.contains('<html');
}

Future<dynamic> _processResponse(http.Response response) async {
  if (response.statusCode == 200) {
    final String body = response.body;
    
    // Check if response is HTML (likely a login page)
    if (_isHtmlResponse(body)) {
      throw SessionException('Session expired or invalid');
    }
    
    // Handle the ||JasonEnd delimiter
    final String cleanedData = body.contains('||JasonEnd')
        ? body.substring(0, body.indexOf('||JasonEnd'))
        : body;
        
    try {
      return json.decode(cleanedData);
    } catch (e) {
      throw FormatException('Invalid JSON response: $e');
    }
  } else {
    throw HttpException('Request failed with status: ${response.statusCode}');
  }
}
```

### Session Recovery

When a session error is detected, you can attempt to reestablish the session:

```dart
Future<T> _withSessionRetry<T>(Future<T> Function() operation) async {
  try {
    return await operation();
  } on SessionException catch (_) {
    // Session expired - attempt to reestablish
    print('Session expired. Attempting to reestablish...');
    
    // First try to get party list, which typically refreshes the session
    await getPartyList();
    
    // Retry the original operation
    return await operation();
  }
}

// Example usage in a service method:
Future<bool> addParty(Party party) async {
  return _withSessionRetry(() async {
    // Original add party code
    // ...
  });
}
```

### User-Friendly Error Messages

Always provide user-friendly error messages when API calls fail:

```dart
try {
  await partyService.addParty(party);
  // Success handling
} catch (e) {
  String errorMessage = 'Failed to add party';
  
  if (e is SessionException) {
    errorMessage = 'Your session has expired. Please try again.';
  } else if (e is FormatException) {
    errorMessage = 'Invalid response from server. Please try again.';
  } else if (e is HttpException) {
    errorMessage = 'Server error. Please try again later.';
  }
  
  // Show error dialog
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Error'),
      content: Text(errorMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
```

## Conclusion and Best Practices

### Key Takeaways

1. **Template-Based Forms**: Always fetch a blank template from `GetPartyMasterByCode` with `ReqPartyCode: "0"` when creating new entities.

2. **Shared HTTP Client**: Maintain session cookies by using a shared Dio or HttpClient instance for all API calls.

3. **Session Management**: Handle session expiration by detecting HTML responses and implementing retry logic.

4. **Consistent Field Handling**: Include all fields from the template in your form and API requests, even if they're not visible to the user.

5. **Modal Forms**: Use modal dialogs for better user experience when adding or editing parties.
