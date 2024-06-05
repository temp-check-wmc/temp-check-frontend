import 'dart:convert';

import '../domain/sensor_data.dart';
import 'package:http/http.dart' as http;

String dbUrl = "https://temp-check-4c71c-default-rtdb.europe-west1.firebasedatabase.app";

class SensorDataService {

  Future<List<SensorData>> getForHour(String hour, String day, String month, String year) async {
    List<SensorData> sensorDataList = [];
    var url = Uri.parse("$dbUrl/$year/$month/$day/$hour.json");

    var response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body) ?? {};
      for (var element in data.entries) {
        var date = DateTime(int.parse(year), int.parse(month), int.parse(day), int.parse(hour), int.parse(element.key));
        sensorDataList.add(SensorData.fromJSON(element.value, date));
      }

    } else {
      throw "Something went wrong for getting Data for hour: $hour";
    }

      return sensorDataList;
  }

  Future<List<SensorData>> getForDay(String day, String month, String year) async {
    List<SensorData> sensorDataList = [];
    var url = Uri.parse("$dbUrl/$year/$month/$day.json?shallow=true");

    var response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body) ?? {};
      for (var element in data.entries) {
        sensorDataList.addAll(await getForHour(element.key, day, month, year));
      }

    } else {
      throw "Something went wrong for getting Data for day: $day";
    }

    return sensorDataList;
  }

  Future<List<SensorData>> getForMonth(String month, String year) async {
    List<SensorData> sensorDataList = [];
    var url = Uri.parse("$dbUrl/$year/$month.json?shallow=true");

    var response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body) ?? {};
      for (var element in data.entries) {
        sensorDataList.addAll(await getForDay(element.key, month, year));
      }

    } else {
      throw "Something went wrong for getting Data for month: $month";
    }

    return sensorDataList;
  }

  Future<List<SensorData>> getForYear(String year) async {
    List<SensorData> sensorDataList = [];
    var url = Uri.parse("$dbUrl/$year.json?shallow=true");

    var response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body) ?? {};
      for (var element in data.entries) {
        sensorDataList.addAll(await getForMonth(element.key, year));
      }

    } else {
      throw "Something went wrong for getting Data for Year: $year";
    }

    return sensorDataList;
  }

  Future<List<SensorData>> getAll() async {
    List<SensorData> sensorDataList = [];
    var url = Uri.parse("$dbUrl/.json?shallow=true");

    var response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body) ?? {};
      for (var element in data.entries) {
        sensorDataList.addAll(await getForYear(element.key));
      }

    } else {
      throw "Something went wrong for getting Data";
    }

    return sensorDataList;
  }
}