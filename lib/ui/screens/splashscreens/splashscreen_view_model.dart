

import 'package:records/core/services/authentication.dart';
import 'package:records/utils/baseModel/baseModel.dart';
import 'package:records/utils/constants/locator.dart';

class SplashscreenViewModel extends BaseModel{
final AuthService _authentication = locator<AuthService>();


isuserloggedin(){
  return _authentication.getCurrentUser();
}



}