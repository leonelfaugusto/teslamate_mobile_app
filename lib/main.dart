import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:teslamate/classes/car_status.dart';
import 'package:teslamate/classes/cars.dart';
import 'package:teslamate/classes/charges.dart';
import 'package:teslamate/classes/drives.dart';
import 'package:teslamate/classes/preferences.dart';
import 'package:teslamate/screens/charge_screen.dart';
import 'package:teslamate/screens/home.dart';
import 'package:teslamate/screens/settings_screen.dart';
import 'package:teslamate/utils/mqtt_client_wrapper.dart';
import 'package:teslamate/utils/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  FlutterNativeSplash.removeAfter(initialization);
  String locale = await findSystemLocale();
  Intl.defaultLocale = locale;
  runApp(const App());
}

void initialization(BuildContext context) async {
  await Future.delayed(const Duration(milliseconds: 500));
  // This is where you can initialize the resources needed by your app while
  // the splash screen is displayed.  After this function completes, the
  // splash screen will be removed.
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Cars(),
        ),
        ChangeNotifierProvider(
          create: (context) => CarStatus(),
        ),
        ChangeNotifierProvider(
          create: (context) => Charges(),
        ),
        ChangeNotifierProvider(
          create: (context) => Drives(),
        ),
        ChangeNotifierProvider(
          create: (context) => MqttClientWrapper(),
        ),
        ChangeNotifierProvider(
          create: (context) => Preferences(),
        ),
      ],
      child: MaterialApp(
        title: 'Teslamate',
        theme: ThemeData(
          brightness: Brightness.dark,
        ),
        routes: {
          Routes.home: (_) => const Home(),
          Routes.charge: (_) => const ChargeScreen(),
          Routes.settings: (_) => const SettingsScreen(),
        },
        localizationsDelegates: const [
          AppLocalizations.delegate,
          RefreshLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }
}
