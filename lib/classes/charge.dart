import 'package:intl/intl.dart';
import 'package:teslamate/classes/charge_detail.dart';

class Charge {
  final int chargeId;
  final DateTime startDate;
  final DateTime endDate;
  final num durationMin;
  final String durationStr;
  final num cost;
  final num startBatteryLevel;
  final num endBatteryLevel;
  final num batteryDiff;
  final String address;
  final num chargeEnergyAdded;
  final num chargeenergyUsed;
  final num startRange;
  final num endRange;
  final num rangeDiff;
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
    required this.startRange,
    required this.endRange,
    required this.rangeDiff,
    this.chargeDetails = const [],
  });

  factory Charge.fromJson(Map<String, dynamic> json) {
    print(DateTime.parse(json['start_date']).toLocal());
    return Charge(
      chargeId: json['charge_id'],
      startDate: DateTime.parse(json['start_date']).toLocal(),
      endDate: DateTime.parse(json['end_date']).toLocal(),
      durationMin: json['duration_min'],
      durationStr: json['duration_str'],
      cost: json['cost'],
      startBatteryLevel: json['battery_details']['start_battery_level'],
      endBatteryLevel: json['battery_details']['end_battery_level'],
      address: json['address'],
      chargeEnergyAdded: json['charge_energy_added'],
      chargeenergyUsed: json['charge_energy_used'],
      batteryDiff: json['battery_details']['end_battery_level'] - json['battery_details']['start_battery_level'],
      startRange: json['range_rated']['start_range'] - json['battery_details']['start_battery_level'],
      endRange: json['range_rated']['end_range'],
      rangeDiff: json['range_rated']['end_range'] - json['range_rated']['start_range'],
    );
  }

  Future fetchMoreInfo() async {
    chargeDetails = await fetchChargeDetails(chargeId);
  }
}
