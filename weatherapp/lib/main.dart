import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weatherapp/constants/constants.dart';
import 'package:weatherapp/pages/contry_page.dart';
import 'package:weatherapp/pages/main_page.dart';
import 'package:weatherapp/database/contry_base.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final consts = Constants();
  await Hive.initFlutter();
  var box = await Hive.openBox(consts.box_key);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  var consts = Constants();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WeatherApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: consts.primaryColor,
          appBarTheme: AppBarTheme(
              backgroundColor: consts.primaryColor,
              titleTextStyle: consts.fontfamily),
          textTheme: TextTheme(
              bodyMedium: consts.fontfamily,
              bodyLarge: consts.fontfamily,
              bodySmall: consts.fontfamily)),
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        '/contry': (context) => const ContryPage(),
        '/main': (context) => const MainPage()
      },
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static final consts = Constants();
  final contryList = Hive.box(consts.box_key);
  ContryBase db = ContryBase();

  @override
  void initState() {
    if (contryList.get(consts.table_key) == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 3), () {
        returnPage();
      });
    });
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('lib/assets/image/cat.png'),
        Text('Немножко подождите', style: consts.fontfamily),
      ],
    )));
  }

  void returnPage() {
    if (db.selectedContry.any((city) => city['isSelected'] == true)) {
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      Navigator.pushReplacementNamed(context, '/contry');
    }
  }
}
