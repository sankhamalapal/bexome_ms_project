import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class FoodData {
  DateTime dateOfFood; //the day, when the food was logged
  DateTime dateOfFoodLog; //the day, when the food was eaten
  final String code;
  final double portion;
  final double kcal; //the amount of kcal of the specific chosen meal
  final double protein;
  final String foodName;
  final double fats;
  final double carbohydrates;
  final int isFav;
  FoodData(
      this.dateOfFood,
      this.dateOfFoodLog,
      this.code,
      this.portion,
      this.kcal,
      this.protein,
      this.foodName,
      this.fats,
      this.carbohydrates,
      this.isFav);
}

class FoodDB {
  final int timestamp;
  final int logDate; //the day, when the food was eaten
  final String foodId;
  final double portion;
  final double kcal; //the amount of kcal of the specific chosen meal
  final double protein;
  final String foodName;
  final double fats;
  final double carbohydrates;
  final int isFav;

  FoodDB(this.timestamp, this.logDate, this.foodId, this.portion, this.kcal,
      this.protein, this.foodName, this.fats, this.carbohydrates, this.isFav);

  factory FoodDB.fromMap(Map<String, dynamic> json) => new FoodDB(
      json['timestamp'],
      json['logDate'],
      json['foodId'],
      json['serving_quantity'],
      json['kcal'],
      json['protein'],
      json['foodName'],
      json['fats'],
      json['carbohydrates'],
      json['isFav']);

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp,
      'logDate': logDate,
      'foodId': foodId,
      'serving_quantity': portion,
      'kcal': kcal,
      'protein': protein,
      'foodName': foodName,
      'fats': fats,
      'carbohydrates': carbohydrates,
      'isFav': isFav
    };
  }
}

