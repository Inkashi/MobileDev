import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weatherapp/constants/constants.dart';

class ContryBase {
  static final consts = Constants();
  List selectedContry = [];
  final _myBox = Hive.box(consts.box_key);

  void createInitialData() {
    selectedContry = [
      {'name': 'Москва', 'isSelected': false},
      {'name': 'Санкт-Петербург', 'isSelected': false},
      {'name': 'Новосибирск', 'isSelected': false},
      {'name': 'Екатеринбург', 'isSelected': false},
      {'name': 'Казань', 'isSelected': false},
      {'name': 'Нижний Новгород', 'isSelected': false},
      {'name': 'Челябинск', 'isSelected': false},
      {'name': 'Самара', 'isSelected': false},
      {'name': 'Омск', 'isSelected': false},
      {'name': 'Ростов-на-Дону', 'isSelected': false},
      {'name': 'Уфа', 'isSelected': false},
      {'name': 'Красноярск', 'isSelected': false},
      {'name': 'Пермь', 'isSelected': false},
      {'name': 'Волгоград', 'isSelected': false},
      {'name': 'Воронеж', 'isSelected': false},
      {'name': 'Ханты-Мансийск', 'isSelected': false},
      {'name': 'Тюмень', 'isSelected': false},
    ];
  }

  void loadData() {
    selectedContry = _myBox.get(consts.table_key, defaultValue: []);
  }

  void updateData() {
    _myBox.put(consts.table_key, selectedContry);
  }
}
