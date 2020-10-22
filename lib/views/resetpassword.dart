import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:records/homepage.dart';


class ResetPasswordpage extends StatefulWidget {  
  @override

  ResetPasswordpageState createState() => ResetPasswordpageState();
}

class ResetPasswordpageState extends State<ResetPasswordpage> {
final formKey = GlobalKey<FormState>();
String  getoldPassword,oldPassword, newPassword;
DocumentSnapshot userDetails;
var userIdentity;



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
  //password validator
String passwordValidator(String value) {
  
  RegExp lowerCase = new RegExp(r'[a-z]');
  RegExp digit = new RegExp(r'[0-9]');

  if (!lowerCase.hasMatch(value)) {
    return 'Password should contain figure and letters';
  }

  if (!digit.hasMatch(value)) {
    return 'Password should contain figure and letters';
  }
  
  else if (value.length < 8){
     return 'password should contain 8 characters';
  }
   else 
    return null; 
}

 // loadng dialoge
void _loadingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.transparent,
          title: new Text(""),
          content: Container(
            height: MediaQuery.of(context).size.height*0.15,
          child:SpinKitChasingDots(
        color: Colors.orangeAccent ,
        size: 50,
       // duration: Duration(milliseconds:3000),
      ),
          )
        );
      },
    );
  }

  //to delay the loading befor next ation
 Future <bool> checkSession() async {
    await Future.delayed(Duration(milliseconds: 5000), (){});
    return true;
 }


 void _passwordSucessfullyChanged() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Password successfully changed"),
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

void _passwordNotSucessfullyChanged() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Wrong Old password"),
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

Future <void> initState() async {

 userIdentity= FirebaseAuth.instance.currentUser.uid;
     print('$userIdentity');
   await FirebaseFirestore.instance.collection('users').doc(userIdentity).get().then((value){
      setState(() {
       userDetails = value;
      });

      if (userDetails!=null){  
        getoldPassword = userDetails.data()['password'].toString();
   }
     
});
 super.initState();
}



  @override
  Widget build(BuildContext context) {
   return Scaffold(
          appBar: AppBar(
        
        backgroundColor: Colors.orangeAccent,
        title: 
          Text('Change Password',textAlign:TextAlign.center, 
          style:TextStyle(color: Colors.white, fontSize:25),),
        centerTitle: true,
      ),

      body: Column(
        children: [
          
        Form(key:formKey,
        child: Column(
        children: <Widget>[
          container(
          TextFormField(decoration: buildSignupInputDecoration('old password'),
          
          onChanged: (value){
            this.oldPassword = value;
          },
          
          validator: passwordValidator,
          ),
          ),

          SizedBox(height:10),

          container(
          TextFormField(decoration: buildSignupInputDecoration('new password'),

               validator: passwordValidator,
          onChanged: (value){
              this.newPassword = value;       
          },),
          ),
        ]
        )
        ),

            flatbutton(
             FlatButton(onPressed:() {
              if(validate()){
                   _loadingDialog();
                  checkSession().then((value) { 
            if(getoldPassword != oldPassword){
              _passwordNotSucessfullyChanged();
            }
            else{
           FirebaseAuth.instance.authStateChanges().listen((User user) {
                  DocumentReference documentReference = FirebaseFirestore.instance.collection('users').doc(userIdentity);
                  FirebaseFirestore.instance.runTransaction((Transaction transaction) async{

                transaction.update(documentReference, {
                "password": newPassword, 
                });    
            });

                user.updatePassword(newPassword);
                   _passwordSucessfullyChanged();                 
           });
            }
              }
                  );
              }
        },
      child: Text('Change Password', style: TextStyle(fontSize:20, color:Colors.white),)
      )
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