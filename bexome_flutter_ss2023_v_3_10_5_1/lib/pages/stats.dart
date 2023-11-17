import '../Translation/translation.dart';
import '../pages/waterintake.dart';
import '../secChart.dart';
import '../colors.dart';
import 'package:flutter/material.dart';
import '../pages/weight.dart';
import 'food.dart';
import '../data_management/food_data.dart';
import '../data_management/water_data.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({Key? key}) : super(key: key);
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  Translation translate = Translation();

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print("Inside stats.dart - build() ...");

    return Scaffold(
      body: getBody(),
    );
  }

  Widget getWaterIntakeText() {
    print("Inside stats.dart - getWaterIntakeText() ...");

    return Text(
      translate.getTranslation(context, 'water_info'),
      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: white),
    );
  }

  Widget getBody() {
    print("Inside stats.dart - getBody() ...");

    var size = MediaQuery.of(context).size; // get users display size
    return SingleChildScrollView(
      // A box in which a single widget (in this case the homepage) can be scrolled
      child: SafeArea(
        // widget that insets its child by sufficient padding to avoid intrusions by the operating system
        child: Padding(
          padding: const EdgeInsets.all(30), // manages distance to the edges
          child: Column(
            // 'main' column with the different widgets (welcoming and categories)
            crossAxisAlignment: CrossAxisAlignment
                .start, // every widget is forced to the left of the column
            children: [
              // welcoming
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translate.getTranslation(context, 'details'),
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: black),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                  Container(
                    width: 50,
                    height: 50,
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),

              // first category
              Container(
                width: double.infinity,
                height: 145,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(colors: [secondary, primary]),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Flexible(
                        child: Container(
                          width: (size.width),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                translate.getTranslation(context, 'water'),
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: white),
                              ),
                              getWaterIntakeText(),
                              Container(
                                width: 95,
                                height: 35,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [fourthColor, thirdColor]),
                                    borderRadius: BorderRadius.circular(20)),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WaterIntake(
                                                notifyParent: refresh,
                                              )),
                                    );
                                  },
                                  child: Center(
                                    child: Text(
                                      translate.getTranslation(
                                          context, 'more_info'),
                                      style:
                                          TextStyle(fontSize: 13, color: white),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient:
                              LinearGradient(colors: [fourthColor, thirdColor]),
                        ),
                        child: Center(
                          child: Text(
                            "${getWaterChartData(true, true, false, false, false, false)[0].milliLiters.toStringAsFixed(2)} L",
                            style: TextStyle(
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(0.3, 0.3),
                                    blurRadius: 1.0,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ],
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: 30,
              ),
              //second category
              Container(
                width: double.infinity,
                height: 145,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(colors: [secondary, primary]),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Flexible(
                        child: Container(
                          width: (size.width),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                translate.getTranslation(context, 'eat'),
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: white),
                              ),
                              Text(
                                translate.getTranslation(
                                    context, 'food_intake'),
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: white),
                              ),
                              Container(
                                width: 95,
                                height: 35,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [fourthColor, thirdColor]),
                                    borderRadius: BorderRadius.circular(20)),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Food(
                                                notifyParent: refresh,
                                              )),
                                    );
                                  },
                                  child: Center(
                                    child: Text(
                                      translate.getTranslation(
                                          context, 'more_info'),
                                      style:
                                          TextStyle(fontSize: 13, color: white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient:
                              LinearGradient(colors: [fourthColor, thirdColor]),
                        ),
                        child: Center(
                          child: Center(
                            child: Text(
                              "${getFoodChartData(true, true, false, DateTime(2000), false)[0].kcal.toStringAsFixed(0)} kcal",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(0.3, 0.3),
                                      blurRadius: 1.0,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ],
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: 30,
              ),

              //Third category
              Container(
                width: double.infinity,
                height: 145,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(colors: [secondary, primary]),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Flexible(
                        child: Container(
                          width: (size.width),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                translate.getTranslation(context, 'weight'),
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: white),
                              ),
                              Text(
                                translate.getTranslation(
                                    context, 'weight_info'),
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: white),
                              ),
                              Container(
                                width: 95,
                                height: 35,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [fourthColor, thirdColor]),
                                    borderRadius: BorderRadius.circular(20)),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Weight(
                                                notifyParent: refresh,
                                              )),
                                    );
                                  },
                                  child: Center(
                                    child: Text(
                                      translate.getTranslation(
                                          context, 'more_info'),
                                      style:
                                          TextStyle(fontSize: 13, color: white),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(child: SecChart.basic(false, true)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
