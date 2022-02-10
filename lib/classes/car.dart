import 'package:flutter/material.dart';

class Car with ChangeNotifier {
  int carID;
  String name;
  String vin;
  String model;
  String color;
  int totalCharges;
  int totalDrives;
  int totalUpdates;

  Car({
    required this.carID,
    required this.name,
    required this.vin,
    required this.model,
    required this.color,
    required this.totalCharges,
    required this.totalDrives,
    required this.totalUpdates,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      carID: json['car_id'],
      name: json['name'],
      color: json['car_exterior']['exterior_color'],
      model: json['car_details']['model'],
      vin: json['car_details']['vin'],
      totalCharges: json['teslamate_stats']['total_charges'],
      totalDrives: json['teslamate_stats']['total_drives'],
      totalUpdates: json['teslamate_stats']['total_updates'],
    );
  }
}
