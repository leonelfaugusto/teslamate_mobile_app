import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<ChargeDetail>> fetchChargeDetails(int id) async {
  final response = await http.get(Uri.parse('http://10.10.20.121:8080/api/v1/cars/1/charges/$id'));
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
      date: DateTime.parse(json['date']),
      bateryLevel: json['battery_level'],
      usableBateryLevel: json['usable_battery_level'],
      chargeEnergyAdded: json['charge_energy_added'],
      chargePower: json['charger_details']['charger_power'],
    );
  }
}
