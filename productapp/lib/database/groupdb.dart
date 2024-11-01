import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:productapp/models/product_model.dart';

class Favorite {
  List<dynamic> groups = [];
  final _myBox = Hive.box('groupsBox');

  void createInitialData() {
    groups = [];
  }

  void loadData() {
    groups = _myBox.get('groups', defaultValue: []);
  }

  void updateData() {
    _myBox.put("groups", groups);
  }
}
