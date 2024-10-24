import 'package:flutter/material.dart';

class Weather {
  DateTime date;
  String day;
  double temperature;
  double maxTemperature;
  String conditionText;
  double windSpeed;
  int humidity;
  String img;

  Weather({
    required this.date,
    required this.day,
    required this.temperature,
    required this.maxTemperature,
    required this.humidity,
    required this.windSpeed,
    required this.conditionText,
    required this.img,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        day: convertDay(DateTime.parse(json["date"]).weekday),
        temperature: json['day']['mintemp_c'],
        maxTemperature: json['day']['maxtemp_c'],
        humidity: json['day']['avghumidity'],
        windSpeed: json['day']['maxwind_kph'],
        conditionText: json['day']['condition']['text'],
        img: json['day']['condition']['icon'],
        date: DateTime.parse(json['date']));
  }

  static String convertDay(int day) {
    List<String> daysOfWeek = [
      'Понедельник',
      'Вторник',
      'Среда',
      'Четверг',
      'Пятница',
      'Суббота',
      'Воскресенье',
    ];
    return daysOfWeek[day - 1];
  }
}
