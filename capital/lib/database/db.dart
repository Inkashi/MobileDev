import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CapitalDB {
  static final CapitalDB instance = CapitalDB._init();
  static Database? _database;

  CapitalDB._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'capitaldb.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
        CREATE TABLE categories(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          color INTEGER,
          type INTEGER
        )
    ''');

    await db.execute('''
      CREATE TABLE notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id NOT NULL,
        title TEXT,
        sum FLOAT, 
        date TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE CASCADE
      )
''');

    await db.insert(
        'categories', {'name': 'Разное', 'color': 0xffae3ace, 'type': 1});
    await db.insert(
        'categories', {'name': 'Разное', 'color': 0xffae3ace, 'type': 0});
  }

  Future<void> deleteDatabaseAndReinitialize() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'capitaldb.db');
    await deleteDatabase(path);
    _database = await _initDatabase();
  }

  Future<void> clearCategory() async {
    final db = await instance.database;
    await db.delete('categories');
  }

  Future<void> clearNotes() async {
    final db = await instance.database;
    await db.delete('notes');
  }

  Future<void> deleteCategory(index) async {
    final db = await instance.database;
    await db.delete('categories', where: 'id = ?', whereArgs: [index]);
  }

  Future<void> deleteNotes(index) async {
    final db = await instance.database;
    await db.delete('notes', where: 'id = ?', whereArgs: [index]);
  }

  //Categories
  Future<void> addCategory(String name, int color, bool type) async {
    final db = await instance.database;
    await db.insert('categories', {'name': name, 'color': color, 'type': type});
  }

  Future<List<Map<String, dynamic>>> getCategoryList() async {
    final db = await instance.database;
    return await db.query(
      'categories',
    );
  }

  Future<int?> getCategoryId(String name) async {
    final db = await instance.database;
    final result = await db.query('categories',
        columns: ['id'], where: 'name = ?', whereArgs: [name]);

    return result.first['id'] as int;
  }

  //Notes
  Future<void> addNotes(categoryId, title, sum, date) async {
    final db = await instance.database;
    await db.insert('notes',
        {'category_id': categoryId, 'title': title, 'sum': sum, 'date': date});
  }

  Future<List<Map<String, dynamic>>> getNotesList(categoryId) async {
    final db = await instance.database;
    return db.query('notes', where: 'category_id = ?', whereArgs: [categoryId]);
  }
}
