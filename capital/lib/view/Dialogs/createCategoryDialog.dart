import 'package:capital/database/db.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class CategoryDialog extends StatefulWidget {
  final bool criteria;
  final VoidCallback onCategoryAdded;

  const CategoryDialog(
      {super.key, required this.criteria, required this.onCategoryAdded});

  @override
  _CategoryDialogState createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  final _nameController = TextEditingController();

  int generateColor() {
    return (Random().nextDouble() * 0xFFFFFF).toInt();
  }

  Future<void> addData(name, color) async {
    final db = CapitalDB.instance;
    await db.addCategory(name, color, widget.criteria);
    widget.onCategoryAdded();
  }

  void _saveCategory() async {
    String name = _nameController.text;
    if (name.isNotEmpty) {
      addData(name, generateColor());
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, заполните все поля')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Добавить категорию'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Название категории'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        TextButton(
          onPressed: _saveCategory,
          child: const Text('Сохранить'),
        ),
      ],
    );
  }
}
