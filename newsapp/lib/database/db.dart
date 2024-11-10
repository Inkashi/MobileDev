import "package:sqflite/sqflite.dart";
import 'package:path/path.dart';
import 'package:newsapp/models/newsModel.dart';

class DatabaseNews {
  static final DatabaseNews instance = DatabaseNews._init();
  static Database? _database;

  DatabaseNews._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'newsdb.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE news (
        id INTEGER PRIMARY KEY,
        name TEXT,
        description TEXT,
        category TEXT,
        image_src TEXT,
        date TEXT
      )
''');
  }

  Future<void> clearTable() async {
    final db = await instance.database;
    await db.delete('news');
  }

  Future<void> insertAllNews(List<Newsmodel> newsList) async {
    final db = await instance.database;
    Batch batch = db.batch();

    for (var news in newsList) {
      batch.insert(
        'news',
        news.tomap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }
}
