import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';
import 'package:records/ui/widget/dropdown.dart';
import 'package:records/ui/widget/valueButton.dart';
import 'package:records/utils/constants/screensize.dart';
import 'package:records/utils/constants/textstyle.dart';
import 'package:records/utils/constants/validator.dart';

import 'addstock_view_model.dart';

class Addstock extends StatefulWidget {
  @override
  _AddStockState createState() => _AddStockState();
}

class _AddStockState extends State<Addstock> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<AddStockViewModel>.withConsumer(
        viewModelBuilder: () => AddStockViewModel(),
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
                    'Add Stock',
                    textAlign: TextAlign.center,
                    style: appBartextStyle,
                  ),
                  centerTitle: true,
                ),
                body: Container(
                    decoration: BoxDecoration(color: Colors.white),
                    width: Responsive.width(1, context),
                    height: Responsive.height(1, context),
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                        child: ListView(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
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
                            SizedBox(
                                height: Responsive.sizeboxheight(context) * 2),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                width: Responsive.width(0.8, context),
                                height: 60,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.orangeAccent,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(
                                  model.itemQty.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            SizedBox(
                                height: Responsive.sizeboxheight(context) * 2),
                            Center(
                              child: Text('Quantity',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Caros',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            ),
                            SizedBox(height: Responsive.sizeboxheight(context)),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                ValueButton(
                                  quantity: 10,
                                  onPressed: () {
                                    controller.text = 10.toString();
                                    model.getAddedQuantity(10);
                                  },
                                ),
                                ValueButton(
                                  quantity: 20,
                                  onPressed: () {
                                    controller.text = 20.toString();
                                    model.getAddedQuantity(20);
                                  },
                                ),
                                ValueButton(
                                  quantity: 50,
                                  onPressed: () {
                                    controller.text = 50.toString();
                                    model.getAddedQuantity(50);
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                ValueButton(
                                  quantity: 100,
                                  onPressed: () {
                                    controller.text = 100.toString();
                                    model.getAddedQuantity(100);
                                  },
                                ),
                                ValueButton(
                                  quantity: 200,
                                  onPressed: () {
                                    controller.text = 200.toString();
                                    model.getAddedQuantity(200);
                                  },
                                ),
                                ValueButton(
                                  quantity: 500,
                                  onPressed: () {
                                    controller.text = 500.toString();
                                    model.getAddedQuantity(500);
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                                height: Responsive.sizeboxheight(context) * 2),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Container(
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
                                            model.onChanaged(
                                                int.parse(newQuantity));
                                          }),
                                    ),
                                    SizedBox(
                                        width:
                                            Responsive.sizeboxheight(context) *
                                                0.4),
                                    IconButton(
                                        onPressed: () {
                                          model.addStock();
                                          print(model.actualQty);
                                        },
                                        icon: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.greenAccent,
                                          size: 35,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )))),
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
