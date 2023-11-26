import 'package:google_place/google_place.dart';
import 'package:weather/weather.dart';
import 'package:http/http.dart' as http;

import 'data_management/weight_data.dart';
import 'data_management/food_data.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'healthData.dart';

class DataToJson {
  var foodList = [];
  var weightList = [];
  String address = "";
  Map<String, dynamic> weather = {};
  Map<String, dynamic> fitList = {};
  Map<String, dynamic> _message = {};
  HealthData health = HealthData();

  void clearData() {
    foodList = [];
    weightList = [];
    fitList = {};
    _message = {};
  }

  // void getPlacesAPIData() async {
  //   String url =
  //       "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=1500&type=restaurant&keyword=cruise&key=YOUR_API_KEY";
  //
  //   var response = await http.post(
  //     Uri.parse(url),
  //   );
  //
  //   var googlePlace = GooglePlace("Your-Key");
  //   // var result = await googlePlace.details.get();
  // }

  Map<String, dynamic> getAllFitData() {
    health.fetchData();
    fitList = health.getFitData();
    return fitList;
  }

  Future<Position> _determineAccess() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied)
        Future.error('Location Permission is Denied');
    }
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> getAddressFromPosition(Position position) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemark[0];
    address = place.locality! + ", " + place.country!;
    // print(address);
  }

  void getCurrentLocation() async {
    Position position = await _determineAccess();
    double latitude = position.latitude;
    double longitude = position.longitude;
    // print("Latitude:" +
    //     latitude.toString() +
    //     " Longitude" +
    //     longitude.toString());
    getAddressFromPosition(position);
    getWeatherData(latitude, longitude);
  }

  Future<void> getWeatherData(double lat, double lon) async {
    String key = '33f8ba56d7b77f605c998e8b25413b54';
    WeatherFactory wf = WeatherFactory(key);
    Weather w = await wf.currentWeatherByLocation(lat, lon);

    print(w);

    weather["description"] = w.weatherDescription;
    weather["average_temperature"] = (w.temperature != null)
        ? double.parse((w.temperature!.celsius)!.toStringAsFixed(2))
        : 0.0;
    weather["max_temperature"] = (w.tempMax != null)
        ? double.parse((w.tempMax!.celsius)!.toStringAsFixed(2))
        : 0.0;
    weather["min_temperature"] = (w.tempMin != null)
        ? double.parse((w.tempMin!.celsius)!.toStringAsFixed(2))
        : 0.0;
    weather["temperature_feel"] = (w.tempFeelsLike != null)
        ? double.parse((w.tempFeelsLike!.celsius)!.toStringAsFixed(2))
        : 0.0;
    weather["max_temperature_feel"] = (w.tempMax != null)
        ? double.parse((w.tempMax!.celsius)!.toStringAsFixed(2))
        : 0.0;
    weather["min_temperature_feel"] = (w.tempMin != null)
        ? double.parse((w.tempMin!.celsius)!.toStringAsFixed(2))
        : 0.0;
    weather["precipitation"] = w.humidity;
    weather["sunrise"] = (w.sunrise!.millisecondsSinceEpoch / 1000).round();
    weather["sunset"] = (w.sunset!.millisecondsSinceEpoch / 1000).round();

    // weather["home"] = 0.0;
    // weather["work"] = 0.0;
    // weather["food_drinks"] = 0.0;
    // weather["outdoors"] = 0.0;
    // weather["sports"] = 0.0;
    // weather["mobility"] = 0.0;
    // weather["entertainment"] = 0.0;
    // weather["shopping"] = 0.0;
    // weather["health"] = 0.0;
    // weather["others"] = 0.0;
    // weather["unknown"] = 0.0;

    print(weather);
  }

  bool getFoodDB() {
    //read from database and get the names in right order and in lowercase
    DatabaseHelper.instance.getAllFoods().then((value) {
      for (var element in value) {
        foodList.add(element);
      }
    });
    if (foodList.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool getWeightDB() {
    //read from database and get the names in right order and in lowercase
    DatabaseHelperWeight.weightInstance.getAllWeights().then((value) {
      for (var element in value) {
        weightList.add(element);
      }
    });
    if (weightList.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool getSaveFitData() {
    bool fitListFlag = false;

    for (String key in fitList.keys) {
      if (fitList[key].isNotEmpty) {
        fitListFlag = true;
        break;
      }
    }
    if (fitListFlag)
      return true;
    else
      return false;
  }

  bool getDB() {
    // getSaveFitData();
    getFoodDB();
    getWeightDB();
    getCurrentLocation();

    return true;
  }

  void formJson() {
    Map<String, dynamic> meal = mealToJson();
    Map<String, dynamic> weight = weightToJson();
    Map<String, dynamic> fit = fitToJson();
    Map<String, dynamic> loc = currLocToJson();
    Map<String, dynamic> weather = currWeatherToJson();

    _message = {
      "Meal": meal,
      "Weight": weight,
      "Currentplace": loc,
      "Fit": fit,
      "Weatherlocation": weather
    };
    if (meal.isEmpty) _message.remove("Meal");
    if (weight.isEmpty) _message.remove("Weight");
    if (loc.isEmpty) _message.remove("Currentplace");
    if (fit.isEmpty) _message.remove("Fit");
    if (weather.isEmpty) _message.remove("Weatherlocation");
    if (_message.isNotEmpty) {
      print(_message);
    }
  }

  Map<String, dynamic> dbJson() {
    formJson();
    return _message;
  }

  Map<String, dynamic> fitToJson() {
    getSaveFitData();

    if (fitList.isNotEmpty) {
      print(fitList);

      return {
        "UID": "20",
        "timestamp": [(DateTime.now().millisecondsSinceEpoch / 1000).round()],
        "steps": (fitList["STEPS"] != null && !fitList["STEPS"].isEmpty)
            ? fitList["STEPS"]
            : [0.0],
        "heartrate":
            (fitList["HEART_RATE"] != null && !fitList["HEART_RATE"].isEmpty)
                ? fitList["HEART_RATE"]
                : [0.0],
        "distance": (fitList["DISTANCE_DELTA"] != null &&
                !fitList["DISTANCE_DELTA"].isEmpty)
            ? fitList["DISTANCE_DELTA"]
            : [0.0],
        "activity": (fitList["EXERCISE_TIME"] != null &&
                !fitList["EXERCISE_TIME"].isEmpty)
            ? fitList["EXERCISE_TIME"]
            : [0.0],
        "low_intensity": (fitList["BASAL_ENERGY_BURNED"] != null &&
                !fitList["BASAL_ENERGY_BURNED"].isEmpty)
            ? fitList["BASAL_ENERGY_BURNED"]
            : [0.0],
        "high_intensity": (fitList["ACTIVE_ENERGY_BURNED"] != null &&
                !fitList["ACTIVE_ENERGY_BURNED"].isEmpty)
            ? fitList["ACTIVE_ENERGY_BURNED"]
            : [0.0],
        "move": (fitList["MOVE_MINUTES"] != null &&
                !fitList["MOVE_MINUTES"].isEmpty)
            ? fitList["MOVE_MINUTES"]
            : [0.0],
        "calories": (fitList["ACTIVE_ENERGY_BURNED"] != null &&
                !fitList["ACTIVE_ENERGY_BURNED"].isEmpty)
            ? fitList["ACTIVE_ENERGY_BURNED"]
            : [0.0],
        "gotosleep": (fitList["SLEEP_IN_BED"] != null &&
                !fitList["SLEEP_IN_BED"].isEmpty)
            ? fitList["SLEEP_IN_BED"]
            : [0.0],
        "wakeup":
            (fitList["SLEEP_AWAKE"] != null && !fitList["SLEEP_AWAKE"].isEmpty)
                ? fitList["SLEEP_AWAKE"]
                : [0.0],
        "hours_sleep": (fitList["SLEEP_SESSION"] != null &&
                !fitList["SLEEP_SESSION"].isEmpty)
            ? fitList["SLEEP_SESSION"]
            : [0.0],
        "awake":
            (fitList["SLEEP_AWAKE"] != null && !fitList["SLEEP_AWAKE"].isEmpty)
                ? fitList["SLEEP_AWAKE"]
                : [0.0],
        "asleep": (fitList["SLEEP_ASLEEP"] != null &&
                !fitList["SLEEP_ASLEEP"].isEmpty)
            ? fitList["SLEEP_ASLEEP"]
            : [0.0],
        "outofbed": (fitList["SLEEP_OUT_OF_BED"] != null &&
                !fitList["SLEEP_OUT_OF_BED"].isEmpty)
            ? fitList["SLEEP_OUT_OF_BED"]
            : [0.0],
        "lightsleep":
            (fitList["SLEEP_LIGHT"] != null && !fitList["SLEEP_LIGHT"].isEmpty)
                ? fitList["SLEEP_LIGHT"]
                : [0.0],
        "deepsleep":
            (fitList["SLEEP_DEEP"] != null && !fitList["SLEEP_DEEP"].isEmpty)
                ? fitList["SLEEP_DEEP"]
                : [0.0],
        "REM": (fitList["SLEEP_REM"] != null && !fitList["SLEEP_REM"].isEmpty)
            ? fitList["SLEEP_REM"]
            : [0.0]
      };
    } else
      return {};
  }

  Map<String, dynamic> currLocToJson() {
    getCurrentLocation();
    if (address.isNotEmpty) {
      return {
        "UID": "20",
        "timestamp": [(DateTime.now().millisecondsSinceEpoch / 1000).round()],
        "place": [address]
      };
    } else {
      return {};
    }
  }

  bool isEmptyNull(dynamic value) {
    if (value != null && !value.isEmpty) return false;
    return true;
  }

  Map<String, dynamic> currWeatherToJson() {
    getCurrentLocation();
    if (weather.isNotEmpty) {
      // return {
      //   "UID": "20",
      //   "timestamp": [1234567890],
      //   "description": ["description"],
      //   "average_temperature": [1.2],
      //   "max_temperature": [12.7],
      //   "min_temperature": [14.6],
      //   "temperature_feel": [13.3],
      //   "max_temperature_feel": [1.3],
      //   "min_temperature_feel": [4.6],
      //   "precipitation": [92.0],
      //   "sunrise": [1693197647],
      //   "sunset": [1693246790],
      //   "home": [0.0],
      //   "work": [0.0],
      //   "food_drinks": [0.0],
      //   "outdoors": [0.0],
      //   "sports": [0.0],
      //   "mobility": [0.0],
      //   "entertainment": [0.0],
      //   "shopping": [0.0],
      //   "health": [0.0],
      //   "others": [0.0],
      //   "unknown": [0.0]
      // };
      return {
        "UID": "20",
        "timestamp": [(DateTime.now().millisecondsSinceEpoch / 1000).round()],
        "description": [
          (weather["description"] != null && !weather["description"].isEmpty)
              ? weather["description"]
              : ""
        ],
        "average_temperature": [
          (weather["average_temperature"] != null)
              ? weather["average_temperature"]
              : 0.0
        ],
        "max_temperature": [
          (weather["max_temperature"] != null)
              ? weather["max_temperature"]
              : 0.0
        ],
        "min_temperature": [
          (weather["min_temperature"] != null)
              ? weather["min_temperature"]
              : 0.0
        ],
        "temperature_feel": [
          (weather["temperature_feel"] != null)
              ? weather["temperature_feel"]
              : 0.0
        ],
        "max_temperature_feel": [
          (weather["max_temperature_feel"] != null)
              ? weather["max_temperature_feel"]
              : 0.0
        ],
        "min_temperature_feel": [
          (weather["min_temperature_feel"] != null)
              ? weather["min_temperature_feel"]
              : 0.0
        ],
        "precipitation": [
          (weather["precipitation"] != null) ? weather["precipitation"] : 0.0
        ],
        "sunrise": [(weather["sunrise"] != null) ? weather["sunrise"] : 0.0],
        "sunset": [(weather["sunset"] != null) ? weather["sunset"] : 0.0],
        "home": [
          (weather["home"] != null && !weather["home"].isEmpty)
              ? weather["home"]
              : 0.0
        ],
        "work": [
          (weather["work"] != null && !weather["work"].isEmpty)
              ? weather["work"]
              : 0.0
        ],
        "food_drinks": [
          (weather["food_drinks"] != null && !weather["food_drinks"].isEmpty)
              ? weather["food_drinks"]
              : 0.0
        ],
        "outdoors": [
          (weather["outdoors"] != null && !weather["outdoors"].isEmpty)
              ? weather["outdoors"]
              : 0.0
        ],
        "sports": [
          (weather["sports"] != null && !weather["sports"].isEmpty)
              ? weather["sports"]
              : 0.0
        ],
        "mobility": [
          (weather["mobility"] != null && !weather["mobility"].isEmpty)
              ? weather["mobility"]
              : 0.0
        ],
        "entertainment": [
          (weather["entertainment"] != null &&
                  !weather["entertainment"].isEmpty)
              ? weather["entertainment"]
              : 0.0
        ],
        "shopping": [
          (weather["shopping"] != null && !weather["shopping"].isEmpty)
              ? weather["shopping"]
              : 0.0
        ],
        "health": [
          (weather["health"] != null && !weather["health"].isEmpty)
              ? weather["health"]
              : 0.0
        ],
        "others": [
          (weather["others"] != null && !weather["others"].isEmpty)
              ? weather["others"]
              : 0.0
        ],
        "unknown": [
          (weather["unknown"] != null && !weather["unknown"].isEmpty)
              ? [weather["unknown"]]
              : 0.0
        ]
      };
    } else {
      return {};
    }
  }

  Map<String, dynamic> mealToJson() {
    getFoodDB();
    if (foodList.isNotEmpty) {
      return {
        "UID": "20",
        "timestamp": foodList[0],
        "timestampchosen": foodList[1],
        "foodID": foodList[2],
        "portion": foodList[3]
      };
    } else {
      return {};
    }
  }

  Map<String, dynamic> weightToJson() {
    getWeightDB();
    if (weightList.isNotEmpty) {
      return {
        "UID": "20",
        "timestamp": weightList[0],
        "timestampchosen": weightList[1],
        "weight": weightList[2]
      };
    } else {
      return {};
    }
  }
}
