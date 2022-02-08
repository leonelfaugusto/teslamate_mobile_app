import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:teslamate/classes/drive.dart';

Future fetchDrives(BuildContext context) async {
  Drives drives = Provider.of<Drives>(context, listen: false);
  final response = await http.get(Uri.parse('http://10.10.20.121:8080/api/v1/cars/1/drives?show=${drives.show}&page=${drives.page}'));
  final List<Drive> drivesToAdd = [];

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Map<String, dynamic> body = jsonDecode(response.body);
    if (body['data']['drives'] != null) {
      for (var charge in (body['data']['drives'] as List)) {
        drivesToAdd.add(Drive.fromJson(charge));
      }
      drives.addCharges(drivesToAdd);
    }
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
