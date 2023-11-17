import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HealthData {
  Map<String, dynamic> getFitData() {
    return _messageList;
  }

  List<HealthDataPoint> _healthDataList = [];
  Map<String, dynamic> _messageList = {};

  static final types = [
    HealthDataType.STEPS, //steps
    HealthDataType.HEART_RATE, //heartrate
    HealthDataType.DISTANCE_DELTA, //distance
    HealthDataType.EXERCISE_TIME, //activity
    HealthDataType.BASAL_ENERGY_BURNED, //low_intensity
    HealthDataType.ACTIVE_ENERGY_BURNED, //high_intensity
    HealthDataType.MOVE_MINUTES, //move
    HealthDataType.ACTIVE_ENERGY_BURNED, //calories
    HealthDataType.SLEEP_IN_BED, //gotosleep
    HealthDataType.SLEEP_AWAKE, //wakeup
    HealthDataType.SLEEP_SESSION, //hours_sleep
    HealthDataType.SLEEP_AWAKE, //awake
    HealthDataType.SLEEP_ASLEEP, //asleep
    HealthDataType.SLEEP_OUT_OF_BED, //outofbed
    HealthDataType.SLEEP_LIGHT, //lightsleep
    HealthDataType.SLEEP_DEEP, //deepsleep
    HealthDataType.SLEEP_REM, //REM
  ];
  final permissions = types.map((e) => HealthDataAccess.READ_WRITE).toList();
  HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);
  Future authorize() async {
    await Permission.activityRecognition.request();
    await Permission.location.request();

    // Check if we have permission
    bool? hasPermissions =
        await health.hasPermissions(types, permissions: permissions);

    hasPermissions = false;

    if (!hasPermissions) {
      // requesting access to the data types before reading them
      try {
        hasPermissions =
            await health.requestAuthorization(types, permissions: permissions);
      } catch (error) {
        print("Exception in authorize: $error");
      }
    }
  }

  Future fetchData() async {
    authorize();
    // get data within the last 24 hours
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(hours: 24));
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'DataSent.txt');
    DateTime lastTimestamp = yesterday;

    try {
      File(path).readAsString().then((String contents) {
        int time = int.parse(contents.split(" ").last.toString());
        lastTimestamp = DateTime.fromMillisecondsSinceEpoch(time * 1000);
      });
    } catch (error) {
      print("Exception in reading the last timestamp: $error");
    }

    // Clear old data points
    _healthDataList.clear();
    _messageList.clear();

    for (HealthDataType type in types) {
      print(type);
      List<HealthDataType> typeList = [];
      typeList.add(type);
      try {
        List<HealthDataPoint> healthData =
            await health.getHealthDataFromTypes(lastTimestamp, now, typeList);
        _healthDataList.addAll((healthData.length < 100)
            ? healthData
            : healthData.sublist(0, 100));
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }
    }

    // filter out duplicates
    _healthDataList = HealthFactory.removeDuplicates(_healthDataList);

    for (HealthDataType type in types) {
      List<dynamic> healthDataValueList = [];
      double val = 0.0;
      double value = 0.0;

      for (HealthDataPoint health in _healthDataList) {
        if (health.value.runtimeType == NumericHealthValue) {
          value = double.parse(health.value.toString());
          if (type.name == health.type.name) {
            val += value;
            healthDataValueList = [val];
          }
        }
      }
      _messageList.addAll({type.name: healthDataValueList});
    }

    print(_messageList);
  }
}
