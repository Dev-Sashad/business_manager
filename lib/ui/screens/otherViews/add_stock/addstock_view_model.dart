import 'package:records/core/services/firestoreServices.dart';
import 'package:records/utils/baseModel/baseModel.dart';
import 'package:records/utils/constants/helpers.dart';
import 'package:records/utils/constants/locator.dart';
import 'package:records/utils/dialogeManager/dialogService.dart';
import 'package:records/utils/router/navigationService.dart';

class AddStockViewModel extends BaseModel {
      final FireStoreService _fireStoreService = locator<FireStoreService>();
      final ProgressService _progressService = locator<ProgressService>();
      final NavigationService _navigationService = locator<NavigationService>();
       
       int actualQuantity = 0 ;
       int get actualQty => actualQuantity;
       



getItemList(){
 return _fireStoreService.getItem();
}

onChanaged(int value){
    actualQuantity = value;
    notifyListeners();
    print(actualQuantity.toString());
}

getAddedQuantity( int value){
  actualQuantity= value;
  print(actualQty);
  notifyListeners();
}


addStock(){
    _progressService.loadingDialog();
  checkSession().then((value){
    print(actualQty);
    print(itemQty);
    print(selectedItem);
 if ( actualQty > 0 && selectedItm !=null){
   _progressService.dialogComplete(response);
  _fireStoreService.addStock(id, actualQty);
  return _progressService.showDialog(
    title: 'Sucessfully Added'
  );
         }  

else  {
   _progressService.dialogComplete(response);
   return _progressService.showDialog(
    title: 'Error',
    description: 'check input values'
  );
         }

  }
  );
}


pop(){
  _navigationService.pop();
}


}




