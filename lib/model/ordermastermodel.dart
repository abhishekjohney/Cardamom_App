class OrderMasterModel {
  final int id;
  final int OrderID;
  final String OrderNo;
  final String OrderDate;
  final String PartyID;
  final String PartyClientID;
  final String PartyName;
  final String UserCode;
  final String UserAutoID;
  final String Remarks;
  final String AddedDate;
  final String VehicleNo;
  final String DelDate;
  final String AccPartyID;
  final String AccPartyName;
  final String EntryDateTime;
  final String TotAmount;
  final String DiscountAmt;
  final String GrossAmount;
  final String CGSTAmt;
  final String SGSTAmt;
  final String IGSTAmt;
  final String GSTAmt;
  final String RofAmt;
  final String NetAmount;
  final String OrderSource;
  final String FullOrderAmount;
  final String FlatDiscount;
  final String TotItemDiscount;
  final String CessAmt;

  OrderMasterModel({
    required this.id,
    required this.OrderID,
    required this.OrderNo,
    required this.OrderDate,
    required this.PartyID,
    required this.PartyClientID,
    required this.PartyName,
    required this.UserCode,
    required this.UserAutoID,
    required this.Remarks,
    required this.AddedDate,
    required this.VehicleNo,
    required this.DelDate,
    required this.AccPartyID,
    required this.AccPartyName,
    required this.EntryDateTime,
    required this.TotAmount,
    required this.DiscountAmt,
    required this.GrossAmount,
    required this.CGSTAmt,
    required this.SGSTAmt,
    required this.IGSTAmt,
    required this.GSTAmt,
    required this.RofAmt,
    required this.NetAmount,
    required this.OrderSource,
    required this.FullOrderAmount,
    required this.FlatDiscount,
    required this.TotItemDiscount,
    required this.CessAmt,
  });

  // Convert a Map into an OrderMasterModel object
  factory OrderMasterModel.fromMap(Map<String, dynamic> map) {
    return OrderMasterModel(
      id: map['id'],
      OrderID: map['OrderID']??'',
      OrderNo: map['OrderNo'].toString() ?? '',
      OrderDate: map['OrderDate'].toString() ?? '',
      PartyID: map['PartyID'].toString() ?? '',
      PartyClientID: map['PartyClientID'].toString() ?? '',
      PartyName: map['PartyName'].toString() ?? '',
      UserCode: map['UserCode'].toString() ?? '',
      UserAutoID: map['UserAutoID'].toString() ?? '',
      Remarks: map['Remarks'].toString() ?? '',
      AddedDate: map['AddedDate'].toString() ?? '',
      VehicleNo: map['VehicleNo'].toString() ?? '',
      DelDate: map['DelDate'].toString() ?? '',
      AccPartyID: map['AccPartyID'].toString() ?? '',
      AccPartyName: map['AccPartyName'].toString() ?? '',
      EntryDateTime: map['EntryDateTime'].toString() ?? '',
      TotAmount: map['TotAmount'].toString() ?? '',
      DiscountAmt: map['DiscountAmt'].toString() ?? '',
      GrossAmount: map['GrossAmount'].toString() ?? '',
      CGSTAmt: map['CGSTAmt'].toString() ?? '',
      SGSTAmt: map['SGSTAmt'].toString() ?? '',
      IGSTAmt: map['IGSTAmt'].toString() ?? '',
      GSTAmt: map['GSTAmt'].toString() ?? '',
      RofAmt: map['RofAmt'].toString() ?? '',
      NetAmount: map['NetAmount'].toString() ?? '',
      OrderSource: map['OrderSource'].toString() ?? '',
      FullOrderAmount: map['FullOrderAmount'].toString() ?? '',
      FlatDiscount: map['FlatDiscount'].toString() ?? '',
      TotItemDiscount: map['TotItemDiscount'].toString() ?? '',
      CessAmt: map['CessAmt'].toString() ?? '',
    );
  }

  // Convert an Order object into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'OrderID': OrderID,
      'OrderNo': OrderNo,
      'OrderDate': OrderDate,
      'PartyID': PartyID,
      'PartyClientID': PartyClientID,
      'PartyName': PartyName,
      'UserCode': UserCode,
      'UserAutoID': UserAutoID,
      'Remarks': Remarks,
      'AddedDate': AddedDate,
      'VehicleNo': VehicleNo,
      'DelDate': DelDate,
      'AccPartyID': AccPartyID,
      'AccPartyName': AccPartyName,
      'EntryDateTime': EntryDateTime,
      'TotAmount': TotAmount,
      'DiscountAmt': DiscountAmt,
      'GrossAmount': GrossAmount,
      'CGSTAmt': CGSTAmt,
      'SGSTAmt': SGSTAmt,
      'IGSTAmt': IGSTAmt,
      'GSTAmt': GSTAmt,
      'RofAmt': RofAmt,
      'NetAmount': NetAmount,
      'OrderSource': OrderSource,
      'FullOrderAmount': FullOrderAmount,
      'FlatDiscount': FlatDiscount,
      'TotItemDiscount': TotItemDiscount,
      'CessAmt': CessAmt
    };
  }
}
