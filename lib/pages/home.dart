import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:temp_check_frontend/services/country_service.dart';
import 'package:temp_check_frontend/services/sensor_data_service.dart';

import '../domain/sensor_data.dart';

class Home extends StatefulWidget {
  const Home({super.key, required String title});

  @override
  State<Home> createState() => _HomeState();
}

List<SensorData> sensorData = [];

class _HomeState extends State<Home> {
  bool loading = true;
  CountryService service = CountryService();
  List<String> modes = ["Day", "Week", "Month", "Year"];
  String currentMode = "Day";

  @override
  void initState() {
    service.initCountries().whenComplete(() => print('A'));
    SensorDataService()
        .getForDay(DateTime
        .now()
        .day
        .toString(),
        DateTime
            .now()
            .month
            .toString(), DateTime
            .now()
            .year
            .toString())
        .then((value) {
      sensorData = value..sort((a, b) => a.dateTime.compareTo(b.dateTime));
      fixList();
      fixList();
    });
    super.initState();
  }

  void fixList() {
    for (var i = 0; i < sensorData.length; ++i) {
      var element = sensorData[i];
      if (element.humidity == 0) {
        element.humidity = element == sensorData.first
            ? sensorData[i + 1].humidity
            : sensorData[i - 1].humidity;
      }

      if (element.temperature == 0 ||
          element.temperature > 50 ||
          element.temperature < 0) {
        element.temperature = element == sensorData.first
            ? sensorData[i + 1].temperature
            : sensorData[i - 1].temperature;
      }

      if (element.pressure == 0) {
        element.pressure = element == sensorData.first
            ? sensorData[i + 1].pressure
            : sensorData[i - 1].pressure;
      }
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[300],
          title: const Text(
            "Temp-Check",
            style: TextStyle(color: Colors.white),
          ),
          leading: Image.asset(
            "images/temp-check-logo.png",
            width: 300,
            height: 300,
          ),
          toolbarHeight: 75,
          leadingWidth: 100,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/compare");
                },
                icon: const Icon(
                  Icons.compare,
                  color: Colors.white,
                ),
                tooltip: "Compare",
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/countries");
                },
                icon: const Icon(
                  Icons.place,
                  color: Colors.white,
                ),
                tooltip: "Countries/Regions",
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/settings");
                },
                icon: const Icon(
                  Icons.plumbing,
                  color: Colors.white,
                ),
                tooltip: "Settings",
              ),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: DropdownButton(
                      value: currentMode,
                      items: modes
                          .map((element) =>
                          DropdownMenuItem(
                            value: element,
                            child: Text(element),
                          ))
                          .toList(),
                      onChanged: (text) async {
                        currentMode = text!;
                        await getDataForMode();
                        setState(() {});
                      }),
                ),
                if (currentMode == "Day")
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextButton(
                        onPressed: () async {
                          var avaiable = await getAvaiableDates()
                            ..sort();

                          var selectedDate = await showDatePicker(
                              context: context,
                              firstDate: avaiable.first,
                              lastDate: DateTime.now(),
                              initialDate: DateTime.now(),
                              selectableDayPredicate: (DateTime date) =>
                                  avaiable.contains(date)
                          );

                          if (selectedDate != null) {
                            sensorData =
                            await SensorDataService().getForDay(selectedDate.day
                                .toString(), selectedDate.month.toString(),
                                selectedDate.year.toString());

                            setState(() {

                            });
                          }
                        },
                        child: const Text("Tag auswählen")),
                  )
              ],
            ),
            Center(
              child: SizedBox(
                width: 1200,
                height: 600,
                child: SfCartesianChart(
                  primaryXAxis: DateTimeAxis(),
                  primaryYAxis: NumericAxis(isVisible: false),
                  axes: [
                    NumericAxis(
                        name: "Pressure", title: AxisTitle(text: "Pressure")),
                    NumericAxis(
                        name: "Humidity", title: AxisTitle(text: "Humidity")),
                    NumericAxis(
                        opposedPosition: true,
                        name: "Temperature",
                        title: AxisTitle(text: "Temperature")),
                  ],
                  legend: const Legend(isVisible: true),
                  series: <CartesianSeries>[
                    LineSeries<SensorData, DateTime>(
                        name: "Pressure",
                        dataSource: sensorData,
                        color: Colors.blueAccent,
                        xValueMapper: (SensorData data, _) => data.dateTime,
                        yValueMapper: (SensorData data, _) => data.pressure,
                        yAxisName: "Pressure"),
                    LineSeries<SensorData, DateTime>(
                        name: "Humidity",
                        dataSource: sensorData,
                        color: Colors.green,
                        xValueMapper: (SensorData data, _) => data.dateTime,
                        yValueMapper: (SensorData data, _) => data.humidity,
                        yAxisName: "Humidity"),
                    LineSeries<SensorData, DateTime>(
                        name: "Temperature",
                        dataSource: sensorData,
                        color: Colors.redAccent,
                        xValueMapper: (SensorData data, _) => data.dateTime,
                        yValueMapper: (SensorData data, _) => data.temperature,
                        yAxisName: "Temperature"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getDataForMode() async {
    if (currentMode == "Day") {
      sensorData = await SensorDataService().getForDay(
          DateTime
              .now()
              .day
              .toString(),
          DateTime
              .now()
              .month
              .toString(),
          DateTime
              .now()
              .year
              .toString());
    } else if (currentMode == "Week") {
      var date = DateTime.now();
      List<SensorData> forWeek = [];

      for (var i = 0; i < 7; ++i) {
        var forDay = await SensorDataService().getForDay(
            date.day.toString(), date.month.toString(), date.year.toString());

        forWeek.addAll(forDay);
        date = date.subtract(const Duration(days: 1));
      }

      sensorData = forWeek..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    } else if (currentMode == "Month") {
      sensorData = await SensorDataService().getForMonth(
          DateTime
              .now()
              .month
              .toString(), DateTime
          .now()
          .year
          .toString());
    } else {
      sensorData =
      await SensorDataService().getForYear(DateTime
          .now()
          .year
          .toString());
    }

    fixList();
    fixList();
  }

  Future<List<DateTime>> getAvaiableDates() async {
    List<SensorData> entries = await SensorDataService().getAll();
    Set<DateTime> dates = {};

    for (var value in entries) {
      dates.add(DateTime(
          value.dateTime.year, value.dateTime.month, value.dateTime.day));
    }

    return dates.toList();
  }
}
