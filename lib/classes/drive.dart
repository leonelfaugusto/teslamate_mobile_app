import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Drive> fetchCharge() async {
  final response = await http.get(Uri.parse('http://10.10.20.121:8080/api/v1/cars/1/drives/35'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Map<String, dynamic> body = jsonDecode(response.body);
    return Drive.fromJson(body['data']['charge']);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load drive');
  }
}

class Drive {
  final int driveId;
  final DateTime startDate;
  final DateTime endDate;
  final int durationMin;
  final String durationStr;
  final dynamic distance;
  final int startBatteryLevel;
  final int endBatteryLevel;
  final int batteryDiff;
  final dynamic startRange;
  final dynamic endRange;
  final dynamic rangeDiff;

  const Drive({
    required this.driveId,
    required this.startDate,
    required this.endDate,
    required this.durationMin,
    required this.durationStr,
    required this.distance,
    required this.startBatteryLevel,
    required this.endBatteryLevel,
    required this.batteryDiff,
    required this.startRange,
    required this.endRange,
    required this.rangeDiff,
  });

  factory Drive.fromJson(Map<String, dynamic> json) {
    return Drive(
      driveId: json['drive_id'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      durationMin: json['duration_min'],
      durationStr: json['duration_str'],
      distance: json['odometer_details']['odometer_distance'].toStringAsFixed(2),
      startBatteryLevel: json['battery_details']['start_usable_battery_level'],
      endBatteryLevel: json['battery_details']['end_usable_battery_level'],
      batteryDiff: json['battery_details']['start_usable_battery_level'] - json['battery_details']['end_usable_battery_level'],
      startRange: json['range_rated']['start_range'],
      endRange: json['range_rated']['end_range'],
      rangeDiff: json['range_rated']['range_diff'],
    );
  }
}
