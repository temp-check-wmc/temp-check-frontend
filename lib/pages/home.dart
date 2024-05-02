import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key, required String title});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        title: const Text("Temp-Check", style: TextStyle(color: Colors.white),),
        leading: const Text("Logo"), //TODO Create Logo
        toolbarHeight: 75,
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
