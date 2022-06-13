import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CarStatus with ChangeNotifier {
  bool isClimateOn = false;
  String state = '';
  String realState = '';
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
  String shiftState = "";
  bool sentryMode = false;
  int odometer = 0;

  double chargingPower = 0.0;
  double chargeEnergyAdded = 0.0;
  String timeToFullCharge = "";
  bool pluggedIn = false;
  DateTime scheduledChargingStartTime = DateTime.now();

  final int delay;

  final StreamController<dynamic> _recipientCtrl = StreamController<dynamic>();
  final StreamController<dynamic> _sentCtrl = StreamController<dynamic>();

  WebSocketChannel? webSocketChannel;

  get stream => _recipientCtrl.stream;

  get sink => _sentCtrl.sink;

  CarStatus({this.delay = 5}) {
    _sentCtrl.stream.listen((event) {
      webSocketChannel!.sink.add(event);
    });
    _connect();
  }

  _connect() {
    SharedPreferences.getInstance().then((_prefs) {
      var url = dotenv.env['APP_MODE'] == 'TEST' ? dotenv.env['WS_URL_DEV'] : dotenv.env['WS_URL_PROD'];
      String? token = _prefs.getString("token");
      webSocketChannel = IOWebSocketChannel.connect(
        Uri.parse(url as String),
        headers: {
          'authorization': "Bearer $token",
        },
      );
      webSocketChannel!.stream.listen(
        (event) {
          Map<String, dynamic> data = jsonDecode(event);
          print(data);
          switch (data['type']) {
            case 'state':
              setState(data['data']);
              break;
            case 'is_climate_on':
              setIsClimateOn(data['data']);
              break;
            case 'inside_temp':
              setInsideTemp(data['data']);
              break;
            case 'outside_temp':
              setOutsideTemp(data['data']);
              break;
            case 'speed':
              setSpeed(data['data']);
              break;
            case 'longitude':
              setLng(data['data']);
              break;
            case 'latitude':
              setLtd(data['data']);
              break;
            case 'heading':
              setHeading(data['data']);
              break;
            case 'battery_level':
              setStateOfCharge(data['data']);
              break;
            case 'rated_battery_range_km':
              setBatteryRange(data['data']);
              break;
            case 'charger_power':
              setChargingPower(data['data']);
              break;
            case 'charge_energy_added':
              setChargeEnergyAdded(data['data']);
              break;
            case 'time_to_full_charge':
              setTimeToFullCharge(data['data']);
              break;
            case 'geofence':
              setGeofence(data['data']);
              break;
            case 'shift_state':
              setShiftState(data['data']);
              break;
            case 'sentry_mode':
              setSentryMode(data['data']);
              break;
            case 'plugged_in':
              setPluggedIn(data['data']);
              break;
            case 'scheduled_charging_start_time':
              setScheduledChargingStartTime(data['data']);
              break;
            case 'odometer':
              setOdometer(data['data']);
              break;
            default:
          }
          // recipientCtrl.add(event);
        },
        onError: (e) async {
          _recipientCtrl.addError(e);
          await Future.delayed(Duration(seconds: delay));
          _connect();
        },
        onDone: () async {
          await Future.delayed(Duration(seconds: delay));
          _connect();
        },
        cancelOnError: true,
      );
      _sentCtrl.sink.add('{"type": "request", "data": "car_status"}');
    });
  }

  void reset() {
    isClimateOn = false;
    state = '';
    realState = '';
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
    shiftState = "";
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

  void setGeofence(String? value) {
    geofence = value ?? "";
    notifyListeners();
  }

  void setShiftState(String? value) {
    shiftState = value ?? "";
    notifyListeners();
  }

  void setScheduledChargingStartTime(String value) {
    scheduledChargingStartTime = value != "" ? DateTime.parse(value).toLocal() : DateTime.now();
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

  static getStateString(context, state) {
    switch (state) {
      case "asleep":
        return AppLocalizations.of(context)!.asleep;
      case "driving":
        return AppLocalizations.of(context)!.driving;
      case "online":
        return AppLocalizations.of(context)!.online;
      case "charging":
        return AppLocalizations.of(context)!.charging;
      case "updating":
        return AppLocalizations.of(context)!.updating;
      case "offline":
        return AppLocalizations.of(context)!.offline;
      case "suspended":
        return AppLocalizations.of(context)!.suspended;
      default:
        return state;
    }
  }

  static getShiftString(context, shift) {
    switch (shift) {
      case "D":
      case "R":
        return shift;
      case "P":
        return AppLocalizations.of(context)!.parked;
      default:
        return AppLocalizations.of(context)!.parked;
    }
  }
}
