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


class HomePage extends StatefulWidget {
 //bool debugShowCheckedModeBanner = false;
@override
  HomePageState createState() => HomePageState();
} 



class HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
final BaseAuth auth= Auth();

var userIdentity,welcomeText ;
final firestoreInstance = FirebaseFirestore.instance;
final formKey = GlobalKey<FormState>();
QuerySnapshot salesList;
DocumentSnapshot userName;
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
        await FirebaseAuth.instance.signOut();
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (BuildContext context)=>LoginSignupPage(authFormType: AuthFormType.signIn))
  );
  
  }
  
  bool isCollapse = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds:400);
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;
  Animation<Offset> _slideAnimation;

  @override
   
   Future<void> initState () async {
    super.initState();
      //to get recently sold
     getData().then((results){
      setState(() {
        salesList = results;
      });
    });
      //to get total sales
      getTotalSales();
    // getTotalSales().then((sales){
      //setState(() {
     //   totalSales = sales;
    //  });
    //});
    
    //to get userName
    userIdentity= FirebaseAuth.instance.currentUser.uid;
     print('$userIdentity');
   await FirebaseFirestore.instance.collection('users').doc(userIdentity).get().then((username){
      setState(() {
       userName = username;
      });

      if (userName!=null){  
        welcomeText = userName.data()['username'].toString();
   }
   else
    welcomeText= "";

   });
  

    _controller = AnimationController(vsync: this, duration: duration);
     _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
      _menuScaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(_controller);
     _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0),).animate(_controller);
   }

     @override
    void dispose () {
      _controller.dispose();
     super.dispose();
    }

Widget build(BuildContext context) {
  Size size = MediaQuery.of(context).size;
    screenHeight= size.height;
    screenWidth= size.width;

return  Scaffold(
  backgroundColor: Colors.orange[700],
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
  child: Padding (
   padding: const EdgeInsets.only(left:0.0),
  child: Align(
    alignment: Alignment.centerLeft,
    child: Container(
      height:MediaQuery.of(context).size.height*0.6,
  child: Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[

      Padding(padding: const EdgeInsets.only(left:10.0),
      child:  Row(
        
        children: <Widget>[  
        Icon(Icons.update , color: Colors.white),
        
       // Padding(padding: EdgeInsets.only(left: 10)),

        FlatButton(onPressed:(){
            setState(() {
                      if(isCollapse)
                      _controller.forward();
                      else
                      _controller.reverse(); 
                      isCollapse =!isCollapse;
                    });

           Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (BuildContext context)=>AddItempage())
  );
    
        } , 
        
        child:Text(
        'Add Item', style: TextStyle(color: Colors.white, fontSize: 15, )),
      ),
      
        ]
      ),
      ),
      

      SizedBox(height:3.0, child: Container(decoration: BoxDecoration(color:Colors.white))),

      Padding(padding: const EdgeInsets.only(left:10.0),
      child: Row(
        
        children: <Widget>[  
        Icon(Icons.show_chart , color: Colors.white),
        
        Padding(padding: EdgeInsets.only(left: 15)),
      Text(
        'Sales Chart', style: TextStyle(color: Colors.white, fontSize: 15, )
      ),
        ]
      ),
      ),

      SizedBox(height:3.0, child: Container(decoration: BoxDecoration(color:Colors.white))),

      Padding(padding: const EdgeInsets.only(left:10.0),
      child:Row(
        
        children: <Widget>[  
        Icon(Icons.settings , color: Colors.white),
        
        Padding(padding: EdgeInsets.only(left: 15)),
      Text(
        'Settings', style: TextStyle(color: Colors.white, fontSize: 15, )
      ),
        ]
      ),
      ),

      SizedBox(height:3.0, child: Container(decoration: BoxDecoration(color:Colors.white))),

      Padding(padding: const EdgeInsets.only(left:10.0),
      child: Row(
        
        children: <Widget>[  
        Icon(Icons.lock_open , color: Colors.white),
        
      //  Padding(padding: EdgeInsets.only(left: 5)),

        FlatButton(onPressed:(){

            setState(() {
                      if(isCollapse)
                      _controller.forward();
                      else
                      _controller.reverse(); 
                      isCollapse =!isCollapse;
                    });
            Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (BuildContext context)=>ResetPasswordpage())
  );

        } , 
        
        child:Text(
        'Change Password', style: TextStyle(color: Colors.white, fontSize: 15, )),
      ),
      
        ]
      ),),

      SizedBox(height:3.0, child: Container(decoration: BoxDecoration(color:Colors.white))),
      
     Padding(padding: const EdgeInsets.only(left:10.0),
     child: Row(
        
        children: <Widget>[  
           Icon(Icons.person , color: Colors.white),
        
        Padding(padding: EdgeInsets.only(left: 15)),

        GestureDetector(
          onTap: logout,
       child: Text(
        'Logout', style: TextStyle(color: Colors.white, fontSize: 15, )
      ),
        ),
        ]
      ),
     )

    ],
  )
  )
  )
  )
  )
  );
}

