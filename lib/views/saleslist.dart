import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class Salelist extends StatefulWidget {

  @override
  _SalelistState createState() => _SalelistState();
}

class _SalelistState extends State<Salelist> {
bool debugShowCheckedModeBanner = false;
var userIdentity;
  QuerySnapshot salesList;

   getData() async {
 userIdentity= FirebaseAuth.instance.currentUser.uid;
     print('$userIdentity');
   return await FirebaseFirestore.instance.collection('users').doc(userIdentity).collection('sales')
   .orderBy('Date', descending: true)
   .limit(100).get();
 }

  @override
  void initState(){
    getData().then((results){
      setState(() {
        salesList = results;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.orangeAccent,
       // actions: <Widget>[
         // IconButton(
         //  icon: Icon((Icons.arrow_back_ios),color: Colors.white,),
         //   onPressed:(){
        //  Navigator.pop(context);
        //    },
        //  ),
        //],
        title: 
          Text('Sales ',textAlign:TextAlign.center, 
          style:TextStyle(color: Colors.white, fontSize:25),),
        centerTitle: true,
      ),

      body: _stockList()      
    );           
  }

  Widget _stockList(){
    if (salesList!=null){

      return ListView.builder(
       itemCount:salesList.docs.length ,
       padding: EdgeInsets.only(top:8) ,
      itemBuilder: (context,i){
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
            leading: CircleAvatar(radius: 10, backgroundColor: Colors.orangeAccent,),
            
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                   Text(salesList.docs[i].data()['Item'], style:TextStyle(color: Colors.green,fontSize:20,
                    fontWeight: FontWeight.bold
                    ),),
                    SizedBox(width:40),
                    Row(children: [
                      Text('Quantity Sold:', style:TextStyle(color: Colors.black,fontSize:15),),
                     SizedBox(width:5),
                   Text(salesList.docs[i].data()['Quantity_sold'].toString(), style:TextStyle(color: Colors.orangeAccent,fontSize:15),),
                  
                    ],)
                     
                ],
            ),

            subtitle: Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(children: [
                    Text('Price:', style:TextStyle(color: Colors.black,fontSize:15),),
                    SizedBox(width:2),
                    Text('₦', style:TextStyle(color: Colors.greenAccent,fontSize:15),),
                    SizedBox(width:2),
                    Text(salesList.docs[i].data()['Price'].toString(), style:TextStyle(color: Colors.redAccent,fontSize:15),),
                    
                  ],),

                    SizedBox(width:20),

                    Row(children: [
                    Text(salesList.docs[i].data()['Date'], style:TextStyle(color: Colors.blue,fontSize:15), ),
                  //  SizedBox(width:2),
                   // Text('/', style:TextStyle(color: Colors.black,fontSize:15),),
                   // SizedBox(width:2),
                  // Text(salesList.docs[i].data()['Time'], style:TextStyle(color: Colors.orange,fontSize:15),),
                    ],)
                   
               ],
            ),

          ),
          
        )
        );
      },
     
      
      );
    }

    else{
      return Text('No sales yet...', textAlign: TextAlign.center,);
    }
    


  }
}