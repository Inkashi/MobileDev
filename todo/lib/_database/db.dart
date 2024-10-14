import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ToDoTask {
  List toDoList = [];
  final _myBox = Hive.box('ToDoBox');

  void createInitialData() {
    toDoList = [];
  }

  void loadData() {
    toDoList = _myBox.get('TODOLIST', defaultValue: []);
  }

  void updateData() {
    _myBox.put("TODOLIST", toDoList);
  }
}
