import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:teslamate/classes/drive.dart';
import 'package:teslamate/classes/drive_detail.dart';
import 'package:teslamate/utils/custom_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DriveScreen extends StatefulWidget {
  const DriveScreen({Key? key}) : super(key: key);

  @override
  State<DriveScreen> createState() => _DriveScreenState();
}

class _DriveScreenState extends State<DriveScreen> {
  List<LineChartBarData> dataBatteryLevel = [];
  List<LineChartBarData> fakeDataBatteryLevel = [];
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  bool wait = true;

  String _mapStyle = '';

  @override
  void didChangeDependencies() {
    Drive drive = ModalRoute.of(context)!.settings.arguments as Drive;
    List<FlSpot> initDataBatteryLevel = [];
    for (var i = 0; i < drive.driveDetails.length; i++) {
      if (0 == i % 10) {
        initDataBatteryLevel.add(FlSpot(drive.driveDetails[i].date.microsecondsSinceEpoch.toDouble(), drive.driveDetails[i].bateryLevel!.toDouble()));
      }
      if (i == drive.driveDetails.length - 1 && 0 != i % 10) {
        initDataBatteryLevel.add(FlSpot(drive.driveDetails[i].date.microsecondsSinceEpoch.toDouble(), drive.driveDetails[i].bateryLevel!.toDouble()));
      }
    }

    dataBatteryLevel = [
      LineChartBarData(
        isCurved: true,
        colors: [Colors.blue, CustomColors.red],
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: true, colors: [Colors.blue.withOpacity(0.3), CustomColors.red.withOpacity(0.3)]),
        spots: initDataBatteryLevel,
      ),
    ];

    List<FlSpot> initFakeDataBatteryLevel = [];
    for (var i = 0; i < drive.driveDetails.length; i++) {
      if (0 == i % 10) {
        initFakeDataBatteryLevel.add(FlSpot(drive.driveDetails[i].date.microsecondsSinceEpoch.toDouble(), 0));
      }
      if (i == drive.driveDetails.length - 1 && 0 != i % 10) {
        initFakeDataBatteryLevel.add(FlSpot(drive.driveDetails[i].date.microsecondsSinceEpoch.toDouble(), 0));
      }
    }

