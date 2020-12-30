import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:records/homepage.dart';
import './login_signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


void main() async {
WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();
 Timer(Duration (seconds: 2 ), (){
 return runApp(MyApp()
 );
 });
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application. 
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
     debugShowCheckedModeBanner: false,
      home: MainPage()
    );
  }

}



class MainPage extends StatefulWidget {
 

  @override
  State<StatefulWidget> createState() => new _MainPageState();
}


class _MainPageState extends State<MainPage> {
  
  @override
  void initState() {
    checkSession().then((value){
    if  (value){
          User user = FirebaseAuth.instance.currentUser;
        if(user != null && user.emailVerified ){
                _navigatetoHome();              
            } 

    else if (user != null && !user.emailVerified ) {
         FirebaseAuth.instance.signOut();
      _navigatetoLogin();
    }


    else{
      _navigatetoLogin();
    }
      
    }
    }
    );

    super.initState();
  }

  Future <bool> checkSession() async {
    await Future.delayed(Duration(milliseconds: 8000), (){});
    return true;
  }

void _navigatetoLogin(){
  Navigator.pushReplacement(context,
    MaterialPageRoute(builder: (BuildContext context)=>LoginSignupPage(authFormType: AuthFormType.signIn))
  );
}

void _navigatetoHome(){
  Navigator.pushReplacement(context,
    MaterialPageRoute(builder: (BuildContext context)=>HomePage())
  );
}

  @override
  Widget build(BuildContext context) {   
return Scaffold(
       body: LayoutBuilder(
         builder: (ctx, constrains){
           return Scaffold(
      body: Container(
        height: constrains.maxHeight,
        child:SingleChildScrollView(
  child: Container(
     child: Column(
       children: <Widget>[
          Container(
           height: MediaQuery.of(context).size.height,
           width:double.infinity,
          // padding: EdgeInsets.only(left:20),
           decoration: BoxDecoration(
             color: Colors.white
            ), 

            child: Column(  
              crossAxisAlignment: CrossAxisAlignment.center,
             mainAxisAlignment: MainAxisAlignment.center,
             //verticalDirection: VerticalDirection.down,
          children: <Widget>[

            Image.asset('assets/logo.png', 
           // width:MediaQuery.of(context).size.width*0.3, 
            height: MediaQuery.of(context).size.height*0.3,),
            SizedBox(height:20),

            Shimmer.fromColors(child:       Text('My Records',style: TextStyle(
                      fontSize:50 , fontFamily: 'Pacifico', fontWeight: FontWeight.w700), ),
                       baseColor: Colors.lightBlueAccent[200],
                        highlightColor: Colors.lightBlueAccent[100] ),

            SizedBox(height:40),

            SpinKitFadingCircle(color: Colors.lightBlueAccent[200],
                            size: 40,
                
                            )         
        
     
      ],),
         ),
       ],
     )
  ) 
    )
      )
       );
         }
       )
);     

}
}
