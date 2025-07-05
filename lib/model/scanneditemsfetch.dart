// models/stock_item_model.dart
class ScannedItemFetch {
  final dynamic alqty;
  final dynamic actionType;
  final dynamic addedBy;
  final dynamic barcodeId;
  final dynamic batchNo;
  final dynamic barcode;
  final dynamic? clientPrefix;
  final dynamic? clientTransId;
  final dynamic catID;
  final dynamic category;
  final dynamic clrGroup;
  final dynamic cost;
  final dynamic costPrice;
  final dynamic counterNo;
  final dynamic dgid;
  final dynamic dgndx;
  final dynamic dropped;
  final dynamic department;
  final dynamic designCode;
  final dynamic designNo;
  final dynamic displayGrp;
  final dynamic expdtyn;
  final dynamic finalStock;
  final dynamic folderName;
  final dynamic freeQty;
  final dynamic genname;
  final dynamic gstitmcd;
  final dynamic iColor;
  final dynamic id;
  final dynamic iSize;
  final dynamic icompany;
  final dynamic imageDescription;
  final dynamic imageFile;
  final dynamic imageFiles;
  final dynamic imagePath;
  final dynamic isActive;
  final dynamic lastDate;
  final dynamic lastRate;
  final dynamic loosQty;
  final dynamic looseRate;
  final dynamic mrp;
  final dynamic material;
  final dynamic numberPerCase;
  final dynamic numberPerCase1;
  final dynamic orgAutoID;
  final dynamic orgCode;
  final dynamic oldHsnCode;
  final dynamic orderCesPer;
  final dynamic pluCode;
  final dynamic pnid;
  final dynamic prersupl;
  final dynamic productBL;
  final dynamic productDupatta;
  final dynamic productGroup;
  final dynamic productLining;
  final dynamic productSL;
  final dynamic productStyle;
  final dynamic productTL;
  final dynamic productWork;
  final dynamic prtRecQty;
  final dynamic purPrice;
  final dynamic qryStr;
  final dynamic qtnMargPer;
  final dynamic qtnMargRate;
  final dynamic rtlProfitPer;
  final dynamic registrationID;
  final dynamic remarks1;
  final dynamic remarks2;
  final dynamic remarks3;
  final dynamic stkcgstRate;
  final dynamic stkdivNum;
  final dynamic stkgstRate;
  final dynamic stkhsnCode;
  final dynamic stkigstRate;
  final dynamic stksgstRate;
  final dynamic stksvrStock;
  final dynamic stockColor;
  final dynamic suplID;
  final dynamic svrEntID;
  final dynamic svrstkID;
  final dynamic svrupdyn;
  final dynamic saleDisPer;
  final dynamic salePrice;
  final dynamic sizeID;
  final dynamic stkOpnRate;
  final dynamic stkOpn;
  final dynamic stkOpn2;
  final dynamic stockType;
  final dynamic subCatID;
  final dynamic subCategory;
  final dynamic type;
  final dynamic transactionID;
  final dynamic units;
  final dynamic units1;
  final dynamic vatMaster;
  final dynamic vatMasterOut;
  final dynamic wsPrice;
  final dynamic wsProfitPer;
  final dynamic youtubeLink;
  final dynamic billNo;
  final dynamic itmCd;
  final dynamic itmNam;
  final dynamic orderType;
  final dynamic pickerValue;
  final dynamic subgrp;
  final dynamic total;

