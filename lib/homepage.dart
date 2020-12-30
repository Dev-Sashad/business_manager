import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:records/login_signup.dart';
import 'package:records/views/additem.dart';
import 'package:records/views/addstock.dart';
import 'package:records/views/resetpassword.dart';
import 'package:records/views/saleslist.dart';
import 'package:records/views/sell.dart';
import 'package:records/views/stocklist.dart';
import 'package:records/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'menuitem.dart';


class HomePage extends StatefulWidget{
 //bool debugShowCheckedModeBanner = false;
@override
  HomePageState createState() => HomePageState();
} 



class HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
final BaseAuth auth= Auth();

var userIdentity,welcomeText=" " ;
final firestoreInstance = FirebaseFirestore.instance;
final formKey = GlobalKey<FormState>();
QuerySnapshot salesList;
DocumentSnapshot userName;
bool isEmpty = true;
double total = 0.0;
// to get recently sold data
   getData() async {
       userIdentity= FirebaseAuth.instance.currentUser.uid;
     print('$userIdentity');
   return await FirebaseFirestore.instance.collection('users')
   .doc(userIdentity)
   .collection('sales')
   .orderBy('Date', descending: true)
   .limit(4).get();
 }
//to get to sales in price
 void getTotalSales() async {
        userIdentity= FirebaseAuth.instance.currentUser.uid;
    print('$userIdentity');
  await FirebaseFirestore.instance.collection('users').
  doc(userIdentity).
  collection('sales').
  orderBy('Quantity_sold').
  get().then((value){
  
  if (value!=null){
     for(int i=0; i < value.docs.length; i++){
   total += value.docs[i].data()['Price'];
   }
   return total;
  }

  });
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
  
  void logout() async{
    await FirebaseAuth.instance.signOut().then((value){
     Navigator.pushReplacement(context, 
     MaterialPageRoute(builder: (BuildContext context)=>LoginSignupPage(authFormType:AuthFormType.signIn)));
     }); 
  }
  
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds:300);
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;
  Animation<Offset> _slideAnimation;
  StreamController<bool> isCollapsedStreamController;
  Stream <bool> isCollapsedStream;
  StreamSink<bool> isCollapsedSink;

  @override
   
   void initState () {
    super.initState();
      //to get recently sold
     getData().then((results){
      setState(() {
        salesList = results;
        isEmpty = salesList.docs.isEmpty;
      });
    });

      //to get total sales
      getTotalSales();
    userIdentity= FirebaseAuth.instance.currentUser.uid;
     print('$userIdentity');
   FirebaseFirestore.instance.collection('users').doc(userIdentity).get().then((username){
      setState(() {
       userName = username;
      });

      if (userName != null){  
       return welcomeText = userName.data()['username'].toString();
   }

   else if (userName = null) {
     return welcomeText= "  ";
   }

   });
  

    _controller = AnimationController(vsync:this, duration: duration);
     _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
      _menuScaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(_controller);
     _slideAnimation = Tween<Offset>(begin: Offset(-0.5, 0), end: Offset(0, 0),).animate(_controller);
    isCollapsedStreamController = PublishSubject<bool>();
    isCollapsedStream = isCollapsedStreamController.stream;
    isCollapsedSink = isCollapsedStreamController.sink;
   }

    @override
void dispose(){
  super.dispose();
  _controller.dispose();
  isCollapsedStreamController.close();
  isCollapsedSink.close();
}

void onIconpressed(){
  final animationStatus = _controller.status;
  final isAnimationCompleted = animationStatus == AnimationStatus.completed;

  if (isAnimationCompleted){
    isCollapsedSink.add(false);
    _controller.reverse();
  }
  else{
    isCollapsedSink.add(true);
      _controller.forward();
  }
}

Widget build(BuildContext context) {
  Size size = MediaQuery.of(context).size;
    screenHeight= size.height;
    screenWidth= size.width;

return  Scaffold(
  backgroundColor: Colors.orange[400],
  body: Stack(
      children: <Widget>[
       menu(context),
       dashboard(context),
      
      ]
  
  ),
  );
}

