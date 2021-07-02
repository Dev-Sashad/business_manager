


import 'package:records/core/services/firestoreServices.dart';
import 'package:records/utils/baseModel/baseModel.dart';
import 'package:records/utils/constants/locator.dart';
import 'package:records/utils/router/navigationService.dart';
import 'package:records/utils/router/routeNames.dart';

class StockListViewModel extends BaseModel {
  final FireStoreService _fireStoreService = locator<FireStoreService>();
final NavigationService _navigationService = locator<NavigationService>();

getStockList(){
 return _fireStoreService.getStocks();
}

 void navigateToAddItem() {
    _navigationService.navigateReplacementTo(AddItemRoute);
  }

pop(){
  _navigationService.pop();
}
}