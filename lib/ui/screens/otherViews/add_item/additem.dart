import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';
import 'package:records/ui/widget/generalButton.dart';
import 'package:records/ui/widget/text_form.dart';
import 'package:records/utils/constants/colors.dart';
import 'package:records/utils/constants/screensize.dart';
import 'package:records/utils/constants/validator.dart';

import 'additem_view_model.dart';


class AddItempage extends StatefulWidget {  
  @override

  AddItempageState createState() => AddItempageState();
}

class AddItempageState extends State<AddItempage> {
final formKey = GlobalKey<FormState>();
var userIdentity;
final firestoreInstance = FirebaseFirestore.instance;
var productName ;
int quantity, price;


  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<AddItemViewModel>.withConsumer(
        viewModelBuilder: () => AddItemViewModel(),
        builder: (context, model, child) {
   return GestureDetector(
            onTap:(){
              FocusScope.of(context).unfocus();
            },
     child: Scaffold(
             appBar: AppBar(
                elevation: 0.0,
          automaticallyImplyLeading: false,
          leading: IconButton(icon: Icon(Icons.arrow_back_ios, color:AppColors.white),
          
           onPressed: (){
              model.pop();
          }),
          backgroundColor: Colors.orangeAccent,
          title: 
            Text('Add Item',textAlign:TextAlign.center, 
            style:TextStyle(color: Colors.white, fontSize:25),),
          centerTitle: true,
        ),       

        body: ListView(
          children: [

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(key:formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              
              SizedBox(height:Responsive.sizeboxheight(context)),

              CustomTextFormField(
                label: 'Product name',
                borderStyle: BorderStyle.solid,
                textInputType: TextInputType.text,
                onChanged: (value){
                  productName = value;
                },
                validator: itemNameValidator,
              ),


                  CustomTextFormField(
                label: 'Quantity',
                borderStyle: BorderStyle.solid,
                textInputType: TextInputType.number,
                validator: (value){
              return value.isEmpty || int.parse(value) < 0 ? 'enter a value':null; 
                 },
              onChanged: (value){
                     
                if(value!=null){
                  this.quantity = int.parse(value);
                }
                else{
                  this.quantity=0;
                }
              
              },
              ),

                   CustomTextFormField(
                label: 'Unit price',
                prefixIcon: ImageIcon(AssetImage('assets/naira.png')),
                borderStyle: BorderStyle.solid,
                textInputType: TextInputType.number,
                validator: (value){
              return value.isEmpty || int.parse(value) < 0 ? 'check input value':null; 
                 },
              onChanged: (value){
                  if(value!=null){
                  this.price = int.parse(value);
                }
                else{
                  this.price =0;
                }
              },
              ),
            ]
        ),
              ),
          ),
             SizedBox(height:Responsive.sizeboxheight(context)*2),

        
         Padding(
           padding: const EdgeInsets.symmetric(horizontal: 20),
           child: CustomButton(
             child: Text('Add', style: TextStyle(fontSize:20, color:Colors.white)),
             onPressed: (){
               model.additem(productName, quantity, price, formKey);
             },),
         )
          
          ]
        ),
     ),
   );
  }
    );
  }
}