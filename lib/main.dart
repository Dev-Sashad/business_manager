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
 return runApp(MyApp());
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
      FirebaseAuth.instance.authStateChanges().listen((User user) async {
        if(user != null){
        if (!user.emailVerified) {
              FirebaseAuth.instance.signOut();
      _navigatetoLogin();              
            } 

    else {
        _navigatetoHome(); 
    }}


    else{
      _navigatetoLogin();
    }
      });
      
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
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (BuildContext context)=>LoginSignupPage(authFormType: AuthFormType.signIn))
  );
}

void _navigatetoHome(){
  Navigator.of(context).pushReplacement(
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
              //gradient: LinearGradient(
              //  begin: Alignment.topRight,
              //  end: Alignment.bottomLeft,
               // colors: [
               //   Colors.orangeAccent[400],
                //  Colors.orange[300],
               //   Colors.orangeAccent[200],
               // ]
             // ),
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
                       baseColor: Colors.orangeAccent[200],
                        highlightColor: Colors.orangeAccent[100] ),

            SizedBox(height:40),

            SpinKitFadingCircle(color: Colors.orangeAccent[200],
                            size: 30,
                
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
