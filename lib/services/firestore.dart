import 'package:budget_app/models/spending_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Database with ChangeNotifier {
  final User user;
  final CollectionReference<SpendingItem> spendingItemReference;

  Database({required this.user})
      : spendingItemReference = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('spendingItems')
            .withConverter<SpendingItem>(
                fromFirestore: (snapshot, _) =>
                    SpendingItem.fromMap(snapshot.data()!, snapshot.reference),
                toFirestore: (spendingItem, _) => spendingItem.toMap());

  Stream<QuerySnapshot<SpendingItem>> spendingItemStream() {
    return spendingItemReference
        .orderBy('createDate', descending: true)
        .snapshots();
  }

  List<SpendingItem> getOrderedSpendingItems() {
    List<SpendingItem> items = [];
    spendingItemStream().first.then((value) {
      value.docs.map((documentSnapshot) => items.add(documentSnapshot.data()));
    });
    return items;
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
}
