import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:budget_app/components/budget_bar.dart';
import 'package:budget_app/components/item_list.dart';
import 'package:budget_app/components/new_item_button.dart';
import 'package:budget_app/components/sign_in.dart';
import 'package:budget_app/models/spending_item.dart';
import 'package:budget_app/services/authentification.dart';
import 'package:budget_app/services/firestore.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization =
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget App',
      theme: buildTheme(ThemeData.light()),
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorPage(errorMessage: snapshot.error.toString());
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return const HomePage();
          }
          return const LoadingPage();
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
        create: (context) => AuthService(),
        builder: (context, child) {
          return StreamBuilder<User?>(
              stream: Provider.of<AuthService>(context).onAuthChanged,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return HomeDashboard(snapshot: snapshot);
                } else if (snapshot.hasError) {
                  return ErrorPage(errorMessage: snapshot.error.toString());
                }
                return const SignIn();
              });
        });
  }
}

class HomeDashboard extends StatelessWidget {
  final AsyncSnapshot<User?> snapshot;
  const HomeDashboard({
    Key? key,
    required this.snapshot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Database>(
      create: (context) => Database(user: snapshot.data!),
      builder: (context, child) {
        Database database = Provider.of<Database>(context);
        return SafeArea(
            child: Scaffold(
                appBar: const MonthBudgetBar(),
                body: ItemList(
                  items: database.items,
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () => showEditSheet(
                      context: context,
                      spendingItem: SpendingItem(createDate: DateTime.now()),
                      buttonLabel: 'Add!',
                      saveItem: database.addSpendingItem),
                )));
      },
    );
  }
}

class ErrorPage extends StatelessWidget {
  final String errorMessage;
  const ErrorPage({
    Key? key,
    required this.errorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Text(errorMessage),
      ),
    ));
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
        child: Scaffold(
      body: Center(child: CircularProgressIndicator()),
    ));
  }
}

ThemeData buildTheme(ThemeData base) {
  return base.copyWith();
}
