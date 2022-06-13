import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teslamate/classes/car_status.dart';
import 'package:teslamate/classes/cars.dart';
import 'package:teslamate/classes/charges.dart';
import 'package:teslamate/classes/drives.dart';
import 'package:teslamate/classes/preferences.dart';
import 'package:teslamate/utils/custom_colors.dart';
import 'package:teslamate/utils/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomDrawer extends StatelessWidget {
  final Cars _cars;
  final Preferences _preferences;
  final CarStatus _carStatus;

  const CustomDrawer(this._cars, this._preferences, this._carStatus, {Key? key}) : super(key: key);

  changeCar(int carId, context) async {
    Preferences preferences = Provider.of<Preferences>(context, listen: false);
    Charges charges = Provider.of<Charges>(context, listen: false);
    Drives drives = Provider.of<Drives>(context, listen: false);
    CarStatus carStatus = Provider.of<CarStatus>(context, listen: false);
    Cars cars = Provider.of<Cars>(context, listen: false);
    await preferences.setCarId(carId);
    carStatus.reset();
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
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
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
                    _cars.getCar(_preferences.carID).name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    _cars.getCar(_preferences.carID).vin,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  Text(
                    "${_carStatus.odometer}Km",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
          ),
          if (_cars.items.length > 1)
            ..._cars.items.map(
              (car) => ListTile(
                leading: Icon(
                  CupertinoIcons.car_detailed,
                  color: car.carID == _preferences.carID ? CustomColors.red : null,
                ),
                title: Text(car.name),
                enabled: car.carID != _preferences.carID,
                onTap: () async {
                  await changeCar(car.carID, context);
                },
              ),
            ),
          if (_cars.items.length > 1) const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(AppLocalizations.of(context)!.settings),
            onTap: () {
              Navigator.pushReplacementNamed(context, Routes.settings);
            },
          ),
        ],
      ),
    );
  }
}
