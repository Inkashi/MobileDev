import 'dart:math';

import 'package:flutter/material.dart';
import 'package:todo/_pages/create.dart';
import 'package:todo/_pages/edit.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/_database/db.dart';

void main() async {
  await Hive.initFlutter();
  var box = await Hive.openBox('TodoBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      title: "Todo",
      initialRoute: '/home',
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => const Home(),
        '/create': (context) => const Create(),
        '/edit': (context) => Edit(),
      },
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todoTask = Hive.box("TodoBox");
  ToDoTask db = ToDoTask();
  List<dynamic> filtredTasks = [];

  @override
  void initState() {
    db.loadData();
    filtredTasks = db.toDoList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Center(
            child: Text(
          "Todo List",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff052659),
          ),
        )),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Color(0xff7DA0CA), Color(0xffC1E8FF)])),
        ),
        actions: [
          PopupMenuButton<String>(
            iconColor: Colors.black,
            onSelected: (String value) {
              setState(() {
                switch (value) {
                  case 'all':
                    filtredTasks = db.toDoList;
                    break;
                  case 'completed':
                    filtredTasks =
                        db.toDoList.where((todo) => todo[2] == true).toList();
                    break;
                  case 'incompleted':
                    filtredTasks =
                        db.toDoList.where((todo) => todo[2] == false).toList();
                    break;
                  default:
                    break;
                }
              });
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'all',
                  child: Text('Все задачи'),
                ),
                const PopupMenuItem(
                  value: 'completed',
                  child: Text('Выполненные'),
                ),
                const PopupMenuItem(
                  value: 'incompleted',
                  child: Text('Невыполненные'),
                ),
              ];
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigate(context, 0, '/create');
          },
          label: const Text('Create ToDo')),
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
        child: filtredTasks.isEmpty
            ? SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: const Center(
                  child: Text(
                    'Список пуст',
                    style: TextStyle(
                        color: Color(0xff052659),
                        fontSize: 20,
                        fontWeight: FontWeight.w900),
                  ),
                ),
              )
            : ListView.builder(
                itemCount: filtredTasks.length,
                itemBuilder: (BuildContext context, int index) {
                  final task = filtredTasks[index];
                  return GestureDetector(
                    onTap: () => Navigate(context, index, '/edit'),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: task[2]
                              ? const Color.fromARGB(115, 44, 44, 44)
                              : const Color.fromARGB(197, 34, 34, 34),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    task[0].toString(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Checkbox(
                                    value: task[2],
                                    onChanged: (bool? value) {
                                      setState(() {
                                        task[2] = value!;
                                        db.updateData();
                                      });
                                    }))
                          ],
                        ),
                      ),
                    ),
                  );
                }),
      ),
    );
  }

  void Navigate(BuildContext context, int index, String path) async {
    final result = await Navigator.pushNamed(context, path, arguments: index);

    if (result != null && result is bool && result) {
      setState(() {
        db.loadData();
      });
    }
  }
}
