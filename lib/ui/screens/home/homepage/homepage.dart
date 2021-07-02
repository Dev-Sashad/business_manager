import 'package:flutter/material.dart';
import 'package:records/ui/screens/Home/dashboard/dashboard.dart';
import 'package:records/ui/screens/Home/sideNav/sideNav.dart';
import 'package:records/utils/constants/colors.dart';



class HomePage extends StatefulWidget {
@override
  HomePageState createState() => HomePageState();
} 

class HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
    
@override
Widget build(BuildContext context) {
return  Scaffold(
  backgroundColor: AppColors.white,
  body: Stack(
      children: <Widget>[
       SideNavpage(),
       Dashboard(),
      
      ]
  
  ),
  );
}
}
