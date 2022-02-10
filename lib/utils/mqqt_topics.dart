class Topics {
  int carID;
  late String displayName;
  late String state;
  late String since;
  late String healthy;
  late String version;
  late String updateAvailable;
  late String updateVersion;
  late String model;
  late String trimBadging;
  late String exteriorColor;
  late String wheelType;
  late String spoilerType;
  late String geofence;
  late String latitude;
  late String longitude;
  late String shiftState;
  late String power;
  late String speed;
  late String heading;
  late String elevation;
  late String locked;
  late String sentryMode;
  late String windowsOpen;
  late String doorsOpen;
  late String trunkOpen;
  late String frunkOpen;
  late String isUserPresent;
  late String isClimateOn;
  late String insideTemp;
  late String outsideTemp;
  late String isPreconditioning;
  late String odometer;
  late String estBatteryRangeKm;
  late String ratedBatteryRangeKm;
  late String idealBatteryRangeKm;
  late String batteryLevel;
  late String usableBatteryLevel;
  late String pluggedIn;
  late String chargeEnergyAdded;
  late String chargeLimitSoc;
  late String chargePortDoorOpen;
  late String chargerActualCurrent;
  late String chargerPhases;
  late String chargerPower;
  late String chargerVoltage;
  late String scheduledChargingStartTime;
  late String timeToFullCharge;

  Topics({required this.carID}) {
    displayName = 'teslamate/cars/$carID/display_name';
    state = 'teslamate/cars/$carID/state';
    since = 'teslamate/cars/$carID/since';
    healthy = 'teslamate/cars/$carID/healthy';
    version = 'teslamate/cars/$carID/version';
    updateAvailable = 'teslamate/cars/$carID/update_available';
    updateVersion = 'teslamate/cars/$carID/update_version';
    model = 'teslamate/cars/$carID/model';
    trimBadging = 'teslamate/cars/$carID/trim_badging';
    exteriorColor = 'teslamate/cars/$carID/exterior_color';
    wheelType = 'teslamate/cars/$carID/wheel_type';
    spoilerType = 'teslamate/cars/$carID/spoiler_type';
    geofence = 'teslamate/cars/$carID/geofence';
    latitude = 'teslamate/cars/$carID/latitude';
    longitude = 'teslamate/cars/$carID/longitude';
    shiftState = 'teslamate/cars/$carID/shift_state';
    power = 'teslamate/cars/$carID/power';
    speed = 'teslamate/cars/$carID/speed';
    heading = 'teslamate/cars/$carID/heading';
    elevation = 'teslamate/cars/$carID/elevation';
    locked = 'teslamate/cars/$carID/locked';
    sentryMode = 'teslamate/cars/$carID/sentry_mode';
    windowsOpen = 'teslamate/cars/$carID/windows_open';
    doorsOpen = 'teslamate/cars/$carID/doors_open';
    trunkOpen = 'teslamate/cars/$carID/trunk_open';
    frunkOpen = 'teslamate/cars/$carID/frunk_open';
    isUserPresent = 'teslamate/cars/$carID/is_user_present';
    isClimateOn = 'teslamate/cars/$carID/is_climate_on';
    insideTemp = 'teslamate/cars/$carID/inside_temp';
    outsideTemp = 'teslamate/cars/$carID/outside_temp';
    isPreconditioning = 'teslamate/cars/$carID/is_preconditioning';
    odometer = 'teslamate/cars/$carID/odometer';
    estBatteryRangeKm = 'teslamate/cars/$carID/est_battery_range_km';
    ratedBatteryRangeKm = 'teslamate/cars/$carID/rated_battery_range_km';
    idealBatteryRangeKm = 'teslamate/cars/$carID/ideal_battery_range_km';
    batteryLevel = 'teslamate/cars/$carID/battery_level';
    usableBatteryLevel = 'teslamate/cars/$carID/usable_battery_level';
    pluggedIn = 'teslamate/cars/$carID/plugged_in';
    chargeEnergyAdded = 'teslamate/cars/$carID/charge_energy_added';
    chargeLimitSoc = 'teslamate/cars/$carID/charge_limit_soc';
    chargePortDoorOpen = 'teslamate/cars/$carID/charge_port_door_open';
    chargerActualCurrent = 'teslamate/cars/$carID/charger_actual_current';
    chargerPhases = 'teslamate/cars/$carID/charger_phases';
    chargerPower = 'teslamate/cars/$carID/charger_power';
    chargerVoltage = 'teslamate/cars/$carID/charger_voltage';
    scheduledChargingStartTime = 'teslamate/cars/$carID/scheduled_charging_start_time';
    timeToFullCharge = 'teslamate/cars/$carID/time_to_full_charge';
  }

  List<String> getTopicsList() {
    return [
      displayName,
      state,
      since,
      healthy,
      version,
      updateAvailable,
      updateVersion,
      model,
      trimBadging,
      exteriorColor,
      wheelType,
      spoilerType,
      geofence,
      latitude,
      longitude,
      shiftState,
      power,
      speed,
      heading,
      elevation,
      locked,
      sentryMode,
      windowsOpen,
      doorsOpen,
      trunkOpen,
      frunkOpen,
      isUserPresent,
      isClimateOn,
      insideTemp,
      outsideTemp,
      isPreconditioning,
      odometer,
      estBatteryRangeKm,
      ratedBatteryRangeKm,
      idealBatteryRangeKm,
      batteryLevel,
      usableBatteryLevel,
      pluggedIn,
      chargeEnergyAdded,
      chargeLimitSoc,
      chargePortDoorOpen,
      chargerActualCurrent,
      chargerPhases,
      chargerPower,
      chargerVoltage,
      scheduledChargingStartTime,
      timeToFullCharge
    ];
  }
}
