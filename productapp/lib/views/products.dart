import 'package:flutter/material.dart';
import 'package:productapp/constants/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:productapp/models/product_model.dart';

class Productcatalog extends StatefulWidget {
  const Productcatalog({super.key});

  @override
  State<Productcatalog> createState() => __ProductcatalogStateState();
}

class __ProductcatalogStateState extends State<Productcatalog> {
  late Stream<List<Map<String, dynamic>>> catalogStream;
  final consts = Constants();
  bool isInit = false;
  final supabase = Supabase.instance.client;
  String searchQuery = '';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      catalogStream = supabase
          .from('products')
          .stream(primaryKey: ['id']).eq('category', args['table_id']);
      setState(() {
        isInit = true;
      });
    });
    super.initState();
  }

  void _updateStream() {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    catalogStream = supabase
        .from('products')
        .stream(primaryKey: ['id']).eq('category', args['table_id']);
  }

  @override
  Widget build(BuildContext context) {
    return isInit != true
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              title: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                    _updateStream();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Поиск по имени...',
                  hintStyle: consts.fontfamily,
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white),
              ),
              flexibleSpace: consts.appbarGradien,
            ),
            body: Container(
              decoration: consts.gradientBox,
              child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: catalogStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final productsList = snapshot.data!
                        .where((product) => product['name']
                            .toString()
                            .toLowerCase()
                            .contains(searchQuery))
                        .toList();
                    ;
                    return ListView.builder(
                      itemCount: productsList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => {
                            Navigator.pushNamed(
                              context,
                              '/product_card',
                              arguments: {
                                'table_id': productsList[index]['id']
                              },
                            ),
                          },
                          child: Container(
                              margin: const EdgeInsets.all(8),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.deepPurple.withAlpha(60),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                        child:
                                            Text(productsList[index]['name'])),
                                  ))),
                        );
                      },
                    );
                  }),
            ),
          );
  }
}
