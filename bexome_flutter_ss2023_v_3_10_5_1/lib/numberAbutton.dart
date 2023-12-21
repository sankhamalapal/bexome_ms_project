import 'Translation/translation.dart';
import 'colors.dart';
import 'package:flutter/material.dart';
import 'data_management/food_data.dart';
import 'data_management/water_data.dart';

class NumberInputWithIncrementDecrement extends StatefulWidget {
  final double portion;
  final String food;
  final String foodId;
  final bool water;
  final double prot;
  final double cal;
  final DateTime foodTime;
  final double fats;
  final double carbohydrates;
  final bool saved;

  NumberInputWithIncrementDecrement(
      {Key? key,
      required this.foodId,
      required this.food,
      required this.water,
      required this.cal,
      required this.prot,
      required this.foodTime,
      required this.fats,
      required this.carbohydrates,
      required this.portion,
      required this.saved});

  @override
  _NumberInputWithIncrementDecrementState createState() =>
      _NumberInputWithIncrementDecrementState();
}

class _NumberInputWithIncrementDecrementState
    extends State<NumberInputWithIncrementDecrement> {
  TextEditingController _controller = TextEditingController();
  String selectedNutrition = "";
  double amountOfNutrition = 100;
  late double amountOfNutritionOld;
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
  IconData fav = Icons.favorite_border;
  bool isFav = false;

  @override
  void initState() {
    super.initState();
    //get values from outside of the Stateclass (widget.)
    foodName = widget.food;
    foodId = widget.foodId;
    water = widget.water;
    prot = widget.prot;
    cal = widget.cal;
    foodTime = widget.foodTime;
    selectedNutrition = widget.water ? "Wasser" : widget.food;
    fats = widget.fats;
    carbohydrats = widget.carbohydrates;
    port = widget.portion;
    saved = widget.saved;
    amountOfNutritionOld = port;

    _controller.text =
        "${widget.portion.toInt()}"; // Setting the initial value for the field.
  }

  void updateChartData(String input) {
    String textWithoutComma =
        input.replaceAll(",", "."); //so input with , works

    //validate input
    if (textWithoutComma[0] == '.' ||
        '.'.allMatches(textWithoutComma).length > 1 ||
        textWithoutComma.contains(RegExp(r'[A-Z]')) ||
        textWithoutComma.contains(RegExp(r'[a-z]'))) {
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
      try {
        amountOfNutrition =
            double.parse(textWithoutComma) ?? amountOfNutritionOld;

        cal = cal / amountOfNutritionOld * amountOfNutrition;
        prot = prot / amountOfNutritionOld * amountOfNutrition;
        fats = fats / amountOfNutritionOld * amountOfNutrition;
        carbohydrats = carbohydrats / amountOfNutritionOld * amountOfNutrition;
        amountOfNutritionOld = amountOfNutrition;
      } catch (e) {
        print(e);
      }
    });
  }

  void savingData() {
    amountOfNutrition = amountOfNutritionOld;
    setState(() {
      try {
        water
            ? addWaterChartItem(foodTime, amountOfNutrition)
            : addFoodChartItem(foodId, foodTime, amountOfNutrition, cal, prot,
                selectedNutrition, fats, carbohydrats, isFav ? 1 : 0);
        saved = true;
        Navigator.popUntil(context, (route) => route.settings.name == "/add");
      } catch (e) {
        print(e);
      }
    });
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return fourthColor;
    }
    return thirdColor;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
            child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.blueGrey.shade50,
                        Colors.grey.shade100.withOpacity(0.6)
                      ],
                    ),
                    border: Border.all(color: Colors.grey.withOpacity(0.1)),
                    borderRadius: BorderRadius.all(Radius.circular(11))),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          width: 150,
                          child: Text(
                              translate.getTranslation(
                                  context, 'selected_food'),
                              style: TextStyle(fontSize: 15)),
                        ),
                      ),
                      Expanded(
                        child: Container(
                            width: MediaQuery.of(context).size.width - 60 - 150,
                            child: Text("${selectedNutrition}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15))),
                      ),
                      Expanded(
                          // Favorite
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                              flex: 2,
                              child: Text(translate.getTranslation(
                                  context, 'favorite'))),
                          Expanded(
                            flex: 1,
                            child: Checkbox(
                              checkColor: Colors.white,
                              fillColor:
                                  MaterialStateProperty.resolveWith(getColor),
                              value: isFav,
                              onChanged: (bool? value) {
                                setState(() {
                                  isFav = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),
                ))),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 25,
                ),
                Text(
                  translate.getTranslation(context, 'enter_amount'),
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: black),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
            SizedBox(
              width: 50,
              height: 50,
            )
          ],
        ),
        Container(
          height: 1,
          color: Colors.grey.withOpacity(0.5),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: Container(
              height: 60,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.blueGrey.shade50,
                      Colors.grey.shade100.withOpacity(0.6),
                    ],
                  ),
                  border: Border.all(color: Colors.grey.withOpacity(0.1)),
                  borderRadius: BorderRadius.all(Radius.circular(11))),
              child: Row(children: [
                SizedBox(
                  width: 5,
                ),
                Icon(Icons.info_outline, size: 18),
                SizedBox(
                  width: 11,
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width - 60 - 70,
                    child: Text(
                      translate.getTranslation(context, 'state_amount'),
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    )),
              ])),
        ),
        Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: TextFormField(
                onFieldSubmitted: updateChartData,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: translate.getTranslation(context, 'amount'),
                  labelText: translate.getTranslation(context, 'enter_amount'),
                  icon: Icon(
                    Icons.scale_rounded,
                    color: Colors.blueGrey.shade600,
                  ),
                  contentPadding: EdgeInsets.all(15.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                controller: _controller,
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                  signed: false,
                ),
              ),
            ),
            Container(
              height: 55.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 0.5, color: primary),
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_drop_up,
                          size: 25.0,
                        ),
                      ),
                      onTap: () {
                        //set intervalls for button-up
                        int currentValue = int.parse(_controller.text);
                        setState(() {
                          if (currentValue >= 0 && currentValue < 50) {
                            currentValue = currentValue + 5;
                          } else if (currentValue >= 50 && currentValue < 100)
                            currentValue = currentValue + 10;
                          else if (currentValue >= 100 && currentValue < 200)
                            currentValue = currentValue + 20;
                          else if (currentValue >= 200 && currentValue < 500)
                            currentValue = currentValue + 50;
                          else if (currentValue >= 500)
                            currentValue = currentValue + 100;

                          _controller.text = (currentValue).toString();
                          updateChartData(_controller.text);
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 3),
                  InkWell(
                    child: Icon(
                      Icons.arrow_drop_down,
                      size: 25.0,
                    ),
                    onTap: () {
                      int currentValue = int.parse(_controller.text);
                      setState(() {
                        //set intervalls for button-down
                        if (currentValue >= 0 && currentValue < 50)
                          currentValue = currentValue - 5;
                        else if (currentValue >= 50 && currentValue <= 100)
                          currentValue = currentValue - 10;
                        else if (currentValue > 100 && currentValue <= 200)
                          currentValue = currentValue - 20;
                        else if (currentValue > 200 && currentValue <= 500)
                          currentValue = currentValue - 50;
                        else if (currentValue >= 500)
                          currentValue = currentValue - 100;
                        _controller.text = (currentValue > 0
                                ? currentValue
                                : 0) //no negative value possible
                            .toString();
                        updateChartData(_controller.text);
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            savingData();
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
            child: Center(
              child: Text(translate.getTranslation(context, 'save'),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
          style: ElevatedButton.styleFrom(
              backgroundColor: thirdColor,
              fixedSize:
                  Size.fromWidth(MediaQuery.of(context).size.width - 60)),
          // style: ButtonStyle(
          //   backgroundColor: MaterialStateProperty.all<Color>(thirdColor),
          // ),
        ),
      ],
    );
  }
}
