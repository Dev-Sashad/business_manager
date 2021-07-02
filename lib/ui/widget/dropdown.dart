import 'package:flutter/material.dart';
import 'package:records/utils/constants/colors.dart';
import 'package:records/utils/constants/screensize.dart';

// ignore: must_be_immutable
class DropdownWidget extends StatelessWidget {
   String selectedItem;
   Function onChanged;
   List<DropdownMenuItem<String>> items;
   DropdownWidget({this.selectedItem, this.onChanged, this.items});
  
  @override
  Widget build(BuildContext context) {
    
    return Container(
      width: Responsive.width(0.8, context),
      height: 40,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                    blurRadius: 4,
                    color: Colors.black12
                  )]
                ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.store, size: 25, color: Colors.orangeAccent),
                        SizedBox(width: 10),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                color: AppColors.white),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                  canvasColor: Colors.orange[
                                      50], // background color for the dropdown items
                                  buttonTheme: ButtonTheme.of(context).copyWith(
                                    alignedDropdown:
                                        true, //If false (the default), then the dropdown's menu will be wider than its button.
                                  )),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  items: items,
                                  iconSize: 30,
                                  onChanged: onChanged,
                                  value: selectedItem,
                                  isExpanded: false,
                                  hint: Text('select stock',
                                      style: TextStyle(color: Colors.black)),
                                ),
                              ),
                            ))
                      ],
                    ),
                  );
 
  }

}