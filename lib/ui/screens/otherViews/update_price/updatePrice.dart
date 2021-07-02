import 'package:flutter/material.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';
import 'package:records/ui/screens/otherViews/update_price/updatePrice_view_model.dart';
import 'package:records/ui/widget/dropdown.dart';
import 'package:records/ui/widget/generalButton.dart';
import 'package:records/ui/widget/text_form.dart';
import 'package:records/utils/constants/colors.dart';
import 'package:records/utils/constants/screensize.dart';
import 'package:records/utils/constants/textstyle.dart';

class UpdatePrice extends StatefulWidget {
  @override
  _UpdatePriceState createState() => _UpdatePriceState();
}

class _UpdatePriceState extends State<UpdatePrice> {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<UpdatePriceViewModel>.withConsumer(
        viewModelBuilder: () => UpdatePriceViewModel(),
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
                    'Update Price',
                    textAlign: TextAlign.center,
                    style: appBartextStyle,
                  ),
                  centerTitle: true,
                ),
                body: SingleChildScrollView(
                    child: Container(
                        decoration: BoxDecoration(color: Colors.white),
                        width: Responsive.width(1, context),
                        height: Responsive.height(1, context),
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
                            child: Column(children: [
                              StreamBuilder<dynamic>(
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
                              SizedBox(
                                  height: Responsive.sizeboxheight(context)*3),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                width: Responsive.width(0.8, context),
                                height: 60,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(
                                  model.itemPrice.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                  height:
                                      Responsive.sizeboxheight(context) * 2),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: CustomTextFormField(
                                  label: 'New price',
                                  labelColor: AppColors.black,
                                  borderStyle: BorderStyle.solid,
                                  textInputType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                       textFormFieldStyle: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Caros',
                                            color: Colors.black,
                                          ),
                                  validator: (value) {
                                    return value.isEmpty ? 'enter value' : null;
                                  },
                                  onChanged: (value) {
                                    model.newUnitPrice = int.parse(value);
                                  },
                                ),
                              ),
                              SizedBox(
                                  height:
                                      Responsive.sizeboxheight(context) * 2),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: CustomButton(
                                    child:
                                        Text('Update', style: buttonTextStyle),
                                    onPressed: () {
                                      model.updatePrice();
                                    }),
                              ),
                            ]))))),
          );
        });
  }
}
