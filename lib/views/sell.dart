import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:records/homepage.dart';
import 'package:records/services/authentication.dart';


class Sellstock extends StatefulWidget {
  
  final BaseAuth auth;
  Sellstock({this.auth});
  @override
  
  _SellStockState createState() => _SellStockState();
}

class _SellStockState extends State<Sellstock> {
  bool debugShowCheckedModeBanner = false;
  final firestoreInstance = FirebaseFirestore.instance;
  QuerySnapshot sellList;
 var selectedItem, newDateTime; //, newTime;
 int index ,actualQuantity;
 String itemName;
 int price = 0, quantity, newprice = 0;

 //var newDate= DatePickerEntryMode.calendar;
 //var newTime= TimeOfDayFormat.HH_colon_mm;
 var item, itemQuantity=0, documentId, userIdentity;
   getData() async {
    userIdentity= FirebaseAuth.instance.currentUser.uid;
     print('$userIdentity');
   return await FirebaseFirestore.instance.collection('users').doc(userIdentity).collection('stockList').orderBy("quantity").get();
 }

  @override
  void initState(){
    getData().then((results){
      setState(() {
        sellList = results;
      });
    });
    super.initState();
  }

   void _salesSucessful() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Your sale was successful. Thank you", textAlign: TextAlign.center),
          content: new Text("Would you like to make another sale?\nClick OK", textAlign: TextAlign.center),
          actions: <Widget>[
           Row(
              children:[
                Align(
                  alignment:Alignment.bottomLeft,
                  child:   flatbutton(
            FlatButton(
              child: new Text("goto home", style: TextStyle(fontSize:20, color:Colors.white),),
              onPressed: () {             
             
              Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (BuildContext context)=>HomePage())
  );
               // loading=false;
              },),)),

               Align(
                  alignment:Alignment.bottomRight,
                  child:   flatbutton(
            FlatButton(
              child: new Text("Ok", style: TextStyle(fontSize:20, color:Colors.white),),
              onPressed: () {             
                    Navigator.pop(context);
              },),)),
         
              ]
            )
          ],
        );
      },
    );
  }

  //Stock validator

