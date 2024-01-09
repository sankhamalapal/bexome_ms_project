import 'package:flutter/services.dart';

import 'Translation/translation.dart';
import 'dbhelper/food_db_helper.dart';
import 'specifyNutrition.dart';
import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate<String> {
  static String clickedFood = '';
  static String clickedFoodId = '';

  static bool clickedWater = false;
  static double calories = 0;
  static double protein = 0;
  static double fat = 0;
  static double carbohydrates = 0;
  final DateTime dateTime_food;
  static double portion = 100;
  static bool saved = false;
  bool gotDB = false;
  bool gotRecentFoodDB = false;

  Translation translate = Translation();

  DataSearch({Key? key, required this.dateTime_food});

  List foodListLowerCase = [];
  List foodList = [];

  @override
  List<Widget>? buildActions(BuildContext context) {
    //actions for searchbar
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // leading icon on the left of the searchbar

    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // show some result based on the selection of the user
    return SpecifyNutrition(
      foodId: clickedFoodId,
      food: clickedFood,
      water: clickedWater,
      cal: calories,
      prot: protein,
      foodTime: dateTime_food,
      fats: fat,
      carbohydrates: carbohydrates,
      port: portion,
      saved: saved,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // show when someone searches for something
    getDB();
    final suggestionList = query.isEmpty
        ? []
        : foodList
            .where((p) => p.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return suggestionList.isEmpty
        ? getEmpty(context)
        : ListView.builder(
            itemBuilder: (context, index) => ListTile(
                onTap: () {
                  void updateFood_Water() {
                    clickedFood = suggestionList[index];
                    clickedWater = false;
                  }

                  suggestionList[index].toLowerCase().contains("water") ||
                          suggestionList[index].toLowerCase().contains("wasser")
                      ? clickedWater = true
                      : updateFood_Water();

                  //get values from database-class
                  try {
                    clickedFoodId = (Food_db_helper
                        .foodMapMap[suggestionList[index]]["code"]);
                    calories = (Food_db_helper.foodMapMap[suggestionList[index]]
                            ["energy"])
                        .toDouble();
                    protein = (Food_db_helper.foodMapMap[suggestionList[index]]
                            ["proteins"])
                        .toDouble();
                    fat = (Food_db_helper.foodMapMap[suggestionList[index]]
                            ["fat"])
                        .toDouble();
                    carbohydrates = (Food_db_helper
                            .foodMapMap[suggestionList[index]]["carbohydrates"])
                        .toDouble();
                    saved = true;
                    portion = (Food_db_helper.foodMapMap[suggestionList[index]]
                            ["serving_quantity"])
                        .toDouble();
                  } catch (e) {
                    calories = 0;
                    protein = 0;
                    fat = 0;
                    carbohydrates = 0;
                    saved = false;
                  }

                  showResults(context);
                },
                leading: Icon(Icons.add),
                title: RichText(
                  text: TextSpan(
                      text: suggestionList[index].substring(0, query.length),
                      style: TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                            text: suggestionList[index].substring(query.length),
                            style: TextStyle(color: Colors.grey))
                      ]),
                )),
            itemCount: suggestionList.length,
          );
  }

  void getDB() {
    //read from database and get the names in right order and in lowercase
    var tmp = [];
    if (!gotDB) {
      readDBallSearching("").then((value) {
        for (var element in value) {
          tmp.add(element.toLowerCase());
        }

        tmp.sort((a, b) => a.length.compareTo(b.length));

        value.sort((a, b) => a.length.compareTo(b.length));
        Set distinctValue = value.toSet();
        foodList = distinctValue.toList();

        gotDB = true; //ensure to call it just once
      });
    }
  }

  Widget getEmpty(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 10,
        ),
        Text(translate.getTranslation(context, 'enter_food'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 20,
              color: Colors.grey,
            ))
      ],
    );
  }
}
