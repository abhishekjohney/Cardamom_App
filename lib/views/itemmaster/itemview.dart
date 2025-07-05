



import 'package:flutter/material.dart';

import '../../model/itemmastermodel.dart';

class ItemView extends StatefulWidget {

  ItemMasterModel item;
  ItemView({super.key, required this.item});

  @override
  State<ItemView> createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.orange.shade700,iconTheme: IconThemeData(color: Colors.white),
        title: Text("Item View",style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 20,),
            Center(child: Image.asset("assets/images/itempic.png",width: MediaQuery.of(context).size.width/3,)),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text("${widget.item.itmNam}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
            ),
            Text("(${widget.item.itmCd})",),
            Text("${widget.item.productGroup}",),
            Text("${widget.item.alQty}",),
            Text("${widget.item.costPrice}",),
            Text("${widget.item.salePrice}",),
            Text("${widget.item.category}",),
            Text("${widget.item.mrp}",),
            Text("${widget.item.remarks1}",),
            Text("${widget.item.wsPrice}",),
            Text("${widget.item.pnid}",),
            Text("${widget.item.id}",),




          ],
        ),
      ),
    );
  }
}
