import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:teslamate/screens/charge_screen.dart';
import 'package:teslamate/screens/home.dart';
import 'package:teslamate/utils/routes.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teslamate Companion',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepOrange).copyWith(secondary: Colors.lightGreen),
      ),
      routes: {
        Routes.home: (_) => const Home(),
        Routes.charge: (_) => const ChargeScreen(),
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("pt", "pt_PT"),
      ],
    );
  }
}
