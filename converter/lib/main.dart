import 'package:flutter/material.dart';
import 'package:converter/pages/CurenncyScreen.dart';
import 'package:converter/pages/WeightScreen.dart';
import 'package:converter/pages/LenghtScreen.dart';
import 'package:converter/pages/TempScreen.dart';
import 'package:converter/pages/VolumeScreen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 30, color: Colors.white),
          displayLarge: TextStyle(color: Colors.white),
          displayMedium: TextStyle(color: Colors.white),
          displaySmall: TextStyle(color: Colors.white),
          headlineLarge: TextStyle(color: Colors.white),
          headlineMedium: TextStyle(color: Colors.white),
          headlineSmall: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleSmall: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
          labelLarge: TextStyle(color: Colors.white),
          labelMedium: TextStyle(color: Colors.white),
          labelSmall: TextStyle(color: Colors.white),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 66, 42, 133),
        appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 25)),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2;

  static final List<Widget> _pages = <Widget>[
    const LenghtScreen(),
    const CurrencyScreen(),
    const WeightScreen(),
    const TempScreen(),
    const SquareScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Конвертер'),
        backgroundColor: Colors.deepPurple,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.deepPurple,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('lib/images/length.png')),
            label: 'Длина',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('lib/images/euro.png')),
            label: 'Валюта',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('lib/images/weight.png')),
            label: 'Вес',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('lib/images/temperature.png')),
            label: 'Температура',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('lib/images/square.png')),
            label: 'Объём',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.white,
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          color: Colors.white,
        ),
        unselectedIconTheme: const IconThemeData(color: Colors.white, size: 30),
        onTap: _onItemTapped,
      ),
    );
  }
}