Widget dashboard(context) {
return AnimatedPositioned (

      duration: duration,
      top: 0,
      bottom: 0,
      left: isCollapse? 0 : 0.38*screenWidth,
      right: isCollapse? 0 : -0.45*screenWidth,

      child: ScaleTransition(
        scale: _scaleAnimation,

    child: Scaffold(
       body: LayoutBuilder(
         builder: (ctx, constrains){
           return Scaffold(
      body: Container(
        height: constrains.maxHeight,
        child:SingleChildScrollView(
      child: Container(
       // margin: EdgeInsets.only(top: 10.0),
        decoration: BoxDecoration(     
        borderRadius: BorderRadius.circular(10),
        color: Colors.white
             
            ),

            child: Column(
              children: <Widget>[
                AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.orangeAccent,
                  title: Row(
                    mainAxisSize: MainAxisSize.max,
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 crossAxisAlignment: CrossAxisAlignment.start,
                   children: <Widget>[ 
                     InkWell(
                  child: Icon(Icons.menu , color: Colors.white, size:30,),
                  onTap: (){
                    setState(() {
                      if(isCollapse)
                      _controller.forward();
                      else
                      _controller.reverse(); 
                      isCollapse =!isCollapse;
                    });
                  },
                ),
                   Text(
                    'My Records', style: TextStyle(
                      fontSize:20 , fontWeight: FontWeight.bold, color: Colors.white), 
                      textAlign: TextAlign.center
                      ),

                   InkWell(
                  child: Icon(Icons.power_settings_new, color: Colors.white, size:30,),
                  onTap: logout,
                ),

                   ]
                 ),
                
                ),
                  
          SizedBox(height:10.0),

         Padding(padding: EdgeInsets.only(left:20),
                      child:   Row(
                    children: [
                      Text('Welcome,', style:TextStyle(fontWeight: FontWeight.bold, fontSize:25, color:Colors.black)),
                      SizedBox(width:5),
                    Text(welcomeText, style:TextStyle(fontWeight: FontWeight.bold, fontSize:25, color:Colors.black)),
                 
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
                    margin: const EdgeInsets.symmetric(horizontal:5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                       color: Colors.orange[50],
                    ),
                    width: MediaQuery.of(context).size.width*0.7,
                    child: Column(
                      children: <Widget>[
                        Padding(padding: const EdgeInsets.only(top:5.0),
                         child: Text('Recent Sales', style:TextStyle(color: Colors.blueAccent, fontSize:20,),
                          textAlign: TextAlign.center,),
                        ),
                       // SizedBox(height:5),

                        Expanded(
                          child: container(
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width*0.5,
                            child: _recentSalesList(),
                          )
                          )
                        )
                         
                      ]
                    ),

                  ),

                    container(
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal:5),
                     decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                       color: Colors.orange[50],
                    ),
                    width: MediaQuery.of(context).size.width*0.7,
                    child: Column(
                      children: <Widget>[
                        Padding(padding: const EdgeInsets.only(top:5.0),
                         child: Text('Total Sales', style:TextStyle(color: Colors.blueAccent, fontSize:20,)),
                        ),
                          SizedBox(height:10),
                         Text('₦ ${total.toString()}', style:TextStyle(color: Colors.black, fontSize:20, fontWeight: FontWeight.bold)),
                      ]
                    ),

                   )
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
                 FlatButton(onPressed: (){
                   Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Stocklist()));
                 },
                   child: _homepagebutton( 'STOCKS',ImageIcon( AssetImage('assets/airtime.png'),
                    color: Colors.white, size: 30, ),
                    Colors.blueAccent))),

                 // SizedBox(height:10),
                    flatbutton(
                  FlatButton(onPressed:(){
                   Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Addstock()));
                 },
                   child: _homepagebutton( 'ADD STOCK',ImageIcon( AssetImage('assets/open_account.png'),
                    color: Colors.white, size: 30,),
                    Colors.redAccent))),

                ]
                ),

                 SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    flatbutton(
                   FlatButton(onPressed: (){
                   Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Sellstock()));
                 },
                   child: _homepagebutton( 'SELL',ImageIcon( AssetImage('assets/paybills.png'),
                    color: Colors.white, size: 30,),
                    Colors.purpleAccent))),

                 // SizedBox(height:10),
                    flatbutton(
                  FlatButton(onPressed: (){
                   Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Salelist()));
                 },
                   child: _homepagebutton( 'SALES',ImageIcon( AssetImage('assets/withdraw.png'),
                    color: Colors.white, size: 30,), 
                    Colors.brown)))
                 
                ],
                ),
              ]
            ),
          ),
            ),
              ],
            ),
      ),
    )
      ));
         }
    )
)));

}

Container _homepagebutton(String _text, ImageIcon _textIcon, Color _color){
  
  return Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width*0.35,
                // margin: EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                     color: _color,              
                    ),
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
    if (salesList!=null){
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
                   Text(salesList.docs[i].data()['Item'], style:TextStyle(color: Colors.green,fontSize:20,
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
                   // SizedBox(width:2),
                  //  Text('/', style:TextStyle(color: Colors.black,fontSize:15, fontWeight: FontWeight.bold),),
                 //   SizedBox(width:2),
                 //  Text(salesList.docs[i].data()['Time'], style:TextStyle(color: Colors.orange,fontSize:15),),
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

    else{
      return Text('');
    }
    


  }


 Container container (Container child){
return Container(
                child: Material(
                  borderRadius: BorderRadius.circular(5),
                  shadowColor: Colors.grey,
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
                  elevation: 2.0,
                  child: child,
                    )
              );
}

}
