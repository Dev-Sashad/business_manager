import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';
import 'package:records/ui/screens/otherViews/stock_list/stocklist_view_model.dart';
import 'package:records/utils/constants/screensize.dart';


class Stocklist extends StatefulWidget {
   
  @override
  _StocklistState createState() => _StocklistState();
}

class _StocklistState extends State<Stocklist> {
  String items, quantity;   

  @override
  Widget build(BuildContext context) {
  return ViewModelProvider<StockListViewModel>.withConsumer(
        viewModelBuilder: () => StockListViewModel(),
        builder: (context, model, child) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        automaticallyImplyLeading: false,
                leading: IconButton(
                  onPressed: () {
                    model.pop();
                  },
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                ),
        title: 
          Text('Stock List',textAlign:TextAlign.center, 
          style:TextStyle(color: Colors.white, fontSize:25),),
        centerTitle: true,
      ),

      body: FutureBuilder <dynamic>(
           future: model.getStockList(),
           builder: (context, snapshot){
                if (!snapshot.hasData){
                      return Align(
                          alignment: Alignment.center,
                          child: SpinKitFadingCircle(
                            color: Colors.orangeAccent[200],
                            size: 50,
                            duration: Duration(seconds: 2),
                          ));
                    }

         else if (snapshot.hasData && snapshot.data.docs.isEmpty){
               return  Container(
                  alignment: Alignment.center,
                  child:Column (
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('You have no available Stock \nClick the button below to add new stock', 
                textAlign: TextAlign.center, style: TextStyle(fontSize:20),),
                SizedBox(height: Responsive.sizeboxheight(context)*2,),
                TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50),),
                    backgroundColor : Colors.white,
                  ),
                
               onPressed: () {
                      model.navigateToAddItem();
                  },
                 child: Icon(Icons.add, size: 30, color: Colors.orangeAccent)
                )
                  
                    ],
                  )
                 );
             }
          
        else {
                   return ListView.builder(
       itemCount:snapshot.data.docs.length,
       padding: EdgeInsets.only(top:8) ,
      itemBuilder: (context,i){
        items= snapshot.data.docs[i].data()["item"].toString();
        quantity = snapshot.data.docs[i].data()["quantity"].toString();
        return new Container(
        height: 70,
        width: MediaQuery.of(context).size.width * 0.8,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        padding: EdgeInsets.symmetric(horizontal: 15) ,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
              CircleAvatar(
                radius: 7,
                backgroundColor: Colors.green,
              ),
              SizedBox(width: Responsive.sizeboxheight(context)),
              Text(
                items,
                style: TextStyle(color: Colors.black, fontSize:17),
              ),
            ]),
            Text(quantity.toString(),
              style: TextStyle(color: Colors.black, fontSize:17),
            ),
          ],
        ));
      },   
           );
            }
           }
           )   
    );            
  }
  );
  }
}