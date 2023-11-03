import '../Translation/translation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../colors.dart';
import '../data_management/food_data.dart';
import '../scaff.dart';
import 'meals.dart';
import 'package:intl/intl.dart';

class Food extends StatefulWidget {
  final Function() notifyParent;

  Food({Key? key, required this.notifyParent}) : super(key: key);

  @override
  State<Food> createState() => _FoodState();
}

class _FoodState extends State<Food> {
  Translation translate = Translation();

  List months = [
    'Jan',
    'Feb',
    'Mär',
    'Apr',
    'Mai',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Okt',
    'Nov',
    'Dez'
  ];
  List monthsEN = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void refresh() {
    setState(() {});
  }

  double getXValues(FoodData foods, _) {
    //function returns the xValues for the graph (that the date is consistent with the graph, the value just gets bigger, if it is recently entered)
    DateTime startingDate = DateTime(2000, 1, 1);
    return (foods.dateOfFoodLog.difference(startingDate).inHours / 24)
        .round()
        .toDouble();
  }

  double currentMinMax(bool minOrMaxVisibleValue, String nutritionStr) {
    //function calculates a specific min and max value for the visibleMinimum and visibleMaximum of the SfCartesianChart, that it looks good
    //for nutritionStr have to be entered for example "Kalorien" or "Fette"
    var adjustedChartData =
        getFoodChartData(true, false, false, DateTime(2000), true);
    if (minOrMaxVisibleValue) {
      double minVisible = 600;
      for (var element in adjustedChartData) {
        double nutrition = 0;
        if (nutritionStr == "Protein") {
          nutrition = element.protein;
        } else if (nutritionStr == "Kalorien") {
          nutrition = element.kcal;
        } else if (nutritionStr == "Fette") {
          nutrition = element.fats;
        } else if (nutritionStr == "Kohlenhydrate") {
          nutrition = element.carbohydrates;
        }
        if (nutrition < minVisible) {
          minVisible = nutrition;
        }
      }
      return minVisible;
    } else {
      double maxVisible = 0;
      for (var element in adjustedChartData) {
        double nutrition = 0;
        if (nutritionStr == "Protein") {
          nutrition = element.protein;
        } else if (nutritionStr == "Kalorien") {
          nutrition = element.kcal;
        } else if (nutritionStr == "Fette") {
          nutrition = element.fats;
        } else if (nutritionStr == "Kohlenhydrate") {
          nutrition = element.carbohydrates;
        }
        if (nutrition > maxVisible) {
          maxVisible = nutrition;
        }
      }
      return maxVisible +
          (maxVisible - currentMinMax(true, nutritionStr)) * 0.1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(child: SafeArea(child: getBody())),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //to go to the meal page
          setState(() {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MealPage(
                        dateOfMeals: DateTime.now(),
                        notifyParent: refresh,
                      )),
            );
            widget.notifyParent();
          });
        },
        tooltip: translate.getTranslation(context, "view_meals_by_day"),
        backgroundColor: fourthColor,
        child: const Icon(Icons.food_bank_outlined, size: 33),
      ),
    );
  }

  Widget getBody() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                RootApp.instance.page = 1;
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RootApp()));
              },
              icon: Icon(Icons.arrow_back, color: black),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    translate.getTranslation(context, "nutrition_values"),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: black),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
              child: Container(
                  child: Text(
                      translate.getTranslation(context, "data_from_today"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: thirdColor))),
            ),
            Container(
              height: 80,
              child: SfCartesianChart(
                legend: Legend(isVisible: true),
                primaryXAxis: NumericAxis(
                  isVisible: false,
                ),
                primaryYAxis: NumericAxis(),
                series: <ChartSeries>[
                  BarSeries<FoodData, double>(
                    name: translate.getTranslation(context, "protein") + " [g]",
                    dataSource: getFoodChartData(
                        true, true, false, DateTime(2000), false),
                    xValueMapper: (FoodData data, _) => 1,
                    yValueMapper: (FoodData data, _) => data.protein,
                    //thats the width of the bar. since there is only one element per bar, it is set to 1

                    width: 1,
                    gradient: LinearGradient(colors: [secondary, primary]),
                  )
                ],
              ),
            ),
            Container(
              height: 80,
              child: SfCartesianChart(
                legend: Legend(isVisible: true),
                primaryXAxis: NumericAxis(
                  isVisible: false,
                ),
                primaryYAxis: NumericAxis(),
                series: <ChartSeries>[
                  BarSeries<FoodData, double>(
                    name: translate.getTranslation(context, "fat") + " [g]",
                    dataSource: getFoodChartData(
                        true, true, false, DateTime(2000), false),
                    xValueMapper: (FoodData data, _) => 1,
                    yValueMapper: (FoodData data, _) => data.fats,
                    width: 1,
                    gradient: LinearGradient(colors: [secondary, primary]),
                  )
                ],
              ),
            ),
            Container(
              height: 80,
              child: SfCartesianChart(
                legend: Legend(isVisible: true),
                primaryXAxis: NumericAxis(
                  isVisible: false,
                ),
                primaryYAxis: NumericAxis(),
                series: <ChartSeries>[
                  BarSeries<FoodData, double>(
                    name: translate.getTranslation(context, "carbohydrates") +
                        " [g]",
                    dataSource: getFoodChartData(
                        true, true, false, DateTime(2000), false),
                    xValueMapper: (FoodData data, _) => 1,
                    yValueMapper: (FoodData data, _) => data.carbohydrates,
                    width: 1,
                    gradient: LinearGradient(colors: [secondary, primary]),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
              child: Container(
                  child: Text(
                      translate.getTranslation(context, "data_from_7_days"),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: thirdColor,
                      ))),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
              child: SingleChildScrollView(
                  //horizontal listView with the 4 graphs for proteins, fats, carbohydrates and kcal
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: Container(
                          width: MediaQuery.of(context).size.width - 80,
                          height: 160,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [secondary, primary],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0.0, 8, 0.0, 0),
                            child: SfCartesianChart(
                                plotAreaBorderWidth: 0,
                                backgroundColor: Colors.transparent,
                                legend: Legend(
                                    isVisible: true,
                                    position: LegendPosition.bottom),
                                series: (<ChartSeries>[
                                  LineSeries<FoodData, double>(
                                      width: 5,
                                      name: translate.getTranslation(
                                          context, "protein"),
                                      color: Colors.grey.shade200,
                                      dataSource: getFoodChartData(true, false,
                                          false, DateTime(2000), true),
                                      xValueMapper: getXValues,
                                      yValueMapper: (FoodData foods, _) =>
                                          foods.protein,
                                      dataLabelSettings:
                                          DataLabelSettings(isVisible: false),
                                      enableTooltip: false),
                                ]),
                                primaryXAxis: NumericAxis(
                                    isVisible: false,
                                    edgeLabelPlacement:
                                        EdgeLabelPlacement.shift),
                                primaryYAxis: NumericAxis(
                                  isVisible: true,
                                  labelStyle: TextStyle(
                                    color: Colors.grey.shade100,
                                  ),
                                  visibleMinimum:
                                      currentMinMax(true, "Protein"),
                                  visibleMaximum:
                                      currentMinMax(false, "Protein"),
                                  labelFormat: "{value} g",
                                  numberFormat: NumberFormat.compact(),
                                )),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Container(
                          width: MediaQuery.of(context).size.width - 80,
                          height: 160,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [secondary, primary],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0.0, 8, 0.0, 0),
                            child: SfCartesianChart(
                                plotAreaBorderWidth: 0,
                                backgroundColor: Colors.transparent,
                                legend: Legend(
                                    isVisible: true,
                                    position: LegendPosition.bottom),
                                series: (<ChartSeries>[
                                  LineSeries<FoodData, double>(
                                      width: 5,
                                      name: translate.getTranslation(
                                          context, "fat"),
                                      color: Colors.grey.shade200,
                                      dataSource: getFoodChartData(true, false,
                                          false, DateTime(2000), true),
                                      xValueMapper: getXValues,
                                      yValueMapper: (FoodData foods, _) =>
                                          foods.fats,
                                      dataLabelSettings:
                                          DataLabelSettings(isVisible: false),
                                      enableTooltip: false),
                                ]),
                                primaryXAxis: NumericAxis(
                                    isVisible: false,
                                    edgeLabelPlacement:
                                        EdgeLabelPlacement.shift),
                                primaryYAxis: NumericAxis(
                                  isVisible: true,
                                  labelStyle: TextStyle(
                                    color: Colors.grey.shade100,
                                  ),
                                  visibleMinimum: currentMinMax(true, "Fette"),
                                  visibleMaximum: currentMinMax(false, "Fette"),
                                  labelFormat: "{value} g",
                                  numberFormat: NumberFormat.compact(),
                                )),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Container(
                          width: MediaQuery.of(context).size.width - 80,
                          height: 160,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [secondary, primary],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0.0, 8, 0.0, 0),
                            child: SfCartesianChart(
                                plotAreaBorderWidth: 0,
                                backgroundColor: Colors.transparent,
                                legend: Legend(
                                    isVisible: true,
                                    position: LegendPosition.bottom),
                                series: (<ChartSeries>[
                                  LineSeries<FoodData, double>(
                                      width: 5,
                                      name: translate.getTranslation(
                                          context, "carbohydrates"),
                                      color: Colors.grey.shade200,
                                      dataSource: getFoodChartData(true, false,
                                          false, DateTime(2000), true),
                                      xValueMapper: getXValues,
                                      yValueMapper: (FoodData foods, _) =>
                                          foods.carbohydrates,
                                      dataLabelSettings:
                                          DataLabelSettings(isVisible: false),
                                      enableTooltip: false),
                                ]),
                                primaryXAxis: NumericAxis(
                                    isVisible: false,
                                    edgeLabelPlacement:
                                        EdgeLabelPlacement.shift),
                                primaryYAxis: NumericAxis(
                                  isVisible: true,
                                  labelStyle: TextStyle(
                                    color: Colors.grey.shade100,
                                  ),
                                  visibleMinimum:
                                      currentMinMax(true, "Kohlenhydrate"),
                                  visibleMaximum:
                                      currentMinMax(false, "Kohlenhydrate"),
                                  labelFormat: "{value} g",
                                  numberFormat: NumberFormat.compact(),
                                )),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Container(
                          width: MediaQuery.of(context).size.width - 80,
                          height: 160,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [secondary, primary],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0.0, 8, 0.0, 0),
                            child: SfCartesianChart(
                                plotAreaBorderWidth: 0,
                                backgroundColor: Colors.transparent,
                                legend: Legend(
                                    isVisible: true,
                                    position: LegendPosition.bottom),
                                series: (<ChartSeries>[
                                  LineSeries<FoodData, double>(
                                      width: 5,
                                      name: translate.getTranslation(
                                              context, "calories") +
                                          " [kcal]",
                                      color: Colors.grey.shade200,
                                      dataSource: getFoodChartData(true, false,
                                          false, DateTime(2000), true),
                                      xValueMapper: getXValues,
                                      yValueMapper: (FoodData foods, _) =>
                                          foods.kcal,
                                      dataLabelSettings:
                                          DataLabelSettings(isVisible: false),
                                      enableTooltip: false),
                                ]),
                                primaryXAxis: NumericAxis(
                                    isVisible: false,
                                    edgeLabelPlacement:
                                        EdgeLabelPlacement.shift),
                                primaryYAxis: NumericAxis(
                                  isVisible: true,
                                  labelStyle: TextStyle(
                                    color: Colors.grey.shade100,
                                  ),
                                  visibleMinimum:
                                      currentMinMax(true, "Kalorien"),
                                  visibleMaximum:
                                      currentMinMax(false, "Kalorien"),
                                  labelFormat: "{value}",
                                  numberFormat: NumberFormat.compact(),
                                )),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
              child: Container(
                  child: Text(
                      translate.getTranslation(context, "total_calories"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: thirdColor))),
            ),
            getFoodChartData(
                        //if there is no entry yet --> show that there are no entries yet, otherwise show all entries:
                        true,
                        false,
                        false,
                        DateTime(2000),
                        false)
                    .isEmpty
                ? Container(
                    height: 50,
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
                        width: 10,
                      ),
                      Icon(Icons.info_outline, size: 18),
                      SizedBox(
                        width: 11,
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width - 60 - 41,
                          child: Text(
                            translate.getTranslation(context, "no_entries"),
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          )),
                    ]))
                : SizedBox(
                    height: 350,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: getFoodChartData(
                                true, false, false, DateTime(2000), false)
                            .length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ListTile(
                              dense: true,
                              leading: Icon(
                                Icons.food_bank_outlined,
                                color: thirdColor,
                              ),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      '${getFoodChartData(true, false, false, DateTime(2000), false)[index].dateOfFoodLog.day}. ${((translate.getTranslation(context, "lang") == "DE") ? months : monthsEN)[getFoodChartData(true, false, false, DateTime(2000), false)[index].dateOfFoodLog.month - 1]} ${getFoodChartData(true, false, false, DateTime(2000), false)[index].dateOfFoodLog.year}'),
                                  Text(
                                      '${getFoodChartData(true, false, false, DateTime(2000), false)[index].kcal.toStringAsFixed(0)} kcal')
                                ],
                              ),
                              trailing: IconButton(
                                  icon: Icon(Icons.info_outline),
                                  color: thirdColor,
                                  onPressed: () {
                                    setState(() {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MealPage(
                                                dateOfMeals: getFoodChartData(
                                                        true,
                                                        false,
                                                        false,
                                                        DateTime(2000),
                                                        false)[index]
                                                    .dateOfFoodLog,
                                                notifyParent: refresh)),
                                      );
                                      widget.notifyParent();
                                    });
                                  }),
                            ),
                          );
                        })),
          ],
        ),
      ),
    );
  }
}
