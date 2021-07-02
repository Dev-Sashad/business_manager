import 'package:flutter/cupertino.dart';
import 'package:records/core/services/authentication.dart';
import 'package:records/utils/baseModel/baseModel.dart';
import 'package:records/utils/constants/locator.dart';
import 'package:records/utils/constants/validator.dart';
import 'package:records/utils/router/navigationService.dart';
import 'package:records/utils/router/routeNames.dart';

class SignUpViewModel extends BaseModel {
    bool _visiblePassword = true;
  bool get visiblePassword => _visiblePassword;
  final AuthService _authentication = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();

  setvisiblePassword() {
    _visiblePassword = !_visiblePassword;
    notifyListeners();
  }

void submit(GlobalKey<FormState> formKey, String email, String password, String bussinessName) async {
if (validate(formKey)){
  try{
  _authentication.signUp(email, password, bussinessName);
  }catch(e){
    print(e);
  }
 }
  }

  void navigateToSignUp() {
    _navigationService.navigateReplacementTo(SignInPageRoute);
  }

}