Widget menu(context) {

  return 
  SlideTransition(
    position: _slideAnimation,
  child: ScaleTransition(
    scale: _menuScaleAnimation, 
    child: Container(
      padding: EdgeInsets.only(top: 100),
      color:Colors.orange[400],
  child: Column(
    children: <Widget>[
              MenuItem(
                  icon: Icons.home,
                   title: 'Homepage',
                   onTap: (){
                     onIconpressed();
               Navigator.pushReplacement(context, 
     MaterialPageRoute(builder: (BuildContext context)=>HomePage()));
                   },
                   ),
                MenuItem(
                  icon: Icons.lock, 
                  title: 'Change Password',
                  onTap: (){
                    onIconpressed();
                   Navigator.pushReplacement(context, 
     MaterialPageRoute(builder: (BuildContext context)=>ResetPasswordpage()));
                   },
                  ),

                  Divider(
                   color: Colors.white.withOpacity(0.9),
                   height: 64,
                   thickness: 0.9,
                   indent: 32,
                   endIndent: 32,
                 ),

                MenuItem(
                  icon: Icons.add, 
                  title: 'Add Items',
                  onTap: (){
                    onIconpressed();
                   Navigator.pushReplacement(context, 
     MaterialPageRoute(builder: (BuildContext context)=>AddItempage()));
                   },
                  ),

                 MenuItem(
                  icon: Icons.show_chart, 
                  title: 'Sales Chart',
                  onTap: (){
                    onIconpressed();
                  Navigator.pushReplacement(context, 
     MaterialPageRoute(builder: (BuildContext context)=>HomePage()));
                   },
                  ),

                 Divider(
                   color: Colors.white.withOpacity(0.9),
                   height: 64,
                   thickness: 0.9,
                   indent: 32,
                   endIndent: 32,
                 ),

                  MenuItem(
                  icon: Icons.settings, 
                  title: 'Settings',
                  onTap: (){
                    onIconpressed();
                   },
                  ),

                 MenuItem(
                  icon: Icons.person, 
                  title: 'LogOut',
                  onTap: () {
                    onIconpressed();
                    logout();  
                   },
                  ),


    ],
  )
  )
  )
  );
}

Widget dashboard(context) {
return StreamBuilder <bool>(
     initialData: false,
     stream: isCollapsedStream,
     builder: (context, isCollapsedAsync){

return AnimatedPositioned (
      duration: duration,
      top: 0,
      bottom: 0,
      left: isCollapsedAsync.data? 0.50*screenWidth : 0,
      right: isCollapsedAsync.data? -0.50*screenWidth: 0,

      child: ScaleTransition(
        scale: _scaleAnimation,

    child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
     floatingActionButton: FloatingActionButton(
       backgroundColor: Colors.white,
          onPressed: () {
           Navigator.of(context).pushReplacement(
                   MaterialPageRoute(builder: (BuildContext context)=>AddItempage()));
          },
          child: Icon(Icons.add, size: 30, color: Colors.orangeAccent),
          tooltip: 'Add Item',
        ),
       body: LayoutBuilder(
         builder: (ctx, constrains){
      return Scaffold(
      body: Container(
        decoration: BoxDecoration(     
        //borderRadius: BorderRadius.circular(40),
        color: Colors.white
             
            ),
        height: constrains.maxHeight,
        child:SingleChildScrollView(
      child: Container(
       // margin: EdgeInsets.only(top: 10.0),

            child: Column(
              children: <Widget>[
                AppBar(
                  automaticallyImplyLeading: false,
                  leading:  IconButton(
                  icon: Icon(Icons.menu , color: Colors.white, size:30,),
                  onPressed: (){
                     onIconpressed();
                  },
                ),
                  backgroundColor: Colors.orangeAccent,


                  actions: <Widget>[
          IconButton(
           icon: Icon((Icons.power_settings_new),color: Colors.white,),
            onPressed:(){
              logout();
            },
          ),
        ],

                  title: Text(
                    'My Records', style: TextStyle(
                      fontSize:20 , fontWeight: FontWeight.bold, color: Colors.white), 
                      textAlign: TextAlign.center
                      ),
                 
                 centerTitle: true,
                
                ),
                  
          SizedBox(height:10.0),

         Padding(padding: EdgeInsets.only(left:20),
                      child:   Row(
                    children: [
                      Text('Welcome,', style:TextStyle(fontWeight: FontWeight.bold, fontSize:20, color:Colors.black)),
                      SizedBox(width:5),
                    Text(welcomeText, style:TextStyle(fontWeight: FontWeight.bold, fontSize:20, color:Colors.black)),
                 
                    ],
                  ), 
                      ),
         
        
          SizedBox(height:20.0),

          Container(
            height: MediaQuery.of(context).size.width*0.6,

            child: PageView(
              controller: PageController(viewportFraction: 0.9),
              scrollDirection: Axis.horizontal,
              pageSnapping: true,
              children: <Widget>[

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal:10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                       color: Colors.orange[50],
                         boxShadow: [
                         BoxShadow(
                           color: Colors.black12,
                           blurRadius: 4,
                         )
                       ]
                    ),
                    width: MediaQuery.of(context).size.width*0.7,
                    child: Column(
                      children: <Widget>[
                        Padding(padding: const EdgeInsets.only(top:5.0),
                         child: Text('Recent Sales', style:TextStyle(color: Colors.blueAccent, fontSize:17,fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,),
                        ),
                       // SizedBox(height:5),

                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width*0.5,
                            child: _recentSalesList(),
                          )
                        )
                         
                      ]
                    )
                  ),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal:10),
                     decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                       color: Colors.orange[50],
                       boxShadow: [
                         BoxShadow(
                           color: Colors.black12,
                           blurRadius:4,
                         )
                       ]
                    ),
                    width: MediaQuery.of(context).size.width*0.7,
                    child: Column(
                      children: <Widget>[
                        Padding(padding: const EdgeInsets.only(top:5.0),
                         child: Text('Total Sales', style:TextStyle(color: Colors.blueAccent, fontSize:17,fontWeight: FontWeight.w600)),
                        ),
                          SizedBox(height:20),
                         Text('₦ ${total.toString()}', style:TextStyle(color: Colors.black, fontSize:20, fontWeight: FontWeight.w600)),
                      ]
                    ),

                   ),

              ],
            ),
          ),

         Container(
           margin: EdgeInsets.symmetric(vertical:20),
          child: Padding(
           padding: EdgeInsets.symmetric(vertical:20),
            child: Column(                          
              children: <Widget>[
                Row (
                  
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //mainAxisSize: MainAxisSize.max,
                  children: <Widget> [
                    flatbutton(
                    color: Colors.cyan,
                child: FlatButton(onPressed: (){
                   Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Stocklist()));
                 },
                   child: _homepagebutton( 'STOCKS',ImageIcon( AssetImage('assets/airtime.png'),
                    color: Colors.white, size: 30, ),
                   ))),

                 // SizedBox(height:10),
                    flatbutton(
                      color: Colors.redAccent,
                  child:FlatButton(onPressed:(){
                   Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Addstock()));
                 },
                   child: _homepagebutton( 'ADD STOCK',ImageIcon( AssetImage('assets/open_account.png'),
                    color: Colors.white, size: 30,),
                   ))),

                ]
                ),

                 SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    flatbutton(
                      color: Colors.purpleAccent,
                   child:FlatButton(onPressed: (){
                   Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Sellstock()));
                 },
                   child: _homepagebutton( 'SELL',ImageIcon( AssetImage('assets/paybills.png'),
                    color: Colors.white, size: 30,),
                    ))),

                 // SizedBox(height:10),
                    flatbutton(
                   color: Colors.brown,
                 child: FlatButton(onPressed: (){
                   Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Salelist()));
                 },
                   child: _homepagebutton( 'SALES',ImageIcon( AssetImage('assets/withdraw.png'),
                    color: Colors.white, size: 30,), 
                    )))
                 
                ],
                ),
              ]
            ),
          ),
            ),

            Padding(
              padding: EdgeInsetsDirectional.only(start:165),
              child:Text('Add Item', style: TextStyle(fontSize:15))
            )
              ],
            ),
      ),
    )
      ));
         }
    )
)));
     }
);

}

