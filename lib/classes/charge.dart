import 'package:teslamate/classes/charge_detail.dart';

class Charge {
  final int chargeId;
  final DateTime startDate;
  final DateTime endDate;
  final int durationMin;
  final String durationStr;
  final dynamic cost;
  final int startBatteryLevel;
  final int endBatteryLevel;
  final int batteryDiff;
  final String address;
  final dynamic chargeEnergyAdded;
  final dynamic chargeenergyUsed;
  List<ChargeDetail> chargeDetails;

  Charge({
    required this.chargeId,
    required this.startDate,
    required this.endDate,
    required this.durationMin,
    required this.durationStr,
    required this.cost,
    required this.startBatteryLevel,
    required this.endBatteryLevel,
    required this.batteryDiff,
    required this.address,
    required this.chargeEnergyAdded,
    required this.chargeenergyUsed,
    this.chargeDetails = const [],
  });

  factory Charge.fromJson(Map<String, dynamic> json) {
    return Charge(
      chargeId: json['charge_id'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      durationMin: json['duration_min'],
      durationStr: json['duration_str'],
      cost: json['cost'],
      startBatteryLevel: json['battery_details']['start_battery_level'],
      endBatteryLevel: json['battery_details']['end_battery_level'],
      address: json['address'],
      chargeEnergyAdded: json['charge_energy_added'],
      chargeenergyUsed: json['charge_energy_used'],
      batteryDiff: json['battery_details']['end_battery_level'] - json['battery_details']['start_battery_level'],
    );
  }

  Future fetchMoreInfo() async {
    chargeDetails = await fetchChargeDetails(chargeId);
  }
}
