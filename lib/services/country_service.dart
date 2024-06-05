import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:temp_check_frontend/domain/country.dart';
import 'package:temp_check_frontend/domain/sensor_data.dart';

class CountryService {

  static Set<Country> countries = {};
  final filename = "weather.json";

  Future<void> initCountries() async {
    var data = await rootBundle.loadString(filename);
    List<dynamic> elements = jsonDecode(data);

    for (var element in elements) {
      countries.add(Country(element['Country/Region']));
    }
  }

  Future<List<SensorData>> getForCountry(String country) async {
    var data = await rootBundle.loadString(filename);
    List<dynamic> elements = jsonDecode(data);
    List<SensorData> withName = [];

    for (var element in elements) {
      if (element['Country/Region'] == country) {
        
        double avgTemp = (double.parse(element["temperatureMax"]) +
           double.parse(element["temperatureMin"])) / 2;

        withName.add(SensorData(dateTime: DateTime.parse(element["time"]),
            temperature: (avgTemp - 32) * (5/9),
            humidity: double.parse(element["humidity"]),
            pressure: double.parse(element["pressure"])));
      }
    }

    return withName..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }
}