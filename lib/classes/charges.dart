import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teslamate/classes/charge.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:teslamate/classes/preferences.dart';

Future fetchCharges(BuildContext context) async {
  Charges charges = Provider.of<Charges>(context, listen: false);
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
  final response = await http.get(Uri.parse('${preferences.api}/api/v1/cars/${preferences.carID}/charges?show=${charges.show}&page=${charges.page}'),
      headers: headers);
  final List<Charge> chargesToAdd = [];

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Map<String, dynamic> body = jsonDecode(response.body);
    if (body['data']['charges'] != null) {
      for (var charge in (body['data']['charges'] as List)) {
        chargesToAdd.add(Charge.fromJson(charge));
      }
    }
    charges.addCharges(chargesToAdd);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load charge');
  }
}

class Charges with ChangeNotifier {
  List<Charge> charges = [];
  int show = 10;
  int page = 1;

  List<Charge> get items {
    return [...charges];
  }

  set items(List<Charge> c) {
    charges = c;
  }

  Charge getCharge(id) {
    return charges.firstWhere((charge) => charge.chargeId == id);
  }

  void clearItems() {
    charges = [];
    notifyListeners();
  }

  void addCharge(Charge charge) {
    charges.add(charge);
    notifyListeners();
  }

  void addCharges(List<Charge> c) {
    charges.addAll(c);
    notifyListeners();
  }

  void getMoreInfo(int index) async {
    await items[index].fetchMoreInfo();
    notifyListeners();
  }
}
