import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class WeightData {
  WeightData(this.timestamp, this.dateOfWeight,
      this.weight); //constructor for the class
  final DateTime timestamp;
  final DateTime dateOfWeight; //date of the logged weight
  final double weight; //how much you weighed
}

class WeightDB {
  final int timestamp;
  final int dateOfWeight; //the day, when the Weight was stored
  final double weight; //how much you weighed

  WeightDB(this.timestamp, this.dateOfWeight,
      this.weight); //constructor for the class

  factory WeightDB.fromMap(Map<String, dynamic> json) =>
      new WeightDB(json['timestamp'], json['dateOfWeight'], json['weight']);

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp,
      'dateOfWeight': dateOfWeight,
      'weight': weight
    };
  }
}

List<WeightData> chartData = []; //list for the entered WeightData objects
List<WeightData> chartDataAll = []; //list for the entered WeightData objects

class DatabaseHelperWeight {
  DatabaseHelperWeight._privateConstructor();
  static final DatabaseHelperWeight weightInstance =
      DatabaseHelperWeight._privateConstructor();

  static Database? _database;

  WeightDB changeWeightObjDatatoDB(WeightData weight) {
    WeightDB db = WeightDB(
        (DateTime.now().millisecondsSinceEpoch / 1000).round(),
        (weight.dateOfWeight.millisecondsSinceEpoch / 1000).round(),
        weight.weight);
    return db;
  }

  WeightData changeWeightObjDBtoData(WeightDB weight) {
    WeightData db = WeightData(
        DateTime.fromMillisecondsSinceEpoch(weight.timestamp * 1000),
        DateTime.fromMillisecondsSinceEpoch(weight.dateOfWeight * 1000),
        weight.weight);
    return db;
  }

  List<WeightDB> changeWeightObjDatatoDBList(List<WeightData> weightList) {
    List<WeightDB> weightDBList = [];
    for (WeightData e in weightList) {
      WeightDB db = changeWeightObjDatatoDB(e);
      weightDBList.add(db);
    }
    return weightDBList;
  }

