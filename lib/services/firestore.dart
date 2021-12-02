import 'package:budget_app/models/spending_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  final User user;
  final CollectionReference spendingItemReference;

  Database({required this.user})
      : spendingItemReference = FirebaseFirestore.instance
            .collection('users')
            .doc(user.id)
            .collection('collectionPath')
            .withConverter(
                fromFirestore: (snapshot, _) =>
                    SpendingItem.fromMap(snapshot.data()!),
                toFirestore: (spendingItem, _) => spendingItem!.toMap());

  Future<DocumentSnapshot> readSpendingItem(String id) {
    return spendingItemReference.doc(id).get();
  }

  Future<void> addSpendingItem(SpendingItem item) {
    return spendingItemReference
        .add(item)
        .then((value) => print("Spending Item Added"))
        .catchError((error) => print('Failed to add Spending Item: $error'));
  }

  Future<void> updateSpendingItem(SpendingItem item) {
    return spendingItemReference
        .doc(item.id)
        .update(item.toMap())
        .then((value) => print("Spending Item Updated"))
        .catchError((error) => print('Failed to update Spending Item: $error'));
  }

  Future deleteSpendingItem(SpendingItem item) {
    return spendingItemReference
        .doc(item.id)
        .delete()
        .then((value) => print("Spending Item Deleted"))
        .catchError((error) => print('Failed to delete Spending Item: $error'));
  }
}
