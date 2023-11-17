import 'colors.dart';
import 'data_management/water_data.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'data_management/weight_data.dart';

class SecChart extends StatefulWidget {
  //class for the charts, which are for example displayed on the water and weight page
  bool big =
      false; //if big = false, it is for the small weight graph on the bottom of the stats page
  bool week = false;
  bool month = false;
  bool year = false;
  bool max = false;
  bool weightOrWater = false;

  SecChart(
      this.big, this.week, this.month, this.year, this.max, this.weightOrWater);

  SecChart.basic(this.big, this.weightOrWater);

  @override
  State<StatefulWidget> createState() => _SecChartState();
}

class _SecChartState extends State<SecChart> {
  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.weightOrWater) {
        getChartData(widget.week, widget.month, widget.year, widget.max, true);
      } else {
        getWaterChartData(
            true, false, widget.week, widget.month, widget.year, widget.max);
      }
    });
  }

  //function calculates a specific min and max value for the visibleMinimum and visibleMaximum of the SfCartesianChart, that it looks good
  double currentMinMax(bool minOrMaxVisibleValue) {
    if (widget.weightOrWater) {
      var adjustedChartData = getChartData(
          widget.week, widget.month, widget.year, widget.max, true);
      if (minOrMaxVisibleValue) {
        double minVisible = 600;
        for (var element in adjustedChartData) {
          double weight = element.weight;
          if (weight < minVisible) {
            minVisible = weight;
          }
        }
        return minVisible;
      } else {
        double maxVisible = 0;
        for (var element in adjustedChartData) {
          double weight = element.weight;
          if (weight > maxVisible) {
            maxVisible = weight;
          }
        }
        return maxVisible + (maxVisible - currentMinMax(true)) * 0.1;
      }
    } else {
      var adjustedChartData = getWaterChartData(
          true, false, widget.week, widget.month, widget.year, widget.max);
      if (minOrMaxVisibleValue) {
        double minVisible = 600;
        for (var element in adjustedChartData) {
          double weight = element.milliLiters;
          if (weight < minVisible) {
            minVisible = weight;
          }
        }
        return minVisible;
      } else {
        double maxVisible = 0;
        for (var element in adjustedChartData) {
          double weight = element.milliLiters;
          if (weight > maxVisible) {
            maxVisible = weight;
          }
        }
        return maxVisible + (maxVisible - currentMinMax(true)) * 0.2;
      }
    }
  }

  //function returns the xValues for the graph (that the date is consistent with the graph, the value just gets bigger, if it is recently entered)
  double getXValues(WeightData weights, _) {
    DateTime startingDate = DateTime(2000, 1, 1);
    return (weights.dateOfWeight.difference(startingDate).inHours / 24)
        .round()
        .toDouble();
  }

  double getXValuesWater(WaterData mL, _) {
    DateTime startingDate = DateTime(2000, 1, 1);
    return (mL.dateOfWaterLog.difference(startingDate).inHours / 24)
        .round()
        .toDouble();
  }

  Widget build(BuildContext context) {
    return style();
  }

  Widget style() {
    if (widget.big) {
      //for the huge graphs on the weight page for example
      return Container(
        width: double.infinity,
        height: 220,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            //gradient of the background of the graph
            colors: [secondary, primary],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 13.0),
          child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              backgroundColor: Colors.transparent,
              legend: Legend(isVisible: false),
              series: widget.weightOrWater
                  ? (<ChartSeries>[
                      LineSeries<WeightData, double>(
                          width: 5,
                          color: Colors.grey.shade200,
                          dataSource: getChartData(widget.week, widget.month,
                              widget.year, widget.max, true),
                          //get specific chartData wheter you pressed on the button week or month or year or MAX

                          xValueMapper: getXValues,
                          yValueMapper: (WeightData weights, _) =>
                              weights.weight,
                          dataLabelSettings:
                              DataLabelSettings(isVisible: false),
                          enableTooltip: false),
                    ])
                  : (<ChartSeries>[
                      LineSeries<WaterData, double>(
                          width: 5,
                          color: Colors.grey.shade200,
                          dataSource: getWaterChartData(
                              true,
                              false,
                              widget.week,
                              widget.month,
                              widget.year,
                              widget.max),
                          xValueMapper: getXValuesWater,
                          yValueMapper: (WaterData mL, _) => mL.milliLiters,
                          dataLabelSettings:
                              DataLabelSettings(isVisible: false),
                          enableTooltip: false),
                    ]),
              primaryXAxis: NumericAxis(
                  isVisible: false,
                  edgeLabelPlacement: EdgeLabelPlacement.shift),
              primaryYAxis: NumericAxis(
                isVisible: widget.big,
                labelStyle: TextStyle(
                  color: Colors.grey.shade100,
                ),
                visibleMinimum: currentMinMax(true),
                visibleMaximum: currentMinMax(false),
                labelFormat: widget.weightOrWater ? "{value} kg" : "{value} L",
                numberFormat: NumberFormat.compact(),
              )),
        ),
      );
    } else {
      return SfCartesianChart(
          plotAreaBorderWidth: 0,
          backgroundColor: Colors.transparent,
          legend: Legend(isVisible: false),
          series: <ChartSeries>[
            LineSeries<WeightData, double>(
                width: 3,
                color: Colors.grey.shade200,
                dataSource: getChartData(false, true, false, false, true),
                xValueMapper: getXValues,
                yValueMapper: (WeightData weights, _) => weights.weight,
                dataLabelSettings: DataLabelSettings(isVisible: false),
                enableTooltip: false),
          ],
          primaryXAxis: NumericAxis(
              isVisible: false, edgeLabelPlacement: EdgeLabelPlacement.shift),
          primaryYAxis: NumericAxis(
            isVisible: widget.big,
            labelStyle: TextStyle(
              color: Colors.grey.shade100,
            ),
            visibleMinimum: currentMinMax(true),
            visibleMaximum: currentMinMax(false),
            labelFormat: "{value}kg",
            numberFormat: NumberFormat.compact(),
          ));
    }
  }
}
