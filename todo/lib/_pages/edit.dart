import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../_database/db.dart';

class Edit extends StatefulWidget {
  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  final todoTask = Hive.box("Todobox");
  final _taskName = TextEditingController();
  final _taskDescription = TextEditingController();
  ToDoTask db = ToDoTask();
  @override
  void initState() {
    if (todoTask.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int arg = ModalRoute.of(context)!.settings.arguments as int;
    try {
      _taskName.text = db.toDoList[arg][0].toString();
      _taskDescription.text = db.toDoList[arg][1].toString();
    } catch (e) {}

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Edit",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xff052659))),
        flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[Color(0xff7DA0CA), Color(0xffC1E8FF)]))),
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color(0xff021024),
                  Color(0xff052659),
                  Color(0xff5483B3),
                  Color(0xff7DA0CA),
                  Color(0xffC1E8FF)
                ],
                tileMode: TileMode.clamp)),
        child: Column(
          children: [
            Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Color.fromARGB(115, 44, 44, 44),
                    ),
                    child: TextField(
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                      textAlign: TextAlign.center,
                      readOnly: false,
                      minLines: 2,
                      maxLines: 2,
                      maxLength: 40,
                      controller: _taskName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 20),
                    ),
                  ),
                )),
            Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Color.fromARGB(115, 44, 44, 44),
                    ),
                    child: TextField(
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                      expands: true,
                      maxLines: null,
                      readOnly: false,
                      controller: _taskDescription,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 18,
                      ),
                    ),
                  ),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 120,
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          deleteData(arg);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          padding:
                              const EdgeInsets.all(20), // Отступы внутри кнопки
                        ),
                        child: const Icon(Icons.delete)),
                  ),
                ),
                SizedBox(
                  width: 120,
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          changeData(arg);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          padding:
                              const EdgeInsets.all(20), // Отступы внутри кнопки
                        ),
                        child: const Icon(Icons.save)),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void changeData(arg) {
    setState(() {
      db.toDoList[arg][0] =
          _taskName.text == '' ? db.toDoList[arg][0] : _taskName.text;
      db.toDoList[arg][1] = _taskDescription.text;
      db.updateData();
    });
    Navigator.pop(context, true);
  }

  void deleteData(arg) {
    db.toDoList.remove(db.toDoList[arg]);
    db.updateData();
    Navigator.pop(context, true);
  }
}
