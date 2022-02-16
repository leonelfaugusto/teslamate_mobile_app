// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:provider/provider.dart';
import 'package:teslamate/classes/car_status.dart';
import 'package:teslamate/classes/preferences.dart';
import 'package:teslamate/utils/mqqt_topics.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MqttClientWrapper with ChangeNotifier {
  int pongCount = 0;
  late MqttServerClient client;
  bool connected = false;

  Future<MqttServerClient> connect(context) async {
    Preferences preferences = Provider.of<Preferences>(context, listen: false);

    client = MqttServerClient.withPort(preferences.mqtt, 'myClient', preferences.mqttPort);

    client.logging(on: false);
    client.setProtocolV31();
    client.keepAlivePeriod = 20;
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;
    client.pongCallback = pong;

    var deviceInfo = DeviceInfoPlugin();
    String? id = "teslamate_companion";
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      id = iosDeviceInfo.identifierForVendor;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      id = androidDeviceInfo.androidId;
    }

    final connMess = MqttConnectMessage();
    if (!preferences.mqttIsAnonymous) {
      connMess.authenticateAs(preferences.mqttUsername, preferences.mqttPassword);
    }
    connMess.withClientIdentifier(id.toString()).withWillQos(MqttQos.atLeastOnce);
    print('EXAMPLE::Mosquitto client connecting....');
    client.connectionMessage = connMess;

    try {
      await client.connect();
      connected = true;
    } on NoConnectionException catch (e) {
      print('EXAMPLE::client exception - $e');
      client.disconnect();
      connected = false;
    } on SocketException catch (e) {
      print('EXAMPLE::socket exception - $e');
      client.disconnect();
      connected = false;
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('EXAMPLE::Mosquitto client connected');
    } else {
      print('EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus!.state}');
      client.disconnect();
      connected = false;
    }
    Topics topics = Topics(carID: preferences.carID);
    var topicsList = topics.getTopicsList();
    for (var topic in topicsList) {
      client.subscribe(topic, MqttQos.atMostOnce);
    }

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      CarStatus carStatus = Provider.of<CarStatus>(context, listen: false);

      if (c[0].topic == topics.isClimateOn) {
        carStatus.setIsClimateOn(pt);
      }
      if (c[0].topic == topics.insideTemp) {
        carStatus.setInsideTemp(pt);
      }
      if (c[0].topic == topics.outsideTemp) {
        carStatus.setOutsideTemp(pt);
      }
      if (c[0].topic == topics.speed) {
        carStatus.setSpeed(pt);
      }
      if (c[0].topic == topics.state) {
        carStatus.setState(pt);
        var value = pt;
        switch (pt) {
          case "asleep":
            value = AppLocalizations.of(context)!.asleep;
            break;
          case "driving":
            value = AppLocalizations.of(context)!.driving;
            break;
          case "online":
            value = AppLocalizations.of(context)!.online;
            break;
          case "charging":
            value = AppLocalizations.of(context)!.charging;
            break;
          case "updating":
            value = AppLocalizations.of(context)!.updating;
            break;
          case "offline":
            value = AppLocalizations.of(context)!.offline;
            break;
          case "suspended":
            value = AppLocalizations.of(context)!.suspended;
            break;
          default:
            value = pt;
        }
        carStatus.setRealState(value);
      }
      if (c[0].topic == topics.latitude) {
        carStatus.setLtd(pt);
      }
      if (c[0].topic == topics.longitude) {
        carStatus.setLng(pt);
      }
      if (c[0].topic == topics.heading) {
        carStatus.setHeading(pt);
      }
      if (c[0].topic == topics.batteryLevel) {
        carStatus.setStateOfCharge(pt);
      }
      if (c[0].topic == topics.ratedBatteryRangeKm) {
        carStatus.setBatteryRange(pt);
      }
      if (c[0].topic == topics.chargerPower) {
        carStatus.setChargingPower(pt);
      }
      if (c[0].topic == topics.chargeEnergyAdded) {
        carStatus.setChargeEnergyAdded(pt);
      }
      if (c[0].topic == topics.timeToFullCharge) {
        carStatus.setTimeToFullCharge(pt);
      }
      if (c[0].topic == topics.geofence) {
        carStatus.setGeofence(pt);
      }
      if (c[0].topic == topics.shiftState) {
        var value = pt;
        switch (pt) {
          case "D":
          case "R":
            value = pt;
            break;
          case "P":
            value = AppLocalizations.of(context)!.parked;
            break;
          default:
            value = AppLocalizations.of(context)!.parked;
            break;
        }
        carStatus.setShiftState(value);
      }
      if (c[0].topic == topics.sentryMode) {
        carStatus.setSentryMode(pt);
      }
      if (c[0].topic == topics.pluggedIn) {
        carStatus.setPluggedIn(pt);
      }
      if (c[0].topic == topics.scheduledChargingStartTime) {
        carStatus.setScheduledChargingStartTime(pt);
      }
      if (c[0].topic == topics.odometer) {
        carStatus.setOdometer(pt);
      }

      print('EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
      print('');
    });
    return client;
  }

  void onSubscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');
  }

  void onDisconnected() {
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (client.connectionStatus!.disconnectionOrigin == MqttDisconnectionOrigin.solicited) {
      print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    } else {
      print('EXAMPLE::OnDisconnected callback is unsolicited or none, this is incorrect - exiting');
    }
    if (pongCount == 3) {
      print('EXAMPLE:: Pong count is correct');
    } else {
      print('EXAMPLE:: Pong count is incorrect, expected 3. actual $pongCount');
    }
    connected = false;
  }

  void onConnected() {
    print('EXAMPLE::OnConnected client callback - Client connection was successful');
  }

  void pong() {
    print('EXAMPLE::Ping response client callback invoked');
    pongCount++;
  }
}
