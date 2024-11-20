import 'package:flutter/material.dart';
import 'package:capital/database/db.dart';
import 'package:capital/constants/constants.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  List<Map<String, dynamic>> notes = [];
  bool loading = false;
  dynamic category;
  DateTime? startDate;
  DateTime? endDate;
  bool isSorted = true;
  final consts = Constants();

  Future<void> getList() async {
    final db = await CapitalDB.instance.database;

    String filter = 'category_id = ?';
    List<dynamic> filterArg = [category['id']];

    if (startDate != null && endDate != null) {
      filter += ' AND date BETWEEN ? AND ?';
      DateTime tempStart =
          DateTime(startDate!.year, startDate!.month, startDate!.day - 1);
      DateTime tempEnd =
          DateTime(endDate!.year, endDate!.month, endDate!.day + 1);
      filterArg.add(tempStart.toString());
      filterArg.add(tempEnd.toString());
    }

    List<Map<String, dynamic>> data =
        await db.query('notes', where: filter, whereArgs: filterArg);

    setState(() {
      notes = List.from(data);
      notes.sort((a, b) => isSorted
          ? a['date'].compareTo(b['date'])
          : b['date'].compareTo(a['date']));
      loading = true;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var arg =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      category = arg['arg'];
    });
    getList();
  }

  void _deleteAlarm(note) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Подверждение'),
            content: Text(
                'Вы действительно хотите удалить запись "${note['title']}"'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Нет')),
              TextButton(
                  onPressed: () => {
                        deleteNote(note['id']),
                        Navigator.of(context).pop(),
                      },
                  child: const Text('Да'))
            ],
          );
        });
  }

  void deleteNote(note) async {
    final db = CapitalDB.instance;
    db.deleteNotes(note);
    setState(() {
      getList();
    });
  }

  Future<void> selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: startDate ?? DateTime.now(),
        end: endDate ?? DateTime.now(),
      ),
    );
    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
      getList();
    }
  }

  void toggleSort() {
    setState(() {
      isSorted = !isSorted;
      getList();
    });
  }

  void resetDateFilter() {
    setState(() {
      startDate = null;
      endDate = null;
    });
    getList();
  }

  @override
  Widget build(BuildContext context) {
    if (!loading) {
      return const CircularProgressIndicator();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(category['name']),
        flexibleSpace: consts.appbarGradien,
        actions: [
          IconButton(
            icon: Icon(isSorted ? Icons.arrow_upward : Icons.arrow_downward),
            onPressed: toggleSort,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: resetDateFilter,
          ),
        ],
      ),
      body: Container(
        decoration: consts.gradientBox,
        child: Column(
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: selectDateRange,
                    child: const Text("Выбрать период"),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onLongPress: () => _deleteAlarm(notes[index]),
                          child: Container(
                            decoration: BoxDecoration(
                                color:
                                    Color(category['color']).withOpacity(0.7),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(16))),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        notes[index]['title'],
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                          'Сумма ${notes[index]['sum'].toString()}')
                                    ],
                                  ),
                                  Text(
                                      'Дата ${notes[index]['date'].toString().substring(0, 10)}')
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
