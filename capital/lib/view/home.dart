import 'package:capital/constants/constants.dart';
import 'package:flutter/material.dart';
import 'bottomNav.dart';
import 'charts/mainChart.dart';
import 'charts/circulChart.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final consts = Constants();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Главная')),
        flexibleSpace: consts.appbarGradien,
      ),
      body: Container(
        decoration: consts.gradientBox,
        child: ListView(
          children: const [
            SizedBox(
              height: 300,
              child: VerticalChart(),
            ),
            SizedBox(
              height: 500,
              child: CirculChart(
                type: true,
              ),
            ),
            SizedBox(
              height: 500,
              child: CirculChart(
                type: false,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const ShareNavgiationBar(
        currIndex: 1,
      ),
    );
  }
}
