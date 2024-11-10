import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/models/newsModel.dart';
import 'package:newsapp/constants/constants.dart';

class Infonews extends StatelessWidget {
  const Infonews({super.key});

  @override
  Widget build(BuildContext context) {
    // Получаем переданный аргумент
    final news = ModalRoute.of(context)?.settings.arguments as Newsmodel;
    final consts = Constants();
    return Scaffold(
      appBar: AppBar(
        title: Text("Детали новости"),
        flexibleSpace: consts.appbarGradien,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: consts.gradientBox,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withAlpha(80),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      news.name,
                      textAlign: TextAlign.center,
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: CachedNetworkImage(imageUrl: news.image_src)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withAlpha(80),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    news.description,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withAlpha(80),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        news.date.toString().substring(0, 19),
                      ),
                      Text(
                        news.category,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
