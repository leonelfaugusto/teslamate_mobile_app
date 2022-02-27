import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:platform_maps_flutter/platform_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:teslamate/classes/car_status.dart';
import 'package:flutter/services.dart' show rootBundle;

class FollowMap extends StatefulWidget {
  const FollowMap({Key? key}) : super(key: key);

  @override
  State<FollowMap> createState() => _FollowMapState();
}

class _FollowMapState extends State<FollowMap> {
  final Completer<PlatformMapController> _controller = Completer();
  late BitmapDescriptor carIcon;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  late LatLng initialPosition;
  late double initialHeading;
  bool noMove = true;
  bool satellite = false;
  String _mapStyle = '';

  @override
  void initState() {
    rootBundle.loadString('lib/assets/map_styles/dark.json').then((style) => _mapStyle = style);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    CarStatus carStatus = Provider.of<CarStatus>(context);
    initialPosition = LatLng(carStatus.ltd, carStatus.lng);
    initialHeading = carStatus.heading;
    setUpMarker();
    super.didChangeDependencies();
  }

  setUpMarker() async {
    CarStatus carStatus = Provider.of<CarStatus>(context);
    carIcon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(48, 48)), 'lib/assets/images/gps.png');
    markers = {
      MarkerId('car'): Marker(
        markerId: MarkerId('car'),
        position: LatLng(carStatus.ltd, carStatus.lng),
        icon: carIcon,

        //rotation: carStatus.heading,
      ),
    };
    newLocationUpdate();
  }

  newLocationUpdate() async {
    CarStatus carStatus = Provider.of<CarStatus>(context, listen: false);
    var marker = Marker(
      markerId: MarkerId("car"),
      position: LatLng(carStatus.ltd, carStatus.lng),
      icon: carIcon,
      /* rotation: carStatus.heading,
      flat: true, */
    );

    if (noMove) {
      final PlatformMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(carStatus.ltd, carStatus.lng),
            zoom: 18,
            bearing: carStatus.heading,
          ),
        ),
      );
    }
    setState(() {
      markers[MarkerId('car')] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
            future: setUpMarker(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return PlatformMap(
                mapType: satellite ? MapType.hybrid : MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: initialPosition,
                  zoom: 18,
                  bearing: initialHeading,
                ),
                rotateGesturesEnabled: noMove ? false : true,
                tiltGesturesEnabled: false,
                zoomGesturesEnabled: noMove ? false : true,
                scrollGesturesEnabled: noMove ? false : true,
                markers: markers.values.toSet(),
                myLocationButtonEnabled: false,
                compassEnabled: false,
                trafficEnabled: false,
                onMapCreated: (PlatformMapController controller) {
                  if (Platform.isAndroid) {
                    controller.googleController!.setMapStyle(_mapStyle);
                  }
                  if (!_controller.isCompleted) {
                    _controller.complete(controller);
                  }
                },
              );
            },
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.topRight,
                  child: ClipOval(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        highlightColor: Colors.transparent,
                        onTap: () => Navigator.of(context).pop(),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(
                            CupertinoIcons.clear_circled_solid,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      alignment: Alignment.topRight,
                      child: ClipOval(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            highlightColor: Colors.transparent,
                            onTap: () {
                              setState(() {
                                noMove = !noMove;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Icon(
                                CupertinoIcons.location_north_fill,
                                size: 30,
                                color: noMove ? Colors.white : Colors.grey[600],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: ClipOval(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            highlightColor: Colors.transparent,
                            onTap: () {
                              setState(() {
                                satellite = !satellite;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Icon(
                                MdiIcons.earth,
                                size: 30,
                                color: satellite ? Colors.white : Colors.grey[600],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  child: ClipOval(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          CarStatus carStatus = Provider.of<CarStatus>(context, listen: false);
                          final PlatformMapController controller = await _controller.future;
                          controller.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: LatLng(carStatus.ltd, carStatus.lng),
                                zoom: 18,
                              ),
                            ),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.gps_fixed,
                            size: 30,
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
      ),
    );
  }
}
