import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class Car with ChangeNotifier {
  final int id;
  String isClimateOn = "false";
  String state = '';
  String insideTemp = '';
  String speed = '';
  String ltd = '41.453196';
  String lng = '-8.181935';
  double heading = 3.14;
  MapController map = MapController(
    initMapWithUserPosition: false,
    initPosition: GeoPoint(latitude: 41.453196, longitude: -8.181935),
  );
  bool mapIsReady = false;

  Car({
    required this.id,
  });

  void setIsClimateOn(String value) {
    isClimateOn = value;
    notifyListeners();
  }

  void setState(String value) {
    state = value;
    notifyListeners();
  }

  void setInsideTemp(String value) {
    insideTemp = value;
    notifyListeners();
  }

  void setSpeed(String value) {
    speed = value;
    notifyListeners();
  }

  void setLtd(String value) async {
    ltd = value;
    if (mapIsReady) {
      await map.changeLocation(GeoPointWithOrientation(angle: heading, latitude: double.parse(value), longitude: double.parse(lng)));
    }
    notifyListeners();
  }

  void setLng(String value) async {
    lng = value;
    if (mapIsReady) {
      await map.changeLocation(GeoPointWithOrientation(angle: heading, latitude: double.parse(ltd), longitude: double.parse(value)));
    }
    notifyListeners();
  }

  void setHeading(String value) {
    heading = int.parse(value) * 3.14 / 180;
    notifyListeners();
  }

  void setMapIsReady() async {
    mapIsReady = true;
    await map.changeLocation(GeoPointWithOrientation(angle: heading, latitude: double.parse(ltd), longitude: double.parse(lng)));
  }
}
