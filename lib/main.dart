import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:teslamate/classes/car.dart';
import 'package:teslamate/screens/charge_screen.dart';
import 'package:teslamate/screens/home.dart';
import 'package:teslamate/utils/routes.dart';

void main() async {
  String locale = await findSystemLocale();
  Intl.defaultLocale = locale;
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Car(id: 1),
        ),
      ],
      child: MaterialApp(
        title: 'Teslamate Companion',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepOrange).copyWith(secondary: Colors.lightGreen),
        ),
        routes: {
          Routes.home: (_) => const Home(),
          Routes.charge: (_) => const ChargeScreen(),
        },
        localizationsDelegates: const [
          RefreshLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale("pt", "pt_PT"),
        ],
      ),
    );
  }
}
