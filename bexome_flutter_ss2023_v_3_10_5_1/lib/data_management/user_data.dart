import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class UserData {
  UserData(
      this.gender,
      this.age,
      this.streetNr,
      this.postalcode,
      this.town,
      this.workStreet,
      this.workPostalCode,
      this.workTown,
      this.studyID); //Konstruktor für die Klasse

  String? gender;
  String? age;
  String? streetNr;
  String? postalcode;
  String? town;
  String? workStreet;
  String? workPostalCode;
  String? workTown;
  String? studyID;
}

// Getter for the UserData
// UserData getUserdata() {
//   return usernow;
// }
UserData usernow =
    new UserData(null, null, null, null, null, null, null, null, null);

// Update the UserData used in the myaccount page
void updateUserData(
  String gender,
  String age,
  String streetNr,
  String postalcode,
  String town,
  String workStreet,
  String workPostalCode,
  String workTown,
) {
  //String? storedID = getStudyID();
  String storedID = "20";
  usernow = UserData(gender, age, streetNr, postalcode, town, workStreet,
      workPostalCode, workTown, storedID);
  DatabaseHelper.instance.getUser();
  DatabaseHelper.instance.remove();
  DatabaseHelper.instance.add(usernow);
  DatabaseHelper.instance.getUser();
}

UserData getCurrentUser() {
  DatabaseHelper.instance.getUser();
  return usernow;
}

void deleteCurrentUser(UserData user) {
  DatabaseHelper.instance.remove();
}

// get the studyID
getStudyID() {
  return usernow.studyID;
}

class UserDB {
  final String gender;
  final String age;
  final String streetNr;
  final String postalcode;
  final String town;
  final String workStreet;
  final String workPostalCode;
  final String workTown;
  final String studyID;
  UserDB(this.gender, this.age, this.streetNr, this.postalcode, this.town,
      this.workStreet, this.workPostalCode, this.workTown, this.studyID);

  factory UserDB.fromMap(Map<String, dynamic> json) => new UserDB(
      json['gender'],
      json['age'],
      json['streetNr'],
      json['postalcode'],
      json['town'],
      json['workStreet'],
      json['workPostalCode'],
      json['workTown'],
      json['studyID']);

  Map<String, dynamic> toMap() {
    return {
      'gender': gender,
      'age': age,
      'streetNr': streetNr,
      'postalcode': postalcode,
      'town': town,
      'workStreet': workStreet,
      'workPostalCode': workPostalCode,
      'workTown': workTown,
      'studyID': studyID,
    };
  }
}

//list with all entered entries -> one list object contains all the points of the FoodData class

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  UserDB changeUserObjDatatoDB(UserData user) {
    UserDB db = UserDB(
        user.gender!,
        user.age!,
        user.streetNr!,
        user.postalcode!,
        user.town!,
        user.workStreet!,
        user.workPostalCode!,
        user.workTown!,
        user.studyID!);
    return db;
  }

  UserData changeUserObjDBtoData(UserDB user) {
    UserData db = UserData(
        user.gender,
        user.age,
        user.streetNr,
        user.postalcode,
        user.town,
        user.workStreet,
        user.workPostalCode,
        user.workTown,
        user.studyID);
    return db;
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
      streetNr TEXT,
      postalcode TEXT,
      town TEXT,
      workStreet TEXT,
      workPostalCode TEXT,
      workTown TEXT,
      studyID TEXT)''');
  }

  Future<UserData> getUser() async {
    Database db = await instance.database;
    var users = await db.query('user');
    UserDB currUser;
    List<UserDB> userList =
        users.isNotEmpty ? users.map((e) => UserDB.fromMap(e)).toList() : [];
    if (userList.isNotEmpty)
      currUser = userList[userList.length - 1];
    else
      currUser = new UserDB("", "", "", "", "", "", "", "", "");

    usernow = changeUserObjDBtoData(currUser);
    return usernow;
  }

  Future<int> add(UserData user) async {
    Database db = await instance.database;
    UserDB userDB = changeUserObjDatatoDB(user);
    print("User added to DB");
    return await db.insert('user', userDB.toMap());
  }

  Future<int> remove() async {
    Database db = await instance.database;
    return await db.delete('user');
  }
}
