import 'package:flutter/material.dart';
import 'package:records/core/services/authentication.dart';
import 'package:records/utils/baseModel/baseModel.dart';
import 'package:records/utils/constants/locator.dart';
import 'package:records/utils/constants/validator.dart';
import 'package:records/utils/router/navigationService.dart';




class ResetPasswordViewModel extends BaseModel {
  bool _visiblePassword = true;
  bool get visiblePassword => _visiblePassword;
  final AuthService _authentication = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();

  setvisiblePassword() {
    _visiblePassword = !_visiblePassword;
    notifyListeners();
  }

  resetpassword(String oldPassword, String newPassword, GlobalKey<FormState> formKey){
    
      if (validate(formKey)){
       try{
         _authentication.resetpassword(oldPassword, newPassword);
       }catch(e){
         print(e);
       }     
          }
    }

      void pop() {
    _navigationService.pop();
  }

}

    
              


 
 