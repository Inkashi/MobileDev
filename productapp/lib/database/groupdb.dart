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

//Если создавать группы в которые можно будет добавлять продукты
  // void createGroup(String groupName) {
  //   groups.add({'name': groupName, 'items': []});
  //   updateData();
  // }

  // void addToGroup(String name, dynamic item) {
  //   final group = groups.firstWhere((e) => e['name'] == name);
  //   group['items'].add(item);
  //   updateData();
  // }
}
