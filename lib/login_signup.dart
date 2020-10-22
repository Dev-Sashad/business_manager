import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:records/homepage.dart';
import 'package:records/loading.dart';
import 'package:records/services/authentication.dart';

 


enum AuthFormType {
  signIn, signUp
}                                                                                     

class LoginSignupPage extends StatefulWidget {
   final AuthFormType authFormType;
   LoginSignupPage ({
   @required this.authFormType
});

  

  @override
  MyLoginSignupPageState createState() => MyLoginSignupPageState(authFormType: this.authFormType);
}

class MyLoginSignupPageState extends State<LoginSignupPage> {
  final BaseAuth auth= Auth();
  AuthFormType authFormType;
  MyLoginSignupPageState ({this.authFormType});

  final formKey = GlobalKey<FormState>();
  final forgetPasswordformKey = GlobalKey<FormState>();
  final buttonKey = GlobalKey<FormState>();
 String _email= '', _password= '', resetEmailPassword;
String userName='';
bool loading=false;
String error;
String state;
bool _passwordVisible;
var userIdentity;
void switchFormState (state){
   formKey.currentState.reset();
   if  (state == 'signUp'){
     setState(() {
      //loading=true;
       authFormType = AuthFormType.signUp;
     });
   }
   else if (state == 'signIn') {
     setState(() {
     // loading=true;
     authFormType = AuthFormType.signIn;
     });
   }
 }

 

 Future <bool> checkSession() async {
    await Future.delayed(Duration(milliseconds: 5000), (){});
    return true;
 }
//email validator
 String emailValidator(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return 'Email format is invalid';
  }
  
  else if (value.isEmpty){
     return 'enter email';
  }
   else 
    return null;
  
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

//validate bool for forget password
bool validateEmail(){

  final form = forgetPasswordformKey.currentState;
   if(form.validate()){
     form.save();
     return true;
  }
  else{
    return false;
    }
 }


//Forget Password dialog
Future <bool> forgetPassword (BuildContext context) async{
return showDialog(
  context: context,
  builder: (BuildContext context){
    return AlertDialog(
      
      title: Row( 
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
        Text('Forget Password', style: TextStyle(fontSize:15,), textAlign: TextAlign.center,),

        FlatButton(onPressed: (){
             Navigator.of(context).pop();
         }, 
          
         child:Icon(Icons.cancel, color: Colors.grey,),
         
         ),
        ]),
      content: Padding(
        padding: EdgeInsets.all(10),
           child:Container(
          height: MediaQuery.of(context).size.height*0.2,
        child: Form(key:forgetPasswordformKey,
        child: Column(
        children: <Widget>[
          TextFormField(decoration: InputDecoration(hintText: 'enter email'),
          
          onChanged: (value){
            this.resetEmailPassword = value;
          },
          
          validator: emailValidator,
          ),

          SizedBox(height:10),

        ]
      ),
        ),
     ),
      ),
      actions: <Widget>[
        FlatButton(onPressed:() async {
        if(validateEmail()) {
  await FirebaseAuth.instance.sendPasswordResetEmail(email: resetEmailPassword);
        Navigator.of(context).pop();  
       return _showforgotPasswordDialog();
        }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
     color: Colors.greenAccent,
      child: Text('Reset'))
      ],
    );
  }

);
}

//Loading dialoge for signup
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
        color: Colors.orangeAccent[200],
        size: 50,
       // duration: Duration(milliseconds:3000),
      ),
          )
        );
      },
    );
  }


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


