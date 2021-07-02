import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';
import 'package:records/ui/screens/otherViews/sell/sell_view_model.dart';
import 'package:records/ui/widget/dropdown.dart';
import 'package:records/ui/widget/valueButton.dart';
import 'package:records/utils/constants/colors.dart';
import 'package:records/utils/constants/screensize.dart';
import 'package:records/utils/constants/validator.dart';

class Sellstock extends StatefulWidget {
  @override
  _SellStockState createState() => _SellStockState();
}

class _SellStockState extends State<Sellstock> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<SellStockViewModel>.withConsumer(
        viewModelBuilder: () => SellStockViewModel(),
        builder: (context, model, child) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
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
                    'Sell Stock',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  centerTitle: true,
                ),
                body: Container(
                    decoration: BoxDecoration(color: Colors.white),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
                        child: ListView(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: StreamBuilder<dynamic>(
                                  stream: model.getItemList(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      List<String> stockList = [];
                                      for (int i = 0;
                                          i < snapshot.data.docs.length;
                                          i++) {
                                        var item = snapshot.data.docs[i]
                                            .data()["item"];

                                        stockList.add(item.toString());
                                      }

                                      return DropdownWidget(
                                          selectedItem: model.selectedItem,
                                          items: stockList.map((String value) {
                                            return new DropdownMenuItem<String>(
                                              value: value,
                                              child: new Text(value),
                                            );
                                          }).toList(),
                                          onChanged: (stockItemsValue) {
                                            model
                                                .dropDownValue(stockItemsValue);
                                            int index = stockList
                                                .indexOf(stockItemsValue);
                                            print('$index');
                                            model.selectedItm = stockItemsValue;
                                            model.itemQty = snapshot
                                                .data.docs[index]
                                                .data()["quantity"];
                                            model.itemPr = snapshot
                                                .data.docs[index]
                                                .data()["price"];
                                            model.id = snapshot
                                                .data.docs[index].id
                                                .toString();
                                            model.getItemQty();
                                            // model.getQuantity(snapshot, index, stockItemsValue);
                                          });
                                    } else
                                      return DropdownWidget();
                                  }),
                          ),
                          SizedBox(height: Responsive.sizeboxheight(context)),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Center(
                                      child: Text('Stock Quantity',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20))),

                                 SizedBox(height: Responsive.sizeboxheight(context)),
                          Container(
                            alignment: Alignment.center,
                            width: Responsive.width(0.4, context),
                            height: 60,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.primaryColor,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              model.itemQty.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 30,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                                ],
                              ),

                                  
                          // SizedBox(height: Responsive.sizeboxheight(context)),
                          Column(
                            children: [
                              Center(
                                  child: Text('Unit Price (₦)',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20))),
                            SizedBox(
                            height: Responsive.sizeboxheight(context),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: Responsive.width(0.4, context),
                            height: 60,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.primaryColor,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              model.itemPr != null
                                  ? '${model.itemPr.toString()}'
                                  : '0',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 30,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                            ],
                          ),
                          
                            ],
                          ),
                         
                          SizedBox(height: Responsive.sizeboxheight(context)),
                          Center(
                              child: Text('Purchase Quantity',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20))),
                          SizedBox(height: 15),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ValueButton(
                                quantity: 10,
                                onPressed: () {
                                  controller.text = 10.toString();
                                  model.actualQty = 10;
                                  model.actualPrice(10); 
                                },
                              ),
                              ValueButton(
                                quantity: 20,
                                onPressed: () {
                                  controller.text = 20.toString();
                                  model.actualQty = 20;
                                  model.actualPrice(20);
                                },
                              ),
                              ValueButton(
                                  quantity: 50,
                                  onPressed: () {
                                    controller.text = 50.toString();
                                    model.actualQty = 50;
                                    model.actualPrice(50);
                                  }),
                            ],
                          ),
                          SizedBox(height: Responsive.sizeboxheight(context)),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ValueButton(
                                quantity: 100,
                                onPressed: () {
                                  controller.text = 100.toString();
                                  model.actualQty = 100;
                                  model.actualPrice(100);
                                },
                              ),
                              ValueButton(
                                quantity: 200,
                                onPressed: () {
                                  controller.text = 200.toString();
                                  model.actualQty = 200;
                                  model.actualPrice(200);
                                },
                              ),
                              ValueButton(
                                  quantity: 500,
                                  onPressed: () {
                                    controller.text = 500.toString();
                                    model.actualQty = 500;
                                    model.actualPrice(500);
                                  }),
                            ],
                          ),
                          SizedBox(height: Responsive.sizeboxheight(context)),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            alignment: Alignment.center,
                            width: Responsive.width(0.7, context),
                            height: 60,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.primaryColor,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(5)),
                            child: TextFormField(
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Caros',
                                  color: Colors.black,
                                ),
                                // showCursor: false,
                                keyboardType: TextInputType.number,
                                decoration: buildSignupInputDecoration(
                                    // model.actualQuantity.toString(),
                                    ),
                                controller: controller,
                                validator: stockValidator,
                                textAlign: TextAlign.center,
                                onChanged: (newQuantity) {
                                  model.setOnChangeQuantity(
                                      int.parse(newQuantity));
                                  model.actualPrice(int.parse(newQuantity));
                                }),
                          ),
                          SizedBox(height: Responsive.sizeboxheight(context)),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 60,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.greenAccent,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: Responsive.width(0.5, context),
                                  child: Text('${model.newPr}',
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontFamily: 'Montserrat',
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold
                                      )),
                                ),
                                SizedBox(
                                    width: Responsive.sizeboxheight(context) *
                                        0.4),
                                IconButton(
                                    onPressed: () {
                                      model.sell();
                                    },
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.greenAccent,
                                      size: 35,
                                    )),
                              ],
                            ),
                          ),
                        ])))),
          );
        });
  }

  InputDecoration buildSignupInputDecoration() {
    return InputDecoration(
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(vertical: 5),
    );
  }
}