  ScannedItemFetch({
    required this.alqty,
    required this.actionType,
    required this.addedBy,
    required this.barcodeId,
    required this.batchNo,
    required this.barcode,
    required this.clientPrefix,
    required this.clientTransId,
    required this.catID,
    required this.category,
    required this.clrGroup,
    required this.cost,
    required this.costPrice,
    required this.counterNo,
    required this.dgid,
    required this.dgndx,
    required this.dropped,
    required this.department,
    required this.designCode,
    required this.designNo,
    required this.displayGrp,
    required this.expdtyn,
    required this.finalStock,
    required this.folderName,
    required this.freeQty,
    required this.genname,
    required this.gstitmcd,
    required this.iColor,
    required this.id,
    required this.iSize,
    required this.icompany,
    required this.imageDescription,
    required this.imageFile,
    required this.imageFiles,
    required this.imagePath,
    required this.isActive,
    required this.lastDate,
    required this.lastRate,
    required this.loosQty,
    required this.looseRate,
    required this.mrp,
    required this.material,
    required this.numberPerCase,
    required this.numberPerCase1,
    required this.orgAutoID,
    required this.orgCode,
    required this.oldHsnCode,
    required this.orderCesPer,
    required this.pluCode,
    required this.pnid,
    required this.prersupl,
    required this.productBL,
    required this.productDupatta,
    required this.productGroup,
    required this.productLining,
    required this.productSL,
    required this.productStyle,
    required this.productTL,
    required this.productWork,
    required this.prtRecQty,
    required this.purPrice,
    required this.qryStr,
    required this.qtnMargPer,
    required this.qtnMargRate,
    required this.rtlProfitPer,
    required this.registrationID,
    required this.remarks1,
    required this.remarks2,
    required this.remarks3,
    required this.stkcgstRate,
    required this.stkdivNum,
    required this.stkgstRate,
    required this.stkhsnCode,
    required this.stkigstRate,
    required this.stksgstRate,
    required this.stksvrStock,

    required this.stockColor,
    required this.suplID,
    required this.svrEntID,
    required this.svrstkID,
    required this.svrupdyn,
    required this.saleDisPer,
    required this.salePrice,
    required this.sizeID,
    required this.stkOpnRate,
    required this.stkOpn,
    required this.stkOpn2,
    required this.stockType,
    required this.subCatID,
    required this.subCategory,
    required this.type,
    required this.transactionID,
    required this.units,
    required this.units1,
    required this.vatMaster,
    required this.vatMasterOut,
    required this.wsPrice,
    required this.wsProfitPer,
    required this.youtubeLink,
    required this.billNo,
    required this.itmCd,
    required this.itmNam,
    required this.orderType,
    required this.pickerValue,
    required this.subgrp,
    required this.total,
  });


