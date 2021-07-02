import 'package:flutter/cupertino.dart';
import 'package:records/core/services/firestoreServices.dart';
import 'package:records/utils/baseModel/baseModel.dart';
import 'package:records/utils/constants/locator.dart';
import 'package:records/utils/constants/validator.dart';
import 'package:records/utils/dialogeManager/dialogService.dart';
import 'package:records/utils/router/navigationService.dart';

class AddItemViewModel extends BaseModel {
  final FireStoreService _firestoreService = locator<FireStoreService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final ProgressService _progressService = locator<ProgressService>();

  additem(String productName, int quantity, int price,
      GlobalKey<FormState> formKey) async {
    if (validate(formKey)) {
      if (productName != null && quantity >= 0 && price >0) { 
           _firestoreService.additem(productName, quantity, price);    
        }    
      else if (productName == null) {
        return _progressService.showDialog(
            title: 'error', description: 'check input values');
      }

      else if (quantity <= 0 || price <= 0) {
        return _progressService.showDialog(
            title: 'error', description: 'input should be greater than 0');
      }
    }
  }

  pop(){
  _navigationService.pop();
}
}