void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {             
               Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (BuildContext context)=>LoginSignupPage(authFormType: AuthFormType.signIn))
  );
              },
            ),
          ],
        );
      },
    );
  }

  void _showwrongCredentialsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Invalid Credentials"),
          content: new Text("kindly provide valid details"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {             
               Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showwrongPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Incorrect password"),
          content: new Text(""),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {             
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  void _showVerifyEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Email is not verified"),
          content: new Text("kindly login to your mail for verification"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
             onPressed: () {             
               Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (BuildContext context)=>LoginSignupPage(authFormType: AuthFormType.signIn))
  );
              },
            ),
          ],
        );
      },
    );
  }

  void _showforgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Link to reset password has been sent to this mail"),
          content: new Text("kindly login to your mail"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {             
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _useralreadyexistDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(" user already exist"),
          content: new Text("kindly login to your account"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {             
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void submit() async {
  //Create user
  if ( authFormType == AuthFormType.signUp){
if (validate()){
     auth.signUp(_email, _password).then((value) async {
          if(value != null){
                User user = FirebaseAuth.instance.currentUser;
                user.sendEmailVerification();
                print('Signed up user: $value');
              userIdentity= value.user.uid;
               print('Signed up user: $userIdentity');
             _loadingDialog();
             checkSession().then((value){ 
              
             FirebaseFirestore.instance.collection('users').doc(userIdentity).set({'email':_email, 'username':userName, 'password':_password});
              _showVerifyEmailSentDialog();
});
          }
    }).catchError((msg) {
      if (msg.code == 'weak-password') {
    print('The password provided is too weak.');
  } else 
    if(msg.code == 'email-already-in-use') {
      print('user already exist');
       _useralreadyexistDialog();  
  }
    }); 
 }
  }

//Else for signIN a user  
else {
  if (validate()){
    auth.signIn(_email, _password).catchError((error) {    
      if (error.code == 'user-not-found') {
    print('No user found for this email.');
        _showwrongCredentialsDialog();
  } else if (error.code == 'wrong-password') {
    print('Wrong password provided for that user.');
    _showwrongPasswordDialog();
  }
  }).then((result) async {
      
          _loadingDialog();
          checkSession().then((value) async {
                if (value){
                  User user = FirebaseAuth.instance.currentUser;

               if(!user.emailVerified){
                 user.sendEmailVerification();
                 FirebaseAuth.instance.signOut();
                    _showVerifyEmailDialog();
                }
         
           
             else{  
              Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context)=>HomePage())
           );
                } 

          }});
  });        
  }
} 
}

  @override
  void initState() {
    _passwordVisible = true;
    super.initState();
  }


 
 
  @override
  Widget build(BuildContext context) {
    return loading? Loading() :  Scaffold(
       body: LayoutBuilder(
         builder: (ctx, constrains){
           return Scaffold(
      body: Container(
        height: constrains.maxHeight,
        child:SingleChildScrollView(
  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,               
                    child: Column(
                      children: <Widget>[
                       
                       Container(
                              padding: EdgeInsets.only(top:30),
                    height: MediaQuery.of(context).size.height*0.4,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                    gradient: LinearGradient(
                begin: Alignment.topCenter,
               colors: [
                  Colors.orangeAccent[200],
                Colors.orangeAccent,
                Colors.orangeAccent[100],
               ]
              ),             
               borderRadius: BorderRadius.only( bottomRight: Radius.circular(30)),
                              ),
                              child: Column(
                                children: [

                             Image.asset('assets/user.png',
                   height: MediaQuery.of(context).size.height*0.23, alignment: Alignment.center,),

                   // SizedBox(height:5),

                    buildHeaderText(),
                                ],
                              ),
                            ),
                       SizedBox(height:5),
                      
                      Expanded(

            child: Column(
              
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,     
              children: <Widget>[

               Padding(
               padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),

               child: Form(key:formKey,
               
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: buildInputs()    
                ),
                ),
               ),      
        ],
      ),
       ),

       BottomAppBar(
             
       child: Padding(
               padding: const EdgeInsets.symmetric(horizontal:0),

               child: Form(key:buttonKey,
               
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:buildButton()   
                ),
                ),
               ),
              ),       
                      ]
                    )
                  
           
    ))));
         }
       )
    );

    
  }

  Container buildHeaderText(){

      String headerText;
      if (authFormType == AuthFormType.signUp){
            headerText = 'Create New Account';
      }
      else {
            headerText = 'LOGIN';
      }
      return Container(
              alignment: Alignment.topLeft,
                  margin: EdgeInsets.fromLTRB(15,5,0,0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                       Text(
                    headerText, style: TextStyle(
                      fontSize:30 , color: Colors.blue,fontWeight: FontWeight.bold, fontFamily: 'pacifico',), 
                      textAlign: TextAlign.left
                      ),
                        
                         SizedBox(height:1),
              
                    Text('we aim at ensuring adequate keeping \nof your records for proper bussines monitoring.',style: TextStyle(
                      fontSize:15,color:Colors.white, fontStyle: FontStyle.italic
                    ),
                    textAlign: TextAlign.left
                    )
                      ]
                    )
          );
  }
  
  List<Widget> buildInputs(){
List <Widget> textFields = [];

 if (authFormType == AuthFormType.signUp){

textFields.add(
TextFormField(
  decoration: buildSignupInputDecoration(
    Icon(Icons.person, color: Colors.grey,),
    'Enter a username',
   // ignore: missing_required_param
   IconButton(icon: Icon(null))
   ),
  validator: (value){
   return value.length <6 ? 'enter username 6 char long ':null;
     },
    onSaved: (value) {
  return this.userName = value;

   }
),  
);

textFields.add(SizedBox(height:10));
}

textFields.add(
TextFormField(
  decoration: buildSignupInputDecoration(
    Icon(Icons.mail, color: Colors.grey,),
    'Email',
    // ignore: missing_required_param
    IconButton(icon: Icon(null))
    ),
  
  validator: emailValidator,
   onSaved: (value) {
   return _email = value;
     }
),  
);

textFields.add(SizedBox(height:10));

textFields.add(
TextFormField(
  decoration: buildSignupInputDecoration(
    Icon(Icons.lock,color: Colors.grey,),
  'Password',
  IconButton(
     icon: Icon(
              // Based on passwordVisible state choose the icon
               _passwordVisible
               ? Icons.visibility
               : Icons.visibility_off,
               color: Colors.grey,
               ),
            onPressed: () {
               // Update the state i.e. toogle the state of passwordVisible variable
               setState(() {
                   _passwordVisible = !_passwordVisible;
               });
             },
            ),
  ),

validator: passwordValidator,
   obscureText: _passwordVisible,
   onSaved: (value) {
  return _password = value;

}

),  
);
return textFields;
}

