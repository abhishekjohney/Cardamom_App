// lib/models/transaction_model.dart
class Transaction {
  final int gcrid;
  final String receiveDate;
  final String compRefNo;
  final String partyName;
  final int partyId;
  final double receivedQty;
  final double processingCharges;
  final String stockEntryDate;
  final double stockQty;
  final double prodRatio;
  final String delDate;
  final double delQty;
  final String transType;
  final double receiptAmount;

  Transaction({
    required this.gcrid,
    required this.receiveDate,
    required this.compRefNo,
    required this.partyName,
    required this.partyId,
    required this.receivedQty,
    required this.processingCharges,
    required this.stockEntryDate,
    required this.stockQty,
    required this.prodRatio,
    required this.delDate,
    required this.delQty,
    required this.transType,
    required this.receiptAmount,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      gcrid: json['GCRID'] ?? 0,
      receiveDate: json['ReceiveDate'] ?? '',
      compRefNo: json['CompRefNo']?.toString() ?? '',
      partyName: json['PartyName'] ?? '',
      partyId: json['PartyID'] ?? 0,
      receivedQty: double.tryParse(json['ReceivedQty']?.toString() ?? '0') ?? 0,
      processingCharges:
          double.tryParse(json['ProcessingCharges']?.toString() ?? '0') ?? 0,
      stockEntryDate: json['StockEntryDate'] ?? '',
      stockQty: double.tryParse(json['StockQty']?.toString() ?? '0') ?? 0,
      prodRatio: double.tryParse(json['ProdRatio']?.toString() ?? '0') ?? 0,
      delDate: json['DelDate'] ?? '',
      delQty: double.tryParse(json['DelQty']?.toString() ?? '0') ?? 0,
      transType: json['TransType'] ?? '',
      receiptAmount:
          double.tryParse(json['ReceiptAmount']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'GCRID': gcrid,
      'ReceiveDate': receiveDate,
      'CompRefNo': compRefNo,
      'PartyName': partyName,
      'PartyID': partyId,
      'ReceivedQty': receivedQty,
      'ProcessingCharges': processingCharges,
      'StockEntryDate': stockEntryDate,
      'StockQty': stockQty,
      'ProdRatio': prodRatio,
      'DelDate': delDate,
      'DelQty': delQty,
      'TransType': transType,
      'ReceiptAmount': receiptAmount,
    };
  }
}