    fakeDataBatteryLevel = [
      LineChartBarData(
        isCurved: true,
        colors: [Colors.blue, CustomColors.red],
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: true, colors: [Colors.blue.withOpacity(0.3), CustomColors.red.withOpacity(0.3)]),
        spots: initFakeDataBatteryLevel,
      ),
    ];
    Future.delayed(const Duration(milliseconds: 300)).then((value) {
      setState(() {
        wait = false;
      });
    });

    super.didChangeDependencies();
  }

  @override
  void initState() {
    rootBundle.loadString('lib/assets/map_styles/dark.json').then((style) => _mapStyle = style);
    super.initState();
  }

  LatLngBounds boundsFromLatLngList(List<DriveDetail> list) {
    assert(list.isNotEmpty);
    double? x0, x1, y0, y1;
    for (DriveDetail detail in list) {
      if (x0 == null || x1 == null || y1 == null || y0 == null) {
        x0 = x1 = detail.latitude;
        y0 = y1 = detail.longitude;
      } else {
        if (detail.latitude > x1) x1 = detail.latitude;
        if (detail.latitude < x0) x0 = detail.latitude;
        if (detail.longitude > y1) y1 = detail.longitude;
        if (detail.longitude < y0) y0 = detail.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1 as double, y1 as double), southwest: LatLng(x0 as double, y0 as double));
  }

  @override
  Widget build(BuildContext context) {
    Drive drive = ModalRoute.of(context)!.settings.arguments as Drive;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat("d MMMM y").format(drive.startDate),
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Chip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.from.toUpperCase()} ${drive.startBatteryLevel}% ${AppLocalizations.of(context)!.to.toUpperCase()} ${drive.endBatteryLevel}%",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Card(
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  margin: EdgeInsets.zero,
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.range,
                              style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${drive.rangeDiff} Km",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.spent,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            Text(
                              "${drive.batteryDiff}%",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 150,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: LineChart(
                              LineChartData(
                                minY: 0,
                                maxY: 100,
                                clipData: FlClipData.none(),
                                borderData: FlBorderData(
                                    show: true,
                                    border: const Border(
                                      bottom: BorderSide(
                                        width: 2,
                                        color: Colors.blueGrey,
                                      ),
                                    )),
                                lineTouchData: LineTouchData(
                                  handleBuiltInTouches: true,
                                  touchTooltipData: LineTouchTooltipData(
                                    fitInsideVertically: true,
                                  ),
                                ),
                                titlesData: FlTitlesData(
                                  topTitles: SideTitles(
                                    showTitles: false,
                                  ),
                                  rightTitles: SideTitles(
                                    showTitles: false,
                                  ),
                                  leftTitles: SideTitles(
                                    showTitles: false,
                                  ),
                                  bottomTitles: SideTitles(
                                    getTextStyles: ((context, value) {
                                      return const TextStyle(fontSize: 10);
                                    }),
                                    showTitles: true,
                                    checkToShowTitle: (minValue, maxValue, sideTitles, appliedInterval, value) {
                                      if (value == minValue || value == maxValue) {
                                        return true;
                                      }
                                      return false;
                                    },
                                    getTitles: (value) {
                                      DateTime date = DateTime.fromMicrosecondsSinceEpoch(value.toInt());
                                      return DateFormat("HH:mm").format(date);
                                    },
                                  ),
                                ),
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false,
                                ),
                                lineBarsData: wait ? fakeDataBatteryLevel : dataBatteryLevel,
                              ),
                              swapAnimationDuration: const Duration(milliseconds: 500),
                              swapAnimationCurve: Curves.linear,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Card(
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  margin: EdgeInsets.zero,
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.speed,
                              style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 1, color: Colors.blue),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: const Icon(
                                      MdiIcons.chevronDoubleDown,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "0",
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                Text(
                                  "km/h",
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 40,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 2,
                                          decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.blue, CustomColors.red])),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "${drive.speedAvg.toStringAsFixed(0)} Km/h",
                                    style: Theme.of(context).textTheme.labelLarge,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.avgSpeed,
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 1, color: CustomColors.red),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: const Icon(
                                      MdiIcons.chevronDoubleUp,
                                      color: CustomColors.red,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "${drive.speedMax}",
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                Text(
                                  "km/h",
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                margin: EdgeInsets.zero,
                clipBehavior: Clip.antiAlias,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.distance,
                            style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${drive.distance} Km",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.duration,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          Text(
                            "${drive.durationStr.replaceFirst(":", "h")}m",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: GoogleMap(
                            mapType: MapType.normal,
                            cameraTargetBounds: CameraTargetBounds(boundsFromLatLngList(drive.driveDetails)),
                            polylines: {
                              Polyline(
                                zIndex: 20,
                                polylineId: const PolylineId('path'),
                                consumeTapEvents: false,
                                color: CustomColors.red,
                                width: 3,
                                points: drive.driveDetails.map((e) => LatLng(e.latitude, e.longitude)).toList(),
                              ),
                            },
                            initialCameraPosition: const CameraPosition(
                              target: LatLng(0, 0),
                            ),
                            myLocationButtonEnabled: false,
                            zoomControlsEnabled: false,
                            zoomGesturesEnabled: false,
                            buildingsEnabled: false,
                            mapToolbarEnabled: false,
                            scrollGesturesEnabled: false,
                            tiltGesturesEnabled: false,
                            trafficEnabled: false,
                            onMapCreated: (GoogleMapController controller) {
                              controller.animateCamera(CameraUpdate.newLatLngBounds(boundsFromLatLngList(drive.driveDetails), 10));
                              controller.setMapStyle(_mapStyle);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            drive.startAddress,
                            style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 14),
                          ),
                          Text(
                            DateFormat("HH:mm").format(drive.startDate),
                            style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Icon(
                        MdiIcons.chevronDoubleDown,
                        color: Theme.of(context).textTheme.caption!.color,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            drive.endAddress,
                            style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 14),
                          ),
                          Text(
                            DateFormat("HH:mm").format(drive.endDate),
                            style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
