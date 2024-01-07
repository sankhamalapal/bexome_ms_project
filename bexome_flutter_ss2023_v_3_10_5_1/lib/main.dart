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
  WidgetsFlutterBinding.ensureInitialized();

  DataToJson dataToJson = DataToJson();
  Directory documentDirectory = await getApplicationDocumentsDirectory();
  print("started");
  String pathTime = join(documentDirectory.path, 'time.json');
  List<int> timestamp = [];
  List<String> description = [];
  print(pathTime);

  var fileTime = File(pathTime);
  var sinkTime = fileTime.openWrite();
  final startTimeUTC = DateTime.now().toUtc();
  int startTime = (startTimeUTC.millisecondsSinceEpoch / 1000).round();
  timestamp.add(startTime);
  description.add("OPEN".toString());
  Map<String, dynamic> timesaved = {
    "timestamp": timestamp,
    "description": description
  };
  String jsonString = jsonEncode(timesaved);
  print(jsonString);
  sinkTime.write(jsonString);
  sinkTime.close();

  runApp(MyApp());

  Food_db_helper db = new Food_db_helper();
  db.init_DB();
  dataToJson.getDB();
  //TODO: FitData
  //dataToJson.getAllFitData();
  int lastPauseTimestamp = 0;
  String pause = "";
  try {
    pause = join(documentDirectory.path, 'DataSent.txt');
    File file = File(pause);

    if (file.existsSync()) {
      print('The file $pause exists.');
      File(pause).readAsString().then((String contents) {
        print(contents);
        int time = int.parse(contents.split(" ").last.toString());
        lastPauseTimestamp = time;
      });
    } else {
      print('The file $pause does not exist.');
    }
  } catch (error) {
    print("Exception in reading the last timestamp: $error");
  }
  Future.delayed(Duration(minutes: 1), () async {
    print("Executed after 1 minutes");

    dataToJson.getDB();
    final now = DateTime.now().toUtc();
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
      if (response.statusCode != 200) {
        print("Message not send...\n body =" + str);
        print("StatusCode: " +
            response.statusCode.toString() +
            "  Reason Phrase :" +
            response.reasonPhrase.toString() +
            "\n");
      } else {
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

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // This widget is the root of your application.
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      String pathTime = join(documentDirectory.path, 'time.json');
      String fileContent = await File(pathTime).readAsString();
      Map<String, dynamic> timesaved = jsonDecode(fileContent);

      var fileTime = File(pathTime);
      var sinkTime = fileTime.openWrite();
      final closeTimeUTC = DateTime.now().toUtc();
      int closeTime = (closeTimeUTC.millisecondsSinceEpoch / 1000).round();
      timesaved["timestamp"].add(closeTime);
      timesaved["description"].add("CLOSE");
      print(jsonEncode(timesaved));
      sinkTime.write(jsonEncode(timesaved));
      sinkTime.close();
    }
    if (state == AppLifecycleState.resumed) {
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      String pathTime = join(documentDirectory.path, 'time.json');

      var fileTime = File(pathTime);
      String content = await fileTime.readAsString();
      // Replace the word
      content = content.replaceAll("CLOSE", "BACKGROUND");
      Map<String, dynamic> timesaved = jsonDecode(content);

      // Write the updated content back to the file
      await fileTime.writeAsString(content);
      var sinkTime = fileTime.openWrite();
      final resumeTimeUTC = DateTime.now().toUtc();
      int resumeTime = (resumeTimeUTC.millisecondsSinceEpoch / 1000).round();
      timesaved["timestamp"].add(resumeTime);
      timesaved["description"].add("RESUMED");
      print(jsonEncode(timesaved));
      sinkTime.write(jsonEncode(timesaved));
      sinkTime.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // hide debug Banner
      title: 'Bexome',
      locale: _locale,
      home: RootApp(),
      // route to the homepage
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
