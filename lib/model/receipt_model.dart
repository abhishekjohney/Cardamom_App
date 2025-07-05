// lib/models/receipt_model.dart
class Receipt {
  final int gcrid;
  String compRefNo;
  String date;
  String refNo;
  String party;
  int partyId;
  double qty;
  double rate;
  double processingCharges;
  int numberOfBags;
  String remark;

  Receipt({
    required this.gcrid,
    required this.compRefNo,
    required this.date,
    required this.refNo,
    required this.party,
    required this.partyId,
    required this.qty,
    required this.rate,
    required this.processingCharges,
    required this.numberOfBags,
    required this.remark,
  });

  factory Receipt.fromJson(Map<String, dynamic> json) {
    return Receipt(
      gcrid: json['GCRID'] ?? 0,
      compRefNo: json['CompRefNo']?.toString() ?? '',
      date: json['CdateStr'] ?? '',
      refNo: json['RefNo'] ?? '',
      party: json['PartyName'] ?? '',
      partyId: json['PartyID'] ?? 0,
      qty: double.tryParse(json['GCRecQty']?.toString() ?? '0') ?? 0,
      rate: double.tryParse(json['Rate']?.toString() ?? '0') ?? 0,
      processingCharges:
          double.tryParse(json['ProcAmount']?.toString() ?? '0') ?? 0,
      numberOfBags: int.tryParse(json['NumberOfBags']?.toString() ?? '1') ?? 1,
      remark: json['GCRecRemarks'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'GCRID': gcrid,
      'CompRefNo': compRefNo,
      'CdateStr': date,
      'RefNo': refNo,
      'PartyName': party,
      'PartyID': partyId,
      'GCRecQty': qty,
      'Rate': rate,
      'ProcAmount': processingCharges,
      'NumberOfBags': numberOfBags,
      'GCRecRemarks': remark,
    };
  }
}
