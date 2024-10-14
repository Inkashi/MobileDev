import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const CalendarApp());
}

class CalendarApp extends StatelessWidget {
  const CalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calendar',
      theme: ThemeData.dark(),
      home: CalendarHomePage(),
    );
  }
}

class CalendarHomePage extends StatefulWidget {
  const CalendarHomePage({super.key});

  @override
  _CalendarHomePageState createState() => _CalendarHomePageState();
}

class _CalendarHomePageState extends State<CalendarHomePage> {
  final DateTime _currentDate = DateTime.now();
  late DateTime _displayedMonth;

  @override
  void initState() {
    super.initState();
    _displayedMonth = DateTime(_currentDate.year, _currentDate.month);
  }

  void _changeMonth(int value) {
    setState(() {
      _displayedMonth =
          DateTime(_displayedMonth.year, _displayedMonth.month + value);
    });
  }

  void _goToToday() {
    setState(() {
      _displayedMonth = DateTime(_currentDate.year, _currentDate.month);
    });
  }

  List<DateTime?> _generateDaysInMonth(DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month, 0);
    final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    List<DateTime?> days = [];

    for (int i = 0; i < firstDayOfMonth.weekday; i++) {
      days.add(null);
    }

    for (int day = 1; day <= daysInMonth; day++) {
      days.add(DateTime(month.year, month.month, day));
    }

    return days;
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = _generateDaysInMonth(_displayedMonth);
    final isCurrentMonth = _displayedMonth.year == _currentDate.year &&
        _displayedMonth.month == _currentDate.month;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          if (!isCurrentMonth)
            IconButton(
              icon: const Icon(Icons.today),
              onPressed: _goToToday,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => _changeMonth(-1)),
                Text(
                  DateFormat.yMMMM().format(_displayedMonth),
                  style: const TextStyle(fontSize: 20),
                ),
                IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () => _changeMonth(1)),
              ],
            ),
            GridView.count(
              crossAxisCount: 7,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(7, (index) {
                const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                return Center(
                  child: Text(
                    days[index],
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                );
              }),
            ),
            Expanded(
              child: GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.velocity.pixelsPerSecond.dx > 0) {
                    _changeMonth(-1);
                  } else if (details.velocity.pixelsPerSecond.dx < 0) {
                    _changeMonth(1);
                  }
                },
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: GridView.builder(
                    key: ValueKey<DateTime>(_displayedMonth),
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                    ),
                    itemCount: daysInMonth.length,
                    itemBuilder: (context, index) {
                      final DateTime? date = daysInMonth[index];
                      return Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: _blockcolor(date),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: date != null
                            ? Text(date.day.toString())
                            : const SizedBox.shrink(),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _blockcolor(DateTime? day) {
    if (day == null) {
      return Colors.transparent;
    }
    if (day.year == _currentDate.year &&
        day.month == _currentDate.month &&
        day.day == _currentDate.day) {
      return Colors.deepOrange;
    } else if (day.year == _currentDate.year &&
        day.month == _currentDate.month) {
      return Colors.deepPurpleAccent;
    } else {
      return Colors.grey;
    }
  }
}
