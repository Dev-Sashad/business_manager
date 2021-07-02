import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:records/utils/baseModel/baseModel.dart';
import 'package:records/utils/constants/locator.dart';
import 'package:records/utils/dialogeManager/dialogService.dart';

class FireStoreService extends BaseModel {

final ProgressService _progressService = locator<ProgressService>();
var userIdentity = FirebaseAuth.instance.currentUser.uid;
  final firestoreInstance = FirebaseFirestore.instance;
  additem(String productName, int quantity, int price) async {
  print('the item is $productName');
  await FirebaseFirestore.instance
        .collection('users')
        .doc(userIdentity)
        .collection('stockList')
        .where('item', isEqualTo: '$productName')
        .get().then((data) {
           if(data.docs.isEmpty){
    firestoreInstance.runTransaction((Transaction transaction) async {
      CollectionReference reference = firestoreInstance
          .collection('users')
          .doc(userIdentity)
          .collection('stockList');
      await reference.add({
        "item": productName.toString(),
        "quantity": quantity,
        "price": price,
      });
    });

     return _progressService.showDialog(
            description: 'item successfully added');
            }

            else{
                     return _progressService.showDialog(
            title: 'error', description: 'item already exist'); 
              }
        });
  }


  recentlySold() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userIdentity)
        .collection('sales')
        .orderBy('Date', descending: true)
        .limit(7).snapshots();
  }

   getTodaySales() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userIdentity)
        .collection('sales')
        .orderBy('Date')
        .snapshots();
  }

  getYesterdaySales() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userIdentity)
        .collection('sales')
        .orderBy('Date')
        .snapshots();
  }

  getTotalSales() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userIdentity)
        .collection('sales')
        .orderBy('Date')
        .snapshots();
  }

  getItem() {
    return firestoreInstance
        .collection('users')
        .doc(userIdentity)
        .collection('stockList')
        .orderBy("item")
        .snapshots();
  }

  getSales() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userIdentity)
        .collection('sales')
        .orderBy('Date', descending: true)
        .limit(100)
        .get();
  }

  getStocks() {
     return FirebaseFirestore.instance
        .collection('users')
        .doc(userIdentity)
        .collection('stockList')
        .orderBy("quantity")
        .get();
  }

  addStock(String documentId, int actualQuantity) async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('users')
        .doc(userIdentity)
        .collection('stockList')
        .doc(documentId);
    FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      int newQuantity = snapshot.data()['quantity'] + actualQuantity;
      print('new Quantity=$newQuantity');

      transaction.update(documentReference, {"quantity": newQuantity});
      return newQuantity;
    });
  }


   updatePrice(String documentId, int newUnitPrice) async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('users')
        .doc(userIdentity)
        .collection('stockList')
        .doc(documentId);
    FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
      transaction.update(documentReference, {"price": newUnitPrice});
      return newUnitPrice;
    });
  }

  sell(String selectedItem, int newPrice, int actualQuantity,
      String newDateTime, documentId) async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('users')
        .doc(userIdentity)
        .collection('stockList')
        .doc(documentId);
    firestoreInstance.runTransaction((Transaction transaction) async {
      CollectionReference reference = FirebaseFirestore.instance
          .collection('users')
          .doc(userIdentity)
          .collection('sales');
      await reference.add({
        "Item": selectedItem,
        "Price": newPrice,
        "Quantity_sold": actualQuantity,
        "Date": newDateTime,
        //"Time": newTime,
      });

      DocumentSnapshot snapshot = await transaction.get(documentReference);
      int newQuantity = snapshot.data()['quantity'] - actualQuantity;
      print('new Quantity=$newQuantity');

      transaction.update(documentReference, {"quantity": newQuantity});

      return newQuantity;
    });
  }
}
