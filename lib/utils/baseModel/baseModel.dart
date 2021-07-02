import 'package:flutter/widgets.dart';
import 'package:records/utils/constants/locator.dart';
import 'package:records/utils/dialogeManager/dialogModels.dart';
import 'package:records/utils/dialogeManager/dialogService.dart';

class BaseModel extends ChangeNotifier {
  final ProgressService _progressService = locator<ProgressService>();
  ProgressResponse response;
  // String userName;
  // String get userNm => userName;

  int total = 0;
  int get totalSls => total;

  int itemQuantity = 0;
  int get itemQty => itemQuantity;

  int itemPrice = 0;
  int get itemPr => itemPrice;
  
  String documentId;
  String get id => documentId;

  String selectedItem;
  String get selectedItm => selectedItem;

  bool _busy = false;
  bool get busy => _busy;


// set userNm(String value) {
// userName = value;
// notifyListeners();
// print(userName.toString());
// }

  set selectedItm(String stockItemsValue){
  selectedItem=stockItemsValue;
  notifyListeners();
  print(selectedItem.toString());
}


set totalSls(int value) {
total = value;
notifyListeners();
print(total.toString());
}


set itemQty(int value) {
itemQuantity = value;
notifyListeners();
print(itemQuantity.toString());
}

set itemPr(int value) {
itemPrice = value;
notifyListeners();
print(itemPrice.toString());
}

set id(String value) {
documentId = value;
notifyListeners();
print(documentId.toString());
}

  String getItemQty(){
    notifyListeners();
   return itemQty.toString();
  }

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
    if(value == true){
      _progressService.loadingDialog();
    }else
    {
      _progressService.dialogComplete(response);
    }
  }


 dropDownValue(String stockItemsValue){
  selectedItem=stockItemsValue;
  print(selectedItem.toString());
  notifyListeners();
}



}
