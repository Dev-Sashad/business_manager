import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:records/homepage.dart';


class AddItempage extends StatefulWidget {  
  @override

  AddItempageState createState() => AddItempageState();
}

class AddItempageState extends State<AddItempage> {
final formKey = GlobalKey<FormState>();
var userIdentity;
final firestoreInstance = FirebaseFirestore.instance;
var productName ;
int quantity, price;

 bool validate(){
final form = formKey.currentState;
   if(form.validate()){
     form.save();
     return true;
   }
   else{
     return false;
   }
 }

//Item name validator

String itemNameValidator(String value) {
  
  RegExp upperCase = new RegExp(r'[A-Z]');
 

  if (!upperCase.hasMatch(value)) {
    return 'Item name should start with caps';
  }
  
  else if (value.isEmpty){
     return 'enter item name';
  }
   else 
    return null;
  
}

void _itemSucessfullyAdded() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Item successfully Added, Thank you", textAlign: TextAlign.center),
          content: new Text("Would you like to new Item?\nClick OK", textAlign: TextAlign.center),
          actions: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
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

void _itemNotSucessfullyAdded() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Item not successfully Added"),
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
              elevation: 0.0,
        automaticallyImplyLeading: false,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),
        
         onPressed: (){
            Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (BuildContext context)=>HomePage())
  );
        }),
        backgroundColor: Colors.orangeAccent,
        title: 
          Text('Add Item',textAlign:TextAlign.center, 
          style:TextStyle(color: Colors.white, fontSize:25),),
        centerTitle: true,
      ),       

      body: Column(
        children: [

        Form(key:formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
              SizedBox(height:50),
            container(
              Row (
                children:[
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width*0.7,
            margin: EdgeInsets.symmetric(horizontal:10),
            child: TextFormField(decoration: buildSignupInputDecoration('enter product name'),
          style: TextStyle(
                 fontSize: 20,
                fontFamily: 'Montserrat',
                color: Colors.black,
               ), 
          keyboardType: TextInputType.text,
          onChanged: (value){
            this.productName = value;
          },
          
          validator: itemNameValidator,
          ),
          )
                ]
              )
            ),

          SizedBox(height:15),

            container(
              Row(
                children:[
          Container (
            height: 50,
            width: MediaQuery.of(context).size.width*0.7,
            margin: EdgeInsets.symmetric(horizontal:10),
            child: TextFormField(decoration: buildSignupInputDecoration('quantity'),
                   style: TextStyle(
                 fontSize: 20,
                fontFamily: 'Montserrat',
                color: Colors.black,
               ), 
          keyboardType: TextInputType.number,
               validator: (value){
          return value.isEmpty ? 'enter stock quantity':null; 
             },
          onChanged: (value){
                 
            if(value!=null){
              this.quantity = int.parse(value);
            }
            else{
              this.quantity=0;
            }
          
          },
          ),
          )
                ]
              )
            ),

            SizedBox(height:15),

            container(
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:[
                  Image.asset('assets/naira.png', height:40),

                Container(
                  height: 50,
            width: MediaQuery.of(context).size.width*0.7,
            margin: EdgeInsets.symmetric(horizontal:10),
              child: TextFormField(decoration: buildSignupInputDecoration('unit price'),
                   style: TextStyle(
                 fontSize: 20,
                fontFamily: 'Montserrat',
                color: Colors.black,
               ), 
          keyboardType: TextInputType.number,
               validator: (value){
          return value.isEmpty ? 'enter unit price of item':null; 
             },
          onChanged: (value){
              if(value!=null){
              this.price = int.parse(value);
            }
            else{
              this.price =0;
            }
          },
          ),
                )
                ]
              )
            )

        ]
      ),
          ),
            SizedBox(height:40),

        flatbutton(
       FlatButton(onPressed:() {
            if(validate()){
          if (productName!=null && quantity>=0){
            
              FirebaseAuth.instance.authStateChanges().listen((User user) {
                  userIdentity= user.uid;
                  firestoreInstance.runTransaction((Transaction transaction) async{  
                   CollectionReference reference = firestoreInstance.collection('users').doc(userIdentity).collection('stockList');
                await reference.add({
                "item":productName.toString(),
                 "quantity":quantity,
                 "price":price,
                 });
            });
               });            
                _itemSucessfullyAdded();
          }

          else if (productName=null || quantity <0){
            _itemNotSucessfullyAdded();
          }
          
            }     
        },
      child: Text('Add', style: TextStyle(fontSize:20, color:Colors.white)))
        )
        ]
      ),
   );
  }

   InputDecoration buildSignupInputDecoration(  String hint) {
return InputDecoration(
     hintText: hint,
     hintStyle: TextStyle( 
     fontSize: 15,
      fontFamily: 'Montserrat',
      color: Colors.grey,
      ),     
      border: InputBorder.none,
      contentPadding: const EdgeInsets.only(left:20)
      );

}

Container container (Row child){
return Container(
        margin: EdgeInsets.symmetric(horizontal:20),
                child: Material(
                  borderRadius: BorderRadius.circular(5),
                  shadowColor: Colors.grey,
                  color: Colors.white,
                  elevation: 2.0,
                  child: child,
                    )
              );
}

Container flatbutton (FlatButton child){
return Container(
  margin: EdgeInsets.symmetric(horizontal:10),
  width: 100,
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