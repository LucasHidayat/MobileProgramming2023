import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController countryname = TextEditingController();
  String country = "";
  String code = "";

  String countryName = "";
  String countryRegion = "";
  String countryCode = "";
  String countryCurrency = "";
  String countryCapital = "";
  String countryPopulation = "";
  String countrySurfaceArea = "";

  var img = const NetworkImage("", scale: 0.5);
  var placeHolder = const AssetImage('assets/images/placeholder.png');

  bool countryExists = false;
  bool flagExists = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.teal),
        home: Scaffold(
            appBar: AppBar(title: const Text("Country Info Finder")),
            body: SingleChildScrollView(
                child: Center(
              child: Column(children: [
                TextField(
                  controller: countryname,
                  decoration: InputDecoration(
                      hintText: "Insert Country Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                ),
                ElevatedButton(
                    onPressed: _getCountryData, child: const Text("Search")),
                Center(
                    child: flagExists
                        ? Image(image: img)
                        : Image(image: placeHolder)),
                Center(
                    child: countryExists
                        ? Center(
                            child: Column(children: [
                              Text(
                                "Name : $countryName\nRegion : $countryRegion\nCode : $countryCode\nCurrency : $countryCurrency\nCapital : $countryCapital\nPopulation : $countryPopulation\nSurface Area : $countrySurfaceArea",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ]),
                          )
                        : const Text(
                            "Please Input Valid Country Name",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          )),
              ]),
            ))));
  }

  Future<void> _getCountryData() async {
    country = countryname.text;
    var apiKey = "4MVI4vhwq9kGz9rHntZ2Cw==2EexMRfvCYtXrmSI";
    var url1 = "https://api.api-ninjas.com/v1/country?name=$country";
    var countryParse = Uri.parse(url1);
    var checkJsonEmpty = "";

    var countryResponse =
        await http.get(countryParse, headers: {'X-Api-Key': apiKey});

    var countryRescode = countryResponse.statusCode;
    if (countryRescode == 200 && country.length > 2) {
      var jsonData = countryResponse.body;
      var parsedData = jsonDecode(jsonData);

      checkJsonEmpty = parsedData.toString();

      if (checkJsonEmpty.length > 2) {
        countryCode = parsedData[0]["iso2"];
        countryCode = countryCode.toString();

        setState(() {
          countryExists = true;
          countryName = parsedData[0]["name"];
          countryRegion = parsedData[0]["region"];
          countryCode = parsedData[0]["iso2"].toString();
          countryCurrency = parsedData[0]["currency"]["name"];
          countryCapital = parsedData[0]["capital"];
          countryPopulation = parsedData[0]["population"].toString();
          countrySurfaceArea = parsedData[0]["surface_area"].toString();
          flagExists = true;
        });
      } else {
        setState(() {
          countryExists = false;
          flagExists = false;
        });
      }
    } else {
      setState(() {
        countryExists = false;
        flagExists = false;
      });
    }

    var url2 = "https://flagsapi.com/$countryCode/flat/64.png";
    var flagParse = Uri.parse(url2);

    var flagResponse = await http.get(flagParse);

    var flagRescode = flagResponse.statusCode;
    if (flagRescode == 200 && flagExists) {
      setState(() {
        img = NetworkImage(url2, scale: 0.5);
      });
    }

    setState(() {});
  }
}
