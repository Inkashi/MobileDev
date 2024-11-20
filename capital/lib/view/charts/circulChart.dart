import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:capital/database/db.dart';

class CirculChart extends StatefulWidget {
  final bool type;
  const CirculChart({super.key, required this.type});

  @override
  State<CirculChart> createState() => _CirculChartState();
}

class _CirculChartState extends State<CirculChart> {
  Map<String, Map<String, dynamic>> categoryData = {};
  bool isLoading = true;

  DateTime? startDate;
  DateTime? endDate;

  Future<Map<String, Map<String, dynamic>>> getCategoryData() async {
    final db = await CapitalDB.instance.database;
    final List<Map<String, dynamic>> categories = await db
        .query('categories', where: 'type = ?', whereArgs: [widget.type]);

    Map<String, Map<String, dynamic>> result = {};

    for (var category in categories) {
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

      final List<Map<String, dynamic>> notes = await db.query(
        'notes',
        where: filter,
        whereArgs: filterArg,
      );

      double sum = 0;
      for (var note in notes) {
        sum += note['sum'];
      }

      result[category['name']] = {
        'sum': sum,
        'color': Color(category['color']).withOpacity(1),
      };
    }

    return result;
  }

  Future<void> _loadData() async {
    final data = await getCategoryData();
    setState(() {
      categoryData = data;
      isLoading = false;
    });
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
          start: startDate ?? DateTime.now(), end: endDate ?? DateTime.now()),
    );

    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
      _loadData();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final List<PieChartSectionData> sections = categoryData.entries
        .map(
          (entry) => PieChartSectionData(
            color: entry.value['color'],
            value: entry.value['sum'],
            title: '${entry.key}\n${entry.value['sum']}',
            radius: 120,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        )
        .toList();
    dynamic sum = sections.map((e) => e.value).reduce((a, b) => a + b);
    final List<PieChartSectionData> sections2 = [
      PieChartSectionData(
        color: Colors.grey,
        value: 100,
        title: 'Данных нет',
        radius: 120,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      )
    ];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            widget.type ? 'Доходы' : 'Траты',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Выбрать период'),
              IconButton(
                icon: const Icon(Icons.date_range),
                onPressed: _selectDateRange,
              ),
            ],
          ),
          if (startDate != null && endDate != null)
            Text(
              '${startDate!.toLocal().toString().substring(0, 10)} - ${endDate!.toLocal().toString().substring(0, 10)}',
              style: const TextStyle(fontSize: 16),
            ),
          Expanded(
            child: PieChart(
              PieChartData(
                sections: sum > 0 ? sections : sections2,
                centerSpaceRadius: 70,
                sectionsSpace: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
