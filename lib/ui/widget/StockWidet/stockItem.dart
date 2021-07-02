import 'package:flutter/material.dart';
import 'package:records/core/model/stock_model.dart';
import 'package:records/utils/constants/screensize.dart';

class StockItem extends StatelessWidget {
  final StockModel stockItem;

  StockItem({this.stockItem});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 70,
        width: MediaQuery.of(context).size.width * 0.8,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
              CircleAvatar(
                radius: 7,
                backgroundColor: Colors.green,
              ),
              SizedBox(width: Responsive.sizeboxheight(context)),
              Text(
                stockItem.item,
                style: TextStyle(color: Colors.black),
              ),
            ]),
            Text(
              stockItem.quantity.toString(),
              style: TextStyle(color: Colors.black),
            ),
          ],
        ));
  }
}
