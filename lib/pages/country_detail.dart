import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:temp_check_frontend/services/country_service.dart';

import '../domain/sensor_data.dart';

class CountryDetail extends StatefulWidget {
  const CountryDetail({super.key, required String title});

  @override
  State<CountryDetail> createState() => _CountryDetailState();
}

class _CountryDetailState extends State<CountryDetail> {
  List<SensorData> withName = [];
  String name = "";

  @override
  void didChangeDependencies() {
    name = ModalRoute.of(context)!.settings.arguments as String;
    CountryService().getForCountry(name).then((value) {
      withName = value;
      setState(() {
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue[300],
        title: Text(
          "Data from $name",
          style: TextStyle(color: Colors.white),
        ),
        toolbarHeight: 75,
        leadingWidth: 100,
        actions: [
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
      body: Center(
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
                  dataSource: withName,
                  color: Colors.blueAccent,
                  xValueMapper: (SensorData data, _) => data.dateTime,
                  yValueMapper: (SensorData data, _) => data.pressure,
                  yAxisName: "Pressure"),
              LineSeries<SensorData, DateTime>(
                  name: "Humidity",
                  dataSource: withName,
                  color: Colors.green,
                  xValueMapper: (SensorData data, _) => data.dateTime,
                  yValueMapper: (SensorData data, _) => data.humidity,
                  yAxisName: "Humidity"),
              LineSeries<SensorData, DateTime>(
                  name: "Temperature",
                  dataSource: withName,
                  color: Colors.redAccent,
                  xValueMapper: (SensorData data, _) => data.dateTime,
                  yValueMapper: (SensorData data, _) => data.temperature,
                  yAxisName: "Temperature"),
            ],
          ),
        ),
      ),
    );
  }
}