//list with all entered entries -> one list object contains all the points of the FoodData class
List<FoodData> chartData = [];
List<FoodData> chartDataAll = [];
List<FoodData> chartDataFav = [];
List<FoodData> chartDataRecent = [];

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  FoodDB changeFoodObjDatatoDB(FoodData food) {
    FoodDB db = FoodDB(
        (food.dateOfFood.millisecondsSinceEpoch / 1000).round(),
        (food.dateOfFoodLog.millisecondsSinceEpoch / 1000).round(),
        food.code,
        food.portion,
        food.kcal,
        food.protein,
        food.foodName,
        food.fats,
        food.carbohydrates,
        food.isFav);
    return db;
  }

  FoodData changeFoodObjDBtoData(FoodDB food) {
    FoodData db = FoodData(
        DateTime.fromMillisecondsSinceEpoch(food.timestamp * 1000),
        DateTime.fromMillisecondsSinceEpoch(food.logDate * 1000),
        food.foodId,
        food.portion,
        food.kcal,
        food.protein,
        food.foodName,
        food.fats,
        food.carbohydrates,
        food.isFav);
    return db;
  }

  List<FoodDB> changeFoodObjDatatoDBList(List<FoodData> foodList) {
    List<FoodDB> foodDBList = [];
    for (FoodData e in foodList) {
      FoodDB db = changeFoodObjDatatoDB(e);
      foodDBList.add(db);
    }
    return foodDBList;
  }

  List<FoodData> changeFoodObjDBtoDataList(List<FoodDB> foodList) {
    List<FoodData> foodDBList = [];
    for (FoodDB e in foodList) {
      FoodData db = changeFoodObjDBtoData(e);
      foodDBList.add(db);
    }
    return foodDBList;
  }

  Future<Database> get database async => _database ??= await _initDtabase();
  Future<Database> _initDtabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'bexome_app_data.db');
    print('Database found in path : ' + path);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE food(
        timestamp INT,
        logDate INT, 
        foodId TEXT,
        serving_quantity REAL,
        kcal REAL,
        protein REAL,
        foodName TEXT,
        fats REAL,
        carbohydrates REAL, isFav INTEGER)''');

    await db.execute('''CREATE TABLE weight(
        timestamp INT,
        dateOfWeight INT, 
        weight REAL
        )''');

    await db.execute('''CREATE TABLE user(
      gender TEXT,
      age TEXT,
      weight TEXT,
      streetNr TEXT,
      postalcode TEXT,
      town TEXT,
      workStreet TEXT,
      workPostalCode TEXT,
      workTown TEXT,
      studyID TEXT)''');
  }

  Future<List> getRecentFood() async {
    Database db = await instance.database;
    List recentItems = [];
    var foods = await db.query('food', orderBy: 'logDate DESC');

    List<FoodDB> foodList =
        foods.isNotEmpty ? foods.map((e) => FoodDB.fromMap(e)).toList() : [];
    chartDataRecent = changeFoodObjDBtoDataList(foodList);
    for (FoodData data in chartDataRecent) recentItems.add(data.foodName);
    recentItems = recentItems.toSet().toList();
    return recentItems;
  }

  Future<List> getFavFood() async {
    Database db = await instance.database;
    List favItems = [];

    var foods = await db.query('food',
        orderBy: 'logDate DESC', where: 'isFav=?', limit: 50, whereArgs: [1]);
    List<FoodDB> foodList =
        foods.isNotEmpty ? foods.map((e) => FoodDB.fromMap(e)).toList() : [];
    chartDataFav = changeFoodObjDBtoDataList(foodList);
    for (FoodData data in chartDataFav) favItems.add(data.foodName);
    favItems = favItems.toSet().toList();
    return favItems;
  }

  Future<List> getAllFoods() async {
    Database db = await instance.database;
    List foodId = [];
    List timestamp = [];
    List timestampchosen = [];
    List portion = [];
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(hours: 24));
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'DataSent.txt');
    int lastTimestamp = (yesterday.millisecondsSinceEpoch / 1000).round();

    try {
      File(path).readAsString().then((String contents) {
        int time = int.parse(contents.split(" ").last.toString());
        lastTimestamp = time * 1000;
      });
    } catch (error) {
      print("Exception in reading the last timestamp: $error");
    }

    List recentItems = [];
    String whereString = 'timestamp >= ?';
    List<int> whereArguments = [lastTimestamp];

    var foods =
        await db.query('food', where: whereString, whereArgs: whereArguments);
    List<FoodDB> foodList =
        foods.isNotEmpty ? foods.map((e) => FoodDB.fromMap(e)).toList() : [];
    chartDataAll = changeFoodObjDBtoDataList(foodList);
    for (FoodData data in chartDataAll)
      timestamp.add((data.dateOfFood.millisecondsSinceEpoch / 1000).round());
    for (FoodData data in chartDataAll)
      timestampchosen
          .add((data.dateOfFoodLog.millisecondsSinceEpoch / 1000).round());
    for (FoodData data in chartDataAll) foodId.add(data.code);
    for (FoodData data in chartDataAll) portion.add(data.portion);

    recentItems.add(timestamp);
    recentItems.add(timestampchosen);
    recentItems.add(foodId);
    recentItems.add(portion);

    recentItems = recentItems.toSet().toList();
    return recentItems;
  }

  Future<List<FoodData>> getFood() async {
    Database db = await instance.database;
    var foods = await db.query('food', orderBy: 'foodName');
    List<FoodDB> foodList =
        foods.isNotEmpty ? foods.map((e) => FoodDB.fromMap(e)).toList() : [];
    chartData = changeFoodObjDBtoDataList(foodList);
    return chartData;
  }

  Future<int> add(FoodData food) async {
    Database db = await instance.database;
    FoodDB foodDB = changeFoodObjDatatoDB(food);
    return await db.insert('food', foodDB.toMap());
  }

  Future<int> remove(String foodName) async {
    Database db = await instance.database;
    return await db.delete('food', where: 'foodName=?', whereArgs: [foodName]);
  }
}

void removeChartData(int index, bool mealPage, DateTime specialDate) {
  //function to remove an element of the chartData list
  if (!mealPage) {
    //if there is more than one entry per day, but you want to delete all elements of one day
    var tempSltList =
        getFoodChartData(true, false, false, DateTime(2000), false);

    DateTime dateOfDelete = tempSltList[index].dateOfFoodLog;
    var growFoodDataList = [];
    for (FoodData d in chartData) {
      if (d.dateOfFoodLog.year == dateOfDelete.year &&
          d.dateOfFoodLog.month == dateOfDelete.month &&
          d.dateOfFoodLog.day == dateOfDelete.day) {
        growFoodDataList.add(d);
      }
    }
    for (FoodData g in growFoodDataList) {
      chartData.remove(g);
      DatabaseHelper.instance.remove(g.foodName);
    }
  } else {
    var list = getFoodChartData(false, false, true, specialDate, false);
    var listElement = list[index];

    var oneFoodDataList = [];
    for (FoodData d in chartData) {
      if (d.dateOfFoodLog == listElement.dateOfFoodLog &&
          d.foodName == listElement.foodName) {
        oneFoodDataList.add(d);
      }
    }
    for (FoodData o in oneFoodDataList) {
      chartData.remove(o);
      DatabaseHelper.instance.remove(o.foodName);
    }
  }
}

void addFoodChartItem(
    String foodId,
    DateTime dateTime,
    double portion,
    double kcal,
    double protein,
    String foodName,
    double fats,
    double carbohydrates,
    int isFav) {
  DateTime now = new DateTime.now();
  //function to add an element to chartData
  FoodData foodDataObject = FoodData(now, dateTime, foodId, portion, kcal,
      protein, foodName, fats, carbohydrates, isFav);
  DatabaseHelper.instance.add(foodDataObject);
  print("Food item saved in DB");
}

List<FoodData> getFoodChartData(oneValuePerDayInList, currentDayData,
    bool wantSpecialDate, DateTime specialDate, bool lastWeek) {
  DatabaseHelper.instance.getFood();

  //function to get specific elements from chartData
  var solutionList = chartData.map((v) => v).toList();

  if (oneValuePerDayInList) {
    //if oneValuePerDayInList is true, then there will be returned a list with only one element per day --> this means if there is more than one entry in a day, then the addition of all the entries are calculated and returned as one item for this one day
    var chartDataCopy = chartData.map((v) => v).toList();
    var fallingList = chartDataCopy.map((v) => v).toList();
    var meanKcalCalc =
        []; //will be filled with all entries of kcal which are from one day
    var meanProteinCalc = [];
    var meanFatsCalc = [];
    var meanCarbohydratesCalc = [];

    for (var element in chartDataCopy) {
      fallingList.remove(element);
      meanKcalCalc.add(element.kcal);
      meanProteinCalc.add(element.protein);
      meanFatsCalc.add(element.fats);
      meanCarbohydratesCalc.add(element.carbohydrates);
      for (var fallElem in fallingList) {
        if (element.dateOfFoodLog.year == fallElem.dateOfFoodLog.year &&
            element.dateOfFoodLog.month == fallElem.dateOfFoodLog.month &&
            element.dateOfFoodLog.day == fallElem.dateOfFoodLog.day) {
          meanKcalCalc.add(fallElem.kcal);
          meanProteinCalc.add(fallElem.protein);
          meanFatsCalc.add(fallElem.fats);
          meanCarbohydratesCalc.add(fallElem.carbohydrates);
          solutionList.remove(fallElem);
        }
      }
      for (int x = 0; x < solutionList.length; x++) {
        if (solutionList[x] == element) {
          double totalKcal = 0;
          for (var e in meanKcalCalc) {
            totalKcal += e;
            //totalKcal for example is the amount of kcal of all entries of one day
          }
          double totalProtein = 0;
          for (var p in meanProteinCalc) {
            totalProtein += p;
          }
          double totalFats = 0;
          for (var f in meanFatsCalc) {
            totalFats += f;
          }
          double totalCarbohydrates = 0;
          for (var c in meanCarbohydratesCalc) {
            totalCarbohydrates += c;
          }
          meanKcalCalc.clear();
          meanProteinCalc.clear();
          meanFatsCalc.clear();
          meanCarbohydratesCalc.clear();
          DateTime savedDate = solutionList[x].dateOfFoodLog;
          String savedFoodName = solutionList[x].foodName;
          String savedFoodId = solutionList[x].code;
          double portion = solutionList[x].portion;
          solutionList.removeAt(x);
          solutionList.add(FoodData(
              DateTime.now(),
              savedDate,
              savedFoodId,
              portion,
              totalKcal,
              totalProtein,
              savedFoodName,
              totalFats,
              totalCarbohydrates,
              0));
          break;
        }
      }
      meanProteinCalc.clear();
      meanKcalCalc.clear();
      meanFatsCalc.clear();
      meanCarbohydratesCalc.clear();
    }
  }

  solutionList.sort((a, b) {
    //this just sorts the solutionList by date
    var aDate = a.dateOfFoodLog;
    var bDate = b.dateOfFoodLog;
    if (!oneValuePerDayInList) {
      //wheter you need the latest date at the bottom or at the top

      return aDate.compareTo(bDate);
    } else {
      return -aDate.compareTo(bDate);
    }
  });

  if (currentDayData) {
    //returns the element of today for the display on the stats page
    for (var element in solutionList) {
      DateTime now = DateTime.now();
      DateTime currentDateOfFoodLog = element.dateOfFoodLog;
      if (DateTime(currentDateOfFoodLog.year, currentDateOfFoodLog.month,
              currentDateOfFoodLog.day) ==
          DateTime(now.year, now.month, now.day)) {
        return [
          FoodData(
              now,
              element.dateOfFoodLog,
              element.code,
              element.portion,
              element.kcal,
              element.protein,
              element.foodName,
              element.fats,
              element.carbohydrates,
              element.isFav)
        ]; //Anstatt einfach element.dateOfFoodLog könnte hier auch die Differenz der zwei Daten genommen werden (wäre etwas genauer aber würde bis jetzt eh nichts bringen)
      }
    }

    return [
      FoodData(DateTime.now(), DateTime.now(), "", 0, 0, 0, "No entry today!",
          0, 0, 0)
    ];
    //if there is no entry today, we display 0 kcal
  }

  if (wantSpecialDate) {
    //returns the entry or the entries of one specific given date (depends if there is more than one entry per day, so it depends on the bool oneValuePerDayInList)
    List<FoodData> listOfSpecialDate = [];
    for (var element in solutionList) {
      DateTime currentDateOfFoodLog = element.dateOfFoodLog;
      if (DateTime(currentDateOfFoodLog.year, currentDateOfFoodLog.month,
              currentDateOfFoodLog.day) ==
          DateTime(specialDate.year, specialDate.month, specialDate.day)) {
        listOfSpecialDate.add(FoodData(
            DateTime.now(),
            element.dateOfFoodLog,
            element.code,
            element.portion,
            element.kcal,
            element.protein,
            element.foodName,
            element.fats,
            element.carbohydrates,
            element.isFav));
      }
    }

    return listOfSpecialDate;
  }

  var now = new DateTime.now();
  if (lastWeek) {
    //returns all entries of the last week for the graphs of the food page
    var sevenDaysBefore = DateTime(now.year, now.month, now.day - 8);
    // Here -8 instead of -7 because the function checks if isAFTER so > instead of >=
    List<FoodData> lastSevenDaysChartData = [];
    for (var element in solutionList) {
      if (element.dateOfFoodLog.isAfter(sevenDaysBefore)) {
        lastSevenDaysChartData.add(element);
      }
    }

    return lastSevenDaysChartData;
  }

  for (var es in solutionList) {
    print("SolutionList -> Proteine: ${es.protein} und Fette: ${es.fats}");
  }
  for (var es in chartData) {
    print("ChartData -> Proteine: ${es.protein} und Fette: ${es.fats}");
  }

  return solutionList; //returns all element of chartData
}
