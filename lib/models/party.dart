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
      "AccAutoID": id ?? 0,
      "AccCity": city,
      "AccState": "",
      "AccountLedger": null,
      "ActionType": id != null && id! > 0 ? 2 : 1, // 1 for new, 2 for update
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
