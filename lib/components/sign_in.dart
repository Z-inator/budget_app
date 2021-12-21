import 'package:budget_app/services/authentification.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Welcome to my Spending Tracker',
                style: Theme.of(context).textTheme.headline2,
              ),
              const Text('Please sign in to continue.'),
              IconButton(
                  onPressed: () => Provider.of<AuthService>(context, listen: false)
                      .signInWithGoogle()
                      .then((result) => ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(result))))
                      .then((value) => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewUserStepper()))),
                  icon: const Image(
                    image: AssetImage('assets/Google-Logo.png'),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class NewUserStepper extends StatefulWidget {
  NewUserStepper({Key? key}) : super(key: key);

  @override
  _NewUserStepperState createState() => _NewUserStepperState();
}

class _NewUserStepperState extends State<NewUserStepper> {
  int _index = 0;
  DateTime? startDate = DateTime.now();
  String spendingAmount = '0.00';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(),
      body: Stepper(
        currentStep: _index,
        onStepCancel: () {
          if (_index > 0) {
            setState(() {
              _index -= 1;
            });
          }
        },
        onStepContinue: () {
          if (_index <= 0) {
            setState(() {
              _index += 1;
            });
          } else {
            Provider.of<AuthService>(context).buildNewUser({
                  'createDate': startDate, 
                  'monthlySpending': spendingAmount,
                });
            Navigator.pop(context);
          }
        },
        onStepTapped: (int index) {
          setState(() {
            _index = index;
          });
        },
        steps: [
          Step(
              title:
                  Text('When do you want to set your spending starting date?'),
              content: TextButton.icon(
                  onPressed: () {
                    setState(() async {
                      startDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100));
                    });
                  },
                  icon: Icon(Icons.today_rounded),
                  label: Text(DateFormat.yMMMMd('en_US').format(startDate!)))),
          Step(
              title: Text('How much do you want to spend a month?'),
              content: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: spendingAmount, border: OutlineInputBorder()),
                  onChanged: (newText) {
                    setState(() {
                      spendingAmount = NumberFormat('#,##0.00', 'en_US')
                          .format(double.parse(newText));
                    });
                  }))
        ],
      ),
    ));
  }
}
