import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teslamate/classes/charge.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future fetchCharges(BuildContext context) async {
  Charges charges = Provider.of<Charges>(context, listen: false);
  final response = await http.get(Uri.parse('http://10.10.20.121:8080/api/v1/cars/1/charges?show=${charges.show}&page=${charges.page}'));
  final List<Charge> chargesToAdd = [];

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Map<String, dynamic> body = jsonDecode(response.body);
    if (body['data']['charges'] != null) {
      for (var charge in (body['data']['charges'] as List)) {
        chargesToAdd.add(Charge.fromJson(charge));
      }
      charges.addCharges(chargesToAdd);
    }
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
}
