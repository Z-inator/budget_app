import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class SpendingItem {
  final DocumentReference reference;
  final DateTime createDate;
  final String itemName;
  final String store;
  final double cost;
  final String reason;
  final String description;

  SpendingItem({
    required this.reference,
    required this.createDate,
    required this.itemName,
    required this.store,
    required this.cost,
    required this.reason,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'createDate': createDate.millisecondsSinceEpoch,
      'itemName': itemName,
      'store': store,
      'cost': cost,
      'reason': reason,
      'description': description,
    };
  }

  factory SpendingItem.fromMap(Map<String, dynamic> map, DocumentReference reference) {
    return SpendingItem(
      reference: reference,
      createDate: (map['createDate'] as Timestamp).toDate(),
      itemName: map['itemName'],
      store: map['store'],
      cost: map['cost'],
      reason: map['reason'],
      description: map['description'],
    );
  }
}
