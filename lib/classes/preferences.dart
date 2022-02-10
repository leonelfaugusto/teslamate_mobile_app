import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> fetchPreferences(context) async {
  try {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    final Preferences preferences = Provider.of<Preferences>(context, listen: false);
    preferences.mqtt = _prefs.getString("mqtt") ?? "";
    preferences.mqttPort = _prefs.getInt("mqttPort") ?? 1883;
    preferences.api = _prefs.getString("api") ?? "";
    preferences.carID = _prefs.getInt("car_id") ?? 1;
    preferences.prefsExist = _prefs.getBool("prefsExist") ?? false;
    preferences.mqttIsAnonymous = _prefs.getBool("mqttIsAnonymous") ?? true;
    preferences.mqttUsername = _prefs.getString("mqttUsername") ?? "";
    preferences.mqttPassword = _prefs.getString("mqttPassword") ?? "";
  } catch (e) {
    throw Exception(e);
  }
}

class Preferences with ChangeNotifier {
  String mqtt = "";
  int mqttPort = 1883;
  String mqttUsername = "";
  String mqttPassword = "";
  bool mqttIsAnonymous = true;
  String api = "";
  int carID = 1;
  bool prefsExist = false;

  Future<void> setMqqt(String url) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString("mqtt", url);
    mqtt = url;
  }

  Future<void> setMqqtPort(int port) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setInt("mqttPort", port);
    mqttPort = port;
  }

  Future<void> setMqttIsAnonymous(bool isAnonymous) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setBool("mqttIsAnonymous", isAnonymous);
    mqttIsAnonymous = isAnonymous;
  }

  Future<void> setMqttUsername(String username) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString("mqttUsername", username);
    mqttUsername = username;
  }

  Future<void> setMqttPassword(String password) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString("mqttPassword", password);
    mqttPassword = password;
  }

  Future<void> setApi(String url) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString("api", url);
    api = url;
  }

  Future<void> setCarId(int id) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setInt("car_id", id);
    carID = id;
  }

  Future<void> setPrefsExist(bool exist) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setBool("prefsExist", exist);
    prefsExist = exist;
  }
}
