import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:teslamate/classes/car_status.dart';
import 'package:teslamate/classes/cars.dart';
import 'package:teslamate/classes/charges.dart';
import 'package:teslamate/classes/drive.dart';
import 'package:teslamate/classes/drives.dart';
import 'package:teslamate/classes/loading.dart';
import 'package:teslamate/classes/preferences.dart';
import 'package:teslamate/components/custom_drawer.dart';
import 'package:teslamate/screens/charges_screen.dart';
import 'package:teslamate/screens/dashboard.dart';
import 'package:teslamate/screens/drives_screen.dart';
import 'package:teslamate/screens/settings_screen.dart';
import 'package:teslamate/utils/custom_colors.dart';
import 'package:teslamate/utils/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  bool allDone = false;
  late String _title;

  late List<String> _titleOptions;

  static const List<Widget> _widgetOptions = <Widget>[
    Dashboard(),
    ChargesScreen(),
    DrivesScreen(),
  ];

  @override
  void didChangeDependencies() {
    _titleOptions = <String>[
      AppLocalizations.of(context)!.home,
      AppLocalizations.of(context)!.charges,
      AppLocalizations.of(context)!.drives,
    ];
    _title = _titleOptions.elementAt(0);
    super.didChangeDependencies();
  }

  void _onItemTapped(int index) {
    var title = _titleOptions.elementAt(index);
    setState(() {
      _selectedIndex = index;
      _title = title;
    });
  }

  Future<bool> initStates() async {
    Preferences preferences = Provider.of<Preferences>(context, listen: false);
    Charges charges = Provider.of<Charges>(context, listen: false);
    Drives drives = Provider.of<Drives>(context, listen: false);
    Cars cars = Provider.of<Cars>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      await fetchPreferences(context);
    } catch (e) {
      return false;
    }

    try {
      if (!allDone) {
        charges.items = [];
        charges.page = 1;
        drives.items = [];
        drives.page = 1;
        cars.cars = [];
        await Future.wait([
          fetchCars(context),
          fetchDrives(context),
          fetchCharges(context),
        ]);
      }

      setState(() {
        allDone = true;
      });

      return preferences.prefsExist;
    } catch (e) {
      return false;
    }
  }

  Future<void> setupInteractedMessage() async {
    // Also handle any interaction when the app is in the background via a
    // Stream listener

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    FirebaseMessaging.onMessage.listen(_handleMessageForeground);

    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
  }

  void _handleMessageForeground(RemoteMessage message) async {
    Loading loading = Provider.of<Loading>(context, listen: false);
    RemoteNotification? notification = message.notification;
    Drives drives = Provider.of<Drives>(context, listen: false);
    Cars cars = Provider.of<Cars>(context, listen: false);

    bool isFinishDrive = message.data['type'] == 'finish_drive';
    loading.state = true;
    if (isFinishDrive) {
      drives.page = 1;
      drives.show = drives.items.length;
      drives.items = [];
      cars.cars = [];
      await Future.wait([
        fetchCars(context),
        fetchDrives(context),
      ]);
      drives.show = 10;
    }
    loading.state = false;

    SnackBar snackBar = SnackBar(
      content: Text(notification?.title ?? "", style: const TextStyle(color: CustomColors.red)),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Theme.of(context).cardColor,
      padding: const EdgeInsets.all(16),
      action: SnackBarAction(
        label: isFinishDrive ? AppLocalizations.of(context)!.see : AppLocalizations.of(context)!.close,
        onPressed: () async {
          if (isFinishDrive) {
            Drive drive = drives.getDrive(int.parse(message.data['drive_id']));
            if (drive.driveDetails.isEmpty) {
              loading.state = true;
              await drive.fetchMoreInfo();
              loading.state = false;
            }
            Navigator.pushNamed(
              context,
              Routes.drive,
              arguments: drive,
            );
          }
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _handleMessage(RemoteMessage message) async {
    print(message.notification!.title);
    Loading loading = Provider.of<Loading>(context, listen: false);
    await fetchPreferences(context);
    if (message.data['type'] == 'finish_drive') {
      loading.state = true;
      Drives drives = Provider.of<Drives>(context, listen: false);
      Cars cars = Provider.of<Cars>(context, listen: false);
      drives.items = [];
      drives.page = 1;
      cars.cars = [];
      await Future.wait([
        fetchCars(context),
        fetchDrives(context),
      ]);
      Drive drive = drives.getDrive(int.parse(message.data['drive_id']));
      if (drive.driveDetails.isEmpty) {
        await drive.fetchMoreInfo();
      }
      Navigator.pushNamed(
        context,
        Routes.drive,
        arguments: drive,
      );
    }
    loading.state = false;
  }

  @override
  void initState() {
    super.initState();
    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: initStates(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && !allDone) {
          return const Scaffold(
            body: Center(
              child: Image(
                image: AssetImage('lib/assets/images/logo_splash.png'),
                height: 256,
                width: 256,
              ),
            ),
          );
        }
        if (snapshot.data == true) {
          Preferences preferences = Provider.of<Preferences>(context, listen: false);
          CarStatus carStatus = Provider.of<CarStatus>(context, listen: false);
          Cars cars = Provider.of<Cars>(context, listen: false);
          Loading loading = Provider.of<Loading>(context, listen: false);
          return Scaffold(
            appBar: AppBar(
              title: Text(_title),
              actions: [
                if (loading.state)
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: JumpingDotsProgressIndicator(
                      fontSize: 20.0,
                      color: Theme.of(context).textTheme.titleLarge?.color as Color,
                    ),
                  ),
              ],
            ),
            drawer: CustomDrawer(cars, preferences, carStatus),
            body: Center(
              child: snapshot.hasData ? _widgetOptions.elementAt(_selectedIndex) : null,
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home),
                  label: _titleOptions.elementAt(0),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.ev_station),
                  label: _titleOptions.elementAt(1),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.swap_calls),
                  label: _titleOptions.elementAt(2),
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: CustomColors.red,
              unselectedItemColor: Theme.of(context).hintColor,
              onTap: _onItemTapped,
            ),
          );
        } else {
          return const SettingsScreen();
        }
      },
    );
  }
}
