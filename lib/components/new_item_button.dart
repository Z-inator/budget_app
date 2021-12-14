import 'package:budget_app/models/spending_item.dart';
import 'package:budget_app/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class EditItemButton extends StatelessWidget {
  final bool isNew;
  final SpendingItem spendingItem;
  const EditItemButton(
      {Key? key, required this.spendingItem, required this.isNew})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Database database = Provider.of<Database>(context);
    return FloatingActionButton(
      onPressed: () => showModalBottomSheet(
          context: context,
          builder: (context) => ChangeNotifierProvider<EditItemProvider>(
              create: (context) => EditItemProvider(spendingItem: spendingItem),
              builder: (context, child) {
                EditItemProvider editItemProvider =
                    Provider.of<EditItemProvider>(context);
                Database database = Provider.of<Database>(context);
                return Container(
                  child: Column(
                    children: [
                      updateItemText(
                          editItemProvider.updateSpendingItemName, 'Name'),
                      updateItemText(
                          editItemProvider.updateSpendingItemVendor, 'Vendor'),
                      updateItemCost(
                          editItemProvider.updateSpendingItemCost, 'Price'),
                      updateItemText(editItemProvider.updateSpendingItemName,
                          'Description'),
                      OutlinedButton(
                          onPressed: () => isNew
                              ? database.addSpendingItem(
                                  editItemProvider.spendingItem)
                              : database.updateSpendingItem(
                                  editItemProvider.spendingItem),
                          child: Text('Add!'))
                    ],
                  ),
                );
              })),
    );
  }

  Widget updateItemText(Function updateFunction, String labelText) {
    return TextField(
      decoration:
          InputDecoration(labelText: labelText, border: OutlineInputBorder()),
      onChanged: (newText) => updateFunction(newText),
    );
  }

  Widget updateItemCost(Function updateFunction, String labelText) {
    final currencyFormat = NumberFormat('#,##0.00', 'en_US');
    return TextField(
      keyboardType: TextInputType.number,
      decoration:
          InputDecoration(labelText: labelText, border: OutlineInputBorder()),
      onChanged: (newText) =>
          updateFunction(currencyFormat.format(double.parse(newText))),
    );
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
