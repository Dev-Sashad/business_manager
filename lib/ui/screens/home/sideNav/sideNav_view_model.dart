import 'package:records/core/services/authentication.dart';
import 'package:records/utils/baseModel/baseModel.dart';
import 'package:records/utils/constants/locator.dart';
import 'package:records/utils/router/navigationService.dart';
import 'package:records/utils/router/routeNames.dart';

class SideNavViewModel extends BaseModel {
 
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authentication = locator<AuthService>();
  
//  bussinessName() async {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//      return  prefs.getString('name');
//   }

    void pop(){
      _navigationService.pop();
    }
  void navigateToAddItem() {
    _navigationService.navigateTo(AddItemRoute);
  }

  void navigateToResetPassword() {   
    _navigationService.navigateTo(ResetPasswordRoute);
  }

 void navigateUpdatePrice() {   
    _navigationService.navigateTo(UpdatePriceRoute);
  }

   void   signout(){
      
          _authentication.signout();
        _navigationService.navigateReplacementTo(SignInPageRoute);
      }

}