import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Food_db_helper {
  String written = '';
  static List names = [];

  static Map codefoodMapMap = {};
  static Map foodMapMap = {};
  static Map foodDetailsMap = {};

  Future init_DB() async {
    final dbPath = await getDatabasesPath();
    print(dbPath);
    final path = join(dbPath, "food_db_merged.db");

    /// db file name

    final exist = await databaseExists((path));

    if (exist) {
      //database already exist at the mobile device
      /// then you need to open the database

      print("food_db_merged alrady exists");

      ///for testing

      Database db = await openDatabase(path);
    } else {
      //database does not exist on the device
      /// create a new database and copy from assets/db

      print("creating a copy from assets/db");

      ///for testing

      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data =
          await rootBundle.load(join("assets", "food_db_merged.db"));

      /// check if db or assets oder assets/db
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await new File(path).writeAsBytes(bytes, flush: true);

      print("db succeffully copied");

      ///for testing
    }
    await openDatabase(path);
  }
}

Future<List> read_food_DB_all(String filterString) async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, "food_db_merged.db");
  Database db = await openDatabase(path);
  List<Map<String, Object?>> result = await db.query('foods_merged',
      columns: [
        'code',
        'product_name',
        'energy',
        'fat',
        'proteins',
        'carbohydrates',
        'fiber',
        'serving_quantity'
      ],
      where: "code LIKE '%$filterString%'");

  List onlyProductNamesList = [];

  result.forEach((element) {
    onlyProductNamesList.add(element["code"]);

    //foodMapMap is a Map where u can search after a name to get all the info related to the name
    Food_db_helper.codefoodMapMap[element["code"]] = {
      "code": element["code"],
      "product_name": element["product_name"],
      "energy": element["energy"],
      "proteins": element["proteins"],
      "carbohydrates": element["carbohydrates"],
      "fiber": element["fiber"],
      "fat": element["fat"],
      "serving_quantity": element["serving_quantity"]
    };
  });

  return onlyProductNamesList;
}

Future<List> read_food_details(String foodSelected) async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, "food_db_merged.db");
  Database db = await openDatabase(path);
  // Food_db_helper.recentfoodMap = {};

  List<Map<String, Object?>> result = await db.query('foods_merged',
      columns: [
        'code',
        'product_name',
        'energy',
        'fat',
        'proteins',
        'carbohydrates',
        'fiber',
        'serving_quantity'
      ],
      where: 'product_name=?',
      whereArgs: [foodSelected]);

  List onlySelectedProductNamesList = [];
  Food_db_helper.foodDetailsMap[result.first["product_name"]] = {
    "code": result.first["code"],
    "product_name": result.first["product_name"],
    "energy": result.first["energy"],
    "proteins": result.first["proteins"],
    "carbohydrates": result.first["carbohydrates"],
    "fiber": result.first["fiber"],
    "fat": result.first["fat"],
    "serving_quantity": result.first["serving_quantity"]
  };

  return onlySelectedProductNamesList;
}

Future<List> readDBallSearching(String filterString) async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, "food_db_merged.db");
  Database db = await openDatabase(path);
  List<Map<String, Object?>> result = await db.query('foods_merged',
      columns: [
        'code',
        'product_name',
        'energy',
        'fat',
        'proteins',
        'carbohydrates',
        'fiber',
        'serving_quantity'
      ],
      where: "product_name LIKE '%$filterString%'");

  List onlyProductNamesList = [];

  result.forEach((element) {
    onlyProductNamesList.add(element["product_name"]);

    //foodMapMap is a Map where u can search after a name to get all the info related to the name

    Food_db_helper.foodMapMap[element["product_name"]] = {
      "code": element["code"],
      "product_name": element["product_name"],
      "energy": element["energy"],
      "proteins": element["proteins"],
      "carbohydrates": element["carbohydrates"],
      "fiber": element["fiber"],
      "fat": element["fat"],
      "serving_quantity": element["serving_quantity"]
    };
  });

  return onlyProductNamesList;
}

Future<List> readDBFavFood() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, "food_db_merged.db");
  Database db = await openDatabase(path);
  List<Map<String, Object?>> result = await db.query(
    'foods_merged',
    columns: [
      'code',
      'product_name',
      'energy',
      'fat',
      'proteins',
      'carbohydrates',
      'fiber',
      'serving_quantity'
    ],
  );

  List onlyFavProductNamesList = [];

  result.forEach((element) {
    onlyFavProductNamesList.add(element["product_name"]);

    //foodMapMap is a Map where u can search after a name to get all the info related to the name

    Food_db_helper.foodMapMap[element["product_name"]] = {
      "code": element["code"],
      "product_name": element["product_name"],
      "energy": element["energy"],
      "proteins": element["proteins"],
      "carbohydrates": element["carbohydrates"],
      "fiber": element["fiber"],
      "fat": element["fat"],
      "serving_quantity": element["serving_quantity"]
    };
  });

  return onlyFavProductNamesList;
}
