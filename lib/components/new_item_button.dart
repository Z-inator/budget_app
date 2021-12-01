import 'package:budget_app/services/firestore.dart';
import 'package:flutter/material.dart';

class NewItemButton extends StatelessWidget {
  const NewItemButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => addSpendingItem(item),
    );
  }
}