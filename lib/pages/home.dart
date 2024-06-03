import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
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

  static Future<void> getLines(String filename)  async {
    var data = await rootBundle.loadString(filename);
    var elements= jsonDecode(data);
  }

    @override
  void initState() {
    getLines("weather.json").whenComplete(() => print("Ahhh"));
    SensorDataService()
        .getForHour("11", "3", "6", "2024")
        .then((value) {
      sensorData = value..sort((a, b) => a.dateTime.compareTo(b.dateTime));
      sensorData.forEach((element) {print(element);});
      setState(() {
        loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[300],
          title: const Text(
            "Temp-Check", style: TextStyle(color: Colors.white),),
          leading: Image.asset(
            "images/temp-check-logo.png", width: 300, height: 300,),
          toolbarHeight: 75,
          leadingWidth: 100,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(onPressed: () {
                Navigator.pushNamed(context, "/settings");
              },
                icon: const Icon(Icons.plumbing, color: Colors.white,),
                tooltip: "Settings",),
            )
          ],
        ),
        body: Center(
          child: SizedBox(
            width: 800,
            height: 400,
            child: SfCartesianChart(
              primaryXAxis: DateTimeAxis(),
              primaryYAxis: NumericAxis(isVisible: false),
              axes: [
                NumericAxis(name: "Pressure", title: AxisTitle(text: "Pressure")),
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
      ),
    );
  }
}
