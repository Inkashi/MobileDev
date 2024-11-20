import 'package:flutter/material.dart';
import 'bottomNav.dart';
import 'package:capital/database/db.dart';
import 'Dialogs/createNotesDialog.dart';
import 'package:capital/constants/constants.dart';

class capitalData extends StatefulWidget {
  const capitalData({super.key});

  @override
  State<capitalData> createState() => _capitalDataState();
}

class _capitalDataState extends State<capitalData> {
  List<Map<String, dynamic>> arr = [];
  List<Map<String, dynamic>> notes = [];
  Map<int, List<Map<String, dynamic>>> categorizedNotes = {};
  bool criteria = true;
  int currIndex = 0;
  final consts = Constants();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var arg =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      criteria = arg['criteria'];
      getList(criteria);
    });
  }

  Future<void> getList(criteria) async {
    final db = await CapitalDB.instance.database;
    final List<Map<String, dynamic>> data =
        await db.query('categories', where: 'type = ?', whereArgs: [criteria]);
    List<Map<String, dynamic>> temp = await db.query('notes');
    List<Map<String, dynamic>> data2 = List.from(temp);
    data2.sort((a, b) => b['date'].compareTo(a['date']));
    Map<int, List<Map<String, dynamic>>> groupedNotes = {};
    for (var note in data2) {
      int categoryId = note['category_id'];
      if (!groupedNotes.containsKey(categoryId)) {
        groupedNotes[categoryId] = [];
      }
      groupedNotes[categoryId]!.add(note);
    }

    setState(() {
      arr = data;
      notes = data2;
      categorizedNotes = groupedNotes;

      if (!criteria) {
        currIndex = 2;
      } else {
        currIndex = 0;
      }
    });
  }

  Future<void> deleteCategory(int categoryId) async {
    final db = CapitalDB.instance;
    await db.deleteCategory(categoryId);

    setState(() {
      getList(criteria);
    });
  }

  void _deleteAlarm(category) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Подверждение'),
            content: Text(
                'Вы действительно хотите удалить категорию "${category['name']}"'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Нет')),
              TextButton(
                  onPressed: () => {
                        deleteCategory(category['id']),
                        Navigator.of(context).pop(),
                      },
                  child: const Text('Да'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(criteria ? 'Доходы' : 'Траты')),
        flexibleSpace: consts.appbarGradien,
      ),
      body: arr.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: consts.gradientBox,
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ListView.builder(
                    itemCount: arr.length,
                    itemBuilder: (context, index) {
                      var category = arr[index];
                      var temp = categorizedNotes[category['id']] ?? [];
                      var notesToDisplay = temp.take(3).toList();
                      return GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/notes',
                            arguments: {'arg': category}),
                        onLongPress: () => _deleteAlarm(category),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(16)),
                                color:
                                    Color(category['color']).withOpacity(0.6)),
                            child: Column(
                              children: [
                                Container(
                                  height: 30,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(3, 3),
                                        ),
                                      ],
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(16)),
                                      color: Color(category['color'])
                                          .withOpacity(1)),
                                  child: Center(
                                      child: Text(
                                    category['name'],
                                    style: const TextStyle(fontSize: 16),
                                  )),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: notesToDisplay.length,
                                  itemBuilder: (context, noteIndex) {
                                    var note = notesToDisplay[noteIndex];
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(note['title']),
                                          Text('Сумма: ${note['sum']}'),
                                          Text(
                                              'Дата: ${note['date'].toString().substring(0, 10)}')
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
      bottomNavigationBar: ShareNavgiationBar(currIndex: currIndex),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => NotesDialog(criteria: criteria));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
