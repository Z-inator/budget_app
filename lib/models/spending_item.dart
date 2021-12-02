import 'dart:convert';

class SpendingItem {
  final String id;
  final String itemName;
  final String store;
  final double cost;
  final String reason;
  final String description;

  SpendingItem({
    required this.id,
    required this.itemName,
    required this.store,
    required this.cost,
    required this.reason,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'itemName': itemName,
      'store': store,
      'cost': cost,
      'reason': reason,
      'description': description,
    };
  }

  factory SpendingItem.fromMap(Map<String, dynamic> map) {
    return SpendingItem(
      id: map['id'],
      itemName: map['itemName'],
      store: map['store'],
      cost: map['cost'],
      reason: map['reason'],
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SpendingItem.fromJson(String source) =>
      SpendingItem.fromMap(json.decode(source));
}
