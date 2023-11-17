import 'Translation/translation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'colors.dart';
import 'data_management/weight_data.dart';
import 'scaff.dart';

class AddWeight extends StatefulWidget {
  const AddWeight({Key? key}) : super(key: key);

  @override
  State<AddWeight> createState() => _AddWeightState();
}

class _AddWeightState extends State<AddWeight> {
  Translation translate = Translation();

  late double userWeight;
  DateTime dateTime = DateTime.now();
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void updateChartData(String input) {
    String textWithoutComma = input.replaceAll(",", ".");
    //so it also works if you enter a comma instead of a point
    if (textWithoutComma[0] == '.' ||
        '.'.allMatches(textWithoutComma).length > 1 ||
        textWithoutComma.contains(RegExp(r'[A-Z]')) ||
        textWithoutComma.contains(RegExp(r'[a-z]'))) {
      //checks if there is more than one point int the entered text or if there are letters, which makes no sense, because you enter your weight
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(translate.getTranslation(context, "error")),
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
        userWeight = double.parse(textWithoutComma);
        addChartItem(dateTime, userWeight);
        //to show on the homepage for a few seconds, that you updated your weight
        Navigator.of(context).pop(userWeight);
      } catch (e) {
        print(e);
      }
    });

    controller.clear(); //to empty the input box afterwards
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: getBody(context));
  }

  Widget getBody(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translate.getTranslation(context, "weight_update"),
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
              SingleChildScrollView(
                  child: Column(children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 45),
                  child: SizedBox(
                      height: 180,
                      //date picker to choose the date, when you weighed yourself
                      child: CupertinoDatePicker(
                        use24hFormat: true,
                        minimumDate: DateTime(DateTime.now().year,
                            DateTime.now().month, DateTime.now().day - 30),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: controller,
                    autofocus: true,
                    //the keyboard will be opened automatically if this is true for a faster workflow
                    decoration: InputDecoration(
                      floatingLabelStyle: TextStyle(
                        color: Colors.blueGrey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blueGrey.shade600.withOpacity(0.8),
                          width: 1.6,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blueGrey.shade600.withOpacity(0.93),
                          width: 2,
                        ),
                      ),
                      hintText: translate.getTranslation(context, "kg"),
                      icon: Icon(
                        Icons.scale_rounded,
                        color: Colors.blueGrey.shade600,
                      ),
                      labelText:
                          translate.getTranslation(context, "enter_weight"),
                    ),
                    keyboardType: TextInputType.number,
                    onSubmitted: updateChartData,
                  ),
                ),
              ]))
            ],
          ),
        ),
      ),
    );
  }
}
