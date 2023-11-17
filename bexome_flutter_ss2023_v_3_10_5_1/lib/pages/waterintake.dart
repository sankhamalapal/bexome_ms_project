import '../Translation/translation.dart';
import '../secChart.dart';
import 'package:flutter/material.dart';
import '../colors.dart';
import '../data_management/water_data.dart';
import 'package:intl/intl.dart';

class WaterIntake extends StatefulWidget {
  final Function() notifyParent;

  WaterIntake({Key? key, required this.notifyParent}) : super(key: key);

  @override
  State<WaterIntake> createState() => _WaterIntakeState();
}

class _WaterIntakeState extends State<WaterIntake> {
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

  bool pressAttention1 = true;
  bool pressAttention2 = false;
  bool pressAttention3 = false;
  bool pressAttention4 = false;

  double userWaterAmountIntake = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void updateChartData(DateTime dateTime, String input) {
    String textWithoutComma = input.replaceAll(",", ".");
//that it also works if you enter a comma instead of a point
    setState(() {
      userWaterAmountIntake = double.parse(textWithoutComma);
      //will be added to the chartData list of water_data.dart
      addWaterChartItem(dateTime, userWaterAmountIntake);
    });
    Navigator.of(context).pop();
  }

  void confirmDelete(int index) {
    //function that asks you again to confirm your deletion or if you pressed on delete by mistake
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              new Text(translate.getTranslation(context, 'delete_next_entry')),
          content: SizedBox(
            height: 29,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${getWaterChartData(true, false, false, false, false, true)[index].dateOfWaterLog.day}. ${((translate.getTranslation(context, "lang") == "DE") ? months : monthsEN)[getWaterChartData(true, false, false, false, false, true)[index].dateOfWaterLog.month - 1]} ${getWaterChartData(true, false, false, false, false, true)[index].dateOfWaterLog.year}',
                        style: TextStyle(fontSize: 13.5),
                      ),
                      Text(
                        DateFormat('HH:mm').format(getWaterChartData(
                                true, false, false, false, false, true)[index]
                            .dateOfWaterLog),
                        style: TextStyle(fontSize: 11),
                      )
                    ]),
                Icon(Icons.arrow_forward),
                Text(
                  '${getWaterChartData(true, false, false, false, false, true)[index].milliLiters.toStringAsFixed(2)} L',
                  style: TextStyle(fontSize: 13.5),
                )
              ],
            ),
          ),
          actions: <Widget>[
            new TextButton(
              child: new Text(translate.getTranslation(context, 'interrupt')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new TextButton(
              child: new Text(translate.getTranslation(context, 'extinguish')),
              onPressed: () {
                setState(() {
                  removeChartData(index);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget getTimeLine() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ClipRRect(
            //round edges
            borderRadius: BorderRadius.circular(4.0),
            //Winkel für das Abrunden der Ecken
            child: Container(
                width: 50,
                height: 30,
                color: pressAttention1
                    ? Colors.grey.shade200
                    : Colors.grey.shade50,
                //logic so the color of the button gets changed if you press on it
                child: TextButton(
                  style: TextButton.styleFrom(
                      // padding: const EdgeInsets.all(10.0),
                      primary: Colors.grey.shade600,
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 10)),
                  onPressed: () {
                    setState(() {
                      //if you press on button 1, all other buttons should be false
                      pressAttention2 = false;
                      pressAttention3 = false;
                      pressAttention4 = false;
                      pressAttention1 =
                          !pressAttention1 ? !pressAttention1 : pressAttention1;
                    });
                  },
                  child: Text(translate.getTranslation(context, '1w')),
                ))),
        ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Container(
                width: 50,
                height: 30,
                color: pressAttention2
                    ? Colors.grey.shade200
                    : Colors.grey.shade50,
                child: TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.grey.shade600,
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 10)),
                  onPressed: () {
                    setState(() {
                      pressAttention1 = false;
                      pressAttention3 = false;
                      pressAttention4 = false;
                      pressAttention2 =
                          !pressAttention2 ? !pressAttention2 : pressAttention2;
                    });
                  },
                  child: Text(translate.getTranslation(context, '1m')),
                ))),
        ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Container(
                width: 50,
                height: 30,
                color: pressAttention3
                    ? Colors.grey.shade200
                    : Colors.grey.shade50,
                child: TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.grey.shade600,
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 10)),
                  onPressed: () {
                    setState(() {
                      pressAttention1 = false;
                      pressAttention2 = false;
                      pressAttention4 = false;
                      pressAttention3 =
                          !pressAttention3 ? !pressAttention3 : pressAttention3;
                    });
                  },
                  child: Text(translate.getTranslation(context, '1y')),
                ))),
        ClipRRect(
            borderRadius: BorderRadius.circular(3.0),
            child: Container(
                width: 50,
                height: 30,
                color: pressAttention4
                    ? Colors.grey.shade200
                    : Colors.grey.shade50,
                child: TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.grey.shade600,
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 10)),
                  onPressed: () {
                    setState(() {
                      pressAttention1 = false;
                      pressAttention2 = false;
                      pressAttention3 = false;
                      pressAttention4 =
                          !pressAttention4 ? !pressAttention4 : pressAttention4;
                    });
                  },
                  child: const Text("MAX"),
                ))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: getBody());
  }

  Widget getBody() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_rounded, size: 30, color: black),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      translate.getTranslation(context, 'water_intake'),
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
              height: 15,
            ),
            getTimeLine(),
            SizedBox(
              height: 30,
            ),
            //the chart for the water intake, which is changing when you press on a button, because the bool values (e.g. pressAttention1 and 2 is changing) and then the data you get will be changed:
            SecChart(true, pressAttention1, pressAttention2, pressAttention3,
                pressAttention4, false),
            SizedBox(
              height: 25,
            ),
            Expanded(
              //listView for all entered water intakes, to see every value exactly and delete something if you want to
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount:
                      getWaterChartData(true, false, false, false, false, true)
                          .length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        dense: true,
                        leading: Icon(
                          Icons.water_drop_outlined,
                          color: thirdColor,
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 12, 0, 0),
                                      child: Text(
                                        '${getWaterChartData(true, false, false, false, false, true)[index].dateOfWaterLog.day}. ${months[getWaterChartData(true, false, false, false, false, true)[index].dateOfWaterLog.month - 1]} ${getWaterChartData(true, false, false, false, false, true)[index].dateOfWaterLog.year}',
                                        style: TextStyle(fontSize: 13.5),
                                      ),
                                    ),
                                    Text(
                                      DateFormat('HH:mm').format(
                                          getWaterChartData(true, false, false,
                                                  false, false, true)[index]
                                              .dateOfWaterLog),
                                      style: TextStyle(fontSize: 11),
                                    )
                                  ]),
                            ),
                            Text(
                              '${getWaterChartData(true, false, false, false, false, true)[index].milliLiters.toStringAsFixed(2)} L',
                              style: TextStyle(fontSize: 13),
                            )
                          ],
                        ),
                        trailing: IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.grey,
                            onPressed: () {
                              setState(() {
                                confirmDelete(index);
                                widget.notifyParent();
                              });
                            }
                            //TODO: connect with database

                            ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
