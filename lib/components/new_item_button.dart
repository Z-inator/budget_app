import 'package:budget_app/models/spending_item.dart';
import 'package:budget_app/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewItemButton extends StatelessWidget {
  const NewItemButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Database database = Provider.of<Database>(context);
    return FloatingActionButton(
      onPressed: () => showModalBottomSheet(
          context: context,
          builder: (context) => ChangeNotifierProvider<EditItemProvider>(
              create: (context) => EditItemProvider(
                  spendingItem: SpendingItem(createDate: DateTime.now())),
              child: EditSpendingItem())),
    );
  }
}

class EditItemButton extends StatelessWidget {
  final SpendingItem spendingItem;
  const EditItemButton({Key? key, required this.spendingItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Database database = Provider.of<Database>(context);
    return FloatingActionButton(
      onPressed: () => showModalBottomSheet(
          context: context,
          builder: (context) => ChangeNotifierProvider<EditItemProvider>(
              create: (context) => EditItemProvider(
                  spendingItem: spendingItem),
              child: EditSpendingItem())),
    );
  }
}

class EditSpendingItem extends StatelessWidget {
  const EditSpendingItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EditItemProvider editItemProvider = Provider.of<EditItemProvider>(context);
    return Container(
      child: Column(
        children: [
          itemName(editItemProvider),
          itemVendor(editItemProvider),
          itemCost(editItemProvider),
          itemDescription(editItemProvider),
          submitButton(editItemProvider)
        ],
      ),
    );
  }

  Widget itemName(EditItemProvider editItemProvider) {
    return ListTile();
  }

  Widget itemVendor(EditItemProvider editItemProvider) {
    return ListTile();
  }

  Widget itemCost(EditItemProvider editItemProvider) {
    return ListTile();
  }

  Widget itemDescription(EditItemProvider editItemProvider) {
    return ListTile();
  }

  Widget submitButton(EditItemProvider editItemProvider) {
    return OutlinedButton(onPressed: () {}, child: Text('Add!'));
  }
}

class EditItemProvider with ChangeNotifier {
  final SpendingItem spendingItem;

  EditItemProvider({required this.spendingItem});

  void updateSpendingItemCreateDate(DateTime newCreateDate) {
    spendingItem.createDate = newCreateDate;
    notifyListeners();
  }

  void updateSpendingItemName(String newName) {
    spendingItem.name = newName;
    notifyListeners();
  }

  void updateSpendingItemVendor(String newVendor) {
    spendingItem.vendor = newVendor;
    notifyListeners();
  }

  void updateSpendingItemCost(double newCost) {
    spendingItem.cost = newCost;
    notifyListeners();
  }

  void updateSpendingItemDescription(String newDescription) {
    spendingItem.description = newDescription;
    notifyListeners();
  }
}
