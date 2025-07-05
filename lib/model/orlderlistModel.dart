class OrderListModel {
  final String id;
  final String OrderTransID;
  final String OrderID;
  final String SVRSTKID;
  final String itm_CD;
  final String OrderQty;
  final String OrderRate;
  final String SaleRate;
  final String OrderAmount;
  final String OrderRemarks;
  final String TrnAmount;
  final String Disper;
  final String ItemDisAmount;
  final String TrnGrossAmt;
  final String TrnCGSTAmt;
  final String TrnSGSTAmt;
  final String TrnIGSTAmt;
  final String TrnGSTAmt;
  final String TrnNetAmount;
  final String FreeQty;
  final String TotQty;
  final String TrnGSTPer;
  final String TrnCessPer;
  final String TrnCGSTPer;
  final String TrnSGSTPer;
  final String TrnIGSTPer;
  final String TrnCessAmt;
  OrderListModel({
    required this.id,
    required this.OrderTransID,
    required this.OrderID,
    required this.SVRSTKID,
    required this.itm_CD,
    required this.OrderQty,
    required this.OrderRate,
    required this.SaleRate,
    required this.OrderAmount,
    required this.OrderRemarks,
    required this.TrnAmount,
    required this.Disper,
    required this.ItemDisAmount,
    required this.TrnGrossAmt,
    required this.TrnCGSTAmt,
    required this.TrnSGSTAmt,
    required this.TrnIGSTAmt,
    required this.TrnGSTAmt,
    required this.TrnNetAmount,
    required this.FreeQty,
    required this.TotQty,
    required this.TrnGSTPer,
    required this.TrnCessPer,
    required this.TrnCGSTPer,
    required this.TrnSGSTPer,
    required this.TrnIGSTPer,
    required this.TrnCessAmt,
  });

  // Convert a Map to an OrderListModel object
  factory OrderListModel.fromMap(Map<String, dynamic> map) {
    return OrderListModel(
      id: map['id'].toString(),
      OrderTransID: map['OrderTransID'].toString(),
      OrderID: map['OrderID'].toString(),
      SVRSTKID: map['SVRSTKID'].toString(),
      itm_CD: map['itm_CD'].toString(),
      OrderQty: map['OrderQty'].toString(),
      OrderRate: map['OrderRate'].toString(),
      SaleRate: map['SaleRate'].toString(),
      OrderAmount: map['OrderAmount'].toString(),
      OrderRemarks: map['OrderRemarks'].toString(),
      TrnAmount: map['TrnAmount'].toString(),
      Disper: map['Disper'].toString(),
      ItemDisAmount: map['ItemDisAmount'].toString(),
      TrnGrossAmt: map['TrnGrossAmt'].toString(),
      TrnCGSTAmt: map['TrnCGSTAmt'].toString(),
      TrnSGSTAmt: map['TrnSGSTAmt'].toString(),
      TrnIGSTAmt: map['TrnIGSTAmt'].toString(),
      TrnGSTAmt: map['TrnGSTAmt'].toString(),
      TrnNetAmount: map['TrnNetAmount'].toString(),
      FreeQty: map['FreeQty'].toString(),
      TotQty: map['TotQty'].toString(),
      TrnGSTPer: map['TrnGSTPer'].toString(),
      TrnCessPer: map['TrnCessPer'].toString(),
      TrnCGSTPer: map['TrnCGSTPer'].toString(),
      TrnSGSTPer: map['TrnSGSTPer'].toString(),
      TrnIGSTPer: map['TrnIGSTPer'].toString(),
      TrnCessAmt: map['TrnCessAmt'].toString(),
    );
  }

  double get itemTotal {
    final saleRate = double.tryParse(SaleRate) ?? 0.0;
    final orderQty = double.tryParse(OrderQty) ?? 0.0;
    return saleRate * orderQty;
  }
}
