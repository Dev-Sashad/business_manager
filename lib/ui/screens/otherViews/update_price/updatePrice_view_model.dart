
import 'package:records/core/services/firestoreServices.dart';
import 'package:records/utils/baseModel/baseModel.dart';
import 'package:records/utils/constants/helpers.dart';
import 'package:records/utils/constants/locator.dart';
import 'package:records/utils/dialogeManager/dialogService.dart';
import 'package:records/utils/router/navigationService.dart';

class UpdatePriceViewModel extends BaseModel {
      final FireStoreService _fireStoreService = locator<FireStoreService>();
      final ProgressService _progressService = locator<ProgressService>();
      final NavigationService _navigationService = locator<NavigationService>();
     
       int newUnitPrice;

getItemList(){
 return _fireStoreService.getItem();
}

setOnChangeQuantity(int value){
    newUnitPrice = value;
    notifyListeners();
}

updatePrice(){
    _progressService.loadingDialog();
  checkSession().then((value){
 if (newUnitPrice > 0 && selectedItem!=null){
   _progressService.dialogComplete(response);
  _fireStoreService.updatePrice(documentId, newUnitPrice);
  return _progressService.showDialog(title: 'Price Sucessfully Updated');
         }  

else  if (newUnitPrice <= 0 || selectedItem==null) {
  _progressService.dialogComplete(response);
   return _progressService.showDialog(title: 'Error',
    description: 'check input values');
         }
  }
  );
}



pop(){
  _navigationService.pop();
}

      

}




