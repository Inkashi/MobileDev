import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:productapp/constants/constants.dart';
import 'package:productapp/views/Navigationbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  final catalogStream = Supabase.instance.client
      .from('products_category')
      .stream(primaryKey: ['id']);
  final consts = Constants();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Категории продуктов"),
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
              final category = snapshot.data!;
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: category.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => {
                      Navigator.pushNamed(
                        context,
                        '/product_catalog',
                        arguments: {
                          'table_id': category[index]['id'],
                          'table_name': category[index]['name']
                        },
                      ),
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            child: ImageFiltered(
                              imageFilter:
                                  ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                              child: Image.network(
                                category[index]['image_src'],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                          ),
                          Text(
                            category[index]['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
      ),
      bottomNavigationBar: const ShareNavgiationBar(
        currIndex: 1,
      ),
    );
  }
}
