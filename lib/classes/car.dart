import 'package:flutter/material.dart';

class Car with ChangeNotifier {
  bool isClimateOn = false;
  String state = 'online';
  double insideTemp = 0.0;
  int speed = 0;
  double lng = 0;
  double ltd = 0;
  double headingRad = 0;
  double heading = 0;
  int stateOfCharge = 0;
  double batteryRange = 0;

  Car();

  void setIsClimateOn(String value) {
    if (value == "false") {
      isClimateOn = false;
    } else {
      isClimateOn = true;
    }
    notifyListeners();
  }

  void setState(String value) {
    state = value;
    notifyListeners();
  }

  void setInsideTemp(String value) {
    insideTemp = double.parse(value);
    notifyListeners();
  }

  void setSpeed(String value) {
    speed = int.parse(value);
    notifyListeners();
  }

  void setLtd(String value) {
    ltd = double.parse(value);
    notifyListeners();
  }

  void setLng(String value) {
    lng = double.parse(value);
    notifyListeners();
  }

  void setHeadingRad(String value) {
    headingRad = (int.parse(value) * 3.14 / 180);

    if (headingRad > 3.14) {
      headingRad -= 6.28;
    }
    if (headingRad < -3.14) {
      headingRad += 6.28;
    }
    notifyListeners();
  }

  void setHeading(String value) {
    heading = double.parse(value);
    notifyListeners();
  }

  void setStateOfCharge(String value) {
    stateOfCharge = int.parse(value);
  }

  void setBatteryRange(String value) {
    batteryRange = double.parse(value);
  }
}
