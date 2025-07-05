class PartyMasterModel {
  dynamic? id;
  dynamic? accAutoId;
  dynamic? orgAutoid;
  String? byrCd;
  String? byrNam;
  String? accAddress;
  String? accAddress1;
  String? accAddress2;
  String? accCity;
  String? accState;
  String? phoneNo;
  String? pinCode;
  String? email;
  String? lcno;
  String? cmnt;
  String? groups;
  String? grphandle;
  String? grpunder;
  String? sbgrp;
  dynamic? opcrblc;
  dynamic? opdrblc;
  dynamic? opbls;
  dynamic? copbls;
  String? ltype;
  String? actyp;
  dynamic? mssb;
  String? fob1;
  String? cntry1;
  String? email2;
  String? contactperson;
  String? contacttitle;
  String? accountno;
  dynamic? baltype;
  dynamic? pcap;
  String? mngrp;
  String? plbal;
  String? ledtype;
  dynamic? tdsyn;
  String? cstno;
  String? stno;
  String? transport;
  String? custype;
  dynamic? isdropped;
  String? reltype;
  dynamic? relid;
  String? worktype;
  String? panno;
  String? vatno;
  String? refno1;
  dynamic refno2;
  dynamic refno3;
  dynamic? accorgautoid;
  String? nature;
  dynamic? impCode;
  dynamic? svrupdyn;
  String? clienttransid;
  String? clientprfix;
  dynamic? maxCreditDays;
  dynamic? maxCreditAmount;
  dynamic? clBalance;
  String? clBalColor;
  dynamic? recalcDate;
  // Constructor
  PartyMasterModel({
    this.id,
    this.accAutoId,
    this.orgAutoid,
    this.byrCd,
    this.byrNam,
    this.accAddress,
    this.accAddress1,
    this.accAddress2,
    this.accCity,
    this.accState,
    this.phoneNo,
    this.pinCode,
    this.email,
    this.lcno,
    this.cmnt,
    this.groups,
    this.grphandle,
    this.grpunder,
    this.sbgrp,
    this.opcrblc,
    this.opdrblc,
    this.opbls,
    this.copbls,
    this.ltype,
    this.actyp,
    this.mssb,
    this.fob1,
    this.cntry1,
    this.email2,
    this.contactperson,
    this.contacttitle,
    this.accountno,
    this.baltype,
    this.pcap,
    this.mngrp,
    this.plbal,
    this.ledtype,
    this.tdsyn,
    this.cstno,
    this.stno,
    this.transport,
    this.custype,
    this.isdropped,
    this.reltype,
    this.relid,
    this.worktype,
    this.panno,
    this.vatno,
    this.refno1,
    this.refno2,
    this.refno3,
    this.accorgautoid,
    this.nature,
    this.impCode,
    this.svrupdyn,
    this.clienttransid,
    this.clientprfix,
    this.maxCreditDays,
    this.maxCreditAmount,
    this.clBalance,
    this.clBalColor,
    this.recalcDate,
  });

  // Convert PartyMasterModel to a Map<String, dynamic> for SQLite insertion
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "AccAutoID": accAutoId,
      "OrgAutoid": orgAutoid,
      "Byr_Cd": byrCd,
      "Byr_nam": byrNam,
      "AccAddress": accAddress,
      "AccAddress1": accAddress1,
      "AccAddress2": accAddress2,
      "AccCity": accCity,
      "AccState": accState,
      "PhoneNo": phoneNo,
      "PinCode": pinCode,
      "EMAIL": email,
      "LCNO": lcno,
      "CMNT": cmnt,
      "GROUPS": groups,
      "GRPHANDLE": grphandle,
      "GRPUNDER": grpunder,
      "sbgrp": sbgrp,
      "OPCRBLC": opcrblc,
      "OPDRBLC": opdrblc,
      "OPBLS": opbls,
      "COPBLS": copbls,
      "LTYPE": ltype,
      "ACTYP": actyp,
      "MSSB": mssb,
      "FOB1": fob1,
      "CNTRY1": cntry1,
      "EMAIL2": email2,
      "CONTACTPERSON": contactperson,
      "CONTACTTITLE": contacttitle,
      "ACCOUNTNO": accountno,
      "BALTYPE": baltype,
      "pcap": pcap,
      "MNGRP": mngrp,
      "PLBAL": plbal,
      "LEDTYPE": ledtype,
      "TDSYN": tdsyn,
      "CSTNO": cstno,
      "STNO": stno,
      "TRANSPORT": transport,
      "CUSTYPE": custype,
      "ISDROPPED": isdropped,
      "RELTYPE": reltype,
      "RELID": relid,
      "WORKTYPE": worktype,
      "PANNO": panno,
      "VATNO": vatno,
      "REFNO1": refno1,
      "REFNO2": refno2,
      "REFNO3": refno3,
      "ACCORGAUTOID": accorgautoid,
      "NATURE": nature,
      "ImpCode": impCode,
      "SVRUPDYN": svrupdyn,
      "CLIENTTRANSID": clienttransid,
      "CLIENTPRFIX": clientprfix,
      "MaxCreditDays": maxCreditDays,
      "MaxCreditAmount": maxCreditAmount,
      "CLBalance": clBalance,
      "CLBalColor": clBalColor,
      "RecalcDate": recalcDate,
    };
  }

  // Create an instance of PartyMasterModel from a Map<String, dynamic>
  factory PartyMasterModel.fromMap(Map<String, dynamic> map) {
    return PartyMasterModel(
        id: map["id"],
        accAutoId: map["AccAutoID"],
        orgAutoid: map["OrgAutoid"],
        byrCd: map["Byr_Cd"],
        byrNam: map["Byr_nam"],
        accAddress: map["AccAddress"],
        accAddress1: map["AccAddress1"],
        accAddress2: map["AccAddress2"],
        accCity: map["AccCity"],
        accState: map["AccState"],
        phoneNo: map["PhoneNo"],
        pinCode: map["PinCode"],
        email: map["EMAIL"],
        lcno: map["LCNO"],
        cmnt: map["CMNT"],
        groups: map["GROUPS"],
        grphandle: map["GRPHANDLE"],
        grpunder: map["GRPUNDER"],
        sbgrp: map["sbgrp"],
        opcrblc: map["OPCRBLC"],
        opdrblc: map["OPDRBLC"],
        opbls: map["OPBLS"],
        copbls: map["COPBLS"],
        ltype: map["LTYPE"],
        actyp: map["ACTYP"],
        mssb: map["MSSB"],
        fob1: map["FOB1"],
        cntry1: map["CNTRY1"],
        email2: map["EMAIL2"],
        contactperson: map["CONTACTPERSON"],
        contacttitle: map["CONTACTTITLE"],
        accountno: map["ACCOUNTNO"],
        baltype: map["BALTYPE"],
        pcap: map["pcap"],
        mngrp: map["MNGRP"],
        plbal: map["PLBAL"],
        ledtype: map["LEDTYPE"],
        tdsyn: map["TDSYN"],
        cstno: map["CSTNO"],
        stno: map["STNO"],
        transport: map["TRANSPORT"],
        custype: map["CUSTYPE"],
        isdropped: map["ISDROPPED"],
        reltype: map["RELTYPE"],
        relid: map["RELID"],
        worktype: map["WORKTYPE"],
        panno: map["PANNO"],
        vatno: map["VATNO"],
        refno1: map["REFNO1"],
        refno2: map["REFNO2"],
        refno3: map["REFNO3"],
        accorgautoid: map["ACCORGAUTOID"],
        nature: map["NATURE"],
        impCode: map["ImpCode"],
        svrupdyn: map["SVRUPDYN"],
        clienttransid: map["CLIENTTRANSID"],
        clientprfix: map["CLIENTPRFIX"],
        maxCreditDays: map["MaxCreditDays"],
        maxCreditAmount: map["MaxCreditAmount"],
        clBalance: map["CLBalance"],
        clBalColor: map["CLBalColor"],
        recalcDate: map["RecalcDate"]
    );
  }
}
