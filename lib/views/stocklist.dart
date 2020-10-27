import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class Stocklist extends StatefulWidget {
   
  @override
  _StocklistState createState() => _StocklistState();
}

class _StocklistState extends State<Stocklist> {
  bool debugShowCheckedModeBanner = false;
  QuerySnapshot stockList;
  String items, quantity;
  var userIdentity;

   getData() async{
    
     userIdentity= FirebaseAuth.instance.currentUser.uid;
     print('$userIdentity');
      return await FirebaseFirestore.instance.collection('users').doc(userIdentity).collection('stockList').orderBy("quantity").get();
   
 }

  @override
  void initState(){
    getData().then((results){
      setState(() {
        stockList = results;
       
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        //actions: <Widget>[
          //IconButton(
         //  icon: Icon((Icons.arrow_back_ios),color: Colors.white,),
          //  onPressed:(){
          //Navigator.pop(context);
         //   },
         // ),
        //],
        title: 
          Text('Stock List',textAlign:TextAlign.center, 
          style:TextStyle(color: Colors.white, fontSize:25),),
        centerTitle: true,
      ),

      body: _stockList()      
    );           
  }

  Widget _stockList(){
    if (stockList!=null){
       //print('${stockList.docs}');
      return ListView.builder(
       itemCount:stockList.docs.length,
       padding: EdgeInsets.only(top:8) ,
      itemBuilder: (context,i){
        items= stockList.docs[i].data()["item"].toString();
        quantity = stockList.docs[i].data()["quantity"].toString();
        return new Container(
          margin: EdgeInsets.symmetric(vertical:5, horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.orangeAccent,
            borderRadius: BorderRadius.circular(10)
          ),
          child: Card(
          margin: EdgeInsets.fromLTRB(10, 6, 10, 6),
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

    
    else{
      return Text('Loading, Please wait......', textAlign: TextAlign.center,);
    }
    


  }
}