InputDecoration buildSignupInputDecoration( Icon prefixIcon, String hint, IconButton suffixIcon) {
return InputDecoration(
      
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
     hintText: hint,
     hintStyle: TextStyle( 
     fontSize: 15,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold,
      color: Colors.grey,
      ),
     // fillColor: Colors.white,
     // focusColor: Colors.white,
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width:1.0), 
      borderRadius: BorderRadius.circular(10),),
      contentPadding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
      );

}
 
 List<Widget> buildButton(){
    String forgotPasswordText,switchButtonText1,switchButtonText2, newFormState, submitButtonText;

    if (authFormType == AuthFormType.signIn){
    forgotPasswordText= 'Forgot Password';  
    switchButtonText1 = 'New User?';
    switchButtonText2 = 'Create New Account';
    newFormState = 'signUp';
    submitButtonText = 'Login';
    }
    else if (authFormType == AuthFormType.signUp) {
      forgotPasswordText= ''; 
      switchButtonText1 = 'Already have an account?';
      switchButtonText2 = 'SignIn';
      newFormState= 'signIn';
      submitButtonText= 'Register';
    }
  
  return  [
          Padding(padding: EdgeInsets.only(bottom:0),
                   child:FlatButton(
                     child:Text(forgotPasswordText, style: 
                   TextStyle(fontSize:15, color:Colors.greenAccent, fontWeight: FontWeight.bold),
                     ),
                      onPressed: (){
                        setState(() {
                          forgetPassword(context);
                        });
                      }
          ),),

                 //  SizedBox(height:10,),

          Container(

               child: Row(
                 children: <Widget>[
                   Container(
                     
                     alignment: Alignment.bottomLeft,
                height:  MediaQuery.of(context).size.height*0.15,
                width:  MediaQuery.of(context).size.width*0.5,
                child: FlatButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                  color: Colors.greenAccent,
                    onPressed: submit,
                   child: Center(
                     child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                       children: <Widget>[
                     Text(submitButtonText,
                     style: TextStyle(
                       color: Colors.white,
                       fontSize: 25,
                       fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                     )),

                      SizedBox(width:5),

                      Icon(Icons.arrow_forward_ios, color:Colors.white, size:  35,),

                       ]
                     )
                   ), 
                    )
                   ),

                  
    Container(
       alignment: Alignment.bottomRight,
      height: MediaQuery.of(context).size.height*0.15,
      width:  MediaQuery.of(context).size.width*0.5,
   child: FlatButton(
     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
     color: Colors.orangeAccent,
      onPressed: (){
        setState(() {
           switchFormState(newFormState);
        });
       
      }, 
      child: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        Text(switchButtonText1, style: TextStyle(color: Colors.grey, fontSize: 15,),),
        SizedBox(height:5),
         Text(switchButtonText2, style: TextStyle(color: Colors.white, fontSize: 15,),),
        ]
        )
          ),
         ) 
         )
                 ],
               )
              ),

 
  ];          
  } 


}