import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../_database/db.dart';

class Create extends StatefulWidget {
  const Create({super.key});

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  final todoTask = Hive.box("TodoBox");
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

  final _taskName = TextEditingController();
  final _taskDescription = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Create ToDo",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xff052659),
            ),
          ),
          flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[Color(0xff7DA0CA), Color(0xffC1E8FF)])))),
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
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Color.fromARGB(115, 44, 44, 44),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _taskName,
                  decoration: InputDecoration(hintText: 'Title'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 18,
                  ),
                  maxLength: 40,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 400,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Color.fromARGB(115, 44, 44, 44),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _taskDescription,
                  decoration: InputDecoration(hintText: "Description"),
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 18,
                  ),
                  expands: true,
                  maxLines: null,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  createData();
                },
                child: Text("Create"))
          ],
        ),
      ),
    );
  }

  void createData() {
    setState(() {
      if (_taskName.text == '') {
      } else {
        db.toDoList.add([_taskName.text, _taskDescription.text, false]);
        print(db.toDoList);
        db.updateData();
      }
    });
    Navigator.pop(context, true);
  }
}
