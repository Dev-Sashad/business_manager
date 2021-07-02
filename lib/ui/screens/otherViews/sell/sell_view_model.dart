import 'package:records/core/services/firestoreServices.dart';
import 'package:records/utils/baseModel/baseModel.dart';
import 'package:records/utils/constants/helpers.dart';
import 'package:records/utils/constants/locator.dart';
import 'package:records/utils/dialogeManager/dialogService.dart';
import 'package:records/utils/router/navigationService.dart';
// import 'package:records/utils/router/routeNames.dart';

class SellStockViewModel extends BaseModel {
  final FireStoreService _fireStoreService = locator<FireStoreService>();
  final ProgressService _progressService = locator<ProgressService>();
  final NavigationService _navigationService = locator<NavigationService>();

  int newPrice = 0;
  int get newPr => newPrice;
  
  int actualQuantity = 0;
  int get actualQty => actualQuantity;

set newPr(int value) {
newPrice = value;
notifyListeners();
print(newPrice.toString());
}

set actualQty(int value) {
actualQuantity = value;
notifyListeners();
print(actualQuantity.toString());
}

  setOnChangeQuantity(int value) {
    actualQty = value;
    notifyListeners();
  }

  getItemList(){
 return _fireStoreService.getItem();
}

  actualPrice(int newQuantity) {
    if (newQuantity != null) {
      newPr = itemPr * newQuantity;
      notifyListeners();
      print(newPr);
    } else {
      newPr = itemPr * 1;
      notifyListeners();
      print(newPr);
    }
  }

  sell() {
    _progressService.loadingDialog();
    checkSession().then((value) {
      if (selectedItm == null || actualQty <= 0 || actualQty > itemQty) {
        notifyListeners();
        _progressService.dialogComplete(response);
        return _progressService.showDialog(
            title: 'Error', description: 'check input values');
      } else {
        // var date = new DateTime.now().toString();
        // var newDateTime = formatDate(date).toString();
         var newDateTime = DateTime.now().toString();
        _progressService.dialogComplete(response);
        _fireStoreService.sell(selectedItm, newPr, actualQty, newDateTime, id);
        notifyListeners();
        return _progressService.showDialog(title: 'Sucessfully');
      }
    });
  }

  pop() {
    notifyListeners();
    // _navigationService.navigateReplacementTo(HomePageRoute);
    _navigationService.pop();
  }
}
