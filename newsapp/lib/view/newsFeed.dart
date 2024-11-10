import 'package:flutter/material.dart';
import 'package:newsapp/database/db.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:newsapp/models/newsModel.dart';
import 'package:newsapp/constants/constants.dart';

const List<String> tags = [
  '-',
  'политика',
  'в мире',
  'спорт',
  'экономика',
  'происшествия'
];

class newsFeed extends StatefulWidget {
  const newsFeed({super.key});

  @override
  State<newsFeed> createState() => _newsFeedState();
}

class _newsFeedState extends State<newsFeed> {
  List<Newsmodel> newsList = [];
  final supabase = Supabase.instance.client;
  List<Newsmodel> filtredList = [];
  final consts = Constants();
  bool sortNav = false;
  var tempTag = tags.first;
  @override
  void initState() {
    super.initState();
    getNewsList();
  }

  Future<void> getNewsList() async {
    try {
      final temp = await Supabase.instance.client.from('newsData').select();
      List<Newsmodel> tempList = (temp as List)
          .map((e) => Newsmodel.fromData(e as Map<String, dynamic>))
          .toList();
      await DatabaseNews.instance.clearTable();
      await DatabaseNews.instance.insertAllNews(tempList);
    } catch (e) {}

    final db = await DatabaseNews.instance.database;
    final List<Map<String, dynamic>> data = await db.query('news');

    setState(() {
      newsList = data.map((e) => Newsmodel.fromData(e)).toList();
      filtredList = newsList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Новостная лента"),
          flexibleSpace: consts.appbarGradien,
        ),
        body: newsList.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Container(
                decoration: consts.gradientBox,
                child: Column(
                  children: [
                    ElevatedButton(
                        onPressed: () => {
                              setState(() {
                                sortNav
                                    ? filtredList.sort(
                                        (a, b) => a.date.compareTo(b.date))
                                    : filtredList.sort(
                                        (a, b) => b.date.compareTo(a.date));
                                sortNav = !sortNav;
                              })
                            },
                        child:
                            Text(sortNav ? 'Сначала старые' : 'Сначала новые')),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              color: Color(0xfff7f2fa),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12, right: 12),
                            child: Container(
                              height: 40,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: tempTag,
                                  items: tags.map((tag) {
                                    return DropdownMenuItem(
                                      value: tag,
                                      child: Text(
                                        tag,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xff6e58a8)),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      tempTag = value;
                                      _filtredList(value);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              pickDate();
                            },
                            child: const Text('Фильтр по дате')),
                      ],
                    ),
                    Expanded(
                      flex: 9,
                      child: ListView.builder(
                        itemCount: filtredList.length,
                        itemBuilder: (context, index) {
                          final news = filtredList[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/newsCard',
                                    arguments: news);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: consts.primaryColor.withAlpha(80),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(16))),
                                width: MediaQuery.of(context).size.width * 0.8,
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        news.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                          news.date.toString().substring(0, 16),
                                          style: TextStyle(fontSize: 14)),
                                      Text(
                                        news.category,
                                        style: TextStyle(fontSize: 14),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )));
  }

  void _filtredList(value) {
    setState(() {
      if (value == '-') {
        filtredList = newsList;
      } else {
        filtredList = newsList.where((e) => e.category == value).toList();
      }
    });

    print(filtredList);
  }

  void filtredDate(start, end) {
    setState(() {
      filtredList = filtredList.where((e) {
        return (start == null || e.date.isAfter(start!)) &&
            (end == null || e.date.isBefore(end!.add(const Duration(days: 1))));
      }).toList();
    });
  }

  Future<void> pickDate() async {
    newsList.sort((a, b) => a.date.compareTo(b.date));
    final firstdate = newsList[0].date;
    final dateRange = await showDateRangePicker(
        context: context, firstDate: firstdate, lastDate: DateTime.now());
    if (dateRange != null) {
      setState(() {
        filtredDate(dateRange.start, dateRange.end);
      });
    }
  }
}
