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
 int price,actualPrice=0;

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
          title: new Text("Your sale was successful"),
          content: new Text("Thank you"),
          actions: <Widget>[
            flatbutton(
             FlatButton(
              child: new Text("Dismiss", style: TextStyle(fontSize:20, color:Colors.white),),
              onPressed: () {             
               //authFormType = AuthFormType.signIn;
              Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (BuildContext context)=>HomePage())
  );
             },
            ),
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
   else 
    return null;
  
}

  void _salesNotSucessful() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("enter/select a value"),
          content: new Text(""),
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
        backgroundColor: Colors.orangeAccent,
        actions: <Widget>[
          IconButton(
           icon: Icon((Icons.arrow_back_ios),color: Colors.white,),
            onPressed:(){
              Navigator.of(context).pop();
            },
          ),
        ],
        title: 
          Text('Sell Stock',textAlign:TextAlign.center, 
          style:TextStyle(color: Colors.white, fontSize:25),),
        centerTitle: true,
      ),

      body: LayoutBuilder(
         
         builder: (ctx, constrains){
           return Scaffold(
      body: Container(
        decoration: BoxDecoration(
           //image: DecorationImage(
           // image: AssetImage("assets/background.png"),
           // fit: BoxFit.cover,
         // ),
         color:  Colors.white
        ),
        height: constrains.maxHeight,
        child:SingleChildScrollView(
  child: Container(
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
       Container(
        padding: EdgeInsets.symmetric(vertical:5, horizontal: 10),
        width: MediaQuery.of(context).size.width*0.7,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.orangeAccent,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(7)
          
        ),

        child: Text(itemQuantity.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize:30,),
        textAlign: TextAlign.center,
      ), 
      ),

      SizedBox(height:20),
           
           Container(
             width: MediaQuery.of(context).size.width*0.7,
             child:TextFormField( 
        
        decoration: buildSignupInputDecoration('enter quantity to sell'),
          validator: stockValidator,
        textAlign: TextAlign.center,

        onChanged: (newQuantity){
          setState(() {
            actualQuantity= int.parse(newQuantity);
          });
              
        },
        
        ),),
      
      SizedBox(height:20),

      Text('Price', style:TextStyle(color: Colors.black, fontWeight:FontWeight.bold, fontSize: 20)),

   SizedBox(height:15),

     
           Row(
             mainAxisSize: MainAxisSize.max,
             
             mainAxisAlignment:MainAxisAlignment.center,
           children: <Widget>[
             _conatiner(price=50 ),
             _conatiner(price=100),
             _conatiner(price=200),
           ],),

           SizedBox(height:15),

           Row(
             mainAxisSize: MainAxisSize.max,
           
             mainAxisAlignment:MainAxisAlignment.center,
           children: <Widget>[
             _conatiner(price=500),
             _conatiner(price=1000),
             _conatiner(price=2000),
           ],),
     
     SizedBox(height:30),

     Container (
       padding: EdgeInsets.symmetric(vertical:10),
        width: MediaQuery.of(context).size.width*0.7,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.greenAccent,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(7)
          
        ),
        child:Row(
          
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
           
           Container(
             width: MediaQuery.of(context).size.width*0.5,
             child: TextFormField(   
        decoration: InputDecoration(
          border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(horizontal:10, vertical:10),
        hintText: actualPrice.toString(),
        hintStyle: TextStyle(fontWeight:FontWeight.bold, color:Colors.black , fontSize:20,),
        prefixIcon: Image.asset('assets/naira.png', ),
        ),
        validator: stockValidator,
        textAlign: TextAlign.center,
        onChanged: (newPrice){

          setState(() {
            actualPrice= int.parse(newPrice);
          });            
        },   
        ),
           ),

        SizedBox(width:10),

        InkWell(onTap: (){
if (selectedItem==null || actualPrice<=0 || actualQuantity<=0 ){
              _salesNotSucessful();
          }

          else{
      var date = new DateTime.now().toString();
 
      var dateParse = DateTime.parse(date);
 
       var formattedDateTime = "${dateParse.day}-${dateParse.month}-${dateParse.year} / ${dateParse.hour}:${dateParse.minute}";
     // var formattedTime = "${dateParse.hour}:${dateParse.minute}";

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
    "Price": actualPrice,
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
      ),)

   ],)
   )
  ) 
  ),
  )
  );})
    );
  }

  FlatButton _conatiner(price){
    return FlatButton(
      child:Container(
       height: 70,
      width: 80,
      alignment: Alignment.center,
      child: Text(price.toString(), style: TextStyle(fontSize:20, fontWeight: FontWeight.bold,
      color: Colors.black), textAlign: TextAlign.center,),
      decoration: BoxDecoration(
        border: Border.all(width:1.0, color:Colors.orangeAccent),
        borderRadius: BorderRadius.circular(10)
      ),
      ),
      onPressed: () {
        setState(() {
            actualPrice= price;
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
              canvasColor: Colors.orangeAccent[100], // background color for the dropdown items
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
      return Text('Loading, Please wait...');
    }
    
  }

Container flatbutton (FlatButton child){
return Container(
  margin: EdgeInsets.symmetric(horizontal:20),
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
     fontSize: 10,
      fontFamily: 'Montserrat',
      color: Colors.grey,
      ),     
      border: InputBorder.none
      );

}
  
}