import 'package:flutter/material.dart';
import 'package:productapp/views/Navigationbar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:productapp/database/groupdb.dart';
import 'package:productapp/models/product_model.dart';
import 'package:productapp/constants/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final favorite = Hive.box("groupsBox");
  Favorite db = Favorite();
  final consts = Constants();

  @override
  void initState() {
    db.loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Главная"),
        flexibleSpace: consts.appbarGradien,
      ),
      body: Container(
        decoration: consts.gradientBox,
        child: db.groups.isEmpty
            ? const Center(
                child: Text(
                  'У вас не добавленно продуктов в избранное',
                  textAlign: TextAlign.center,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Center(
                      child: Text('Избранные продукты'),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: db.groups.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () => {
                                Navigator.pushNamed(
                                  context,
                                  '/product_card',
                                  arguments: {
                                    'table_id': db.groups[index][0]['id']
                                  },
                                ).then((value) => {
                                      setState(
                                        () {
                                          db.updateData();
                                        },
                                      )
                                    })
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.deepPurple.withAlpha(60),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  margin: const EdgeInsets.all(8),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(db.groups[index][0]['name']),
                                  )),
                            );
                          }),
                    )
                  ],
                ),
              ),
      ),
      bottomNavigationBar: const ShareNavgiationBar(
        currIndex: 0,
      ),
    );
  }
}
