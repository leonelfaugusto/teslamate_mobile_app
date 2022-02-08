import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:teslamate/screens/charges_screen.dart';
import 'package:teslamate/screens/dashboard.dart';
import 'package:teslamate/screens/drives_screen.dart';
import 'package:teslamate/utils/mqtt_client_wrapper.dart';
import 'package:teslamate/utils/routes.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late MqttServerClient client;
  int _selectedIndex = 0;
  late String _title;
  late Color _color;

  static const List<Color> _colorOptions = <Color>[
    RoutesColors.dashboard,
    RoutesColors.charge,
    RoutesColors.drive,
    RoutesColors.settings,
    RoutesColors.statistics,
  ];

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
    Dashboard(),
    Dashboard(),
  ];

  @override
  void initState() {
    connect(context).then((value) => client = value);
    _title = _titleOptions.elementAt(0);
    _color = _colorOptions.elementAt(0);
    super.initState();
  }

  void _onItemTapped(int index) async {
    if (index == 0) {
      client = await connect(context);
    } else {
      client.disconnect();
    }
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
            icon: const Icon(Icons.bolt),
            label: _titleOptions.elementAt(1),
            backgroundColor: _colorOptions.elementAt(1),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.swap_calls),
            label: _titleOptions.elementAt(2),
            backgroundColor: _colorOptions.elementAt(2),
          ),
          /* BottomNavigationBarItem(
            icon: const Icon(Icons.stacked_bar_chart),
            label: _titleOptions.elementAt(3),
            backgroundColor: _colorOptions.elementAt(3),
          ), */
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: _titleOptions.elementAt(3),
            backgroundColor: _colorOptions.elementAt(3),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
