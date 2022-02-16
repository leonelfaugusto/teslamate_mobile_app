import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CarStatus with ChangeNotifier {
  bool isClimateOn = false;
  String state = 'online';
  double insideTemp = 0.0;
  double outsideTemp = 0.0;
  int speed = 0;
  double lng = 0;
  double ltd = 0;
  double headingRad = 0;
  double heading = 0;
  int stateOfCharge = 0;
  double batteryRange = 0;
  String geofence = "";
  String shiftState = "Estacionado";
  bool sentryMode = false;
  int odometer = 0;

  double chargingPower = 0.0;
  double chargeEnergyAdded = 0.0;
  String timeToFullCharge = "";
  bool pluggedIn = false;
  DateTime scheduledChargingStartTime = DateTime.now();

  CarStatus();

  void reset() {
    isClimateOn = false;
    state = 'online';
    insideTemp = 0.0;
    outsideTemp = 0.0;
    speed = 0;
    lng = 0;
    ltd = 0;
    headingRad = 0;
    heading = 0;
    stateOfCharge = 0;
    batteryRange = 0;
    chargingPower = 0.0;
    chargeEnergyAdded = 0;
    timeToFullCharge = "";
    geofence = "";
    shiftState = "Estacionado";
    sentryMode = false;
    pluggedIn = false;
    scheduledChargingStartTime = DateTime.now();
    odometer = 0;
    notifyListeners();
  }

  void setIsClimateOn(String value) {
    if (value == "false") {
      isClimateOn = false;
    } else {
      isClimateOn = true;
    }
    notifyListeners();
  }

  void setSentryMode(String value) {
    if (value == "false") {
      sentryMode = false;
    } else {
      sentryMode = true;
    }
    notifyListeners();
  }

  void setState(String value) {
    state = value;
    notifyListeners();
  }

  get realState {
    switch (state) {
      case "asleep":
        return "A dormir";
      case "driving":
        return "Em movimento";
      case "online":
        return "Online";
      case "charging":
        return "A carregar";
      case "Updating":
        return "A atualizar";
      case "offline":
        return "Offline";
      case "suspended":
        return "A adormecer";
      default:
        return state;
    }
  }

  void setInsideTemp(String value) {
    insideTemp = double.parse(value);
    notifyListeners();
  }

  void setOutsideTemp(String value) {
    outsideTemp = double.parse(value);
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

  void setHeading(String value) {
    heading = double.parse(value);
    headingRad = (int.parse(value) * 3.14 / 180);

    if (headingRad > 3.14) {
      headingRad -= 6.28;
    }
    if (headingRad < -3.14) {
      headingRad += 6.28;
    }
    notifyListeners();
  }

  void setStateOfCharge(String value) {
    stateOfCharge = int.parse(value);
    notifyListeners();
  }

  void setBatteryRange(String value) {
    batteryRange = double.parse(value);
    notifyListeners();
  }

  void setChargingPower(String value) {
    chargingPower = double.parse(value);
    notifyListeners();
  }

  void setChargeEnergyAdded(String value) {
    chargeEnergyAdded = double.parse(value);
    notifyListeners();
  }

  void setPluggedIn(String value) {
    if (value == "false") {
      pluggedIn = false;
    } else {
      pluggedIn = true;
    }
    notifyListeners();
  }

  void setTimeToFullCharge(String value) {
    var time = double.parse(value);
    var minutes = (time * 60).toInt();
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    timeToFullCharge = '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
    notifyListeners();
  }

  void setGeofence(String value) {
    geofence = value;
    notifyListeners();
  }

  void setShiftState(String value) {
    switch (value) {
      case "D":
      case "R":
        shiftState = value;
        break;
      case "P":
        shiftState = "Estacionado";
        break;
      default:
        shiftState = "Estacionado";
        break;
    }
    notifyListeners();
  }

  void setScheduledChargingStartTime(String value) {
    scheduledChargingStartTime = DateTime.parse(value);
    notifyListeners();
  }

  void setOdometer(String value) {
    value = double.parse(value).toStringAsFixed(0);
    odometer = int.parse(value);
    notifyListeners();
  }

  IconData getBatteryChargeIcon() {
    if (stateOfCharge > 0 && stateOfCharge <= 10) {
      return MdiIcons.batteryOutline;
    }
    if (stateOfCharge > 10 && stateOfCharge <= 20) {
      return MdiIcons.battery10;
    }
    if (stateOfCharge > 20 && stateOfCharge <= 30) {
      return MdiIcons.battery20;
    }
    if (stateOfCharge > 30 && stateOfCharge <= 40) {
      return MdiIcons.battery30;
    }
    if (stateOfCharge > 40 && stateOfCharge <= 50) {
      return MdiIcons.battery40;
    }
    if (stateOfCharge > 50 && stateOfCharge <= 60) {
      return MdiIcons.battery50;
    }
    if (stateOfCharge > 60 && stateOfCharge <= 70) {
      return MdiIcons.battery60;
    }
    if (stateOfCharge > 70 && stateOfCharge <= 80) {
      return MdiIcons.battery70;
    }
    if (stateOfCharge > 80 && stateOfCharge <= 90) {
      return MdiIcons.battery80;
    }
    if (stateOfCharge > 90 && stateOfCharge < 100) {
      return MdiIcons.battery90;
    }
    if (stateOfCharge == 100) {
      return MdiIcons.battery;
    }
    return MdiIcons.batteryUnknown;
  }

  IconData getBatteryChargingIcon() {
    if (stateOfCharge > 0 && stateOfCharge <= 10) {
      return MdiIcons.batteryChargingOutline;
    }
    if (stateOfCharge > 10 && stateOfCharge <= 20) {
      return MdiIcons.batteryCharging10;
    }
    if (stateOfCharge > 20 && stateOfCharge <= 30) {
      return MdiIcons.batteryCharging20;
    }
    if (stateOfCharge > 30 && stateOfCharge <= 40) {
      return MdiIcons.batteryCharging30;
    }
    if (stateOfCharge > 40 && stateOfCharge <= 50) {
      return MdiIcons.batteryCharging40;
    }
    if (stateOfCharge > 50 && stateOfCharge <= 60) {
      return MdiIcons.batteryCharging50;
    }
    if (stateOfCharge > 60 && stateOfCharge <= 70) {
      return MdiIcons.batteryCharging60;
    }
    if (stateOfCharge > 70 && stateOfCharge <= 80) {
      return MdiIcons.batteryCharging70;
    }
    if (stateOfCharge > 80 && stateOfCharge <= 90) {
      return MdiIcons.batteryCharging80;
    }
    if (stateOfCharge > 90 && stateOfCharge < 100) {
      return MdiIcons.batteryCharging90;
    }
    if (stateOfCharge == 100) {
      return MdiIcons.battery;
    }
    return MdiIcons.batteryUnknown;
  }
}