  List<WeightData> changeWeightObjDBtoDataList(List<WeightDB> weightList) {
    List<WeightData> weightDBList = [];
    for (WeightDB e in weightList) {
      WeightData db = changeWeightObjDBtoData(e);
      weightDBList.add(db);
    }
    return weightDBList;
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
        portion REAL,
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

  Future<List> getAllWeights() async {
    Database db = await weightInstance.database;
    List timestamp = [];
    List timestampchosen = [];
    List weight = [];
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

    String whereString = 'timestamp >= ?';
    List<int> whereArguments = [lastTimestamp];

    List recentItems = [];
    var weights =
        await db.query('weight', where: whereString, whereArgs: whereArguments);
    List<WeightDB> weightList = weights.isNotEmpty
        ? weights.map((e) => WeightDB.fromMap(e)).toList()
        : [];
    chartDataAll = changeWeightObjDBtoDataList(weightList);
    for (WeightData data in chartDataAll)
      timestamp.add((data.timestamp.millisecondsSinceEpoch / 1000).round());
    for (WeightData data in chartDataAll)
      timestampchosen
          .add((data.dateOfWeight.millisecondsSinceEpoch / 1000).round());
    for (WeightData data in chartDataAll) weight.add(data.weight);

    recentItems.add(timestamp);
    recentItems.add(timestampchosen);
    recentItems.add(weight);

    recentItems = recentItems.toSet().toList();
    return recentItems;
  }

  Future<List<WeightData>> getWeight() async {
    Database db = await weightInstance.database;
    var weights = await db.query('weight', orderBy: 'dateOfWeight');
    List<WeightDB> weightList = weights.isNotEmpty
        ? weights.map((e) => WeightDB.fromMap(e)).toList()
        : [];
    chartData = changeWeightObjDBtoDataList(weightList);
    return chartData;
  }

  Future<int> add(WeightData weight) async {
    Database db = await weightInstance.database;
    WeightDB weightDB = changeWeightObjDatatoDB(weight);
    return await db.insert('weight', weightDB.toMap());
  }

  Future<int> remove(WeightData weight) async {
    Database db = await weightInstance.database;
    WeightDB weightDB = changeWeightObjDatatoDB(weight);
    return await db.delete('weight',
        where: 'weight = ? AND dateOfWeight = ?',
        whereArgs: [weightDB.weight, weightDB.dateOfWeight]);
  }
}

void removeChartData(int index) {
  //function to remove a specific WeightData object from chartData (index is the index on which you press on the listView on the weight page)
  chartData.sort((a, b) {
    var aDate = a.dateOfWeight;
    var bDate = b.dateOfWeight;
    return -aDate.compareTo(bDate);
  });
  DatabaseHelperWeight.weightInstance.remove(WeightData(
      chartData[index].timestamp,
      chartData[index].dateOfWeight,
      chartData[index].weight));
  chartData.removeAt(index);
}

void addChartItem(DateTime dateTime, double weight) {
  //function to add an WeightData element to chartData
  WeightData weightDataObject = WeightData(DateTime.now(), dateTime, weight);
  chartData.add(weightDataObject);
  DatabaseHelperWeight.weightInstance.add(weightDataObject);
  print("weight saved in DB");
}

List<WeightData> getChartData(
    bool week, bool month, bool year, bool max, bool graphOrListView) {
  //function to get specific data from the chartData list
  DatabaseHelperWeight.weightInstance.getWeight();

  var solutionList = chartData.map((v) => v).toList();
  if (graphOrListView) {
    //if there is more than one entry per day in the list, then there should be calculated the mean of all the entries for that day to show the mean in the graph
    var chartDataCopy = chartData.map((v) => v).toList();
    var fallingList = chartData.map((v) => v).toList();
    var meanWeightCalc = [];
    for (var element in chartDataCopy) {
      fallingList.remove(element);
      meanWeightCalc.add(element.weight);
      for (var fallElem in fallingList) {
        if (element.dateOfWeight.year == fallElem.dateOfWeight.year &&
            element.dateOfWeight.month == fallElem.dateOfWeight.month &&
            element.dateOfWeight.day == fallElem.dateOfWeight.day) {
          meanWeightCalc.add(fallElem.weight);
          solutionList.remove(fallElem);
        }
      }
      for (int x = 0; x < solutionList.length; x++) {
        if (solutionList[x] == element) {
          double meanWeight = 0;
          for (var e in meanWeightCalc) {
            meanWeight += e; //addition of all entered weights of one day
          }
          meanWeight /= meanWeightCalc.length; //calculation of the mean
          meanWeightCalc.clear();
          DateTime timeSaved = solutionList[x].timestamp;
          DateTime savedDate = solutionList[x].dateOfWeight;
          solutionList.removeAt(x);
          solutionList.add(WeightData(timeSaved, savedDate,
              meanWeight)); //solutionList contains only one element per day with the mean value
          break;
        }
      }
      meanWeightCalc.clear();
    }
  }

  solutionList.sort((a, b) {
    //this just sorts the solutionList by date
    var aDate = a.dateOfWeight;
    var bDate = b.dateOfWeight;
    if (graphOrListView) {
      //wheter you need the latest date at the bottom or at the top
      return aDate.compareTo(bDate);
    } else {
      return -aDate.compareTo(bDate);
    }
  });

  var now = new DateTime.now();
  if (week) {
    //returns the elements of the last week
    var sevenDaysBefore = DateTime(now.year, now.month, now.day - 8);
    List<WeightData> lastSevenDaysChartData = [];
    for (var element in solutionList) {
      if (element.dateOfWeight.isAfter(sevenDaysBefore)) {
        lastSevenDaysChartData.add(element);
      }
    }
    return lastSevenDaysChartData;
  }

  if (month) {
    //returns all elements of the last month
    var dateMonthBefore = DateTime(now.year, now.month - 1, now.day - 1);
    List<WeightData> lastMonthChartData = [];
    for (var element in solutionList) {
      if (element.dateOfWeight.isAfter(dateMonthBefore)) {
        lastMonthChartData.add(element);
      }
    }
    return lastMonthChartData;
  }

  if (year) {
    //returns all elements of the last year
    var dateYearBefore = DateTime(now.year - 1, now.month, now.day - 1);
    List<WeightData> lastYearChartData = [];
    for (var element in solutionList) {
      if (element.dateOfWeight.isAfter(dateYearBefore)) {
        lastYearChartData.add(element);
      }
    }
    return lastYearChartData;
  }

  return solutionList; //in case of max == true --> returns all elements of chartData
}
