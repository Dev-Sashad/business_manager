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
int quantity;

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
          title: new Text("Item successfully Added"),
          content: new Text("Thank you"),
          actions: <Widget>[
            flatbutton(
            FlatButton(
              child: new Text("Go to Homepage", style: TextStyle(fontSize:20, color:Colors.white),),
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
        children: <Widget>[

            container(
          TextFormField(decoration: buildSignupInputDecoration('enter product name'),
          onChanged: (value){
            this.productName = value;
          },
          
          validator: itemNameValidator,
          ),
            ),

          SizedBox(height:10),

            container(
          TextFormField(decoration: buildSignupInputDecoration('quantity'),

               validator: (value){
          return value.isEmpty ? 'enter a quantity':null; 
             },
          onChanged: (value){
            
            if(value!=null){
              this.quantity = int.parse(value);
            }
            else{
              this.quantity=0;
            }
          },),
            )

        ]
      ),
          ),

        flatbutton(
       FlatButton(onPressed:() {
            if(validate()){
          if (productName!=null && quantity>=0){
            
              FirebaseAuth.instance.authStateChanges().listen((User user) {
                  userIdentity= user.uid;
                  firestoreInstance.runTransaction((Transaction transaction) async{  
                   CollectionReference reference = firestoreInstance.collection('users').doc(userIdentity).collection('stockList');
                await reference.add({"item":productName.toString(), "quantity":quantity});
            });
               });            
                _itemSucessfullyAdded();
          }

          else if (productName=null || quantity<0){
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
     fontSize: 10,
      fontFamily: 'Montserrat',
      color: Colors.grey,
      ),     
      border: InputBorder.none
      );

}

Container container (TextFormField child){
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