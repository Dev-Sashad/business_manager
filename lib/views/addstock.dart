import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:records/homepage.dart';


class Addstock extends StatefulWidget {  
  @override

  _AddStockState createState() => _AddStockState();
}

class _AddStockState extends State<Addstock> {
  bool debugShowCheckedModeBanner = false;
 // final firestoreInstance = FirebaseFirestore.instance;  
  QuerySnapshot addList;
 var selectedItem;
 String itemName;
 int index;
 int quantity,initQuantity;
 var item, itemQuantity=0, documentId,actualQuantity=0;
  var userIdentity;
 getData() async {
     userIdentity= FirebaseAuth.instance.currentUser.uid;
     print('$userIdentity');
   return await FirebaseFirestore.instance.collection('users').doc(userIdentity).collection('stockList').orderBy("quantity").get();
 }

  @override
  void initState(){
    getData().then((results){
      setState(() {
        addList = results;
      });
    });

    super.initState();
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

  void _addStockSucessful() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Stock was successfully added"),
          content: new Text("Thank you"),
          actions: <Widget>[
            
            flatbutton(
             FlatButton(
              child: new Text("Dismiss",  style: TextStyle(fontSize:20, color:Colors.white),),
              onPressed: () {             
               //authFormType = AuthFormType.signIn;
              Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (BuildContext context)=>HomePage())
  );
               // loading=false;
              },
            ),
            )
          ],
        );
      },
    );
  }

void _addStockNotSucessful() {
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
              child: new Text("Dismiss",  style: TextStyle(fontSize:20, color:Colors.white),),
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
        title: 
          Text('Add Stock',textAlign:TextAlign.center, 
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
    padding: EdgeInsets.fromLTRB(10, 40, 10, 0),
   child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
     
     children: [
       _listView(),
       SizedBox(height: 20,),
      Container(
        padding: EdgeInsets.symmetric(vertical:10, horizontal: 10),
        width: MediaQuery.of(context).size.width*0.7,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.orangeAccent,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(5)
          
        ),

        child: Text( itemQuantity.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize:30,),
        textAlign: TextAlign.center,
      ), 
      ),
      
      SizedBox(height:30),

      Text('Quantity', style:TextStyle(color: Colors.black, fontWeight:FontWeight.bold, fontSize: 20)),

   SizedBox(height:15),

     
           Row(
             mainAxisSize: MainAxisSize.max,
             
             mainAxisAlignment:MainAxisAlignment.center,
           children: <Widget>[
             _conatiner(quantity=50 ),
             _conatiner(quantity=100),
             _conatiner(quantity=200),
           ],),

           SizedBox(height:15),

           Row(
             mainAxisSize: MainAxisSize.max,
           
             mainAxisAlignment:MainAxisAlignment.center,
           children: <Widget>[
             _conatiner(quantity=500),
             _conatiner(quantity=1000),
             _conatiner(quantity=2000),
           ],),
     
     SizedBox(height:30),

     Container (
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width*0.7,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.greenAccent,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(5)
          
        ),
        child:Row(
          
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
           
           Container(
             width: MediaQuery.of(context).size.width*0.5,
             child: TextFormField(
               style: TextStyle(
                 fontSize: 30,
                 fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                color: Colors.black,
               ), 
          keyboardType: TextInputType.number,
        decoration: buildSignupInputDecoration(actualQuantity.toString(),),
        validator: stockValidator,
        textAlign: TextAlign.center,
        onChanged: (newQuantity){
          setState(() {
            actualQuantity= int.parse(newQuantity);
          });
           
        }
        
        
        ),
           ),

        SizedBox(width:10),

        IconButton(onPressed: (){

          if (actualQuantity > 0 && selectedItem!=null){

           DocumentReference documentReference = FirebaseFirestore.instance.collection('users').doc(userIdentity).collection('stockList').doc(documentId);
                  FirebaseFirestore.instance.runTransaction((Transaction transaction) async{
                  
                DocumentSnapshot snapshot = await transaction.get(documentReference);
                int newQuantity = snapshot.data()['quantity'] + actualQuantity ;
                print('new Quantity=$newQuantity');

                transaction.update(documentReference, {"quantity": newQuantity});
            
                   return newQuantity;     
            });
            _addStockSucessful();       
          //Navigator.of(context).pop();
         }  

         else  if (actualQuantity <= 0 || selectedItem==null) {
            _addStockNotSucessful();
         }    

        },
                
         icon: Icon(Icons.subdirectory_arrow_right, color:Colors.greenAccent, size:35,)),
         
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

  FlatButton _conatiner(quantity){
    return FlatButton(
      child:Container(
      height: 70,
      width: 80,
      alignment: Alignment.center,
      child: Text(quantity.toString(), style: TextStyle(fontSize:20, fontWeight: FontWeight.bold,
      color: Colors.black), textAlign: TextAlign.center,),
      decoration: BoxDecoration(
        border: Border.all(width:1.5, color:Colors.orangeAccent),
        borderRadius: BorderRadius.circular(10)
      ),
      ),
      onPressed: () {
        setState(() {
          actualQuantity=quantity;
        });
        
      },
    );
  }

  // ignore: missing_return
  Widget _listView(){
  
    if (addList !=null){
      List<String>stockList=[];
      
      for(int i=0; i < addList.docs.length; i++){
        
        item = addList.docs[i].data()["item"];
        
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
                 
                   itemQuantity = addList.docs[index].data()["quantity"];
                    documentId = addList.docs[index].id;
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

   InputDecoration buildSignupInputDecoration(  String hint) {
return InputDecoration(
     hintText: hint,
     hintStyle: TextStyle( 
     fontSize: 30,
      fontFamily: 'Montserrat',
      color: Colors.grey,
      ),     
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(vertical:5),
      );

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
  
}

