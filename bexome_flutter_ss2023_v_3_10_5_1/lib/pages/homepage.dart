import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../QR_Scanner.dart';
import '../Translation/demo_localization.dart';
import '../Translation/languages.dart';
import '../Translation/translation.dart';
import '../data_management/health_data.dart';
import '../main.dart';
import '../dataToJson.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../addnutrition.dart';
import '../addweight.dart';
import '../colors.dart';
import 'package:flutter/material.dart';
import '../scaff.dart';

//import 'food.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<HomePage> {
  DataToJson dataToJson = DataToJson();
  double successReportWeight = 0;
  String dataSavedMessage = "";
  bool changedWeight = false;
  bool dataSaved = false;
  bool test = false;
  bool test2 = false;
  String waiter = "";
  Translation translate = Translation();

  void refresh() {
    setState(() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => RootApp()));
    });
  }

  void _changeLanguage(Languages languages) {
    refresh();
    print(languages.languageCode);
    Locale _temp;
    switch (languages.languageCode) {
      case 'en':
        _temp = Locale(languages.languageCode, 'en_US');
        break;
      case 'de':
        _temp = Locale(languages.languageCode, 'de_DE');
        break;
      default:
        _temp = Locale(languages.languageCode, 'de_DE');
    }
    MyApp.setLocale(context, _temp);
  }

  @override
  Widget build(BuildContext context) {
    dataToJson.getDB();
    //TODO: FitData
    // print(dataToJson.getAllFitData());

    print("Inside homepage.dart - build() ...");
    return Scaffold(
      body: getBody(),
    );
  }

  Widget getBody() {
    print("Inside homepage.dart - getBody() ...");
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
                        translate.getTranslation(context, 'welcome'),
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
                    alignment: Alignment.topRight,
                    child: DropdownButton(
                      underline: SizedBox(),
                      icon: Icon(
                        Icons.language,
                        color: black,
                      ),
                      items: Languages.languageList()
                          .map<DropdownMenuItem<Languages>>((lang) =>
                              DropdownMenuItem(
                                value: lang,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [Text(lang.flag), Text(lang.name)],
                                ),
                              ))
                          .toList(),
                      onChanged: (Languages? languages) {
                        _changeLanguage(languages!);
                      },
                    ),
                  ),
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
                child: Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          width: (size.width),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                translate.getTranslation(context, 'food'),
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: white),
                              ),
                              Text(
                                translate.getTranslation(context, 'add_food'),
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: white),
                              ),
                              Container(
                                width: 95,
                                height: 35,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(30),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(30)),
                        shape: BoxShape.rectangle,
                        gradient:
                            LinearGradient(colors: [fourthColor, thirdColor]),
                      ),
                      child: Center(
                          child: IconButton(
                              iconSize: 40,
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    settings: RouteSettings(name: "/add"),
                                    builder: (context) => AddNutrition(),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.add_circle_outline,
                                color: white,
                              ))),
                    )
                  ],
                ),
              ),

              SizedBox(
                height: 30,
              ),

              //Second category
              Container(
                width: double.infinity,
                height: 145,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(colors: [
                    secondary,
                    Colors.blueGrey.shade400.withOpacity(0.9)
                  ]),
                ),
                child: Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
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
                                translate.getTranslation(context, 'add_weight'),
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: white),
                              ),
                              Container(
                                width: 95,
                                height: 35,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(30),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(30)),
                        shape: BoxShape.rectangle,
                        gradient:
                            LinearGradient(colors: [fourthColor, thirdColor]),
                      ),
                      child: Center(
                          child: IconButton(
                              iconSize: 40,
                              onPressed: () async {
                                double newValue = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddWeight(),
                                    ));
                                setState(() {
                                  successReportWeight = newValue;
                                  changedWeight = true;
                                });
                              },
                              icon: Icon(
                                Icons.add_circle_outline,
                                color: white,
                              ))),
                    )
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Container(
                    height: changedWeight ? 50 : 0,
                    width: double.infinity,
                    child: AnimatedOpacity(
                        curve: Curves.easeInBack,
                        onEnd: () =>
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              setState(() {
                                changedWeight = false;
                              });
                            }),
                        duration: changedWeight
                            ? Duration(milliseconds: 4800)
                            : Duration(milliseconds: 0),
                        opacity: changedWeight ? 0 : 1,
                        child: Container(
                            width: MediaQuery.of(context).size.width - 60,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: LinearGradient(
                                    colors: [secondary, primary])),
                            child: Center(
                                child: Text(
                                    translate.getTranslation(
                                            context, 'weight_saved_part1') +
                                        '$successReportWeight' +
                                        translate.getTranslation(
                                            context, 'weight_saved_part2'),
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    )))))),
              ),

              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton.extended(
                          heroTag: 'qr_scan',
                          backgroundColor: fourthColor,
                          label: Text(
                              translate.getTranslation(context, 'qr_scan'),
                              style: TextStyle(color: Colors.white)),
                          icon: const Icon(Icons.qr_code_scanner),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => QR_Scanner()));
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton.extended(
                          heroTag: 'save_data',
                          backgroundColor: fourthColor,
                          label: Text(
                              translate.getTranslation(context, 'pause'),
                              style: TextStyle(color: Colors.white)),
                          icon: const Icon(Icons.pause_circle_outline),
                          onPressed: () async {
                            pause();
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Container(
                    height: dataSaved ? 50 : 0,
                    width: double.infinity,
                    child: AnimatedOpacity(
                        curve: Curves.easeInBack,
                        onEnd: () =>
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              setState(() {
                                dataSaved = false;
                              });
                            }),
                        duration: dataSaved
                            ? Duration(milliseconds: 4800)
                            : Duration(milliseconds: 0),
                        opacity: dataSaved ? 0 : 1,
                        child: Container(
                            width: MediaQuery.of(context).size.width - 60,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: LinearGradient(
                                    colors: [secondary, primary])),
                            child: Center(
                                child: Text(dataSavedMessage,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    )))))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void pause() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String pause = "";
    try {
      pause = join(documentDirectory.path, 'pause.txt');
    } catch (error) {
      print("no pause.txt file found");
    }
    var file = File(pause);
    var sink = file.openWrite();
    final now = DateTime.now();
    int time = (now.millisecondsSinceEpoch / 1000).round();
    sink.write('PAUSING TIMESTAMP:  ${time}\n');

    // Close the IOSink to free system resources.
    sink.close();
  }

  // void callIESlab() async {
  //   dataToJson.getDB();
  //   var str = jsonEncode(dataToJson.dbJson());
  //   print(str);
  //   // var response = await http.post(Uri.parse('https://cloud.ieslab.de/in/'),
  //   //     headers: <String, String>{
  //   //       'Content-Type': 'application/json; charset=UTF-8',
  //   //     },
  //   //     body: str);
  //   print("Message Sending...\n" + str);
  //   // print(response.body);
  //
  //   // setState(() {
  //   //   dataSaved = true;
  //   //   dataSavedMessage = response.body;
  //   // });
  // }

  String join(String path, String s) {
    return '$path/$s';
  }
}
