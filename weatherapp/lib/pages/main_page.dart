import 'dart:convert';
import 'package:weatherapp/models/Weather.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weatherapp/constants/constants.dart';
import 'package:weatherapp/database/contry_base.dart';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static final consts = Constants();
  final contryList = Hive.box(consts.box_key);
  ContryBase db = ContryBase();
  var activeContry;
  List<Weather> weather_list = [];
  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() async {
    if (contryList.get(consts.table_key) == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }

    activeContry = db.selectedContry
        .firstWhere((city) => city['isSelected'] == true)['name'];
    fetchWeatherData();
  }

  void fetchWeatherData() async {
    List<Weather> fetchedWeather = await fetchWeather(activeContry);
    setState(() {
      weather_list = fetchedWeather;
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryWidth = MediaQuery.of(context).size.width * 0.8;
    final selectedCities =
        db.selectedContry.where((city) => city['isSelected'] == true).toList();
    selectedCities.add({
      'name': 'изменить города',
    });
    return Scaffold(
      appBar: AppBar(
        actions: [
          const Spacer(),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
                alignment: Alignment.center,
                dropdownColor: consts.primaryColor,
                icon: const SizedBox(),
                hint: const Text("Выберите город"),
                value: activeContry,
                items: selectedCities.map<DropdownMenuItem<String>>((city) {
                  return DropdownMenuItem<String>(
                    value: city['name'],
                    child: Text(city['name'],
                        style: city['name'] == activeContry
                            ? consts.fontfamily.copyWith(fontSize: 30)
                            : consts.fontfamily),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue == 'изменить города') {
                    Navigator.pushNamed(context, '/contry');
                  } else {
                    setState(() {
                      activeContry = newValue;
                      weather_list = [];
                      fetchWeatherData();
                    });
                  }
                }),
          ),
          const Spacer()
        ],
      ),
      body: weather_list.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: SizedBox(
                    width: primaryWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Сейчас",
                          style: TextStyle(fontSize: 30),
                        ),
                        Image.network(
                          "http:${weather_list[0].img}",
                          fit: BoxFit.contain,
                          height: 140,
                        ),
                        Text(
                          "${weather_list[0].temperature.toString()}°",
                          style: const TextStyle(fontSize: 40),
                        ),
                        Text(
                          weather_list[0].conditionText,
                          style: consts.fontfamily,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  const Text("Скорость ветра",
                                      style: TextStyle(fontSize: 20)),
                                  Text(
                                    "${weather_list[0].windSpeed.toString()}км/ч",
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Text(
                                    "Влажность",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    weather_list[0].humidity.toString(),
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: weather_list.length - 1,
                    itemBuilder: (BuildContext context, int index) {
                      index += 1;
                      return Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: SizedBox(
                          width: primaryWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  "${weather_list[index].day}/${weather_list[index].date.day}.${weather_list[index].date.month}"),
                              Image.network("http:${weather_list[index].img}"),
                              Text(
                                  "${weather_list[index].temperature}°/${weather_list[index].maxTemperature}°")
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Future<List<Weather>> fetchWeather(String city) async {
    final url =
        "https://api.weatherapi.com/v1/forecast.json?key=${consts.apiKey}&q=$city&days=7&aqi=no&alerts=no&lang=ru";

    try {
      final response = await http.get(Uri.parse(url));
      String decodedResponse = utf8.decode(response.bodyBytes);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(decodedResponse);
        List<Weather> temp = processWeatherData(jsonData);
        temp[0].temperature = jsonData['current']['temp_c'];
        temp[0].windSpeed = jsonData['current']['wind_mph'];
        temp[0].humidity = jsonData['current']['humidity'];
        return temp;
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      print('Ошибка: $e');
      return List.empty();
    }
  }

  List<Weather> processWeatherData(Map<String, dynamic> json) {
    List<Weather> weatherRecords = [];
    print(json['forecast']['forecastday'][1]);
    for (int i = 0; i < 7; i++) {
      weatherRecords.add(Weather.fromJson(json['forecast']['forecastday'][i]));
    }

    return weatherRecords;
  }
}
