import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Car with ChangeNotifier {
  late bool isClimateOn;
  late String state;
  late double insideTemp;
  late int speed;
  late double lng;
  late double ltd;
  late double headingRad;
  late double heading;
  bool finish = false;

  Car();

  Future refreshTasks() async {
    final response = await http.get(Uri.parse('http://10.10.20.121:8080/api/v1/cars/1/status'));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String, dynamic> body = jsonDecode(response.body);
      setIsClimateOn(body['data']['status']['climate_details']['is_climate_on'].toString());
      setInsideTemp(body['data']['status']['climate_details']['inside_temp'].toString());
      setState(body['data']['status']['state'].toString());
      setSpeed(body['data']['status']['driving_details']['speed'].toString());
      setLng(body['data']['status']['car_geodata']['longitude'].toString());
      setLtd(body['data']['status']['car_geodata']['latitude'].toString());
      setHeadingRad(body['data']['status']['driving_details']['heading'].toString());
      setHeading(body['data']['status']['driving_details']['heading'].toString());
      finish = true;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load charge');
    }

    notifyListeners();
  }

  void setIsClimateOn(String value) {
    if (value == "false") {
      isClimateOn = false;
    } else {
      isClimateOn = true;
    }
    notifyListeners();
  }

  void setState(String value) {
    state = value;
    notifyListeners();
  }

  void setInsideTemp(String value) {
    insideTemp = double.parse(value);
    notifyListeners();
  }

  void setSpeed(String value) {
    speed = int.parse(value);
    notifyListeners();
  }

  void setLtd(String value) {
    ltd = double.parse(value);
    notifyListeners();
  }

  void setLng(String value) {
    lng = double.parse(value);
    notifyListeners();
  }

  void setHeadingRad(String value) {
    headingRad = (int.parse(value) * 3.14 / 180);

    if (headingRad > 3.14) {
      headingRad -= 6.28;
    }
    if (headingRad < -3.14) {
      headingRad += 6.28;
    }
    notifyListeners();
  }

  void setHeading(String value) {
    heading = double.parse(value);
    notifyListeners();
  }
}
