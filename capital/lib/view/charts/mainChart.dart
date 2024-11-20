import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:capital/database/db.dart';

class VerticalChart extends StatefulWidget {
  const VerticalChart({super.key});

  @override
  State<VerticalChart> createState() => _VerticalChartState();
}

class _VerticalChartState extends State<VerticalChart> {
  Map<String, double> positiveSum = {};
  Map<String, double> negativeSum = {};
  dynamic combinedKeys;
  bool isLoading = true;
  final monthses = [
    "январь",
    "февраль",
    "март",
    "апрель",
    "май",
    "июнь",
    "июль",
    "август",
    "сентябрь",
    "октябрь",
    "ноябрь",
    "декабрь"
  ];

  Future<void> _loadData() async {
    final db = await CapitalDB.instance.database;

    positiveSum = await monthSum(db, true);
    negativeSum = await monthSum(db, false);
    setState(() {
      isLoading = false;
    });
  }

  Future<Map<String, double>> monthSum(dynamic db, bool criteria) async {
    final categories =
        await db.query('categories', where: 'type = ?', whereArgs: [criteria]);
    Map<String, double> monthlySums = {};

    for (var category in categories) {
      final notes = await db.query(
        'notes',
        where: 'category_id = ? AND date >= ?',
        whereArgs: [category['id'], '${DateTime.now().year}-01-01'],
      );

      for (var note in notes) {
        final date = DateTime.parse(note['date']);
        final month = date.month;
        final sum = note['sum'];
        var strMonth = monthses[month - 1];
        monthlySums[strMonth] =
            (monthlySums[strMonth] ?? 0) + (criteria ? sum : -sum);
      }
    }

    return monthlySums;
  }

  List<BarChartGroupData> _buildBarGroups() {
    final months =
        monthses.sublist(DateTime.now().month - 4, DateTime.now().month);
    return List.generate(months.length, (e) {
      final month = months[e];
      return BarChartGroupData(
        x: e,
        barRods: [
          BarChartRodData(
              toY: positiveSum[month] ?? 0, color: Colors.blue, width: 15),
          BarChartRodData(
              toY: negativeSum[month] ?? 0, color: Colors.red, width: 15),
        ],
      );
    });
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

    return Column(
      children: [
        const Text(
          'Общая информация',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: (positiveSum.values.isNotEmpty
                      ? positiveSum.values.reduce((a, b) => a > b ? a : b)
                      : 0) *
                  1.2,
              minY: (negativeSum.values.isNotEmpty
                      ? negativeSum.values.reduce((a, b) => a < b ? a : b)
                      : 0) *
                  1.2,
              barGroups: _buildBarGroups(),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 60),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      final months = monthses.sublist(
                          DateTime.now().month - 4, DateTime.now().month);
                      return Text(months[index],
                          style: const TextStyle(fontSize: 16));
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
      ],
    );
  }
}
