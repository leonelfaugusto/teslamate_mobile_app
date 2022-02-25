import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<List<DriveDetail>> fetchDriveDetails(int id) async {
  final SharedPreferences _prefs = await SharedPreferences.getInstance();
  final api = _prefs.getString("api");
  final carID = _prefs.getInt("car_id") ?? 1;
  final apiUsername = _prefs.getString("wwwUsername") ?? "";
  final apiPassword = _prefs.getString("wwwPassword") ?? "";
  final isApiProtected = _prefs.getBool("isApiProtected") ?? false;
  Map<String, String> headers = {};
  if (isApiProtected) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String send = stringToBase64.encode("$apiUsername:$apiPassword");
    headers = {
      ...headers,
      "Authorization": "Basic $send",
    };
  }
  final response = await http.get(Uri.parse('$api/api/v1/cars/$carID/drives/$id'), headers: headers);
  final List<DriveDetail> driveDetails = [];

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Map<String, dynamic> body = jsonDecode(response.body);
    for (var driveDetail in (body['data']['drive']['drive_details'] as List)) {
      driveDetails.add(DriveDetail.fromJson(driveDetail));
    }
    return driveDetails;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load drive');
  }
}

class DriveDetail {
  final int driveDetailId;
  final DateTime date;
  final double latitude;
  final double longitude;
  final int? speed;
  final int? power;
  final double odometer;
  final int? bateryLevel;
  final int? usableBateryLevel;
  final int? elevation;

  DriveDetail({
    required this.driveDetailId,
    required this.date,
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.power,
    required this.odometer,
    required this.bateryLevel,
    required this.usableBateryLevel,
    required this.elevation,
  });

  factory DriveDetail.fromJson(Map<String, dynamic> json) {
    return DriveDetail(
      driveDetailId: json['detail_id'],
      date: DateTime.parse(json['date']),
      bateryLevel: json['battery_level'],
      usableBateryLevel: json['usable_battery_level'],
      elevation: json['elevation'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      odometer: json['odometer'],
      power: json['power'],
      speed: json['speed'],
    );
  }
}
