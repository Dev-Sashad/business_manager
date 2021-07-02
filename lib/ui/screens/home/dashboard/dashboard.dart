import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';
import 'package:records/ui/screens/Home/sideNav/sideNav.dart';
import 'package:records/ui/widget/homepageButton.dart';
import 'package:records/utils/constants/colors.dart';
import 'package:records/utils/constants/helpers.dart';
import 'package:records/utils/constants/screensize.dart';
import 'package:records/utils/constants/textstyle.dart';
import 'dashboard_view_model.dart';

class Dashboard extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<DashboardViewModel>.withConsumer(
        viewModelBuilder: () => DashboardViewModel(),
        builder: (context, model, child) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: AppColors.white,
                key: _scaffoldKey,
                extendBodyBehindAppBar: false,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  leading: GestureDetector(
                    onTap: () {
                      _scaffoldKey.currentState.openDrawer();
                    },
                    child: Icon(
                      Icons.menu,
                      size: 25,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  title: Text('Business Manager',
                      style: titletextStyle, textAlign: TextAlign.center),
                  centerTitle: true,
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(
                        (Icons.power_settings_new),
                        size: 25,
                        color: AppColors.primaryColor,
                      ),
                      onPressed: () {
                        model.signout();
                      },
                    ),
                  ],
                  elevation: 0,
                ),
                resizeToAvoidBottomInset: false,
                drawer: SideNavpage(),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.miniEndDocked,
                floatingActionButton: FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: () {
                    model.navigateToAddItem();
                  },
                  child: Icon(Icons.add_shopping_cart_outlined,
                      size: 30, color: Colors.orangeAccent),
                  tooltip: 'Add Item',
                ),
                body: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: Responsive.sizeboxheight(context)),

                        Container(
                          height: MediaQuery.of(context).size.width * 0.7,
                          child: PageView(
                            controller: PageController(viewportFraction: 0.9),
                            scrollDirection: Axis.horizontal,
                            pageSnapping: true,
                            children: <Widget>[
                              Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.orange[50],
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 4,
                                        )
                                      ]),
                                  width: Responsive.width(0.7, context),
                                  child: Column(children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Text(
                                        'Recent Sales',
                                        style: dashboardPageViewStyle,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    // SizedBox(height:5),

                                    Expanded(
                                        child: Container(
                                      width: Responsive.width(1, context),
                                      height: Responsive.width(0.7, context),
                                      child: RecentSales(),
                                    ))
                                  ])),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.orange[50],
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4,
                                      )
                                    ]),
                                width: Responsive.width(0.7, context),
                                child: Column(children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text('Total Sales',
                                        style: dashboardPageViewStyle),
                                  ),
                                  SizedBox(
                                      height:
                                          Responsive.sizeboxheight(context)),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left:
                                            Responsive.sizeboxheight(context)),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            children: [
                                              Text('Today:',
                                                  style: pageViewStyle),
                                              SizedBox(
                                                  height:
                                                      Responsive.sizeboxheight(
                                                          context)),
                                              StreamBuilder<dynamic>(
                                                  stream: model.todaySales(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      int total = 0;
                                                      var value = snapshot.data;
                                                      DateTime today =
                                                          DateTime.now();

                                                      for (int i = 0;
                                                          i < value.docs.length;
                                                          i++) {
                                                        if (formatDateOnly(today
                                                                .toString()) ==
                                                            formatDateOnly(value
                                                                    .docs[i]
                                                                    .data()[
                                                                'Date'])) {
                                                          total += value.docs[i]
                                                              .data()['Price'];
                                                        }
                                                      }

                                                      print(total.toString());
                                                      return Text(
                                                          '₦ ${total.toString()}',
                                                          style:
                                                              totalsaleStyle);
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return Text('₦ 0',
                                                          style:
                                                              totalsaleStyle);
                                                    } else
                                                      return Text('₦ 0',
                                                          style:
                                                              totalsaleStyle);
                                                  })
                                            ],
                                          ),
                                          SizedBox(
                                              height: Responsive.sizeboxheight(
                                                  context)),
                                          Row(
                                            children: [
                                              Text('Previous day:',
                                                  style: pageViewStyle),
                                              SizedBox(
                                                  width:
                                                      Responsive.sizeboxheight(
                                                          context)),
                                              StreamBuilder<dynamic>(
                                                  stream:
                                                      model.yesterdaySales(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      int total = 0;
                                                      var value = snapshot.data;
                                                      DateTime yesterday =
                                                          DateTime.now()
                                                              .subtract(
                                                                  Duration(
                                                                      days: 1));
                                                      print(
                                                          'answer is ${yesterday.toString()}');
                                                      for (int i = 0;
                                                          i < value.docs.length;
                                                          i++) {
                                                        if (formatDateOnly(
                                                                yesterday
                                                                    .toString()) ==
                                                            formatDateOnly(value
                                                                    .docs[i]
                                                                    .data()[
                                                                'Date'])) {
                                                          total += value.docs[i]
                                                              .data()['Price'];
                                                        }
                                                      }

                                                      print(total.toString());
                                                      return Text(
                                                          '₦ ${total.toString()}',
                                                          style:
                                                              totalsaleStyle);
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return Text('₦ 0',
                                                          style:
                                                              totalsaleStyle);
                                                    } else
                                                      return Text('₦ 0',
                                                          style:
                                                              totalsaleStyle);
                                                  })
                                            ],
                                          ),
                                          SizedBox(
                                              height: Responsive.sizeboxheight(
                                                  context)),
                                          Row(
                                            children: [
                                              Text('Total Sales:',
                                                  style: pageViewStyle),
                                              SizedBox(
                                                  width:
                                                      Responsive.sizeboxheight(
                                                          context)),
                                              StreamBuilder<dynamic>(
                                                  stream: model.totalSales(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      int total = 0;
                                                      var value = snapshot.data;

                                                      for (int i = 0;
                                                          i < value.docs.length;
                                                          i++) {
                                                        total += value.docs[i]
                                                            .data()['Price'];
                                                      }

                                                      print(total.toString());
                                                      return Text(
                                                          '₦ ${total.toString()}',
                                                          style:
                                                              totalsaleStyle);
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return Text('₦ 0',
                                                          style:
                                                              totalsaleStyle);
                                                    } else
                                                      return Text('₦ 0',
                                                          style:
                                                              totalsaleStyle);
                                                  })
                                            ],
                                          ),
                                        ]),
                                  ),
                                ]),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Column(children: <Widget>[
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Homebutton(
                                        color: Colors.cyan,
                                        text: 'STOCKS',
                                        imageIcon: ImageIcon(
                                          AssetImage(
                                              'assets/images/stocks.png'),
                                          color: AppColors.white,
                                        ),
                                        onpressed: () {
                                          model.navigateToStockList();
                                        }),
                                    Homebutton(
                                        color: Colors.redAccent,
                                        text: 'ADD STOCKS',
                                        imageIcon: ImageIcon(
                                          AssetImage(
                                              'assets/images/addstock.png'),
                                          color: AppColors.white,
                                        ),
                                        onpressed: () {
                                          model.navigateToAddStock();
                                        }),
                                  ]),
                              SizedBox(
                                  height: Responsive.sizeboxheight(context)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                //mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Homebutton(
                                      color: Colors.purpleAccent,
                                      text: 'SELL',
                                      imageIcon: ImageIcon(
                                        AssetImage('assets/images/sell.png'),
                                        color: AppColors.white,
                                      ),
                                      onpressed: () {
                                        model.navigateToSell();
                                      }),
                                  Homebutton(
                                      color: Colors.brown,
                                      text: 'SAELS',
                                      imageIcon: ImageIcon(
                                        AssetImage('assets/images/sales.png'),
                                        color: AppColors.white,
                                      ),
                                      onpressed: () {
                                        model.navigateToSalesList();
                                      }),
                                ],
                              ),
                            ]),
                          ),
                        ),

                        // Padding(
                        //   padding: EdgeInsetsDirectional.only(start:Responsive.width(0.4, context)),
                        //   child:Text('Add Item', style: TextStyle(fontSize:15))
                        // )
                      ],
                    ),
                  ),
                )),
          );
        });
  }
}

