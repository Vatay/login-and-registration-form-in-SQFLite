import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final _dbName = 'persons';
  static final _dbVersion = 1;
  static final table = 'persons_table';
  static final columnID = 'id';
  static final columnName = 'name';
  static final columnPhone = 'phone';
  static final columnEmail = 'email';
  static final columnCountry = 'country';
  static final columnStory = 'story';
  static final columnPassword = 'password';

  // Singleton
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  // referens
  static Database? _database;

  Future<Database?> get datatabase async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, _dbName);

    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database database, int version) async {
    // integer primary key autoincrement
    await database.execute("""
      CREATE TABLE $table(
        $columnID INTEGER PRIMARY KEY,
        $columnName TEXT,
        $columnPhone TEXT,
        $columnEmail TEXT,
        $columnCountry TEXT,
        $columnStory TEXT,
        $columnPassword TEXT
      )
      """);
  }

  Future<int?> insert(Map<String, dynamic> row) async {
    Database? db = await instance.datatabase;
    return await db!.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database? db = await instance.datatabase;

    return await db!.query(table);
  }

  delete(int id) async {
    Database? db = await instance.datatabase;

    return db!.delete(table, where: "$columnID = ?", whereArgs: [id]);
  }
}
