import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Charge>> fetchCharges() async {
  final response = await http.get(Uri.parse('http://10.10.20.121:8080/api/v1/cars/1/charges'));
  final List<Charge> charges = [];

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Map<String, dynamic> body = jsonDecode(response.body);
    body['data']['charges'].forEach((charge) => charges.add(Charge.fromJson(charge)));
    return charges;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load charge');
  }
}

Future<Charge> fetchCharge() async {
  final response = await http.get(Uri.parse('http://10.10.20.121:8080/api/v1/cars/1/charges/35'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Map<String, dynamic> body = jsonDecode(response.body);
    return Charge.fromJson(body['data']['charge']);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load charge');
  }
}

class Charge {
  final int chargeId;
  final String startDate;
  final String endDate;
  final int durationMin;
  final String durationStr;
  final dynamic cost;
  final int startBatteryLevel;
  final int endBatteryLevel;
  final int batteryDiff;

  const Charge({
    required this.chargeId,
    required this.startDate,
    required this.endDate,
    required this.durationMin,
    required this.durationStr,
    required this.cost,
    required this.startBatteryLevel,
    required this.endBatteryLevel,
    required this.batteryDiff,
  });

  factory Charge.fromJson(Map<String, dynamic> json) {
    return Charge(
      chargeId: json['charge_id'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      durationMin: json['duration_min'],
      durationStr: json['duration_str'],
      cost: json['cost'],
      startBatteryLevel: json['battery_details']['start_battery_level'],
      endBatteryLevel: json['battery_details']['end_battery_level'],
      batteryDiff: json['battery_details']['end_battery_level'] - json['battery_details']['start_battery_level'],
    );
  }
}
