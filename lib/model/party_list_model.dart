import 'package:flutter/material.dart';

class PartyItem {
  final int accAutoID;
  final String accAutoIDClient;
  final String byrCd;
  final String byrNam;
  final String accAddress;
  final String? accAddress1;
  final String? accAddress2;
  final String? accCity;
  final String? accState;
  final String? phoneNo;
  final String? vatno;
  final double balance;
  final String balColor;
  final double maxCreditAmount;
  final int maxCreditDays;
  final String? locationString;
  final bool locAprYN;
  final String? locLatLong;
  final String? partyRemarks;
  final String groups;

  PartyItem({
    required this.accAutoID,
    required this.accAutoIDClient,
    required this.byrCd,
    required this.byrNam,
    required this.accAddress,
    this.accAddress1,
    this.accAddress2,
    this.accCity,
    this.accState,
    this.phoneNo,
    this.vatno,
    required this.balance,
    required this.balColor,
    required this.maxCreditAmount,
    required this.maxCreditDays,
    this.locationString,
    required this.locAprYN,
    this.locLatLong,
    this.partyRemarks,
    required this.groups,
  });

  factory PartyItem.fromJson(Map<String, dynamic> json) {
    return PartyItem(
      accAutoID: (json['AccAutoID'] ?? 0).toInt(),
      accAutoIDClient: json['AccAutoIDClient']?.toString() ?? '',
      byrCd: json['Byr_Cd']?.toString() ?? '',
      byrNam: json['Byr_nam']?.toString() ?? '',
      accAddress: json['AccAddress']?.toString() ?? '',
      accAddress1: json['AccAddress1']?.toString(),
      accAddress2: json['AccAddress2']?.toString(),
      accCity: json['AccCity']?.toString(),
      accState: json['AccState']?.toString(),
      phoneNo: json['PhoneNo']?.toString(),
      vatno: json['VATNO']?.toString(),
      balance: (json['Balance'] ?? 0.0).toDouble(),
      balColor: json['BalColor']?.toString() ?? 'GREEN',
      maxCreditAmount: (json['MaxCreditAmount'] ?? 0.0).toDouble(),
      maxCreditDays: (json['MaxCreditDays'] ?? 0).toInt(),
      locationString: json['LocationString']?.toString(),
      locAprYN: json['LocAprYN'] ?? false,
      locLatLong: json['LocLatLong']?.toString(),
      partyRemarks: json['PartyRemarks']?.toString(),
      groups: json['Groups']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'AccAutoID': accAutoID,
      'AccAutoIDClient': accAutoIDClient,
      'Byr_Cd': byrCd,
      'Byr_nam': byrNam,
      'AccAddress': accAddress,
      'AccAddress1': accAddress1,
      'AccAddress2': accAddress2,
      'AccCity': accCity,
      'AccState': accState,
      'PhoneNo': phoneNo,
      'VATNO': vatno,
      'Balance': balance,
      'BalColor': balColor,
      'MaxCreditAmount': maxCreditAmount,
      'MaxCreditDays': maxCreditDays,
      'LocationString': locationString,
      'LocAprYN': locAprYN,
      'LocLatLong': locLatLong,
      'PartyRemarks': partyRemarks,
      'Groups': groups,
    };
  }
  
  // Helper getter for full address
  String get fullAddress {
    final parts = [accAddress, accAddress1, accAddress2, accCity, accState]
        .where((part) => part != null && part.isNotEmpty)
        .toList();
    return parts.join(', ');
  }
  
  // Helper getter for balance color
  Color get balanceColor {
    final colorStr = balColor.trim().toUpperCase();
    switch (colorStr) {
      case 'GREEN':
        return const Color(0xFF4CAF50);
      case 'RED':
        return const Color(0xFFF44336);
      case 'BLUE':
        return const Color(0xFF2196F3);
      case '':
        // If balance color is empty, determine by balance amount
        if (balance > 0) {
          return const Color(0xFF4CAF50); // Green for positive
        } else if (balance < 0) {
          return const Color(0xFFF44336); // Red for negative
        } else {
          return const Color(0xFF9E9E9E); // Grey for zero
        }
      default:
        return const Color(0xFF9E9E9E);
    }
  }
}

class PartyListResponse {
  final List<PartyItem> partyList;

  PartyListResponse({required this.partyList});

  factory PartyListResponse.fromJson(Map<String, dynamic> json) {
    var list = json['PartyList'] as List;
    List<PartyItem> partyList = list.map((i) => PartyItem.fromJson(i)).toList();
    return PartyListResponse(partyList: partyList);
  }

  Map<String, dynamic> toJson() {
    return {
      'PartyList': partyList.map((party) => party.toJson()).toList(),
    };
  }
}

class TotalSum {
  final double due;
  final double advance;
  final double total;
  final double grandTotal;
  final int totalParties;

  TotalSum({
    required this.due,
    required this.advance,
    required this.total,
    required this.grandTotal,
    required this.totalParties,
  });
}
