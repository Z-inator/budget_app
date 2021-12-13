import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class SpendingItem {
  String reference;
  DateTime createDate;
  String name;
  String vendor;
  double cost;
  String description;

  SpendingItem({
    this.reference = '',
    required this.createDate,
    this.name = '',
    this.vendor = '',
    this.cost = 0.0,
    this.description = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'createDate': createDate,
      'itemName': name,
      'store': vendor,
      'cost': cost,
      'description': description,
    };
  }

  factory SpendingItem.fromMap(
      Map<String, dynamic> map, DocumentReference reference) {
    return SpendingItem(
      reference: reference.id,
      createDate: (map['createDate'] as Timestamp).toDate(),
      name: map['itemName'],
      vendor: map['store'],
      cost: map['cost'],
      description: map['description'],
    );
  }

  factory SpendingItem.copySpendingItem(SpendingItem oldSpendingItem) {
    return SpendingItem(
        reference: oldSpendingItem.reference,
        createDate: oldSpendingItem.createDate,
        name: oldSpendingItem.name,
        vendor: oldSpendingItem.vendor,
        cost: oldSpendingItem.cost,
        description: oldSpendingItem.description);
  }
}
