import 'package:flutter/material.dart';
import 'package:temp_check_frontend/services/sensor_data_service.dart';

class Home extends StatefulWidget {
  const Home({super.key, required String title});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  @override
  void initState() {
    SensorDataService().getAll().then((value) => print(value));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        title: const Text("Temp-Check", style: TextStyle(color: Colors.white),),
        leading: Image.asset("images/temp-check-logo.png", width: 300, height: 300,), //TODO Create Logo
        toolbarHeight: 75,
        leadingWidth: 100,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(onPressed: () {

              Navigator.pushNamed(context, "/settings");

            }, icon: const Icon(Icons.plumbing, color: Colors.white,), tooltip: "Settings",),
          )
        ],
      ),
    );
  }
}
