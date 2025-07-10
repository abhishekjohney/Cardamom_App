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
    "PinCode": "682022",
    "CLBalance": 1500.00
    // Other fields...
  },
  // More party entries...
]
```

### 2. Add New Party

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
  final String phoneNumber;
  final String address;
  final String city;
  final String pinCode;
  final double balance;

  Party({
    this.id,
    required this.partyCode,
    required this.partyName,
    this.contactPerson = '',
    this.phoneNumber = '',
    this.address = '',
    this.city = '',
    this.pinCode = '',
    this.balance = 0.0,
  });

  factory Party.fromJson(Map<String, dynamic> json) {
    return Party(
      id: json['AccAutoID'],
      partyCode: json['Byr_Cd'] ?? '',
      partyName: json['Byr_nam'] ?? '',
      contactPerson: json['CONTACTPERSON'] ?? '',
      phoneNumber: json['PhoneNo'] ?? '',
      address: json['AccAddress'] ?? '',
      city: json['AccCity'] ?? '',
      pinCode: json['PinCode'] ?? '',
      balance: json['CLBalance'] != null 
        ? double.tryParse(json['CLBalance'].toString()) ?? 0.0
        : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ACCORGAUTOID": 1,
      "ACCOUNTNO": "",
      "ACCQRYSTR": "",
      "ACTYP": "LED",
      "AccAddress": address,
      "AccAddress1": "",
      "AccAddress2": "",
      "AccAutoID": 0,
      "AccCity": city,
      "AccState": "",
      "AccountLedger": null,
      "ActionType": 1,
      "BALTYPE": 0,
      "Byr_Cd": partyCode,
      "Byr_nam": partyName,
      "CLBalColor": "",
      "CLBalance": 0,
      "CLIENTPRFIX": "",
      "CLIENTTRANSID": "",
      "CMNT": "",
      "CNTRY1": "",
      "CONTACTPERSON": contactPerson,
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
      "PhoneNo": phoneNumber,
      "PinCode": pinCode,
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
                ],
              ),
              onTap: () {
                // Navigate to party details (to be implemented)
              },
            ),
          );
        },
      ),
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

  // Text controllers
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _pinCodeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _contactPersonController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _pinCodeController.dispose();
    super.dispose();
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
      phoneNumber: _phoneController.text,
      address: _addressController.text,
      city: _cityController.text,
      pinCode: _pinCodeController.text,
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
      body: Form(
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
