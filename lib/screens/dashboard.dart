import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:teslamate/classes/car.dart';
import 'package:teslamate/classes/car_status.dart';
import 'package:teslamate/classes/cars.dart';
import 'package:teslamate/classes/charges.dart';
import 'package:teslamate/classes/drives.dart';
import 'package:teslamate/classes/preferences.dart';
import 'package:teslamate/components/soc_card.dart';
import 'package:teslamate/utils/custom_colors.dart';
import 'package:teslamate/utils/mqtt_client_wrapper.dart';
import 'package:teslamate/utils/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    Preferences preferences = Provider.of<Preferences>(context);
    Car car = Provider.of<Cars>(context, listen: false).getCar(preferences.carID);
    Charges charges = Provider.of<Charges>(context, listen: false);
    Drives drives = Provider.of<Drives>(context, listen: false);
    MqttClientWrapper mqttClientWrapper = Provider.of<MqttClientWrapper>(context, listen: false);
    return Scaffold(
      body: Consumer<CarStatus>(
        builder: (context, carStatus, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (carStatus.shiftState != "D" && carStatus.shiftState != "R")
                                Row(
                                  children: [
                                    const Icon(MdiIcons.carBrakeParking, color: CustomColors.red),
                                    Text(
                                      " ${carStatus.shiftState == "" ? AppLocalizations.of(context)!.parked : carStatus.shiftState}",
                                    ),
                                  ],
                                ),
                              if (carStatus.shiftState == "D" || carStatus.shiftState == "R")
                                Row(
                                  children: [
                                    const Icon(CupertinoIcons.location_fill),
                                    Text(
                                      " ${carStatus.speed}Km/h",
                                    ),
                                  ],
                                ),
                              Chip(
                                label: Text(carStatus.realState),
                              ),
                            ],
                          ),
                          if (carStatus.state == 'charging')
                            Card(
                              clipBehavior: Clip.antiAlias,
                              elevation: 0,
                              color: Theme.of(context).scaffoldBackgroundColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5), // if you need this
                                side: BorderSide(
                                  color: Colors.green.withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "${AppLocalizations.of(context)!.power} (Kw)",
                                          style: Theme.of(context).textTheme.labelSmall,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              carStatus.getBatteryChargingIcon(),
                                              color: Colors.amber,
                                            ),
                                            Text(
                                              "${carStatus.chargingPower}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.khwAdded,
                                          style: Theme.of(context).textTheme.labelSmall,
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.add,
                                              color: Colors.amber,
                                            ),
                                            Text(
                                              "${carStatus.chargeEnergyAdded.toStringAsFixed(2)}Kwh",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.timeRemaining,
                                          style: Theme.of(context).textTheme.labelSmall,
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.timer_outlined,
                                              color: Colors.amber,
                                            ),
                                            Text(
                                              carStatus.timeToFullCharge,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (carStatus.pluggedIn && carStatus.state != 'charging')
                            Card(
                              clipBehavior: Clip.antiAlias,
                              elevation: 0,
                              color: Theme.of(context).scaffoldBackgroundColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5), // if you need this
                                side: BorderSide(
                                  color: Colors.green.withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.pluggedIn,
                                          style: Theme.of(context).textTheme.labelSmall,
                                        ),
                                        const Icon(
                                          MdiIcons.evPlugType2,
                                          color: Colors.amber,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.scheduledStart,
                                          style: Theme.of(context).textTheme.labelSmall,
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.timer_outlined,
                                              color: Colors.amber,
                                            ),
                                            Text(
                                              DateFormat("HH:mm").format(carStatus.scheduledChargingStartTime),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          Container(
                            margin: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        CupertinoIcons.thermometer,
                                        size: 30,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(right: 5),
                                        child: Column(
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!.inside,
                                              style: Theme.of(context).textTheme.labelSmall,
                                            ),
                                            Text(
                                              "${carStatus.insideTemp} ºC",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(right: 5),
                                        child: Column(
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!.outside,
                                              style: Theme.of(context).textTheme.labelSmall,
                                            ),
                                            Text(
                                              "${carStatus.outsideTemp} ºC",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 5),
                                        child: Column(
                                          children: [
                                            Text(
                                              carStatus.isClimateOn
                                                  ? AppLocalizations.of(context)!.on.toUpperCase()
                                                  : AppLocalizations.of(context)!.off.toUpperCase(),
                                              style: carStatus.isClimateOn
                                                  ? Theme.of(context).textTheme.labelSmall?.copyWith(color: CustomColors.red)
                                                  : Theme.of(context).textTheme.labelSmall,
                                            ),
                                            if (!carStatus.isClimateOn) const Icon(MdiIcons.fanOff),
                                            if (carStatus.isClimateOn)
                                              const Icon(
                                                MdiIcons.fan,
                                                color: CustomColors.red,
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (!carStatus.sentryMode) const Icon(MdiIcons.recordCircleOutline),
                                  if (carStatus.sentryMode)
                                    const Icon(
                                      MdiIcons.recordRec,
                                      color: CustomColors.red,
                                    ),
                                  /* InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.followMap,
                                      );
                                    },
                                    child: const Icon(
                                      Icons.map,
                                      size: 30,
                                    ),
                                  ) */
                                ],
                              ),
                            ),
                          ),
                          SocCard(carStatus: carStatus),
                        ],
                      ),
                      if (!preferences.useMqtt || !mqttClientWrapper.connected)
                        Positioned(
                          bottom: 0,
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(5)),
                              color: CustomColors.red.withOpacity(0.7),
                            ),
                            alignment: Alignment.center,
                            child: Card(
                              elevation: 3,
                              color: Theme.of(context).cardTheme.shadowColor,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  AppLocalizations.of(context)!.mqttMessage,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).textTheme.displaySmall?.color),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.charges,
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                                Text(
                                  car.totalCharges.toString(),
                                  style: Theme.of(context).textTheme.displaySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.drives,
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                                FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    car.totalDrives.toString(),
                                    style: Theme.of(context).textTheme.displaySmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.updates,
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                                Text(
                                  car.totalUpdates.toString(),
                                  style: Theme.of(context).textTheme.displaySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.lastCharges,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        Card(
                          clipBehavior: Clip.antiAlias,
                          elevation: 0,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5), // if you need this
                            side: BorderSide(
                              color: CustomColors.red.withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (var i = 0; i < 3; i++)
                                Column(
                                  children: [
                                    ListTile(
                                      contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                                      visualDensity: VisualDensity.compact,
                                      dense: true,
                                      onTap: () async {
                                        if (charges.items[i].chargeDetails.isEmpty) {
                                          await charges.getMoreInfo(i);
                                        }
                                        Navigator.pushNamed(
                                          context,
                                          Routes.charge,
                                          arguments: charges.items[i],
                                        );
                                      },
                                      subtitle: Text(
                                        "${DateFormat("HH:mm").format(charges.items[i].startDate)} - ${DateFormat("HH:mm").format(charges.items[i].endDate)}",
                                        style: Theme.of(context).textTheme.labelSmall,
                                      ),
                                      title: Text(DateFormat("d MMMM y").format(charges.items[i].startDate)),
                                      trailing: Text("${charges.items[i].cost}€"),
                                    ),
                                    if (i != 2)
                                      const Divider(
                                        height: 0,
                                      )
                                  ],
                                ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.lastDrives,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        Card(
                          clipBehavior: Clip.antiAlias,
                          elevation: 0,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5), // if you need this
                            side: BorderSide(
                              color: CustomColors.red.withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (var i = 0; i < 3; i++)
                                Column(
                                  children: [
                                    ListTile(
                                      contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                                      visualDensity: VisualDensity.compact,
                                      dense: true,
                                      onTap: () async {
                                        if (drives.items[i].driveDetails.isEmpty) {
                                          await drives.getMoreInfo(i);
                                        }
                                        Navigator.pushNamed(
                                          context,
                                          Routes.drive,
                                          arguments: drives.items[i],
                                        );
                                      },
                                      subtitle: Text(
                                        "${DateFormat("HH:mm").format(drives.items[i].startDate)} - ${DateFormat("HH:mm").format(drives.items[i].endDate)}",
                                        style: Theme.of(context).textTheme.labelSmall,
                                      ),
                                      title: Text(DateFormat("d MMMM y").format(drives.items[i].startDate)),
                                      trailing: Text("${drives.items[i].distance}Km"),
                                    ),
                                    if (i != 2)
                                      const Divider(
                                        height: 0,
                                      )
                                  ],
                                ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
