import 'package:flutter/material.dart';
import 'package:teslamate/screens/charges_screen.dart';
import 'package:teslamate/screens/dashboard.dart';
import 'package:teslamate/screens/drives_screen.dart';
import 'package:teslamate/utils/routes.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  late String _title;
  late Color _color;

  static const List<Color> _colorOptions = <Color>[
    RoutesColors.dashboard,
    RoutesColors.charge,
    RoutesColors.drive,
    RoutesColors.statistics,
    RoutesColors.settings,
  ];

  static const List<String> _titleOptions = <String>[
    RoutesTabNames.dashboard,
    RoutesTabNames.charge,
    RoutesTabNames.drive,
    RoutesTabNames.statistics,
    RoutesTabNames.settings,
  ];

  static const List<Widget> _widgetOptions = <Widget>[
    Dashboard(),
    ChargesScreen(),
    DrivesScreen(),
    Dashboard(),
    Dashboard(),
  ];

  @override
  void initState() {
    super.initState();
    _title = _titleOptions.elementAt(0);
    _color = _colorOptions.elementAt(0);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _title = _titleOptions.elementAt(index);
      _color = _colorOptions.elementAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        backgroundColor: _color,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: _titleOptions.elementAt(0),
            backgroundColor: _colorOptions.elementAt(0),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.battery_charging_full),
            label: _titleOptions.elementAt(1),
            backgroundColor: _colorOptions.elementAt(1),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.drive_eta),
            label: _titleOptions.elementAt(2),
            backgroundColor: _colorOptions.elementAt(2),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.stacked_bar_chart),
            label: _titleOptions.elementAt(3),
            backgroundColor: _colorOptions.elementAt(3),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: _titleOptions.elementAt(4),
            backgroundColor: _colorOptions.elementAt(4),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