  factory ScannedItemFetch.fromMap(Map<String, dynamic> map) {
    return ScannedItemFetch(
      alqty: map["ALQTY"] ?? 0,
      actionType: map["ActionType"] ?? 0,
      addedBy: map["AddedBy"] ?? 0,
      barcodeId: map["BARCODEID"] ?? "",
      batchNo: map["BATCHNO"] ?? "",
      barcode: map["Barcode"] ?? "",
      clientPrefix: map["CLIENTPRFIX"],
      clientTransId: map["CLIENTTRANSID"],
      catID: map["CatID"] ?? 0,
      category: map["Category"] ?? "",
      clrGroup: map["ClrGroup"] ?? "",
      cost: map["Cost"]?.toDouble() ?? 0.0,
      costPrice: map["CostPrice"]?.toDouble() ?? 0.0,
      counterNo: map["CounterNo"] ?? "",
      dgid: map["DGID"] ?? 0,
      dgndx: map["DGNDX"] ?? 0,
      dropped: map["DROPPED"] ?? false,
      department: map["Department"] ?? "",
      designCode: map["DesignCode"] ?? "",
      designNo: map["DesignNo"] ?? 0,
      displayGrp: map["DisplayGrp"] ?? "",
      expdtyn: map["EXPDTYN"] ?? false,
      finalStock: map["FinalStock"]?.toDouble() ?? 0.0,
      folderName: map["FolderName"] ?? "",
      freeQty: map["FreeQty"]?.toDouble() ?? 0.0,
      genname: map["GENNAME"] ?? "",
      gstitmcd: map["GSTITMCD"] ?? 0,
      iColor: map["IColor"] ?? "",
      id: map["ID"] ?? 0,
      iSize: map["ISize"] ?? "",
      icompany: map["Icompany"] ?? "",
      imageDescription: map["ImageDescription"] ?? "",
      imageFile: map["ImageFile"] ?? "",
      imageFiles: map["ImageFiles"] ?? "",
      imagePath: map["ImagePath"] ?? "",
      isActive: map["IsActive"] ?? false,
      lastDate: map["LastDate"] ?? "",
      lastRate: map["LastRate"]?.toDouble() ?? 0.0,
      loosQty: map["LoosQty"]?.toDouble() ?? 0.0,
      looseRate: map["LooseRate"]?.toDouble() ?? 0.0,
      mrp: map["MRP"]?.toDouble() ?? 0.0,
      material: map["Material"] ?? "",
      numberPerCase: map["NUMBERPERCASE"] ?? 0,
      numberPerCase1: map["NUMBERPERCASE1"] ?? 0,
      orgAutoID: map["ORGAUTOID"] ?? 0,
      orgCode: map["ORGCODE"] ?? 0,
      oldHsnCode: map["OldHsnCode"] ?? 0,
      orderCesPer: map["OrderCesPer"]?.toDouble() ?? 0.0,
      pluCode: map["PLUCODE"] ?? "",
      pnid: map["PNID"] ?? 0,
      prersupl: map["PRERSUPL"] ?? "",
      productBL: map["ProductBL"] ?? "",
      productDupatta: map["ProductDupatta"] ?? "",
      productGroup: map["ProductGroup"] ?? "",
      productLining: map["ProductLining"] ?? "",
      productSL: map["ProductSL"] ?? "",
      productStyle: map["ProductStyle"] ?? "",
      productTL: map["ProductTL"] ?? "",
      productWork: map["ProductWork"] ?? "",
      prtRecQty: map["PrtRecQty"]?.toDouble() ?? 0.0,
      purPrice: map["PurPrice"]?.toDouble() ?? 0.0,
      qryStr: map["QryStr"] ?? "",
      qtnMargPer: map["QtnMargPer"]?.toDouble() ?? 0.0,
      qtnMargRate: map["QtnMargRate"]?.toDouble() ?? 0.0,
      rtlProfitPer: map["RTLProfitPer"]?.toDouble() ?? 0.0,
      registrationID: map["RegistrationID"] ?? 0,
      remarks1: map["Remarks1"] ?? "",
      remarks2: map["Remarks2"] ?? "",
      remarks3: map["Remarks3"] ?? "",
      stkcgstRate: map["STKCGSTRate"]?.toDouble() ?? 0.0,
      stkdivNum: map["STKDIVNUM"] ?? 0,
      stkgstRate: map["STKGSTRate"]?.toDouble() ?? 0.0,
      stkhsnCode: map["STKHSNCode"] ?? 0,
      stkigstRate: map["STKIGSTRate"]?.toDouble() ?? 0.0,
      stksgstRate: map["STKSGSTRate"]?.toDouble() ?? 0.0,
      stksvrStock: map["STKSVRSTOCK"]?.toDouble() ?? 0.0,
      stockColor: map["STOCKCOLOR"] ?? "",
      suplID: map["SUPLID"] ?? 0,
      svrEntID: map["SVRENTID"] ?? 0,
      svrstkID: map["SVRSTKID"] ?? 0,
      svrupdyn: map["SVRUPDYN"] ?? 0,
      saleDisPer: map["SaleDisPer"]?.toDouble() ?? 0.0,
      salePrice: map["SalePrice"]?.toDouble() ?? 0.0,
      sizeID: map["SizeID"] ?? 0,
      stkOpnRate: map["Stk_Opn_Rate"]?.toDouble() ?? 0.0,
      stkOpn: map["Stk_opn"]?.toDouble() ?? 0.0,
      stkOpn2: map["Stk_opn2"]?.toDouble() ?? 0.0,
      stockType: map["StockType"] ?? "",
      subCatID: map["SubCatID"] ?? 0,
      subCategory: map["SubCategory"] ?? "",
      type: map["TYPE"] ?? "",
      transactionID: map["TransactionID"] ?? 0,
      units: map["UNITS"] ?? "",
      units1: map["UNITS1"] ?? "",
      vatMaster: map["VatMaster"] ?? "",
      vatMasterOut: map["VatMasterOut"] ?? "",
      wsPrice: map["WSPrice"]?.toDouble() ?? 0.0,
      wsProfitPer: map["WSProfitPer"]?.toDouble() ?? 0.0,
      youtubeLink: map["YouTubeLink"] ?? "",
      billNo: map["billno"] ?? 0,
      itmCd: map["itm_CD"] ?? 0,
      itmNam: map["itm_NAM"] ?? "",
      orderType: map["ordertype"] ?? 0,
      pickerValue: map["pickerValue"] ?? "",
      subgrp: map["subgrp"] ?? "",
      total: map["total"]?.toDouble() ?? 0.0,
    );
  }
  factory ScannedItemFetch.fromJson(Map<dynamic, dynamic> json) {
    return ScannedItemFetch(
      alqty: json["ALQTY"],
      actionType: json["ActionType"],
      addedBy: json["AddedBy"],
      barcodeId: json["BARCODEID"] ?? "",
      batchNo: json["BATCHNO"] ?? "",
      barcode: json["Barcode"] ?? "",
      clientPrefix: json["CLIENTPRFIX"],
      clientTransId: json["CLIENTTRANSID"],
      catID: json["CatID"],
      category: json["Category"] ?? "",
      clrGroup: json["ClrGroup"] ?? "",
      cost: (json["Cost"] ?? 0).todynamic(),
      costPrice: (json["CostPrice"] ?? 0).todynamic(),
      counterNo: json["CounterNo"] ?? "",
      dgid: json["DGID"],
      dgndx: json["DGNDX"],
      dropped: json["DROPPED"],
      department: json["Department"],
      designCode: json["DesignCode"],
      designNo: json["DesignNo"],
      displayGrp: json["DisplayGrp"],
      expdtyn: json["EXPDTYN"],
      finalStock: json["FinalStock"],
      folderName: json["FolderName"],
      freeQty: json["FreeQty"],
      genname: json["GENNAME"],
      gstitmcd: json["GSTITMCD"],
      iColor: json["IColor"],
      id: json["ID"],
      iSize: json["ISize"],
      icompany: json["Icompany"],
      imageDescription: json["ImageDescription"],
      imageFile: json["ImageFile"],
      imageFiles: json["ImageFiles"],
      imagePath: json["ImagePath"],
      isActive: json["IsActive"],
      lastDate: json["LastDate"],
      lastRate: (json["LastRate"] ?? 0).todynamic(),
      loosQty: json["LoosQty"],
      looseRate: (json["LooseRate"] ?? 0).todynamic(),
      mrp: (json["MRP"] ?? 0).todynamic(),
      material: json["Material"],
      numberPerCase: json["NUMBERPERCASE"],
      numberPerCase1: json["NUMBERPERCASE1"],
      orgAutoID: json["ORGAUTOID"],
      orgCode: json["ORGCODE"],
      oldHsnCode: json["OldHsnCode"],
      orderCesPer: (json["OrderCesPer"] ?? 0).todynamic(),
      pluCode: json["PLUCODE"],
      pnid: json["PNID"],
      prersupl: json["PRERSUPL"],
      productBL: json["ProductBL"],
      productDupatta: json["ProductDupatta"],
      productGroup: json["ProductGroup"],
      productLining: json["ProductLining"],
      productSL: json["ProductSL"],
      productStyle: json["ProductStyle"],
      productTL: json["ProductTL"],
      productWork: json["ProductWork"],
      prtRecQty: json["PrtRecQty"],
      purPrice: (json["PurPrice"] ?? 0).todynamic(),
      qryStr: json["QryStr"],
      qtnMargPer: (json["QtnMargPer"] ?? 0).todynamic(),
      qtnMargRate: (json["QtnMargRate"] ?? 0).todynamic(),
      rtlProfitPer: (json["RTLProfitPer"] ?? 0).todynamic(),
      registrationID: json["RegistrationID"],
      remarks1: json["Remarks1"],
      remarks2: json["Remarks2"],
      remarks3: json["Remarks3"],
      stkcgstRate: (json["STKCGSTRate"] ?? 0).todynamic(),
      stkdivNum: json["STKDIVNUM"],
      stkgstRate: (json["STKGSTRate"] ?? 0).todynamic(),
      stkhsnCode: json["STKHSNCode"],
      stkigstRate: (json["STKIGSTRate"] ?? 0).todynamic(),
      stksgstRate: (json["STKSGSTRate"] ?? 0).todynamic(),
      stksvrStock: json["STKSVRSTOCK"],
      stockColor: json["STOCKCOLOR"],
      suplID: json["SUPLID"],
      svrEntID: json["SVRENTID"],
      svrstkID: json["SVRSTKID"],
      svrupdyn: json["SVRUPDYN"],
      saleDisPer: (json["SaleDisPer"] ?? 0).todynamic(),
      salePrice: (json["SalePrice"] ?? 0).todynamic(),
      sizeID: json["SizeID"],
      stkOpnRate: (json["Stk_Opn_Rate"] ?? 0).todynamic(),
      stkOpn: json["Stk_opn"],
      stkOpn2: json["Stk_opn2"],
      stockType: json["StockType"],
      subCatID: json["SubCatID"],
      subCategory: json["SubCategory"],
      type: json["TYPE"],
      transactionID: json["TransactionID"],
      units: json["UNITS"],
      units1: json["UNITS1"],
      vatMaster: json["VatMaster"],
      vatMasterOut: json["VatMasterOut"],
      wsPrice: (json["WSPrice"] ?? 0).todynamic(),
      wsProfitPer: (json["WSProfitPer"] ?? 0).todynamic(),
      youtubeLink: json["YouTubeLink"],
      billNo: json["billno"],
      itmCd: json["itm_CD"],
      itmNam: json["itm_NAM"],
      orderType: json["ordertype"],
      pickerValue: json["pickerValue"],
      subgrp: json["subgrp"],
      total: json["total"],
    );
  }
}
