import 'package:flutter/material.dart';
import 'package:temp_check_frontend/services/country_service.dart';
import 'package:temp_check_frontend/services/sensor_data_service.dart';

import '../domain/country.dart';

class Difference extends StatefulWidget {
  const Difference({super.key, required String title});

  @override
  State<Difference> createState() => _DifferenceState();
}

class _DifferenceState extends State<Difference> {
  var avgTemperatrueDay = 0.0;
  List<Country> avgTemperaturesCountries = [];

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue[300],
        title: const Text(
          "Average Comparison",
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
      body: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
              child: Center(
                child: Text(
            "Todays average Temperature:  ${avgTemperatrueDay.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 30),
          ),
              )),
          Expanded(
            child: ListView(
              children: avgTemperaturesCountries
                  .map((country) => Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: country.favorite ? Colors.pinkAccent : Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 1,
                            blurRadius: 5,
                            color: Colors.grey.withOpacity(0.5)
                        )
                      ]
                  ),
                  margin: const EdgeInsets.all(20.0),
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
                          child: ListTile(
                        title: Text(country.name, style: const TextStyle(fontSize: 20),),
                        trailing: Text(country.avgTemp.toStringAsFixed(2), style: const TextStyle(fontSize: 20),),
                      )))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }

  Future<void> initData() async {
    var dayData = await SensorDataService().getForDay(
        DateTime.now().day.toString(),
        DateTime.now().month.toString(),
        DateTime.now().year.toString());
    avgTemperatrueDay = SensorDataService().calcAvgTemp(dayData);

    for (var element in CountryService.countries) {
      if (element.favorite) {
        var data = await CountryService().getForCountry(element.name);
        element.avgTemp = SensorDataService().calcAvgTemp(data);
      }
    }

    var onlyFavs =
        CountryService.countries.where((element) => element.favorite == true);
    avgTemperaturesCountries = onlyFavs.toList()
      ..sort((a, b) {
        double diffA = (a.avgTemp - avgTemperatrueDay).abs();
        double diffb = (b.avgTemp - avgTemperatrueDay).abs();
        return diffA.compareTo(diffb);
      });
    setState(() {});
  }
}
