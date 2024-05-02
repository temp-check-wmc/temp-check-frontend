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
        title: const Text("Temp-Check", style: TextStyle(fontSize: 30),),
        leading: const Text("Logo"), //TODO Create Logo
        actions: [
          IconButton(onPressed: () {

            Navigator.pushNamed(context, "/settings");

          }, icon: const Icon(Icons.plumbing, color: Colors.white,))
        ],
      ),
    );
  }
}
