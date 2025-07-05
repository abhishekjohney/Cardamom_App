



import 'package:flutter/material.dart';
import 'package:shopapp/model/PartyMasterModel.dart';

class PartyView extends StatefulWidget {

  PartyMasterModel party;
  PartyView({super.key, required this.party});

  @override
  State<PartyView> createState() => _PartyViewState();
}

class _PartyViewState extends State<PartyView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.orange.shade700,iconTheme: IconThemeData(color: Colors.white),
        title: Text("Party View",style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 20,),
            Center(child: Image.asset("assets/images/party.png",width: MediaQuery.of(context).size.width/3,)),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text("${widget.party.byrNam}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
            ),
            Text("(${widget.party.impCode})",),
            Text("${widget.party.phoneNo}",),
            Text("${widget.party.accAddress}",),
            Text("${widget.party.groups}",),
            Text("${widget.party.panno}",),
            Text("${widget.party.worktype}",),
            Text("${widget.party.vatno}",),
            Text("${widget.party.pinCode}",),
            Text("${widget.party.cmnt}",),
            Text("${widget.party.maxCreditDays}",),
            Text("${widget.party.id}",),




          ],
        ),
      ),
    );
  }
}
