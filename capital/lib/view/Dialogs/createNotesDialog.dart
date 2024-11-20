import 'package:capital/database/db.dart';
import 'package:flutter/material.dart';
import 'createCategoryDialog.dart';

class NotesDialog extends StatefulWidget {
  final bool criteria;
  const NotesDialog({
    super.key,
    required this.criteria,
  });

  @override
  State<NotesDialog> createState() => __NotesDialogStateState();
}

class __NotesDialogStateState extends State<NotesDialog> {
  List<Map<String, dynamic>> arr = [];
  final titleController = TextEditingController();
  final sumController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  int? selectedCategoryId;

  Future<void> addNote(
      int categoryId, String title, double sum, DateTime date) async {
    final db = await CapitalDB.instance.database;
    await db.insert('notes', {
      'category_id': categoryId,
      'title': title,
      'sum': sum,
      'date': date.toString(),
    });

    Navigator.pushReplacementNamed(context, '/money',
        arguments: {'criteria': widget.criteria});
  }

  Future<void> getList(criteria) async {
    final db = await CapitalDB.instance.database;
    final List<Map<String, dynamic>> data =
        await db.query('categories', where: 'type = ?', whereArgs: [criteria]);
    setState(() {
      arr = data;
      selectedCategoryId = arr[0]['id'];
    });
  }

  @override
  void initState() {
    super.initState();
    getList(widget.criteria);
  }

  @override
  Widget build(BuildContext context) {
    return arr.isEmpty
        ? const CircularProgressIndicator()
        : AlertDialog(
            title: const Text('Добавить запись'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Заголовок'),
                ),
                TextField(
                  controller: sumController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Сумма'),
                ),
                ListTile(
                  title: Text("${selectedDate.toLocal()}".substring(0, 10)),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2023),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                ),
                DropdownButton<int>(
                  hint: const Text("Выберите категорию"),
                  value: selectedCategoryId,
                  onChanged: (newValue) {
                    setState(() {
                      selectedCategoryId = newValue;
                    });
                  },
                  items: arr.map((category) {
                    return DropdownMenuItem<int>(
                      value: category['id'],
                      child: Text(category['name']),
                    );
                  }).toList()
                    ..add(
                      DropdownMenuItem<int>(
                        value: null,
                        child: TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => CategoryDialog(
                                  criteria: widget.criteria,
                                  onCategoryAdded: () {
                                    getList(widget.criteria);
                                    setState(() {
                                      arr = arr;
                                    });
                                  },
                                ),
                              );
                            },
                            child: const Text('Создать категорию')),
                      ),
                    ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Отмена'),
              ),
              TextButton(
                onPressed: () {
                  String title = titleController.text;
                  String sumText = sumController.text;
                  if (title.isNotEmpty &&
                      sumText.isNotEmpty &&
                      selectedCategoryId != null) {
                    double? sum = double.tryParse(sumText);
                    if (sum != null) {
                      addNote(selectedCategoryId!, title, sum, selectedDate);
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Пожалуйста, введите корректную сумму')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Пожалуйста, заполните все поля')),
                    );
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Сохранить'),
              ),
            ],
          );
  }
}
