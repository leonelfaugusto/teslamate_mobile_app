import 'package:teslamate/classes/drive_detail.dart';

class Drive {
  final int driveId;
  final DateTime startDate;
  final DateTime endDate;
  final num durationMin;
  final String durationStr;
  final num distance;
  final num startBatteryLevel;
  final num endBatteryLevel;
  final num batteryDiff;
  final num startRange;
  final num endRange;
  final num rangeDiff;
  final String startAddress;
  final String endAddress;
  final num speedMax;
  final num speedAvg;
  List<DriveDetail> driveDetails;

  Drive({
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
    required this.startAddress,
    required this.endAddress,
    required this.speedMax,
    required this.speedAvg,
    this.driveDetails = const [],
  });

  factory Drive.fromJson(Map<String, dynamic> json) {
    num diffCalc = json['range_rated']['end_range'] - json['range_rated']['start_range'];
    num diff = double.parse(diffCalc.toStringAsFixed(2));
    return Drive(
      driveId: json['drive_id'],
      startDate: DateTime.parse(json['start_date']).toLocal(),
      endDate: DateTime.parse(json['end_date']).toLocal(),
      durationMin: json['duration_min'],
      durationStr: json['duration_str'],
      distance: double.parse(json['odometer_details']['odometer_distance'].toStringAsFixed(2)),
      startBatteryLevel: json['battery_details']['start_usable_battery_level'],
      endBatteryLevel: json['battery_details']['end_usable_battery_level'],
      batteryDiff: json['battery_details']['end_usable_battery_level'] - json['battery_details']['start_usable_battery_level'],
      startRange: json['range_rated']['start_range'],
      endRange: json['range_rated']['end_range'],
      rangeDiff: diff,
      startAddress: json['start_address'],
      endAddress: json['end_address'],
      speedAvg: json['speed_avg'],
      speedMax: json['speed_max'],
    );
  }

  Future fetchMoreInfo() async {
    driveDetails = await fetchDriveDetails(driveId);
  }
}
