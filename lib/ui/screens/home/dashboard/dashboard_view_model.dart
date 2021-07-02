

import 'package:records/core/services/authentication.dart';
import 'package:records/core/services/firestoreServices.dart';
import 'package:records/utils/baseModel/baseModel.dart';
import 'package:records/utils/constants/locator.dart';
import 'package:records/utils/router/navigationService.dart';
import 'package:records/utils/router/routeNames.dart';

class DashboardViewModel extends BaseModel {
 final FireStoreService _firestoreService = locator<FireStoreService>();
 final NavigationService _navigationService = locator<NavigationService>();
 final AuthService _authentication = locator<AuthService>();


  // bussinessName() async {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //    return  prefs.getString('name');
  // }

 totalSales() {
  return _firestoreService.getTotalSales();
 }

 todaySales(){
  return _firestoreService.getTodaySales();
 }

  yesterdaySales(){
  return _firestoreService.getYesterdaySales();
 }

  recentsales(){
    return _firestoreService.recentlySold();
  }

   void navigateToStockList() {
    _navigationService.navigateTo(StockListRoute);
  }

   void navigateToAddStock() {
    _navigationService.navigateTo(AddStockRoute);
  }

  void navigateToAddItem() {
    _navigationService.navigateTo(AddItemRoute);
  }

   void navigateToSell() {
    _navigationService.navigateTo(SellRoute);
  }

   void navigateToSalesList() {
    _navigationService.navigateTo(SalesListRoute);
  }

  signout(){
          _authentication.signout();
        _navigationService.navigateReplacementTo(SignInPageRoute);
         
      }

}