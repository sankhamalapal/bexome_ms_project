// import 'dart:async';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:health/health.dart';
//
// //TODO: Implement IOS/Android specific code to downlaod and send in the background
// DateTime lastdownload = DateTime(2022,7,18,8,0,0,0,0);
//
// List<HealthDataPoint> healthData = [];
//
//
// void updatelastdownload () {
//   lastdownload = DateTime.now();
// }
//
// void updatehealthdata (List<HealthDataPoint> upload){
//   healthData = upload;
// }
//
//
// Future getData() async {
//   // create a HealthFactory for use in the app
//   HealthFactory health = HealthFactory();
//
//   // get the number of steps for today
//   final now = DateTime.now();
//   var midnight = DateTime(now.year, now.month, now.day);
//   int? steps = await health.getTotalStepsInInterval(midnight, now);
//
//   //types of the data collected
//   var types = [
//     HealthDataType.STEPS,
//     HealthDataType.ACTIVE_ENERGY_BURNED,
//     HealthDataType.BLOOD_GLUCOSE,
//     HealthDataType.BLOOD_OXYGEN,
//     HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
//     HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
//     HealthDataType.BODY_FAT_PERCENTAGE,
//     HealthDataType.BODY_MASS_INDEX,
//     HealthDataType.BODY_TEMPERATURE,
//     HealthDataType.HEART_RATE,
//     HealthDataType.SLEEP_IN_BED,
//     HealthDataType.SLEEP_ASLEEP,
//     HealthDataType.WORKOUT,
//   ];
//
//   //necessary for permission handling
//   final permissions = [
//     HealthDataAccess.READ,
//     HealthDataAccess.READ,
//     HealthDataAccess.READ,
//     HealthDataAccess.READ,
//     HealthDataAccess.READ,
//     HealthDataAccess.READ,
//     HealthDataAccess.READ,
//     HealthDataAccess.READ,
//     HealthDataAccess.READ,
//     HealthDataAccess.READ,
//     HealthDataAccess.READ,
//     HealthDataAccess.READ,
//     HealthDataAccess.READ,
//   ];
//
//   // requesting access to the data types before reading them
//   bool requested =
//   await health.requestAuthorization(types, permissions: permissions);
//   print('requested: $requested');
//
//   //for StepCount etc.
//   await Permission.activityRecognition.request();
//   await Permission.location.request();
//
//
//   // get data within the last 24 hours
//   final yesterday = now.subtract(Duration(days: 5));
//
//
//   // fetch health data from the last 24 hours
//   List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
//       now.subtract(Duration(days: 1)), now, types);
//
//   print(healthData);
//
//   return healthData;
// }
//
