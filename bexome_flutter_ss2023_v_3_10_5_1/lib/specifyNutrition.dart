import 'Translation/translation.dart';
import 'addnutrition.dart';
import 'scaff.dart';
import 'package:flutter/material.dart';
import 'colors.dart';
import 'data_management/food_data.dart';
import 'data_management/water_data.dart';
import 'numberAbutton.dart';

class SpecifyNutrition extends StatefulWidget {
  final String foodId;
  final String food;
  final bool water;
  final double prot;
  final double cal;
  final DateTime foodTime;
  final double fats;
  final double carbohydrates;
  final double port;
  final bool saved;

  SpecifyNutrition({
    Key? key,
    required this.foodId,
    required this.food,
    required this.water,
    required this.cal,
    required this.prot,
    required this.foodTime,
    required this.fats,
    required this.carbohydrates,
    required this.port,
    required this.saved,
  });

  @override
  State<SpecifyNutrition> createState() => _SpecifyNutritionState();
}

class _SpecifyNutritionState extends State<SpecifyNutrition> {
  String selectedNutrition = "";
  double amountOfNutrition = 100;
  late TextEditingController controller;
  Translation translate = Translation();

  bool water = false;
  double prot = 0;
  double cal = 0;
  DateTime foodTime = DateTime.now();
  String foodName = '';
  String foodId = '';
  double carbohydrats = 0;
  double fats = 0;
  double port = 0;
  bool saved = false;

  @override
  void initState() {
    super.initState();
    //get values from outside of the Stateclass (widget.)
    foodId = widget.foodId;
    foodName = widget.food;
    water = widget.water;
    prot = widget.prot;
    cal = widget.cal;
    foodTime = widget.foodTime;
    selectedNutrition = widget.water ? "Wasser" : widget.food;
    fats = widget.fats;
    carbohydrats = widget.carbohydrates;
    port = widget.port;
    saved = widget.saved;
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: getBody());
  }

  Widget getBody() {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddNutrition()));
                    },
                    icon: Icon(Icons.arrow_back, color: black),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                                translate.getTranslation(context, 'Info_title'),
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            // title: new Text(
                            //     "Nutrition facts: \n\nApple - one raw, unpeeled, medium-sized apple (100 grams): Calories: 52 \n\nMilk Chocolate - 1 serving 5 pieces (44 grams): Calories: 230"),
                            actions: <Widget>[
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      translate.getTranslation(
                                          context, 'fruits_veggie'),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: fourthColor),
                                    ),
                                    SizedBox(
                                      height: 50,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: new Image.asset(
                                              'assets/apple.png',
                                              // width: 50,
                                              // height: 50,
                                              fit: BoxFit.scaleDown,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: new Text(
                                                translate.getTranslation(
                                                    context,
                                                    'fruits_veggie_fact'),
                                                style: TextStyle(
                                                    color: thirdColor,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      translate.getTranslation(
                                          context, 'sweets'),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: fourthColor),
                                    ),
                                    SizedBox(
                                      height: 50,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: new Image.asset(
                                              'assets/chocolate.png',
                                              // width: 50,
                                              // height: 50,
                                              fit: BoxFit.scaleDown,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: new Text(
                                                translate.getTranslation(
                                                    context, 'sweets_fact'),
                                                style: TextStyle(
                                                    color: thirdColor,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      translate.getTranslation(context, 'Meat'),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: fourthColor),
                                    ),
                                    SizedBox(
                                      height: 50,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: new Image.asset(
                                              'assets/meat.png',
                                              // width: 50,
                                              // height: 50,
                                              fit: BoxFit.scaleDown,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: new Text(
                                                translate.getTranslation(
                                                    context, 'Meat_fact'),
                                                style: TextStyle(
                                                    color: thirdColor,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      translate.getTranslation(
                                          context, 'fast_food'),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: fourthColor),
                                    ),
                                    SizedBox(
                                      height: 50,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: new Image.asset(
                                              'assets/pizza.png',
                                              // width: 50,
                                              // height: 50,
                                              fit: BoxFit.scaleDown,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: new Text(
                                                translate.getTranslation(
                                                    context, 'fast_food_fact'),
                                                style: TextStyle(
                                                    color: thirdColor,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
                    },
                    icon: Icon(Icons.info, color: black),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: NumberInputWithIncrementDecrement(
                  foodId: foodId,
                  portion: port,
                  water: water,
                  food: foodName,
                  foodTime: foodTime,
                  cal: cal,
                  carbohydrates: carbohydrats,
                  fats: fats,
                  prot: prot,
                  saved: saved,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
