import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<List<ChargeDetail>> fetchChargeDetails(int id) async {
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
  final response = await http.get(Uri.parse('$api/api/v1/cars/$carID/charges/$id'), headers: headers);
  final List<ChargeDetail> chargeDetails = [];

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Map<String, dynamic> body = jsonDecode(response.body);
    for (var chargeDetail in (body['data']['charge']['charge_details'] as List)) {
      if (chargeDetail['charger_details']['charger_power'] < 0) {
        chargeDetail['charger_details']['charger_power'] = 0;
      }
      chargeDetails.add(ChargeDetail.fromJson(chargeDetail));
    }
    return chargeDetails;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load charge');
  }
}

class ChargeDetail {
  final int chargeDetailId;
  final DateTime date;
  final int bateryLevel;
  final int usableBateryLevel;
  final dynamic chargeEnergyAdded;
  final int chargePower;

  ChargeDetail({
    required this.chargeDetailId,
    required this.date,
    required this.bateryLevel,
    required this.usableBateryLevel,
    required this.chargeEnergyAdded,
    required this.chargePower,
  });

  factory ChargeDetail.fromJson(Map<String, dynamic> json) {
    return ChargeDetail(
      chargeDetailId: json['detail_id'],
      date: DateTime.parse(json['date']).toLocal(),
      bateryLevel: json['battery_level'],
      usableBateryLevel: json['usable_battery_level'],
      chargeEnergyAdded: json['charge_energy_added'],
      chargePower: json['charger_details']['charger_power'],
    );
  }
}
