import '../Translation/translation.dart';
import '../secChart.dart';
import 'package:flutter/material.dart';
import '../colors.dart';
import '../data_management/weight_data.dart';
import 'package:intl/intl.dart';

class Weight extends StatefulWidget {
  final Function() notifyParent;

  Weight({Key? key, required this.notifyParent}) : super(key: key);

  @override
  State<Weight> createState() => _WeightState();
}

class _WeightState extends State<Weight> {
  Translation translate = Translation();

  //to show the for example Feb instead of 02
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

//for the buttons over the graph, to choose if you want to see the data of the last week, or mont, year, MAX
  bool pressAttention1 = true;
  bool pressAttention2 = false;
  bool pressAttention3 = false;
  bool pressAttention4 = false;

  double userWeight = 0.0;
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
    setState(() {
      //new weight will be entered in the chartData list of weight_data.dart
      userWeight = double.parse(textWithoutComma);
      addChartItem(dateTime, userWeight);
    });
    Navigator.of(context).pop();
    controller.clear();
  }

  void confirmDelete(int index) {
    //function that asks you again to confirm your deletion or if you pressed on delete by mistake
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              new Text(translate.getTranslation(context, "delete_next_entry")),
          content: SizedBox(
            height: 31,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${getChartData(false, false, false, true, false)[index].dateOfWeight.day}. ${((translate.getTranslation(context, "lang") == "DE") ? months : monthsEN)[getChartData(false, false, false, true, false)[index].dateOfWeight.month - 1]} ${getChartData(false, false, false, true, false)[index].dateOfWeight.year}',
                        style: TextStyle(fontSize: 13.5),
                      ),
                      Text(
                        DateFormat('HH:mm').format(getChartData(
                                false, false, false, true, false)[index]
                            .dateOfWeight),
                        style: TextStyle(fontSize: 11),
                      )
                    ]),
                Icon(Icons.arrow_forward),
                Text(
                  '${getChartData(false, false, false, true, false)[index].weight.toStringAsFixed(1)} Kg',
                  style: TextStyle(fontSize: 13.5),
                )
              ],
            ),
          ),
          actions: <Widget>[
            new TextButton(
              child: new Text(translate.getTranslation(context, "interrupt")),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new TextButton(
              child: new Text(translate.getTranslation(context, "extinguish")),
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
//rounded edges:
            borderRadius: BorderRadius.circular(4.0),
            child: Container(
                width: 50,
                height: 30,
                color: pressAttention1
                    ? Colors.grey.shade200
                    : Colors.grey.shade50,
//logic so the color of the button gets changed if you press on it
                child: TextButton(
                  style: TextButton.styleFrom(
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
                  child: Text(translate.getTranslation(context, "1w")),
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
                  child: Text(translate.getTranslation(context, "1m")),
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
                  child: Text(translate.getTranslation(context, "1y")),
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
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
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
                      translate.getTranslation(context, "weight"),
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
                pressAttention4, true),
            SizedBox(
              height: 25,
            ),
            //listView for all entered water intakes, to see every value exactly and delete something if you want to
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: chartData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        dense: true,
                        leading: Icon(
                          Icons.scale,
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
                                        '${getChartData(false, false, false, true, false)[index].dateOfWeight.day}. ${((translate.getTranslation(context, "lang") == "DE") ? months : monthsEN)[getChartData(false, false, false, true, false)[index].dateOfWeight.month - 1]} ${getChartData(false, false, false, true, false)[index].dateOfWeight.year}',
                                        style: TextStyle(fontSize: 13.5),
                                      ),
                                    ),
                                    Text(
                                      DateFormat('HH:mm').format(getChartData(
                                              false,
                                              false,
                                              false,
                                              true,
                                              false)[index]
                                          .dateOfWeight),
                                      style: TextStyle(fontSize: 11),
                                    )
                                  ]),
                            ),
                            Text(
                              '${getChartData(false, false, false, true, false)[index].weight.toStringAsFixed(1)} Kg',
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
                            }),
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
