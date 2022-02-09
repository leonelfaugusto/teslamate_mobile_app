import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teslamate/classes/loading.dart';
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
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<bool> _prefsExist;
  int _selectedIndex = 0;
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
    _prefsExist = _prefs.then((SharedPreferences prefs) {
      /* prefs.remove('api');
      prefs.remove('mqqt');
      prefs.remove('prefsExist'); */
      return prefs.getBool('prefsExist') ?? false;
    });
    super.initState();
  }

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
      _title = _titleOptions.elementAt(index);
    });
  }

  Future<Map<String, dynamic>> initStates() async {
    final client = await connect(context);
    final prefsExist = await _prefsExist;
    return {
      "client": client,
      "prefsExist": prefsExist,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: initStates(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data?['prefsExist'] == true) {
          return Scaffold(
            appBar: AppBar(
              title: Text(_title),
              bottom: PreferredSize(
                preferredSize: const Size(double.infinity, 1.0),
                child: Consumer<Loading>(
                  builder: (context, loading, child) {
                    return ProgressBar(isLoading: loading.isLoading);
                  },
                ),
              ),
            ),
            body: Center(
              child: _widgetOptions.elementAt(_selectedIndex),
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
          return Scaffold(body: SafeArea(child: InitialPreferencesScreen()));
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
