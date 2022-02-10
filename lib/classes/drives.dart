import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:teslamate/classes/drive.dart';
import 'package:teslamate/classes/preferences.dart';

Future fetchDrives(BuildContext context) async {
  Drives drives = Provider.of<Drives>(context, listen: false);
  Preferences preferences = Provider.of<Preferences>(context, listen: false);
  final response = await http.get(Uri.parse('${preferences.api}/api/v1/cars/${preferences.carID}/drives?show=${drives.show}&page=${drives.page}'));
  final List<Drive> drivesToAdd = [];

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Map<String, dynamic> body = jsonDecode(response.body);
    if (body['data']['drives'] != null) {
      for (var charge in (body['data']['drives'] as List)) {
        drivesToAdd.add(Drive.fromJson(charge));
      }
    }
    drives.addCharges(drivesToAdd);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load charge');
  }
}

class Drives with ChangeNotifier {
  List<Drive> drives = [];
  int show = 10;
  int page = 1;

  List<Drive> get items {
    return [...drives];
  }

  set items(List<Drive> c) {
    drives = c;
  }

  void clearItems() {
    drives = [];
    notifyListeners();
  }

  void addCharge(Drive drive) {
    drives.add(drive);
    notifyListeners();
  }

  void addCharges(List<Drive> d) {
    drives.addAll(d);
    notifyListeners();
  }
}
