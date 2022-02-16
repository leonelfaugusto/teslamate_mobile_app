import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teslamate/classes/car.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:teslamate/classes/preferences.dart';

Future fetchCars(BuildContext context) async {
  Cars cars = Provider.of<Cars>(context, listen: false);
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
  final response = await http.get(Uri.parse('${preferences.api}/api/v1/cars'), headers: headers);
  final List<Car> carsToAdd = [];

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Map<String, dynamic> body = jsonDecode(response.body);
    if (body['data']['cars'] != null) {
      for (var charge in (body['data']['cars'] as List)) {
        carsToAdd.add(Car.fromJson(charge));
      }
      cars.addCars(carsToAdd);
    }
    // cars.addCar(Car(carID: 2, name: "Leonel", vin: "awdawd", model: "Y", color: "red", totalCharges: 20, totalDrives: 50, totalUpdates: 3));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception("failed ${response.reasonPhrase}");
  }
}

class Cars with ChangeNotifier {
  List<Car> cars = [];

  List<Car> get items {
    return [...cars];
  }

  set items(List<Car> c) {
    cars = c;
  }

  Car getCar(id) {
    return cars.firstWhere((car) => car.carID == id);
  }

  void clearItems() {
    cars = [];
    notifyListeners();
  }

  void addCar(Car c) {
    cars.add(c);
    notifyListeners();
  }

  void addCars(List<Car> c) {
    cars.addAll(c);
    notifyListeners();
  }
}
