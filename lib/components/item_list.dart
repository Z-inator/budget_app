import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:budget_app/main.dart';
import 'package:budget_app/models/spending_item.dart';
import 'package:budget_app/services/firestore.dart';

class ItemList extends StatelessWidget {
  final List<SpendingItem> items;
  const ItemList({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<SpendingItem> items = Provider.of<Database>(context).getOrderedSpendingItems();
    return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) => Item(
                    item: items[index],
                  ));
  }


  // @override
  // Widget build(BuildContext context) {
  //   return StreamBuilder<QuerySnapshot<SpendingItem>>(
  //       stream: Provider.of<Database>(context).spendingItemStream(),
  //       builder: (BuildContext context,
  //           AsyncSnapshot<QuerySnapshot<SpendingItem>> snapshot) {
  //         if (snapshot.hasError) {
  //           return ErrorPage(errorMessage: snapshot.error.toString());
  //         } else if (!snapshot.hasData) {
  //           return LoadingPage();
  //         }
  //         final QuerySnapshot<SpendingItem> data = snapshot.requireData;
  //         return ListView.builder(
  //             itemCount: data.size,
  //             itemBuilder: (context, index) => Item(
  //                   item: data.docs[index].data(),
  //                   reference: data.docs[index].reference,
  //                 ));
  //       });
  // }
}

class Item extends StatelessWidget {
  final SpendingItem item;
  const Item({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
