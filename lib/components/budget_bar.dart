import 'package:flutter/material.dart';

class MonthBudgetBar extends StatelessWidget implements PreferredSizeWidget {
  const MonthBudgetBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar();
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
