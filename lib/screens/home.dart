import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teslamate/classes/car_status.dart';
import 'package:teslamate/classes/cars.dart';
import 'package:teslamate/classes/charges.dart';
import 'package:teslamate/classes/drives.dart';
import 'package:teslamate/classes/preferences.dart';
import 'package:teslamate/screens/charges_screen.dart';
import 'package:teslamate/screens/dashboard.dart';
import 'package:teslamate/screens/drives_screen.dart';
import 'package:teslamate/screens/settings_screen.dart';
import 'package:teslamate/utils/custom_colors.dart';
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
  ];

  static const List<Widget> _widgetOptions = <Widget>[
    Dashboard(),
    ChargesScreen(),
    DrivesScreen(),
  ];

  @override
  void initState() {
    _title = _titleOptions.elementAt(0);
    super.initState();
  }

  void _onItemTapped(int index) async {
    var title = _titleOptions.elementAt(index);
    setState(() {
      _selectedIndex = index;
      _title = title;
    });
  }

  changeCar(int carId) async {
    Preferences preferences = Provider.of<Preferences>(context, listen: false);
    MqttClientWrapper clientWrapper = Provider.of<MqttClientWrapper>(context, listen: false);
    Charges charges = Provider.of<Charges>(context, listen: false);
    Drives drives = Provider.of<Drives>(context, listen: false);
    CarStatus carStatus = Provider.of<CarStatus>(context, listen: false);
    await preferences.setCarId(carId);
    carStatus.reset();
    clientWrapper.client.disconnect();
    charges.items = [];
    charges.page = 1;
    drives.items = [];
    drives.page = 1;
    await fetchCharges(context);
    await fetchDrives(context);
    clientWrapper.connect(context);
    Navigator.pop(context);
  }

  Future<bool> initStates() async {
    MqttClientWrapper clientWrapper = Provider.of<MqttClientWrapper>(context, listen: false);
    Preferences preferences = Provider.of<Preferences>(context, listen: false);
    Charges charges = Provider.of<Charges>(context, listen: false);
    Drives drives = Provider.of<Drives>(context, listen: false);
    Cars cars = Provider.of<Cars>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      await fetchPreferences(context);
      if (!clientWrapper.connected) {
        await clientWrapper.connect(context);
      }
      if (!allDone) {
        charges.items = [];
        charges.page = 1;
        drives.items = [];
        drives.page = 1;
        cars.items = [];
        await fetchCars(context);
        await fetchCharges(context);
        await fetchDrives(context);
      }

      setState(() {
        allDone = true;
      });
      return preferences.prefsExist;
    } catch (e) {
      return false;
    }
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
          Preferences preferences = Provider.of<Preferences>(context, listen: false);
          Cars cars = Provider.of<Cars>(context, listen: false);
          return Scaffold(
            appBar: AppBar(
              title: Text(_title),
            ),
            drawer: Drawer(
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: [
                  SizedBox(
                    height: 150,
                    child: DrawerHeader(
                      decoration: const BoxDecoration(
                        color: CustomColors.red,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cars.getCar(preferences.carID).name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            cars.getCar(preferences.carID).vin,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (cars.items.length > 1)
                    ...cars.items.map(
                      (car) => ListTile(
                        leading: Icon(
                          Icons.drive_eta,
                          color: car.carID == preferences.carID ? CustomColors.red : null,
                        ),
                        title: Text(car.name),
                        enabled: car.carID != preferences.carID,
                        onTap: () async {
                          await changeCar(car.carID);
                        },
                      ),
                    ),
                  if (cars.items.length > 1) const Divider(),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text(RoutesTabNames.settings),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, Routes.settings);
                    },
                  ),
                ],
              ),
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