String stockValidator(String value) {
  
  RegExp digit = new RegExp(r'[0-9]');

  if (!digit.hasMatch(value)) {
    return 'enter only digits';
  }

   else if (value.isEmpty){
     return 'enter quantity';
  }

  else if (int.parse(value) > itemQuantity){
    return 'quantity to sell is greater than available quantity';
  }
   else 
    return null;
  
}

  void _salesNotSucessful() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Your sale was not successful"),
          content: new Text("enter/check your inputs"),
          actions: <Widget>[
              flatbutton(
             FlatButton(
              child: new Text("Dismiss", style: TextStyle(fontSize:20, color:Colors.white),),
              onPressed: () {             
               //authFormType = AuthFormType.signIn;
              Navigator.of(context).pop();
               // loading=false;
              },
            ),
              )
          ],
        );
      },
    );
  }
            
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         elevation: 0.0,
        backgroundColor: Colors.orangeAccent,
        title: 
          Text('Sell Stock',textAlign:TextAlign.center, 
          style:TextStyle(color: Colors.white, fontSize:25),),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
  child: Container(
     decoration: BoxDecoration(
         color:  Colors.white
        ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
  child: Padding(
  padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
   child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
     
     children: [
       _listView(),

       SizedBox(height:30),
      Text('Available Quantity', style:TextStyle(color: Colors.black, fontWeight:FontWeight.bold,fontSize:20)),
       SizedBox(height: 10,),

       design(
         child: Material(
            color:Colors.white,
        child: Text(itemQuantity.toString(), style: TextStyle(fontSize:30,),
        textAlign: TextAlign.center,
      ),
         ) 
      ),

      SizedBox(height:20),
      Text('Unit Price', style:TextStyle(color: Colors.black, fontWeight:FontWeight.bold,fontSize:20)),
       SizedBox(height: 10,),

       design(
         child: Material(
           color:Colors.white,
        child: Text('₦ ${price.toString()}', style: TextStyle(fontSize:30,),
        textAlign: TextAlign.center,
      ),
         ) 
      ),
      
      SizedBox(height:20),

      Text('Purchase Quantity', style:TextStyle(color: Colors.black, fontWeight:FontWeight.bold, fontSize: 20)),

   SizedBox(height:15),
     
           Row(
             mainAxisSize: MainAxisSize.max,
             
             mainAxisAlignment:MainAxisAlignment.center,
           children: <Widget>[
             _conatiner(quantity=5 ),
             _conatiner(quantity=10),
             _conatiner(quantity=20),
           ],),

           SizedBox(height:15),

           Row(
             mainAxisSize: MainAxisSize.max,
           
             mainAxisAlignment:MainAxisAlignment.center,
           children: <Widget>[
             _conatiner(quantity=50),
             _conatiner(quantity=100),
             _conatiner(quantity=200),
           ],),

             SizedBox(height:10),
           
           design(
             child:Material(
                color:Colors.white,
             child:TextFormField( 
                 style: TextStyle(
                 fontSize: 30,
                fontFamily: 'Montserrat',
                color: Colors.black,
               ), 
          keyboardType: TextInputType.number,
        decoration: buildSignupInputDecoration((actualQuantity != null)? actualQuantity.toString():'0'),
          validator: stockValidator,
        textAlign: TextAlign.center,

        onChanged: (newQuantity){
          setState(() {
            actualQuantity= int.parse(newQuantity);
          });
            if(newQuantity != null){
                newprice = price * actualQuantity;
            }

            else{
                 newprice = price * 1; 
            }      
        },
        ),
           )
           ),
     
     SizedBox(height:30),

        design ( 
            child: Material(
           color:Colors.white,
        child:Row(   
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
        Image.asset('assets/naira.png'),
          
        Text((newprice != null)? newprice.toString():'0', style: TextStyle( color:Colors.black, fontSize: 30),),

        InkWell(onTap: (){
if (selectedItem==null || actualQuantity<=0 || actualQuantity > itemQuantity){
              _salesNotSucessful();
          }

          else{
      var date = new DateTime.now().toString();
 
      var dateParse = DateTime.parse(date);
 
       var formattedDateTime = "${dateParse.day}-${dateParse.month}-${dateParse.year} / ${dateParse.hour}:${dateParse.minute}:${dateParse.second}";

    setState(() {
 
      newDateTime = formattedDateTime.toString() ;
      //newTime = formattedTime.toString();
 
    });
    userIdentity= FirebaseAuth.instance.currentUser.uid;
  DocumentReference documentReference = FirebaseFirestore.instance.collection('users').doc(userIdentity).collection('stockList').doc(documentId);
 firestoreInstance.runTransaction((Transaction transaction) async{ 
    CollectionReference reference = FirebaseFirestore.instance.collection('users').doc(userIdentity).collection('sales');
  await reference.add(

  {
    "Item" : selectedItem,
    "Price": newprice,
    "Quantity_sold": actualQuantity,
    "Date": newDateTime,
    //"Time": newTime,
  });

  DocumentSnapshot snapshot = await transaction.get(documentReference);
                int newQuantity = snapshot.data()['quantity'] - actualQuantity ;
                print('new Quantity=$newQuantity');

                transaction.update(documentReference, {"quantity": newQuantity});
            
                   return newQuantity; 
 });
          _salesSucessful();
        }   
        },
        
         child: Icon(Icons.subdirectory_arrow_right, color:Colors.greenAccent,size:35,)),

         
        ],
      ),
      )
        )

   ],)
   )
  ) 
  ),
    );
  }

  FlatButton _conatiner(quantity){
    return FlatButton(
      child:Container(
       height: 70,
      width: 80,
      alignment: Alignment.center,
      child: Text(quantity.toString(), style: TextStyle(fontSize:20, fontWeight: FontWeight.bold,
      color: Colors.black), textAlign: TextAlign.center,),
      decoration: BoxDecoration(
        color:Colors.white,
        border: Border.all(width:1.0, color:Colors.orangeAccent),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius:4
          )
        ]
      ),
      ),
      onPressed: () {
        setState(() {
            actualQuantity= quantity;
             if(actualQuantity != null){
                newprice = price * actualQuantity;
            }

            else{
                 newprice = price * 1;
            }
        });
    
      },
    );
  }

   Widget _listView(){
  
    if (sellList !=null){
      List<String>stockList=[];
      
      for(int i=0; i < sellList.docs.length; i++){
        
        item = sellList.docs[i].data()["item"];
        
              stockList.add(
                item.toString() 
              );
      }
        return new Container(
           child:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              
              children: <Widget>[
                Icon(Icons.store, size:25, color: Colors.orangeAccent),
                SizedBox(width:10),

                Container(
                  width: MediaQuery.of(context).size.width*0.6,
                 height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Color(0xFFF2F2F2)
                   ),
                child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.orange[50], // background color for the dropdown items
              buttonTheme: ButtonTheme.of(context).copyWith(
                alignedDropdown: true,  //If false (the default), then the dropdown's menu will be wider than its button.
              )
            ),
            child: DropdownButtonHideUnderline(

                child: DropdownButton(items: stockList.map((String value)          
                {
                return new DropdownMenuItem<String>(
                   value: value,
                  child: new Text(value),
                     );
                         }).toList(),
                iconSize: 30,
                
                onChanged: (stockItemsValue){
                  setState(() {             
                       selectedItem=stockItemsValue;
                       print(selectedItem);  
                  });
                  index = stockList.indexOf(stockItemsValue);
                  
                 print('$index');
                 
                   itemQuantity = sellList.docs[index].data()["quantity"];
                   price = sellList.docs[index].data()["price"];
                   documentId = sellList.docs[index].id;
                      print('$documentId'); 
                },
                value: selectedItem,
                isExpanded: false,
                hint: Text('select stock', style: TextStyle(color: Colors.black)),
                ),
                ),
                )
                )
              ],
            ),);
            
  } 


     else{
      return Container(
           child:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              
              children: <Widget>[
                Icon(Icons.store, size:25, color: Colors.orangeAccent),
                SizedBox(width:10),
      
                    Container(
                  width: MediaQuery.of(context).size.width*0.6,
                 height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Color(0xFFF2F2F2)
                   ),
                child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.orange[50], // background color for the dropdown items
              buttonTheme: ButtonTheme.of(context).copyWith(
                alignedDropdown: true,  //If false (the default), then the dropdown's menu will be wider than its button.
              )
            ),
            child: DropdownButtonHideUnderline(

                child: DropdownButton(
                iconSize: 30,
                isExpanded: false,
                hint: Text('select stock', style: TextStyle(color: Colors.black)),
                onChanged: (value) {  },
                items: [],
                ),
                ),
                )
                )
              ]
           )
      );
    }
    
  }

Container flatbutton (FlatButton child){
return Container(
  width: 100,
  margin: EdgeInsets.symmetric(horizontal:10),
                child: Material(
                  borderRadius: BorderRadius.circular(5),
                  shadowColor: Colors.grey,
                  color: Colors.green,
                  elevation: 2.0,
                  child: child,
                    )
              );
}

 InputDecoration buildSignupInputDecoration(  String hint) {
return InputDecoration(
     hintText: hint,
     hintStyle: TextStyle( 
     fontSize: 30,
      fontFamily: 'Montserrat',
      color: Colors.black,
      ),     
      border: InputBorder.none
      );

}

Container design ({ Material child}){
  return   Container(
        padding: EdgeInsets.symmetric(vertical:5, horizontal: 10),
        width: MediaQuery.of(context).size.width*0.7,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.orangeAccent,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(7)
          
        ),

        child: child 
      );
    }
  
}