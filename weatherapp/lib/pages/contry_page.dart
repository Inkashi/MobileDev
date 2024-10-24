import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weatherapp/constants/constants.dart';
import 'package:weatherapp/database/contry_base.dart';

class ContryPage extends StatefulWidget {
  const ContryPage({super.key});

  @override
  State<ContryPage> createState() => _ContryPageState();
}

class _ContryPageState extends State<ContryPage> {
  static final consts = Constants();
  final contryList = Hive.box(consts.box_key);
  ContryBase db = ContryBase();

  @override
  void initState() {
    db.createInitialData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Выберите нужные вам города'),
      ),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
              itemCount: db.selectedContry.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        db.selectedContry[index]['name'],
                      ),
                      Transform.scale(
                        scale: 1.5,
                        child: Checkbox(
                            activeColor: consts.secondColor,
                            value: db.selectedContry[index]['isSelected'],
                            onChanged: (bool? newValue) {
                              setState(() {
                                db.selectedContry[index]['isSelected'] =
                                    newValue ?? false;
                              });
                            }),
                      )
                    ],
                  ),
                );
              }),
        ),
        if (db.selectedContry.any((city) => city['isSelected'] == true))
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: consts.secondColor,
                        foregroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5)))),
                    onPressed: () {
                      selectContryandNaigate();
                    },
                    child: const Text("Выбрать"))),
          ),
      ]),
    );
  }

  void selectContryandNaigate() {
    setState(() {
      db.updateData();
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/main',
        (Route<dynamic> route) => false,
      );
    });
  }
}
