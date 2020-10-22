import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget{
 //  bool debugShowCheckedModeBanner = false;
  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.white,
      child: SpinKitChasingDots(
        color: Colors.orangeAccent[200],
        size: 50,
        duration: Duration(milliseconds:3000),
      ),
    );
  }
}