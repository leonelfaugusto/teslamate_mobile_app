import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> fetchPreferences(context) async {
  try {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    final Preferences preferences = Provider.of<Preferences>(context, listen: false);
    preferences.api = _prefs.getString("api") ?? "";
    preferences.carID = _prefs.getInt("car_id") ?? 1;
    preferences.prefsExist = _prefs.getBool("prefsExist") ?? false;
    preferences.apiUsername = _prefs.getString("wwwUsername") ?? "";
    preferences.apiPassword = _prefs.getString("wwwPassword") ?? "";
    preferences.isApiProtected = _prefs.getBool("isApiProtected") ?? false;
  } catch (e) {
    throw Exception(e);
  }
}

class Preferences with ChangeNotifier {
  String apiUsername = "";
  String apiPassword = "";
  bool isApiProtected = false;
  String api = "";
  int carID = 1;
  bool prefsExist = false;

  Future<void> setApi(String url) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString("api", url);
    api = url;
  }

  Future<void> setIsApiProtected(bool isApiProtectedValue) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setBool("isApiProtected", isApiProtectedValue);
    isApiProtected = isApiProtectedValue;
  }

  Future<void> setApiUsername(String username) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString("wwwUsername", username);
    apiUsername = username;
  }

  Future<void> setApiPassword(String password) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString("wwwPassword", password);
    apiPassword = password;
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
