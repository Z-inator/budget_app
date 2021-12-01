import 'package:budget_app/components/budget_bar.dart';
import 'package:budget_app/components/item_list.dart';
import 'package:budget_app/components/new_item_button.dart';
import 'package:budget_app/models/spending_item.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget App',
      theme: buildTheme(ThemeData.light()),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  List<SpendingItem> items = [];
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MonthBudgetBar(),
        body: ItemList(items: items),
        floatingActionButton: NewItemButton(),
      )
    );
  }
}



ThemeData buildTheme(ThemeData base) {
  return base.copyWith();
}
