import 'package:flutter/material.dart';
import 'package:temp_check_frontend/services/country_service.dart';

class Countries extends StatefulWidget {
  const Countries({super.key, required String title});

  @override
  State<Countries> createState() => _CountriesState();
}

class _CountriesState extends State<Countries> {
  @override
  Widget build(BuildContext context) {
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
        body: ListView(
          children: CountryService.countries
              .map(
                (country) => GestureDetector(
                  onTap: () => Navigator.pushNamed(context, "/detail", arguments: country.name),
                  child: Container(
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
                      titleTextStyle: const TextStyle(fontSize: 20),
                        title: Text(country.name),
                        trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              country.favorite = ! country.favorite;
                            });
                          },
                          icon: Icon(
                            country.favorite ? Icons.favorite : Icons.favorite_border,
                            color: Colors.pinkAccent,
                          ),
                        )),
                  ),
                ),
              )
              .toList(),
        ));
  }
}
