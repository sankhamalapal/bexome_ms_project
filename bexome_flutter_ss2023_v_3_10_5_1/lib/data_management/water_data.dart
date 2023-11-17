class WaterData {
  WaterData(this.dateOfWaterLog, this.milliLiters);
  final DateTime dateOfWaterLog; //date of logged water
  final double milliLiters; //amount of milliLiters entered
}

//list of WaterData entries
List<WaterData> chartData = [
];

void removeChartData(int index) {
  //function to remove an element of chartData (index is the index on which you press on the listView on the water page)
  var tempSltList = getWaterChartData(true, false, false, false, false, true);
  DateTime dateOfDelete = tempSltList[index].dateOfWaterLog;
  var growFoodDataList = [];
  for(var d in chartData) {
    if(d.dateOfWaterLog.year == dateOfDelete.year &&
        d.dateOfWaterLog.month == dateOfDelete.month &&
        d.dateOfWaterLog.day == dateOfDelete.day) {
      growFoodDataList.add(d);
    }
  }
  for(var g in growFoodDataList) {
    chartData.remove(g);
  }
}

void addWaterChartItem(DateTime dateTime, double ml) {
  //function to add an WaterData element to chartData
  WaterData foodDataObject = WaterData(dateTime, ml);
  chartData.add(foodDataObject);
}

List<WaterData> getWaterChartData(oneValuePerDayInList, currentDayData, bool week, bool month, bool year, bool max) {
  //function to get specific elements of chartData
  var solutionList = chartData.map((v) => v).toList();
  if (oneValuePerDayInList) {
    //returns a list which contains only one element per day, which is the addition of all elements of that day
    var chartDataCopy = chartData.map((v) => v).toList();
    var fallingList = chartDataCopy.map((v) => v).toList();
    var milliLiterFractions = [];
    for (var element in chartDataCopy) {
      fallingList.remove(element);
      milliLiterFractions.add(element.milliLiters);
      for (var fallElem in fallingList) {
        if (element.dateOfWaterLog.year == fallElem.dateOfWaterLog.year &&
            element.dateOfWaterLog.month == fallElem.dateOfWaterLog.month &&
            element.dateOfWaterLog.day == fallElem.dateOfWaterLog.day) {
          milliLiterFractions.add(fallElem.milliLiters);
          solutionList.remove(fallElem);
        }
      }
      for (int x = 0; x < solutionList.length; x++) {
        if (solutionList[x] == element) {
          double totalMilliLiters = 0;
          for (var e in milliLiterFractions) {
            totalMilliLiters += e;
          }
          milliLiterFractions.clear();
          DateTime savedDate = solutionList[x].dateOfWaterLog;
          solutionList.removeAt(x);
          solutionList.add(WaterData(savedDate, totalMilliLiters));
          break;
        }
      }
      milliLiterFractions.clear();
    }
  }

  solutionList.sort((a, b) {
    var aDate = a.dateOfWaterLog;
    var bDate = b.dateOfWaterLog;
    if (!oneValuePerDayInList) {
      return aDate.compareTo(bDate);
    } else {
      return -aDate.compareTo(bDate);
    }
  });

  if(currentDayData) {
    //returns the element of todays date
    for(var element in solutionList) {
      DateTime now = DateTime.now();
      DateTime currentDateOfFoodLog = element.dateOfWaterLog;
      if(DateTime(currentDateOfFoodLog.year, currentDateOfFoodLog.month, currentDateOfFoodLog.day) == DateTime(now.year, now.month, now.day)) {
        return [WaterData(element.dateOfWaterLog, element.milliLiters)];
      }
    }
    return [WaterData(DateTime.now(), 0)];
  }

  var now = new DateTime.now();
  if (week) {
    //returns the elements of the last week
    var sevenDaysBefore = DateTime(now.year, now.month, now.day - 8);
    List<WaterData> lastSevenDaysChartData = [];
    for (var element in solutionList) {
      if (element.dateOfWaterLog.isAfter(sevenDaysBefore)) {
        lastSevenDaysChartData.add(element);
      }
    }
    return lastSevenDaysChartData;
  }

  if (month) {
    //returns all elements of the last month
    var dateMonthBefore = DateTime(now.year, now.month - 1, now.day - 1);
    List<WaterData> lastMonthChartData = [];
    for (var element in solutionList) {
      if (element.dateOfWaterLog.isAfter(dateMonthBefore)) {
        lastMonthChartData.add(element);
      }
    }
    return lastMonthChartData;
  }

  if (year) {
    //returns all elements of the last year
    var dateYearBefore = DateTime(now.year - 1, now.month, now.day - 1);
    List<WaterData> lastYearChartData = [];
    for (var element in solutionList) {
      if (element.dateOfWaterLog.isAfter(dateYearBefore)) {
        lastYearChartData.add(element);
      }
    }
    return lastYearChartData;
  }

  return solutionList; //in case of max == true
}