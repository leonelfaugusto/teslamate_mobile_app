import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> fetchPreferences(context) async {
  try {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    final Preferences preferences = Provider.of<Preferences>(context, listen: false);
    preferences.mqqt = _prefs.getString("mqtt") ?? "";
    preferences.api = _prefs.getString("api") ?? "";
    preferences.prefsExist = _prefs.getBool("prefsExist") ?? false;
  } catch (e) {
    print(e);
  }
}

class Preferences with ChangeNotifier {
  String mqqt = "";
  String api = "";
  bool prefsExist = false;
}
