import 'package:budget_app/models/document_user.dart';
import 'package:budget_app/models/spending_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Database with ChangeNotifier {
  final User user;
  final CollectionReference<SpendingItem> spendingItemReference;
  final DocumentReference userDocumentReference;
  late DocumentUser documentUser;
  late List<SpendingItem> items;

  Database({required this.user})
      : spendingItemReference = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('spendingItems')
            .withConverter<SpendingItem>(
                fromFirestore: (snapshot, _) =>
                    SpendingItem.fromMap(snapshot.data()!, snapshot.reference),
                toFirestore: (spendingItem, _) => spendingItem.toMap()),
        userDocumentReference = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .withConverter<DocumentUser>(
                fromFirestore: (snapshot, _) =>
                    DocumentUser.fromMap(snapshot.data()!),
                toFirestore: (userDocument, _) => userDocument.toMap()) {
    getDocumentUserDetails();
    getOrderedItems();
  }

  Future<void> getDocumentUserDetails() {
    return userDocumentReference.get().then((DocumentSnapshot snapshot) {
      documentUser = snapshot.data()! as DocumentUser;
    });
  }

  Stream<QuerySnapshot<SpendingItem>> spendingItemStream() {
    return spendingItemReference
        .orderBy('createDate', descending: true)
        .snapshots();
  }

  List<SpendingItem> getOrderedItems() {
    spendingItemStream().first.then((value) {
      value.docs.map((documentSnapshot) => items.add(documentSnapshot.data()));
    });
    return items;
  }

  List<SpendingItem> getSpentItems() {
    return items.where((item) => item.cost > 0).toList();
  }

  List<SpendingItem> getSurplusItems() {
    return items.where((item) => item.cost < 0).toList();
  }

  double getTotalSurplus() {
    double cost = 0;
    getSurplusItems().forEach((element) {
      cost += element.cost;
    });
    return cost;
  }

  int getTotalMonths() {
    DateTime createDate = documentUser.createDate;
    DateTime now = DateTime.now();
    return now.month +
        (12 - createDate.month) +
        (12 * (now.year - createDate.year));
  }

  double getTotalSpendingAdded() {
    return getTotalSurplus() + (getTotalMonths() * 100.0);
  }

  double getSurplusAvailable() {
    return getTotalSpendingAdded() - getTotalSpent();
  }

  double getTotalSpent() {
    double cost = 0;
    getSpentItems().forEach((element) {
      cost += element.cost;
    });
    return cost;
  }

  List<SpendingItem> currentMonthSpentItems() {
    return getSpentItems()
        .where((element) =>
            element.createDate.year == DateTime.now().year &&
            element.createDate.month == DateTime.now().month)
        .toList();
  }

  double currentMonthAvailbleSpending() {
    double spent = 0;
    currentMonthSpentItems().forEach((element) {
      spent += element.cost;
    });
    return spent;
  }

  Future<void> addSpendingItem(SpendingItem item) {
    return spendingItemReference
        .add(item)
        .then((value) => print("Spending Item Added"))
        .catchError((error) => print('Failed to add Spending Item: $error'));
  }

  Future<void> updateSpendingItem(SpendingItem item) {
    return spendingItemReference
        .doc(item.reference)
        .update(item.toMap())
        .then((value) => print("Spending Item Updated"))
        .catchError((error) => print('Failed to update Spending Item: $error'));
  }

  Future deleteSpendingItem(SpendingItem item) {
    return spendingItemReference
        .doc(item.reference)
        .delete()
        .then((value) => print("Spending Item Deleted"))
        .catchError((error) => print('Failed to delete Spending Item: $error'));
  }

  Future updateUserDocument(Map<String, dynamic> data) {
    return userDocumentReference
        .update(data)
        .then((value) => print('User document updated'))
        .catchError((error) => print('Failed to update user document: $error'));
  }
}
