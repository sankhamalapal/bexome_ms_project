import 'Translation/translation.dart';
import 'barcodeScanner.dart';
import 'dbhelper/food_db_helper.dart';
import 'foodSearching.dart';
import 'data_management/food_data.dart';
import 'scaff.dart';
import 'specifyNutrition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'colors.dart';
import 'data_management/weight_data.dart';

class AddNutrition extends StatefulWidget {
  const AddNutrition({Key? key}) : super(key: key);

  @override
  State<AddNutrition> createState() => _AddNutritionState();
}

class _AddNutritionState extends State<AddNutrition> {
  static String clickedFood = '';
  String foodSaved = "";
  static String foodId = '';
  static double calories = 0;
  static double protein = 0;
  static double fat = 0;
  static double carbohydrates = 0;
  static double portion = 100;
  static bool saved = false;
  late double userWeight;
  DateTime dateTime = DateTime.now();
  late TextEditingController controller;
  Translation translate = Translation();
  bool gotRecentFoodDB = false;
  List foodRecentList = [];
  bool gotFavFoodDB = false;
  List foodFavList = [];
  bool visible = false;
  static Map favfoodDetailsMap = {};
  static Map recentfoodDetailsMap = {};

  final List<bool> _selectedMeals = <bool>[true, false];
  static const List<Widget> mealsEN = <Widget>[
    Padding(
      padding: EdgeInsets.all(10.0),
      child: Text('Favorite dishes'),
    ),
    Padding(
      padding: EdgeInsets.all(10.0),
      child: Text('Recent dishes'),
    ),
  ];
  static const List<Widget> mealsDE = <Widget>[
    Padding(
      padding: EdgeInsets.all(10.0),
      child: Text('Lieblingsgerichte'),
    ),
    Padding(
      padding: EdgeInsets.all(10.0),
      child: Text('Letzte Speisen'),
    ),
  ];
  int indexMeal = 0;
  bool getlistfromDB = true;

  @override
  void initState() {
    super.initState();
    getlistfromDB = true;
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    getlistfromDB = false;
    super.dispose();
  }

  void updateChartData(String input) {
    String textWithoutComma = input.replaceAll(",", ".");
    //so it also works if you enter a comma instead of a point
    if (textWithoutComma[0] == '.' ||
        '.'.allMatches(textWithoutComma).length > 1) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(translate.getTranslation(context, 'error')),
            actions: <Widget>[
              new TextButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    setState(() {
      getlistfromDB = true;
      userWeight = double.parse(textWithoutComma);
      addChartItem(dateTime, userWeight);
    });
    Navigator.of(context).pop(userWeight);
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: getBody());
  }

