import 'package:flutter/material.dart';
import 'package:records/utils/constants/screensize.dart';

class Homebutton extends StatelessWidget {
 final Color color;
final String text;
 final ImageIcon imageIcon;
 final Function onpressed;

 Homebutton ({this.text, this.color, this.imageIcon, this.onpressed});


  @override
  Widget build(BuildContext context) {
      return  TextButton(
        onPressed: onpressed,
        child: Container(
  height: 100,
  width: Responsive.width(0.35, context),
  decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(5),
               
  ),
  margin: EdgeInsets.symmetric(horizontal:10),
                  child: Material(
                    borderRadius: BorderRadius.circular(5),
                    shadowColor: Colors.grey,
                    color: color,
                    elevation: 2.0,
                    child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget> [
                 Center(
                      child: imageIcon,
                    ),
                    SizedBox(height:10),
                Text( text,
                    style: TextStyle( 
                      fontSize: 12,
                      fontFamily: 'Caros',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                ),    
               ]
                  ), 
                      ) 
                ),
      );

  }

}