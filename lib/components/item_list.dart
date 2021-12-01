import 'package:budget_app/models/spending_item.dart';
import 'package:flutter/material.dart';


class ItemList extends StatelessWidget {
  final List<SpendingItem> items;
  const ItemList({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(items.length, (index) => Item(item: items[index]))
        ),
      ),
    );
  }
}

class Item extends StatelessWidget {
  final SpendingItem item;
  const Item({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}