import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teslamate/classes/charges.dart';
import 'package:teslamate/classes/drives.dart';
import 'package:teslamate/classes/preferences.dart';
import 'package:teslamate/screens/charges_screen.dart';
import 'package:teslamate/screens/dashboard.dart';
import 'package:teslamate/screens/drives_screen.dart';
import 'package:teslamate/screens/initial_preferences_screen.dart';
import 'package:teslamate/utils/mqtt_client_wrapper.dart';
import 'package:teslamate/utils/routes.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  bool allDone = false;
  late String _title;

  static const List<String> _titleOptions = <String>[
    RoutesTabNames.dashboard,
    RoutesTabNames.charge,
    RoutesTabNames.drive,
    RoutesTabNames.settings,
    RoutesTabNames.statistics,
  ];

  static const List<Widget> _widgetOptions = <Widget>[
    Dashboard(),
    ChargesScreen(),
    DrivesScreen(),
    InitialPreferencesScreen(),
    Dashboard(),
  ];

  @override
  void initState() {
    _title = _titleOptions.elementAt(0);
    super.initState();
  }

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
      _title = _titleOptions.elementAt(index);
    });
  }

  Future<bool> initStates() async {
    MqttClientWrapper clientWrapper = Provider.of<MqttClientWrapper>(context, listen: false);
    Preferences preferences = Provider.of<Preferences>(context, listen: false);
    Charges charges = Provider.of<Charges>(context, listen: false);
    Drives drives = Provider.of<Drives>(context, listen: false);
    if (!clientWrapper.connected) {
      await clientWrapper.connect(context);
    }
    if (!allDone) {
      charges.items = [];
      charges.page = 1;
      drives.items = [];
      drives.page = 1;
      await fetchPreferences(context);
      await fetchCharges(context);
      await fetchDrives(context);
    }
    setState(() {
      allDone = true;
    });
    return preferences.prefsExist;
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
          )));
        }
        if (snapshot.data == true) {
          return Scaffold(
            appBar: AppBar(
              title: Text(_title),
            ),
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
                  icon: const Icon(Icons.bolt),
                  label: _titleOptions.elementAt(1),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.swap_calls),
                  label: _titleOptions.elementAt(2),
                ),
                /* BottomNavigationBarItem(
              icon: const Icon(Icons.stacked_bar_chart),
              label: _titleOptions.elementAt(3),
              backgroundColor: _colorOptions.elementAt(3),
            ), */
                BottomNavigationBarItem(
                  icon: const Icon(Icons.settings),
                  label: _titleOptions.elementAt(3),
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Theme.of(context).hintColor,
              unselectedItemColor: Theme.of(context).hintColor,
              onTap: _onItemTapped,
            ),
          );
        } else {
          return const Scaffold(body: SafeArea(child: InitialPreferencesScreen()));
        }
      },
    );
  }
}

class ProgressBar extends StatelessWidget {
  final bool isLoading;
  const ProgressBar({
    Key? key,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return LinearProgressIndicator(
        minHeight: 1,
        color: Colors.redAccent[700],
      );
    }
    return Container(height: 1);
  }
}
