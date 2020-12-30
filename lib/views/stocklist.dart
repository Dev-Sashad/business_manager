import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:records/views/additem.dart';
import 'dart:async';


class Stocklist extends StatefulWidget {
   
  @override
  _StocklistState createState() => _StocklistState();
}

class _StocklistState extends State<Stocklist> {
  bool debugShowCheckedModeBanner = false;
  QuerySnapshot stockList;
  String items, quantity;
  bool isEmpty = true;
  var userIdentity;

    //to delay the loading befor next ation
 Future <bool> checkSession() async {
    await Future.delayed(Duration(milliseconds: 1000), (){});
    return true;
 }

  @override
  void initState() {
      userIdentity= FirebaseAuth.instance.currentUser.uid;
          print('$userIdentity');
        FirebaseFirestore.instance.collection('users').doc(userIdentity)
        .collection('stockList').orderBy("quantity").get().then((value) {

              setState(() {
                stockList = value;
                isEmpty = stockList.docs.isEmpty;
              });
               
        });  
    super.initState();
  }

  ListView _stockList() {
           return ListView.builder(
       itemCount:stockList.docs.length,
       padding: EdgeInsets.only(top:8) ,
      itemBuilder: (context,i){
        items= stockList.docs[i].data()["item"].toString();
        quantity = stockList.docs[i].data()["quantity"].toString();
        return new Container(
          margin: EdgeInsets.symmetric(vertical:5, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.orangeAccent,
            borderRadius: BorderRadius.circular(10)
          ),
          child: Card(
          margin: EdgeInsets.fromLTRB(6, 6, 6, 6),
          child: ListTile(
            contentPadding: null,
            hoverColor: Colors.orangeAccent[100],
            leading: CircleAvatar(radius: 10, backgroundColor: Colors.green,),
            
            title: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                    Text(items, style:TextStyle(color: Colors.black),),
                     
                    Text( quantity, style:TextStyle(color: Colors.black),),
                ],
            ),
          ),
          
        )
        );
      },   
           );      
  }
 
  Scaffold _stocKListIsEmpty(){
           return Scaffold (
                body: Container(
                  alignment: Alignment.center,
                  child: Text('You have no Item in Stock\nClick button to add items', 
                textAlign: TextAlign.center, style: TextStyle(fontSize:15),)),

                floatingActionButtonLocation:FloatingActionButtonLocation.endTop,
     floatingActionButton:FloatingActionButton(
       backgroundColor: Colors.white,
          onPressed: () {
           Navigator.of(context).pushReplacement(
                   MaterialPageRoute(builder: (BuildContext context)=>AddItempage()));
          },
          child: Icon(Icons.add, size: 30, color: Colors.orangeAccent),
          tooltip: 'Add Item',
        ) 
    );  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: 
          Text('Stock List',textAlign:TextAlign.center, 
          style:TextStyle(color: Colors.white, fontSize:25),),
        centerTitle: true,
      ),

      body: (!isEmpty) ? _stockList() : _stocKListIsEmpty(),

    );            
  }

}