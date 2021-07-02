import 'package:flutter/material.dart';
class Responsive{
  
  static width(value, BuildContext context)
  {
    return MediaQuery.of(context).size.width * value;
  }

  static height(value, BuildContext context)
  {
    return MediaQuery.of(context).size.height * value;
  }



static sizeboxheight(BuildContext context){
  return height(0.02,context);
}
}