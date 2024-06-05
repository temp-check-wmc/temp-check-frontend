import 'package:flutter/material.dart';
import 'package:temp_check_frontend/pages/compare.dart';
import 'package:temp_check_frontend/pages/countries.dart';
import 'package:temp_check_frontend/pages/country_detail.dart';
import 'package:temp_check_frontend/pages/home.dart';
import 'package:temp_check_frontend/pages/settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: "/",
      routes: {
        "/" : (context) => const Home(title: "Home",),
        "/settings" : (context) => const Settings(title: "Settings"),
        "/countries": (context) => const Countries(title: "Countries"),
        "/detail" : (context) => const CountryDetail(title: "Detail"),
        "/compare" : (context) => const Compare(title: "Compare"),
      },
    );
  }
}