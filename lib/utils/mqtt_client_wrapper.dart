// ignore_for_file: avoid_print

/*
 * Package : mqtt_client
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 31/05/2017
 * Copyright :  S.Hamblett
 */

import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teslamate/classes/car.dart';
import 'package:teslamate/utils/mqqt_topics.dart';

var pongCount = 0; // Pong counter

Future<MqttServerClient> connect(context) async {
  final SharedPreferences _prefs = await SharedPreferences.getInstance();
  final mqqt = _prefs.getString("mqtt");

  MqttServerClient client = MqttServerClient.withPort("$mqqt", 'myClient', 1883);

  client.logging(on: false);
  client.setProtocolV31();
  client.keepAlivePeriod = 20;
  client.onDisconnected = () => onDisconnected(client);
  client.onConnected = onConnected;
  client.onSubscribed = onSubscribed;
  client.pongCallback = pong;

  var deviceInfo = DeviceInfoPlugin();
  String? id = "teslamate_companion";
  if (Platform.isIOS) {
    var iosDeviceInfo = await deviceInfo.iosInfo;
    id = iosDeviceInfo.identifierForVendor; // unique ID on iOS
  } else {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    id = androidDeviceInfo.androidId; // unique ID on Android
  }

  final connMess = MqttConnectMessage().authenticateAs('leonel', '25802580Tks').withClientIdentifier(id.toString()).withWillQos(MqttQos.atLeastOnce);
  print('EXAMPLE::Mosquitto client connecting....');
  client.connectionMessage = connMess;

  try {
    await client.connect();
  } on NoConnectionException catch (e) {
    print('EXAMPLE::client exception - $e');
    client.disconnect();
  } on SocketException catch (e) {
    print('EXAMPLE::socket exception - $e');
    client.disconnect();
  }

  if (client.connectionStatus!.state == MqttConnectionState.connected) {
    print('EXAMPLE::Mosquitto client connected');
  } else {
    print('EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
    client.disconnect();
  }

  for (var topic in Topics.topicsList) {
    client.subscribe(topic, MqttQos.atMostOnce);
  }

  client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
    final recMess = c![0].payload as MqttPublishMessage;
    final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    Car car = Provider.of<Car>(context, listen: false);
    switch (c[0].topic) {
      case Topics.isClimateOn:
        car.setIsClimateOn(pt);
        break;
      case Topics.insideTemp:
        car.setInsideTemp(pt);
        break;
      case Topics.speed:
        car.setSpeed(pt);
        break;
      case Topics.state:
        car.setState(pt);
        break;
      case Topics.latitude:
        car.setLtd(pt);
        break;
      case Topics.longitude:
        car.setLng(pt);
        break;
      case Topics.heading:
        car.setHeading(pt);
        car.setHeadingRad(pt);
        break;
      case Topics.batteryLevel:
        car.setStateOfCharge(pt);
        break;
      case Topics.ratedBatteryRangeKm:
        car.setBatteryRange(pt);
        break;
      default:
    }

    print('EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
    print('');
  });
  return client;
}

void onSubscribed(String topic) {
  print('EXAMPLE::Subscription confirmed for topic $topic');
}

void onDisconnected(client) {
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
}

void onConnected() {
  print('EXAMPLE::OnConnected client callback - Client connection was successful');
}

void pong() {
  print('EXAMPLE::Ping response client callback invoked');
  pongCount++;
}
