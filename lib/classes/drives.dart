import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:teslamate/classes/drive.dart';
import 'package:teslamate/classes/preferences.dart';

Future fetchDrives(BuildContext context) async {
  Drives drives = Provider.of<Drives>(context, listen: false);
  Preferences preferences = Provider.of<Preferences>(context, listen: false);
  Map<String, String> headers = {};
  if (preferences.isApiProtected) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String send = stringToBase64.encode("${preferences.apiUsername}:${preferences.apiPassword}");
    headers = {
      ...headers,
      "Authorization": "Basic $send",
    };
  }
  final response = await http.get(Uri.parse('${preferences.api}/api/v1/cars/${preferences.carID}/drives?show=${drives.show}&page=${drives.page}'),
      headers: headers);
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
    drives.addDrives(drivesToAdd);
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

  Drive getDrive(id) {
    return drives.firstWhere((drive) => drive.driveId == id);
  }

  void clearItems() {
    drives = [];
    notifyListeners();
  }

  void addDrive(Drive drive) {
    drives.add(drive);
    notifyListeners();
  }

  void addDrives(List<Drive> d) {
    drives.addAll(d);
    notifyListeners();
  }

  Future<void> getMoreInfo(int index) async {
    await items[index].fetchMoreInfo();
    notifyListeners();
  }
}
