import 'package:flutter/material.dart';
import 'package:temp_check_frontend/services/sensor_data_service.dart';

class Settings extends StatefulWidget {
  const Settings({super.key, required String title});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextEditingController controller = TextEditingController(text: dbUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        toolbarHeight: 75,
      ),
      body: Column(
        children: [
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
              child: Text(
                "DB-Link",
                style: TextStyle(fontSize: 30),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: 600,
              child: TextField(
                controller: controller,
                onSubmitted: (text) {
                  submit();
                },
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20.0),
            child: FloatingActionButton(
              backgroundColor: Colors.green,
              onPressed: () {
                submit();
              },
              child: const Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  void submit() {
    setState(() {
      dbUrl = controller.text;
      Navigator.pop(context);
    });
  }
}
