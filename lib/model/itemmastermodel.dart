class ItemMasterModel {
  dynamic? id;
  dynamic? svrstkid;
  dynamic? orgautoid;
  dynamic? itmCd;
  String? plucode;
  String? genname;
  String? productGroup;
  String? itmNam;
  dynamic? salePrice;
  dynamic? wsPrice;
  dynamic? mrp;
  dynamic? purPrice;
  dynamic? costPrice;
  dynamic? expdtyn;
  String? vatMaster;
  String? vatMasterOut;
  dynamic? stkOpn;
  dynamic? stkOpn2;
  dynamic? alQty;
  String? units;
  String? units1;
  String? department;
  String? subgrp;
  String? icompany;
  dynamic? suplid;
  String? prersupl;
  dynamic? dropped;
  String? isize;
  String? type;
  String? displayGrp;
  dynamic? dgId;
  dynamic? dgndx;
  String? clrGroup;
  String? material;
  String? iColor;
  dynamic? numberPerCase;
  dynamic? looseRate;
  dynamic? loosQty;
  dynamic? stkOpnRate;
  String? stockType;
  dynamic? cost;
  String? remarks1;
  String? remarks2;
  String? remarks3;
  dynamic? addedBy;
  String? addedDtm;
  dynamic? modifyBy;
  String? modifyDtm;
  String? socid;
  dynamic? stkcgstrRate;
  dynamic? stksgstrRate;
  dynamic? stkigstrRate;
  dynamic? stkgstrRate;
  dynamic? stkhsnCode;
  dynamic? gstitmcd;
  dynamic? wsProfitPer;
  dynamic? rtlProfitPer;
  dynamic? saleDisPer;
  dynamic? numberPerCase1;
  dynamic? qtnMargPer;
  dynamic? qtnMargRate;
  dynamic? oldHsnCode;
  dynamic? svrUpdYn;
  String? clientTransId;
  String? clientPrFix;
  dynamic? stksvrStock;
  dynamic? stkdivNum;
  dynamic? finalStock;
  dynamic? catId;
  String? category;
  dynamic? subCatId;
  String? subCategory;
  dynamic? pnid;
  dynamic? sizeId;
  String? productWork;
  String? productStyle;
  String? productDupatta;
  String? productTl;
  String? productBl;
  String? productSl;
  String? productLining;
  String? youTubeLink;
  String? designCode;
  dynamic? designNo;

  // Constructor
  ItemMasterModel({
    this.id,
    this.svrstkid,
    this.orgautoid,
    this.itmCd,
    this.plucode,
    this.genname,
    this.productGroup,
    this.itmNam,
    this.salePrice,
    this.wsPrice,
    this.mrp,
    this.purPrice,
    this.costPrice,
    this.expdtyn,
    this.vatMaster,
    this.vatMasterOut,
    this.stkOpn,
    this.stkOpn2,
    this.alQty,
    this.units,
    this.units1,
    this.department,
    this.subgrp,
    this.icompany,
    this.suplid,
    this.prersupl,
    this.dropped,
    this.isize,
    this.type,
    this.displayGrp,
    this.dgId,
    this.dgndx,
    this.clrGroup,
    this.material,
    this.iColor,
    this.numberPerCase,
    this.looseRate,
    this.loosQty,
    this.stkOpnRate,
    this.stockType,
    this.cost,
    this.remarks1,
    this.remarks2,
    this.remarks3,
    this.addedBy,
    this.addedDtm,
    this.modifyBy,
    this.modifyDtm,
    this.socid,
    this.stkcgstrRate,
    this.stksgstrRate,
    this.stkigstrRate,
    this.stkgstrRate,
    this.stkhsnCode,
    this.gstitmcd,
    this.wsProfitPer,
    this.rtlProfitPer,
    this.saleDisPer,
    this.numberPerCase1,
    this.qtnMargPer,
    this.qtnMargRate,
    this.oldHsnCode,
    this.svrUpdYn,
    this.clientTransId,
    this.clientPrFix,
    this.stksvrStock,
    this.stkdivNum,
    this.finalStock,
    this.catId,
    this.category,
    this.subCatId,
    this.subCategory,
    this.pnid,
    this.sizeId,
    this.productWork,
    this.productStyle,
    this.productDupatta,
    this.productTl,
    this.productBl,
    this.productSl,
    this.productLining,
    this.youTubeLink,
    this.designCode,
    this.designNo,
  });

  // Convert ItemMasterModel to a Map<String, dynamic> for SQLite insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'SVRSTKID': svrstkid,
      'ORGAUTOID': orgautoid,
      'itm_CD': itmCd,
      'PLUCODE': plucode,
      'GENNAME': genname,
      'ProductGroup': productGroup,
      'itm_NAM': itmNam,
      'SalePrice': salePrice,
      'WSPrice': wsPrice,
      'MRP': mrp,
      'PurPrice': purPrice,
      'CostPrice': costPrice,
      'EXPDTYN': expdtyn,
      'VatMaster': vatMaster,
      'VatMasterOut': vatMasterOut,
      'Stk_opn': stkOpn,
      'Stk_opn2': stkOpn2,
      'ALQTY': alQty,
      'UNITS': units,
      'UNITS1': units1,
      'Department': department,
      'subgrp': subgrp,
      'Icompany': icompany,
      'SUPLID': suplid,
      'PRERSUPL': prersupl,
      'DROPPED': dropped,
      'ISize': isize,
      'TYPE': type,
      'DisplayGrp': displayGrp,
      'DGID': dgId,
      'DGNDX': dgndx,
      'ClrGroup': clrGroup,
      'Material': material,
      'IColor': iColor,
      'NUMBERPERCASE': numberPerCase,
      'LooseRate': looseRate,
      'LoosQty': loosQty,
      'Stk_Opn_Rate': stkOpnRate,
      'StockType': stockType,
      'Cost': cost,
      'Remarks1': remarks1,
      'Remarks2': remarks2,
      'Remarks3': remarks3,
      'AddedBy': addedBy,
      'AddedDTM': addedDtm,
      'ModifyBy': modifyBy,
      'ModifyDTM': modifyDtm,
      'SOCID': socid,
      'STKCGSTRate': stkcgstrRate,
      'STKSGSTRate': stksgstrRate,
      'STKIGSTRate': stkigstrRate,
      'STKGSTRate': stkgstrRate,
      'STKHSNCode': stkhsnCode,
      'GSTITMCD': gstitmcd,
      'WSProfitPer': wsProfitPer,
      'RTLProfitPer': rtlProfitPer,
      'SaleDisPer': saleDisPer,
      'NUMBERPERCASE1': numberPerCase1,
      'QtnMargPer': qtnMargPer,
      'QtnMargRate': qtnMargRate,
      'OldHsnCode': oldHsnCode,
      'SVRUPDYN': svrUpdYn,
      'CLIENTTRANSID': clientTransId,
      'CLIENTPRFIX': clientPrFix,
      'STKSVRSTOCK': stksvrStock,
      'STKDIVNUM': stkdivNum,
      'FinalStock': finalStock,
      'CatID': catId,
      'Category': category,
      'SubCatID': subCatId,
      'SubCategory': subCategory,
      'PNID': pnid,
      'SizeID': sizeId,
      'ProductWork': productWork,
      'ProductStyle': productStyle,
      'ProductDupatta': productDupatta,
      'ProductTL': productTl,
      'ProductBL': productBl,
      'ProductSL': productSl,
      'ProductLining': productLining,
      'YouTubeLink': youTubeLink,
      'DesignCode': designCode,
      'DesignNo': designNo,
    };
  }

  // Create an instance of ItemMasterModel from a Map<String, dynamic>
  factory ItemMasterModel.fromMap(Map<String, dynamic> map) {
    return ItemMasterModel(
      id: map['id'],
      svrstkid: map['SVRSTKID'],
      orgautoid: map['ORGAUTOID'],
      itmCd: map['itm_CD'],
      plucode: map['PLUCODE'],
      genname: map['GENNAME'],
      productGroup: map['ProductGroup'],
      itmNam: map['itm_NAM'],
      salePrice: map['SalePrice'],
      wsPrice: map['WSPrice'],
      mrp: map['MRP'],
      purPrice: map['PurPrice'],
      costPrice: map['CostPrice'],
      expdtyn: map['EXPDTYN'],
      vatMaster: map['VatMaster'],
      vatMasterOut: map['VatMasterOut'],
      stkOpn: map['Stk_opn'],
      stkOpn2: map['Stk_opn2'],
      alQty: map['ALQTY'],
      units: map['UNITS'],
      units1: map['UNITS1'],
      department: map['Department'],
      subgrp: map['subgrp'],
      icompany: map['Icompany'],
      suplid: map['SUPLID'],
      prersupl: map['PRERSUPL'],
      dropped: map['DROPPED'],
      isize: map['ISize'],
      type: map['TYPE'],
      displayGrp: map['DisplayGrp'],
      dgId: map['DGID'],
      dgndx: map['DGNDX'],
      clrGroup: map['ClrGroup'],
      material: map['Material'],
      iColor: map['IColor'],
      numberPerCase: map['NUMBERPERCASE'],
      looseRate: map['LooseRate'],
      loosQty: map['LoosQty'],
      stkOpnRate: map['Stk_Opn_Rate'],
      stockType: map['StockType'],
      cost: map['Cost'],
      remarks1: map['Remarks1'],
      remarks2: map['Remarks2'],
      remarks3: map['Remarks3'],
      addedBy: map['AddedBy'],
      addedDtm: map['AddedDTM'],
      modifyBy: map['ModifyBy'],
      modifyDtm: map['ModifyDTM'],
      socid: map['SOCID'],
      stkcgstrRate: map['STKCGSTRate'],
      stksgstrRate: map['STKSGSTRate'],
      stkigstrRate: map['STKIGSTRate'],
      stkgstrRate: map['STKGSTRate'],
      stkhsnCode: map['STKHSNCode'],
      gstitmcd: map['GSTITMCD'],
      wsProfitPer: map['WSProfitPer'],
      rtlProfitPer: map['RTLProfitPer'],
      saleDisPer: map['SaleDisPer'],
      numberPerCase1: map['NUMBERPERCASE1'],
      qtnMargPer: map['QtnMargPer'],
      qtnMargRate: map['QtnMargRate'],
      oldHsnCode: map['OldHsnCode'],
      svrUpdYn: map['SVRUPDYN'],
      clientTransId: map['CLIENTTRANSID'],
      clientPrFix: map['CLIENTPRFIX'],
      stksvrStock: map['STKSVRSTOCK'],
      stkdivNum: map['STKDIVNUM'],
      finalStock: map['FinalStock'],
      catId: map['CatID'],
      category: map['Category'],
      subCatId: map['SubCatID'],
      subCategory: map['SubCategory'],
      pnid: map['PNID'],
      sizeId: map['SizeID'],
      productWork: map['ProductWork'],
      productStyle: map['ProductStyle'],
      productDupatta: map['ProductDupatta'],
      productTl: map['ProductTL'],
      productBl: map['ProductBL'],
      productSl: map['ProductSL'],
      productLining: map['ProductLining'],
      youTubeLink: map['YouTubeLink'],
      designCode: map['DesignCode'],
      designNo: map['DesignNo'],
    );
  }
}
