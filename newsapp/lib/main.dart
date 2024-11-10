import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'view/newsFeed.dart';
import 'view/infoNews.dart';
import 'constants/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://jijzmhowblzhtdqjsjmy.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImppanptaG93Ymx6aHRkcWpzam15Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzExNjU4OTksImV4cCI6MjA0Njc0MTg5OX0.bywl01ldxkMsCkqToG1rHqKuyuc6mHXqy0iHeH3827g",
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final consts = Constants();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          appBarTheme: AppBarTheme(titleTextStyle: consts.fontfamily),
          textTheme: TextTheme(
              bodyMedium: consts.fontfamily,
              bodyLarge: consts.fontfamily,
              bodySmall: consts.fontfamily)),
      debugShowCheckedModeBanner: false,
      initialRoute: '/main',
      routes: {
        '/main': (context) => const newsFeed(),
        '/newsCard': (context) => Infonews(),
      },
    );
  }
}
