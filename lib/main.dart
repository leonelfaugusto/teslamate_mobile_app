import 'package:flutter/material.dart';
import 'package:teslamate/screens/dashboard.dart';
import 'package:teslamate/utils/routes.dart';

void main() {
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teslamate Companion',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepOrange).copyWith(secondary: Colors.lightGreen),
      ),
      routes: {Routes.dashboard: (_) => const Dashboard()},
    );
  }
}
