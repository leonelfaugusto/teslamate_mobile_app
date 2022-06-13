import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teslamate/classes/car_status.dart';
import 'package:teslamate/classes/cars.dart';
import 'package:teslamate/classes/charges.dart';
import 'package:teslamate/classes/drives.dart';
import 'package:teslamate/classes/loading.dart';
import 'package:teslamate/classes/preferences.dart';
import 'package:teslamate/screens/charge_screen.dart';
import 'package:teslamate/screens/drive_screen.dart';
import 'package:teslamate/screens/home.dart';
import 'package:teslamate/screens/settings_screen.dart';
import 'package:teslamate/utils/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'firebase_options.dart';
import 'package:http/http.dart' as http;

void main() async {
  await dotenv.load(fileName: ".env");
  FlutterNativeSplash.removeAfter(initialization);
  String locale = await findSystemLocale();
  Intl.defaultLocale = locale;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

Future<void> saveTokenToDatabase(String? token) async {
  // Assume user is logged in for this example
  var deviceInfo = DeviceInfoPlugin();
  String? deviceId = "";
  if (Platform.isIOS) {
    var iosDeviceInfo = await deviceInfo.iosInfo;
    deviceId = iosDeviceInfo.identifierForVendor;
  } else {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    deviceId = androidDeviceInfo.androidId;
  }
  try {
    var url = dotenv.env['APP_MODE'] == 'TEST' ? dotenv.env['API_URL_DEV'] : dotenv.env['API_URL_PROD'];
    Response responseLogin = await http.post(
      Uri.parse('$url/users/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        <String, String>{
          'email': 'leonelfaugusto@gmail.com',
          'password': '25802580Tks',
        },
      ),
    );
    Map<String, dynamic> body = jsonDecode(responseLogin.body);
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString("token", body['token']);
    Response response = await http.post(
      Uri.parse('$url/notifications/update_notification_token'),
      headers: {
        "Content-Type": "application/json",
        "authorization": "B ${body['token']}",
      },
      body: jsonEncode(
        <String, String>{
          'token': token as String,
          'deviceId': deviceId as String,
        },
      ),
    );
    print(response.body);
  } catch (e) {
    print("Error: $e");
  }
}

void initialization(BuildContext context) async {
  await Future.delayed(const Duration(milliseconds: 500));
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  String? token = await FirebaseMessaging.instance.getToken();
  await saveTokenToDatabase(token);
  FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
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
          create: (context) => Preferences(),
        ),
        ChangeNotifierProvider(
          create: (context) => Loading(),
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
          Routes.drive: (_) => const DriveScreen(),
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
