import 'dart:convert';

class CartItem {
  final String? OrderTransID;
  final String? OrderID;
  final String? SVRSTKID;
  final String? itm_CD;
  final String? OrderQty;
  final String? OrderRate;
  final String? SaleRate;
  final String? OrderAmount;
  final String? OrderRemarks;
  final String? TrnAmount;
  final String? Disper;
  final String? ItemDisAmount;
  final String? TrnGrossAmt;
  final String? TrnCGSTAmt;
  final String? TrnSGSTAmt;
  final String? TrnIGSTAmt;
  final String? TrnGSTAmt;
  final String? TrnNetAmount;
  final String? FreeQty;
  final String? TotQty;
  final String? TrnGSTPer;
  final String? TrnCessPer;
  final String? TrnCGSTPer;
  final String? TrnSGSTPer;
  final String? TrnIGSTPer;
  final String? TrnCessAmt;

  CartItem({
     this.OrderTransID,
     this.OrderID,
     this.SVRSTKID,
     this.itm_CD,
     this.OrderQty,
     this.OrderRate,
     this.SaleRate,
     this.OrderAmount,
     this.OrderRemarks,
     this.TrnAmount,
     this.Disper,
     this.ItemDisAmount,
     this.TrnGrossAmt,
     this.TrnCGSTAmt,
     this.TrnSGSTAmt,
     this.TrnIGSTAmt,
     this.TrnGSTAmt,
     this.TrnNetAmount,
     this.FreeQty,
     this.TotQty,
     this.TrnGSTPer,
     this.TrnCessPer,
     this.TrnCGSTPer,
     this.TrnSGSTPer,
     this.TrnIGSTPer,
     this.TrnCessAmt,
  });

  // Convert CartItem to a Map to store in SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'OrderTransID': OrderTransID,
      'OrderID': OrderID,
      'SVRSTKID': SVRSTKID,
      'itm_CD': itm_CD,
      'OrderQty': OrderQty,
      'OrderRate': OrderRate,
      'SaleRate': SaleRate,
      'OrderAmount': OrderAmount,
      'OrderRemarks': OrderRemarks,
      'TrnAmount': TrnAmount,
      'Disper': Disper,
      'ItemDisAmount': ItemDisAmount,
      'TrnGrossAmt': TrnGrossAmt,
      'TrnCGSTAmt': TrnCGSTAmt,
      'TrnSGSTAmt': TrnSGSTAmt,
      'TrnIGSTAmt': TrnIGSTAmt,
      'TrnGSTAmt': TrnGSTAmt,
      'TrnNetAmount': TrnNetAmount,
      'FreeQty': FreeQty,
      'TotQty': TotQty,
      'TrnGSTPer': TrnGSTPer,
      'TrnCessPer': TrnCessPer,
      'TrnCGSTPer': TrnCGSTPer,
      'TrnSGSTPer': TrnSGSTPer,
      'TrnIGSTPer': TrnIGSTPer,
      'TrnCessAmt': TrnCessAmt,
    };
  }

  // Convert CartItem to JSON string
  String toJson() => json.encode(toMap());

  // Convert Map to CartItem
  static CartItem fromMap(Map<String, dynamic> map) {
    return CartItem(
      OrderTransID: map['OrderTransID']??'',
      OrderID: map['OrderID']??'',
      SVRSTKID: map['SVRSTKID']??'',
      itm_CD: map['itm_CD']??'',
      OrderQty: map['OrderQty']??'',
      OrderRate: map['OrderRate']??'',
      SaleRate: map['SaleRate']??'',
      OrderAmount: map['OrderAmount']??'',
      OrderRemarks: map['OrderRemarks']??'',
      TrnAmount: map['TrnAmount']??'',
      Disper: map['Disper']??'',
      ItemDisAmount: map['ItemDisAmount']??'',
      TrnGrossAmt: map['TrnGrossAmt']??'',
      TrnCGSTAmt: map['TrnCGSTAmt']??'',
      TrnSGSTAmt: map['TrnSGSTAmt']??'',
      TrnIGSTAmt: map['TrnIGSTAmt']??'',
      TrnGSTAmt: map['TrnGSTAmt']??'',
      TrnNetAmount: map['TrnNetAmount']??'',
      FreeQty: map['FreeQty']??'',
      TotQty: map['TotQty']??'',
      TrnGSTPer: map['TrnGSTPer']??'',
      TrnCessPer: map['TrnCessPer']??'',
      TrnCGSTPer: map['TrnCGSTPer']??'',
      TrnSGSTPer: map['TrnSGSTPer']??'',
      TrnIGSTPer: map['TrnIGSTPer']??'',
      TrnCessAmt: map['TrnCessAmt']??'',
    );
  }

  // Convert JSON string back to CartItem
  static CartItem fromJson(String source) {
    return CartItem.fromMap(json.decode(source));
  }
}
