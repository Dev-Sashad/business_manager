import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:records/views/sell.dart';


class Salelist extends StatefulWidget {

  @override
  _SalelistState createState() => _SalelistState();
}

class _SalelistState extends State<Salelist> {
bool debugShowCheckedModeBanner = false;
var userIdentity;
  QuerySnapshot salesList;
   bool isEmpty = true;

   getData() async {
 userIdentity= FirebaseAuth.instance.currentUser.uid;
     print('$userIdentity');
   return await FirebaseFirestore.instance.collection('users').doc(userIdentity).collection('sales')
   .orderBy('Date', descending: true)
   .limit(100).get();
 }

     //to delay the loading befor next ation
 Future <bool> checkSession() async {
    await Future.delayed(Duration(milliseconds: 1000), (){});
    return true;
 }

  @override
  void initState(){
    getData().then((results){
      setState(() {
        salesList = results;
         isEmpty = salesList.docs.isEmpty;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
         elevation: 0.0,
        backgroundColor: Colors.orangeAccent,
        title: 
          Text('Sales ',textAlign:TextAlign.center, 
          style:TextStyle(color: Colors.white, fontSize:25),),
        centerTitle: true,
      ),

      body: (!isEmpty) ? _salesList() : _salesListIsEmpty()       
    );           
  }

  ListView _salesList(){
     return ListView.builder(
       itemCount:salesList.docs.length ,
       padding: EdgeInsets.only(top:8) ,
      itemBuilder: (context,i){
        return new Container(
          height: 70,
          width: MediaQuery.of(context).size.width*0.8,
           margin: EdgeInsets.symmetric(vertical:10, horizontal: 15),
           alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius:4 
                )
            ]
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                   Text(salesList.docs[i].data()['Item'], style:TextStyle(color: Colors.green,fontSize:20,
                    fontWeight: FontWeight.bold
                    ),),
                    SizedBox(width:40),
                    Row(children: [
                      Text('Quantity Sold:', style:TextStyle(color: Colors.black,fontSize:15),),
                     SizedBox(width:5),
                   Text(salesList.docs[i].data()['Quantity_sold'].toString(), style:TextStyle(color: Colors.orangeAccent,fontSize:15),),
                  
                    ],),
                ],
                 ),


                 Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(children: [
                    Text('Price:', style:TextStyle(color: Colors.black,fontSize:15),),
                    SizedBox(width:2),
                    Text('₦', style:TextStyle(color: Colors.green,fontSize:15),),
                    SizedBox(width:2),
                    Text(salesList.docs[i].data()['Price'].toString(), style:TextStyle(color: Colors.redAccent,fontSize:15),),
                    
                  ],),
                   SizedBox(width:20),

                    Row(children: [
                    Text(salesList.docs[i].data()['Date'], style:TextStyle(color: Colors.blue,fontSize:15), ),
                    ],)

                       ],
            ), 

            ]
          )
        );
      },
     
      );

  }

  Scaffold _salesListIsEmpty(){ 
          return Scaffold (
                body: Container(
                  alignment: Alignment.center,
                  child: Text('You have no sales record\nClick button to sell item', 
                textAlign: TextAlign.center, style: TextStyle(fontSize:15),)),

                floatingActionButtonLocation:FloatingActionButtonLocation.endTop,
     floatingActionButton:FloatingActionButton(
       backgroundColor: Colors.white,
          onPressed: () {
           Navigator.of(context).pushReplacement(
                   MaterialPageRoute(builder: (BuildContext context)=>Sellstock()));
          },
          child: Icon(Icons.add, size: 30, color: Colors.orangeAccent),
          tooltip: 'Sell Item',
        ) 
    );  
  }
}



                    