class RecentSales extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<DashboardViewModel>.withConsumer(
        viewModelBuilder: () => DashboardViewModel(),
        builder: (context, model, child) {
          return StreamBuilder<dynamic>(
            stream: model.recentsales(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Align(
                    alignment: Alignment.center,
                    child: SpinKitFadingCircle(
                      color: Colors.orangeAccent[200],
                      size: 50,
                      duration: Duration(seconds: 2),
                    ));
              } else if (snapshot.hasData && snapshot.data.docs.isEmpty) {
                return Container(
                  alignment: Alignment.center,
                  child: Text(
                    'You have no sales record',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    padding: EdgeInsets.only(top: 0),
                    itemBuilder: (context, i) {
                      return new ListTile(
                          contentPadding: null,
                          //leading: CircleAvatar(radius: 5, backgroundColor: Colors.orangeAccent,),

                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                snapshot.data.docs[i].data()['Item'],
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 40),
                              Row(
                                children: [
                                  Text(
                                    'Quantity Sold:',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
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
                              )
                            ],
                          ),
                          subtitle: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Row(
                                  children: [
                                    Text(
                                      'Price:',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      '₦',
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 15),
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
                                      // snapshot.data.docs[i].data()['Date'].toString(),
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 15),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                                height: 1.5,
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.orangeAccent[200])))
                          ]));
                    });
              }
            },
          );
        });
  }
}
