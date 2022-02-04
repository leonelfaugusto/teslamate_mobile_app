/*
 * Package : mqtt_client
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 31/05/2017
 * Copyright :  S.Hamblett
 */

import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:provider/provider.dart';
import 'package:teslamate/classes/car.dart';
import 'package:teslamate/utils/mqqt_topics.dart';

final client = MqttServerClient.withPort('10.10.20.151', 'myClient', 1883);

var pongCount = 0; // Pong counter

Future<MqttServerClient> connect(context) async {
  client.logging(on: false);
  client.setProtocolV31();
  client.keepAlivePeriod = 20;
  client.onDisconnected = onDisconnected;
  client.onConnected = onConnected;
  client.onSubscribed = onSubscribed;
  client.pongCallback = pong;

  final connMess =
      MqttConnectMessage().authenticateAs('leonel', '25802580Tks').withClientIdentifier('teslamate_companion').withWillQos(MqttQos.atLeastOnce);
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

  print('EXAMPLE::Subscribing to all topics');
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
}

void onConnected() {
  print('EXAMPLE::OnConnected client callback - Client connection was successful');
}

void pong() {
  print('EXAMPLE::Ping response client callback invoked');
  pongCount++;
}
