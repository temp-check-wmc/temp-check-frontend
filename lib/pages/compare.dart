import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:temp_check_frontend/domain/country.dart';
import 'package:temp_check_frontend/domain/sensor_data.dart';
import 'package:temp_check_frontend/services/country_service.dart';
import 'package:temp_check_frontend/services/sensor_data_service.dart';

class Compare extends StatefulWidget {
  const Compare({super.key, required String title});

  @override
  State<Compare> createState() => _CompareState();
}

class _CompareState extends State<Compare> {
  String currentCountry = CountryService.countries.first.name;
  List<Country> sortedCountries = CountryService.countries.toList();
  List<SensorData> raspData = [];
  List<SensorData> countryData = [];
  bool initial = true;

  @override
  Widget build(BuildContext context) {
    sortedCountries.sort((a, b) {
      if (a.favorite == b.favorite) {
        return a.name.compareTo(b.name);
      }

      return a.favorite ? -1 : 1;
    });
    currentCountry = sortedCountries.first.name;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue[300],
        title: const Text(
          "Countries/Regions",
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
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Land auswählen",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: DropdownButton(
                    value: currentCountry,
                    items: sortedCountries
                        .map((element) => DropdownMenuItem(
                            value: element.name, child: Text(element.name)))
                        .toList(),
                    onChanged: (text) async {
                      raspData = await SensorDataService().getForDay(DateTime.now().day.toString(), DateTime.now().month.toString(), DateTime.now().year.toString());
                      countryData = await CountryService().getForCountry(text!);

                      setState(() {
                        currentCountry = text;
                        initial = false;
                      });
                    }),
              )
            ],
          ),
          if (!initial)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 800,
                  height: 400,
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
                          dataSource: raspData,
                          color: Colors.blueAccent,
                          xValueMapper: (SensorData data, _) => data.dateTime,
                          yValueMapper: (SensorData data, _) => data.pressure,
                          yAxisName: "Pressure"),
                      LineSeries<SensorData, DateTime>(
                          name: "Humidity",
                          dataSource: raspData,
                          color: Colors.green,
                          xValueMapper: (SensorData data, _) => data.dateTime,
                          yValueMapper: (SensorData data, _) => data.humidity,
                          yAxisName: "Humidity"),
                      LineSeries<SensorData, DateTime>(
                          name: "Temperature",
                          dataSource: raspData,
                          color: Colors.redAccent,
                          xValueMapper: (SensorData data, _) => data.dateTime,
                          yValueMapper: (SensorData data, _) => data.temperature,
                          yAxisName: "Temperature"),
                    ],
                  ),
                ),

                SizedBox(
                  width: 800,
                  height: 400,
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
                          dataSource: countryData,
                          color: Colors.blueAccent,
                          xValueMapper: (SensorData data, _) => data.dateTime,
                          yValueMapper: (SensorData data, _) => data.pressure,
                          yAxisName: "Pressure"),
                      LineSeries<SensorData, DateTime>(
                          name: "Humidity",
                          dataSource: countryData,
                          color: Colors.green,
                          xValueMapper: (SensorData data, _) => data.dateTime,
                          yValueMapper: (SensorData data, _) => data.humidity,
                          yAxisName: "Humidity"),
                      LineSeries<SensorData, DateTime>(
                          name: "Temperature",
                          dataSource: countryData,
                          color: Colors.redAccent,
                          xValueMapper: (SensorData data, _) => data.dateTime,
                          yValueMapper: (SensorData data, _) => data.temperature,
                          yAxisName: "Temperature"),
                    ],
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }
}