// ignore: unused_element
FlatButton _homepagebutton(String _text, ImageIcon _textIcon){
  
  // ignore: missing_required_param
  return FlatButton(             
                // margin: EdgeInsets.symmetric(horizontal: 30),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget> [
                 Center(
                      child: _textIcon,
                    ),
                    SizedBox(height:10),
                Text( _text,
                    style: TextStyle( 
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                ),    
               ]
                  ),
                  );

}


Widget _recentSalesList(){

          if(isEmpty){
          return Container(
            alignment: Alignment.center,
            
            child: Text('You have no sales record', textAlign: TextAlign.center, style: TextStyle(fontSize:20),),

          );
              }

    else {
      return ListView.builder(
       itemCount:salesList.docs.length,
       padding: EdgeInsets.only(top:0) ,
      itemBuilder: (context,i){
        return new  ListTile(
          contentPadding: null,
         //leading: CircleAvatar(radius: 5, backgroundColor: Colors.orangeAccent,),
            
            title: Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                   Text(salesList.docs[i].data()['Item'], style:TextStyle(color: Colors.green,fontSize:17,
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

            subtitle: Column(
              children: [
            Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(children: [
                    Text('Price:', style:TextStyle(color: Colors.black,fontSize:15),),
                    SizedBox(width:5),
                    Text('₦', style:TextStyle(color: Colors.green,fontSize:15),),
                    SizedBox(width:2),
                    Text(salesList.docs[i].data()['Price'].toString(), style:TextStyle(color: Colors.redAccent,fontSize:15),),
                    
                  ],),

                    SizedBox(width:20),

                    Row(children: [
                    Text(salesList.docs[i].data()['Date'], style:TextStyle(color: Colors.blue,fontSize:15), ),
                    ],),
               ],
            ),
          SizedBox(height:1.5, width: MediaQuery.of(context).size.width*0.75, 
         child: Container(decoration: BoxDecoration(color:Colors.orangeAccent[200])))
              ]     
            )
          );
      }
      );
    }

  }

Container flatbutton ({Color color, FlatButton child}){
return Container(
  height: 100,
  width: MediaQuery.of(context).size.width*0.35,
  decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(5),
             
  ),
  margin: EdgeInsets.symmetric(horizontal:10),
                child: Material(
                  borderRadius: BorderRadius.circular(5),
                  shadowColor: Colors.grey,
                  color: color,
                  elevation: 2.0,
                  child: child,
                    ) 
              );
}

}
