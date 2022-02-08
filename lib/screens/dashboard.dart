import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:teslamate/classes/car.dart';
import 'package:teslamate/components/info_card.dart';

import '../components/map.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late MapWrapperController mapWrapperController;

  @override
  void initState() {
    mapWrapperController = MapWrapperController();
    super.initState();
  }

  onTap() {
    showDialog(
      useSafeArea: false,
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Stack(
          children: [
            Consumer<Car>(
              builder: (context, car, child) {
                LatLng lt = LatLng(car.ltd, car.lng);
                Marker marker = Marker(
                  point: lt,
                  rotate: false,
                  builder: (ctx) => Transform.rotate(
                    angle: car.headingRad,
                    child: Icon(
                      CupertinoIcons.location_circle,
                      color: Colors.red[700],
                      size: 30,
                    ),
                  ),
                );
                if (mapWrapperController.readyAndMounted) {
                  mapWrapperController.controller?.move(lt, mapWrapperController.controller!.zoom);
                }
                return FlutterMapWrapper(
                  wrapperController: mapWrapperController,
                  options: MapOptions(
                    center: lt,
                    zoom: 15.0,
                    maxZoom: 18,
                  ),
                  layers: [
                    TileLayerOptions(
                      urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayerOptions(
                      markers: [
                        marker,
                      ],
                    ),
                  ],
                );
              },
            ),
            SafeArea(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topRight,
                    child: ClipOval(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          highlightColor: Colors.transparent,
                          onTap: () => Navigator.of(context).pop(),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Icon(
                              CupertinoIcons.clear_circled_solid,
                              size: 40,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomRight,
                      child: ClipOval(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            highlightColor: Colors.transparent,
                            onTap: () {
                              if (mapWrapperController.readyAndMounted) {
                                Car car = Provider.of<Car>(context, listen: false);
                                mapWrapperController.controller?.move(
                                  LatLng(car.ltd, car.lng),
                                  mapWrapperController.controller!.zoom,
                                );
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Icon(
                                Icons.gps_fixed,
                                size: 40,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        builder: (context, snapshot) {
          return Consumer<Car>(
            builder: (context, car, child) {
              if (car.finish) {
                return GridView.count(
                  padding: const EdgeInsets.all(10),
                  crossAxisCount: 2,
                  children: [
                    InfoCard(
                      info: car.insideTemp.toString(),
                    ),
                    InfoCard(
                      info: car.speed.toString(),
                    ),
                    InfoCard(
                      info: car.isClimateOn.toString(),
                    ),
                    InfoCard(
                      info: car.state.toString(),
                    ),
                    InfoCard(
                      onTap: onTap,
                      info: car.ltd.toString(),
                    ),
                    InfoCard(
                      onTap: onTap,
                      info: car.lng.toString(),
                    ),
                    InfoCard(
                      info: car.heading.toString(),
                    ),
                  ],
                );
              }
              return const Text("data");
            },
          );
        },
        future: Provider.of<Car>(context, listen: false).refreshTasks(),
      ),
    );
  }
}
