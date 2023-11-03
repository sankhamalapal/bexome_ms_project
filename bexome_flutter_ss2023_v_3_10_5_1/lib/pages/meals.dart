import '../Translation/translation.dart';
import '../pages/food.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../colors.dart';
import 'package:intl/intl.dart';
import '../data_management/food_data.dart';
import '../scaff.dart';

class MealPage extends StatefulWidget {
  DateTime dateOfMeals = DateTime.now();

  final Function() notifyParent;
  MealPage({Key? key, required this.dateOfMeals, required this.notifyParent})
      : super(key: key);

  @override
  State<MealPage> createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  Translation translate = Translation();
  void refresh() {
    setState(() {});
  }

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

  // DateTime dateTime = DateTime.now();
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void confirmDelete(int index) {
    //function that asks you again, if you really want to delete this item or if you pressed on delete on accident
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              new Text(translate.getTranslation(context, "delete_next_entry")),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                child: Text(
                  "${getFoodChartData(false, false, true, widget.dateOfMeals, false)[index].foodName}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                      '${getFoodChartData(false, false, true, widget.dateOfMeals, false)[index].dateOfFoodLog.day}. ${((translate.getTranslation(context, "lang") == "DE") ? months : monthsEN)[getFoodChartData(false, false, true, widget.dateOfMeals, false)[index].dateOfFoodLog.month - 1]} ${getFoodChartData(false, false, true, widget.dateOfMeals, false)[index].dateOfFoodLog.year}'),
                  Icon(Icons.arrow_forward),
                  Text(
                      '${getFoodChartData(false, false, true, widget.dateOfMeals, false)[index].kcal.toStringAsFixed(0)} kcal')
                ],
              ),
            ],
          ),
          actions: <Widget>[
            new TextButton(
              //nothing is done, process is aborted
              child: new Text(translate.getTranslation(context, "interrupt")),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new TextButton(
              child: new Text(translate.getTranslation(context, "extinguish")),
              //item will be deleted
              onPressed: () {
                setState(() {
                  removeChartData(index, true, widget.dateOfMeals);
                });
                widget.notifyParent();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Food(
                                        notifyParent: refresh,
                                      )));
                        },
                        icon: Icon(Icons.arrow_back, color: black),
                      ),
                      Text(
                        translate.getTranslation(context, "meals_from") +
                            " ${DateFormat("dd.MM.yyyy").format(widget.dateOfMeals)}",
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
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 45),
                child: SizedBox(
                    height: 100,
                    //date picker for selecting the date, where you want to check on your eaten meals
                    child: CupertinoDatePicker(
                      minimumYear: DateTime.now().year - 100,
                      maximumYear: DateTime.now().year,
                      maximumDate: DateTime.now(),
                      initialDateTime: widget.dateOfMeals,
                      dateOrder: DatePickerDateOrder.dmy,
                      mode: CupertinoDatePickerMode.date,
                      onDateTimeChanged: (DateTime value) {
                        setState(() {
                          widget.dateOfMeals = value;
                        });
                      },
                    )),
              ),

              //if there is no entry yet --> show that there are no entries yet, otherwise show all entries:
              getFoodChartData(false, false, true, widget.dateOfMeals, false)
                      .isEmpty
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Container(
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
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.1)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(11))),
                          child: Row(children: [
                            SizedBox(
                              width: 10,
                            ),
                            Icon(Icons.info_outline, size: 18),
                            SizedBox(
                              width: 11,
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width - 60 - 41,
                                child: Text(
                                  translate.getTranslation(
                                      context, "no_entries_on_day"),
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                )),
                          ])),
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height - 355,
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: getFoodChartData(
                                  false, false, true, widget.dateOfMeals, false)
                              .length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: ListTile(
                                dense: true,
                                leading: Icon(
                                  Icons.food_bank_outlined,
                                  color: thirdColor,
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 5, 0, 10),
                                      child: Text(
                                        getFoodChartData(
                                                false,
                                                false,
                                                true,
                                                widget.dateOfMeals,
                                                false)[index]
                                            .foodName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 3),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              '${DateFormat("HH:mm").format(getFoodChartData(false, false, true, widget.dateOfMeals, false)[index].dateOfFoodLog)}'),
                                          Text(
                                              '${getFoodChartData(false, false, true, widget.dateOfMeals, false)[index].kcal.toStringAsFixed(0)} kcal')
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    color: Colors.grey,
                                    onPressed: () {
                                      setState(() {
                                        confirmDelete(index);
                                      });
                                    }),
                              ),
                            );
                          }),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
