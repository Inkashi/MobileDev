import 'package:flutter/material.dart';
import 'package:productapp/views/home.dart';
import 'package:productapp/views/category.dart';
import 'package:productapp/views/productCard.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:productapp/views/products.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:productapp/constants/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  var box = await Hive.openBox('groupsBox');
  await Supabase.initialize(
    url: "https://pmqfdiwbudtfjuyndndw.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBtcWZkaXdidWR0Zmp1eW5kbmR3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzAxMTUwNDYsImV4cCI6MjA0NTY5MTA0Nn0.wyyb8_N-3x61hQMG1VcNNW1M5cpfeYbS9DN5A_S_kOQ",
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
      initialRoute: '/home',
      routes: {
        '/home': (context) => const Home(),
        '/catalog': (context) => const Category(),
        '/product_catalog': (context) => const Productcatalog(),
        '/product_card': (context) => const ProductCard(),
      },
    );
  }
}
