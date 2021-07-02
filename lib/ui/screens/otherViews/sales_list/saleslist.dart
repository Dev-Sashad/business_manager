import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';
import 'package:records/ui/screens/otherViews/sales_list/sales_list_view_model.dart';
import 'package:records/utils/constants/helpers.dart';

class Salelist extends StatefulWidget {
  @override
  _SalelistState createState() => _SalelistState();
}

class _SalelistState extends State<Salelist> {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<SalesListViewModel>.withConsumer(
        viewModelBuilder: () => SalesListViewModel(),
        builder: (context, model, child) {
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0.0,
                backgroundColor: Colors.orangeAccent,
                automaticallyImplyLeading: false,
                leading: IconButton(
                  onPressed: () {
                    model.pop();
                  },
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                ),
                title: Text(
                  'Sales ',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                centerTitle: true,
              ),
              body: FutureBuilder<dynamic>(
                  future: model.getSalesList(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData){
                      return Align(
                          alignment: Alignment.center,
                          child: SpinKitFadingCircle(
                            color: Colors.orangeAccent[200],
                            size: 50,
                            duration: Duration(seconds: 2),
                          ));
                    }
                  else if (snapshot.hasData && snapshot.data.docs.isEmpty) {
                       print('it has error');
                      return Center(
                        child: Container(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'You have no Sales record\nClick the button below to make sales',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                  onPressed: () {
                                    model.navigateToSell();
                                  },
                                  child: Icon(Icons.shopping_cart_outlined,
                                      size: 50, color: Colors.orangeAccent),
                                )
                              ],
                            )),
                      );
                    } 

                     else{
                      print('it has data');
                      return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        padding: EdgeInsets.only(top: 8),
                        itemBuilder: (context, i) {
                          return new Container(
                              height: 70,
                              width: MediaQuery.of(context).size.width * 0.8,
                              margin: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.orange[50],
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12, blurRadius: 4)
                                  ]),
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text(
                                          snapshot.data.docs[i].data()['Item'],
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(width: 40),
                                        Row(
                                          children: [
                                            Text(
                                              'Quantity Sold:',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15),
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              snapshot.data.docs[i]
                                                  .data()['Quantity_sold']
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.orangeAccent,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            Text(
                                              'Price:',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15),
                                            ),
                                            SizedBox(width: 2),
                                            Text(
                                              '₦',
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 15),
                                            ),
                                            SizedBox(width: 2),
                                            Text(
                                              snapshot.data.docs[i]
                                                  .data()['Price']
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.redAccent,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: 20),
                                        Row(
                                          children: [
                                            Text(
                                              formatDate(snapshot.data.docs[i]
                                                      .data()['Date'])
                                                  .toString(),
                                              // snapshot.data.docs[i]
                                              //     .data()['Date'],
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ]));
                        },
                      );
                    } 
                  }));
        });
  }
}
