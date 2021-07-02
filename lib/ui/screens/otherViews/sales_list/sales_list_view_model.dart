import 'package:firebase_auth/firebase_auth.dart';
import 'package:records/core/services/firestoreServices.dart';
import 'package:records/utils/baseModel/baseModel.dart';
import 'package:records/utils/constants/locator.dart';
import 'package:records/utils/router/navigationService.dart';
import 'package:records/utils/router/routeNames.dart';

class SalesListViewModel extends BaseModel {
  final FireStoreService _fireStoreService = locator<FireStoreService>();
  final NavigationService _navigationService = locator<NavigationService>();
 
  String userIdentity = FirebaseAuth.instance.currentUser.uid;
  getSalesList() {
    return _fireStoreService.getSales();
  }


  void navigateToSell() {
    _navigationService.navigateReplacementTo(SellRoute);
  }

  pop() {
    _navigationService.pop();
  }
}
