import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';

import 'Translation/demo_localization.dart';
import 'dataToJson.dart';
import 'dbhelper/food_db_helper.dart';
import 'package:flutter/material.dart';
import 'scaff.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;

void main() async {
  DataToJson dataToJson = DataToJson();

  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
  Food_db_helper db = new Food_db_helper();
  db.init_DB();
  dataToJson.getDB();
  //TODO: FitData
  dataToJson.getAllFitData();
  Directory documentDirectory = await getApplicationDocumentsDirectory();
  int lastPauseTimestamp = 0;
  String pause = "";
  try {
    pause = join(documentDirectory.path, 'DataSent.txt');
    File(pause).readAsString().then((String contents) {
      print(contents);
      int time = int.parse(contents.split(" ").last.toString());
      lastPauseTimestamp = time;
    });
  } catch (error) {
    print("Exception in reading the last timestamp: $error");
  }
  Future.delayed(Duration(minutes: 1), () async {
    print("Executed after 1 minutes");

    dataToJson.getDB();
    final now = DateTime.now();
    // final yesterday = now.subtract(Duration(hours: 24));

    int time = (now.millisecondsSinceEpoch / 1000).round();

    //pause button check
    if (lastPauseTimestamp == 0 || (time - lastPauseTimestamp) > 3600) {
      var str = jsonEncode(dataToJson.dbJson());

      var response = await http.post(Uri.parse('https://cloud.ieslab.de/in/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: str);
      print("Message Sending...\n" + str);
      print(response.body);

      print(str.toString());
      String path = join(documentDirectory.path, 'DataSent.txt');
      var file = File(path);
      var sink = file.openWrite();
      sink.write('LAST DATA SENT TO IES LAB AT TIMESTAMP:  ${time}\n');

      // Close the IOSink to free system resources.
      sink.close();

      File(path).readAsString().then((String contents) {
        print(contents);
      });
    }
  });
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLocale(locale);
  }
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Future.delayed(Duration(seconds: 5), () async {
    //   print("Executed after 1 minutes");
    //   Navigator.push(
    //       context, MaterialPageRoute(builder: (context) => RootApp()));
    // });
    return MaterialApp(
      debugShowCheckedModeBanner: false, // hide debug Banner
      title: 'Bexome',
      locale: _locale,
      home: RootApp(), // route to the homepage
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DemoLocalizations.delegate
      ],
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        for (var locale in supportedLocales) {
          if (locale.languageCode == deviceLocale!.languageCode &&
              locale.countryCode == deviceLocale!.countryCode) {
            return deviceLocale;
          }
        }
        return supportedLocales.first;
      },
      supportedLocales: [
        const Locale('de', 'de_DE'), // German
        const Locale('en', 'en_US'), // English
        // ... other locales the app supports
      ],
    );
  }
}
