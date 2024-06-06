import 'package:flutter/material.dart';

class CurrentData extends StatelessWidget {
  const CurrentData(
      {super.key,
      required this.humidity,
      required this.temperature,
      required this.pressure});

  final double humidity;
  final double pressure;
  final double temperature;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            margin:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Text("Temperature: ${temperature.toStringAsFixed(2)} °C", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
        Container(
            margin:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Text("Humidity: ${humidity.toStringAsFixed(2)} %", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        Container(
            margin:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Text("Pressure: ${pressure.toStringAsFixed(2)} Millibars", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))
      ],
    );
  }
}