  Widget getBody() {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RootApp()));
              },
              icon: Icon(Icons.arrow_back, color: black),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    translate.getTranslation(context, 'set_meal_time'),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: black),
                  ),
                  getTime(),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    translate.getTranslation(context, 'find_your_meal'),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: black),
                  ),
                  // Text(translate.getTranslation(context, 'quick_meal'),
                  //     style: TextStyle(fontWeight: FontWeight.w400)),
                  getSearchbar(),
                  SizedBox(
                    height: 10,
                  ),
                  getListView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getSearchbar() {
    return // Generated code for this Container Widget...
        Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: () async {
                showSearch(
                    context: context,
                    delegate: DataSearch(dateTime_food: dateTime));
              },
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  // width: 290,
                  // height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      //mainAxisSize: MainAxisSize.max,

                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              showSearch(
                                  context: context,
                                  delegate:
                                      DataSearch(dateTime_food: dateTime));
                            },
                            child: Icon(
                              Icons.search,
                              size: 24,
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 8,
                            child: Text(translate.getTranslation(
                                context, 'find_food'))),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: FloatingActionButton(
              onPressed: () {
                //if you want to use the barcode scan instead of the textfield to enter a new meal
                //read_barcode_DBall("");
                read_food_DB_all("");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BarcodeScanner(
                              dateTime_food: dateTime,
                            )));
              },
              backgroundColor: primary,
              child: const Icon(Icons
                  .document_scanner_outlined), //Icons.document_scanner_outlined
            ),
          ),
        ],
      ),
    );
  }

  Widget getTime() {
    return // Generated code for this Container Widget...
        SingleChildScrollView(
            child: Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 45),
        child: SizedBox(
            height: 180,
            //date picker to enter the date, when you have eaten your meal
            child: CupertinoDatePicker(
              use24hFormat: true,
              minimumDate: DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day - 30),
              maximumDate: DateTime.now(),
              initialDateTime: dateTime,
              mode: CupertinoDatePickerMode.dateAndTime,
              onDateTimeChanged: (DateTime value) {
                setState(() {
                  dateTime = value;
                });
              },
            )),
      ),
    ]));
  }

  Widget getListView() {
    return Column(
      children: [
        Container(
            alignment: Alignment.topLeft,
            child: ToggleButtons(
              // direction: vertical ? Axis.vertical : Axis.horizontal,
              onPressed: (int index) {
                setState(() {
                  indexMeal = index;
                  // The button that is tapped is set to true, and the others to false.
                  for (int i = 0; i < _selectedMeals.length; i++) {
                    _selectedMeals[i] = i == index;
                  }
                });
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              selectedBorderColor: thirdColor,
              selectedColor: white,
              fillColor: thirdColor,
              color: black,
              constraints: const BoxConstraints(
                minHeight: 40.0,
                minWidth: double.minPositive,
              ),
              isSelected: _selectedMeals,
              children: (translate.getTranslation(context, 'lang') == "EN")
                  ? mealsEN
                  : mealsDE,
            )),
        Padding(
          padding: EdgeInsets.zero,
          child: Container(
            margin: EdgeInsets.all(10),
            alignment: Alignment.topLeft,
            height: 200,
            width: double.maxFinite,
            child: getList(indexMeal),
            decoration: BoxDecoration(
                color: fourthColor, borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    ); // Generated code for this Container Widget...
  }

  void getRecentFoodDB() {
    //read from database and get the names in right order and in lowercase
    var tmp = [];

    DatabaseHelper.instance.getRecentFood().then((value) {
      for (var element in value) {
        tmp.add(element);
      }
      if (mounted) {
        setState(() {
          foodRecentList = tmp;
        });
      }
      //ensure to call it just once
    });
  }

  void getFavFoodDB() {
    //read from database and get the names in right order and in lowercase
    var tmp = [];

    DatabaseHelper.instance.getFavFood().then((value) {
      for (var element in value) {
        tmp.add(element);
      }
      if (mounted) {
        setState(() {
          foodFavList = tmp;
        });
      }
    });
  }

  Widget getList(int index) {
    if (getlistfromDB) {
      if (index == 0) {
        getFavFoodDB();

        for (var food in foodFavList) {
          if (!favfoodDetailsMap.keys.contains(food)) {
            read_food_details(food);
            favfoodDetailsMap.addAll(Food_db_helper.foodDetailsMap);
          }
        }
        return getMealList(foodFavList, index);
      } else {
        getRecentFoodDB();
        for (var food in foodRecentList) {
          if (!favfoodDetailsMap.keys.contains(food)) {
            read_food_details(food);
            recentfoodDetailsMap.addAll(Food_db_helper.foodDetailsMap);
          }
        }

        return getMealList(foodRecentList, index);
      }
    }
    return Container();
  }

  ListView getMealList(List foodList, int index) {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      // Let the ListView know how many items it needs to build.
      itemCount: foodList.length,
      itemBuilder: (context, index) {
        return SizedBox(
          height: 50,
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(),
            title: ElevatedButton(
              style: TextButton.styleFrom(
                backgroundColor: thirdColor,
                alignment: Alignment.centerLeft,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 15),
              ),
              child: Text(foodList[index]),
              onPressed: () {
                foodList[index] = foodList[index].toLowerCase();

                if (index == 0) {
                  Food_db_helper.foodDetailsMap.addAll(favfoodDetailsMap);
                } else {
                  Food_db_helper.foodDetailsMap.addAll(recentfoodDetailsMap);
                }
                clickedFood = foodList[index];
                foodSaved = clickedFood;
                if (Food_db_helper.foodDetailsMap.keys.contains(clickedFood)) {
                  foodId =
                      (Food_db_helper.foodDetailsMap[foodList[index]]["code"]);
                  calories = (Food_db_helper.foodDetailsMap[foodList[index]]
                          ["energy"])
                      .toDouble();
                  protein = (Food_db_helper.foodDetailsMap[foodList[index]]
                          ["proteins"])
                      .toDouble();
                  fat = (Food_db_helper.foodDetailsMap[foodList[index]]["fat"])
                      .toDouble();
                  carbohydrates = (Food_db_helper
                          .foodDetailsMap[foodList[index]]["carbohydrates"])
                      .toDouble();

                  saved = true;
                  portion = (Food_db_helper.foodDetailsMap[foodList[index]]
                          ["serving_quantity"])
                      .toDouble();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SpecifyNutrition(
                        foodId: foodId,
                        food: clickedFood,
                        water: false,
                        cal: calories,
                        prot: protein,
                        foodTime: dateTime,
                        fats: fat,
                        carbohydrates: carbohydrates,
                        port: portion,
                        saved: saved,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
