// ignore_for_file: unused_field

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  late Database _database;

  Future<Database> _currentDatabase() async {
    if (_database != null) {
      return _database;
    }
    return _database =
        await openDatabase(join(await getDatabasesPath(), 'quiz.db'),
            onCreate: (database, version) {
      return database.execute(
          'CREATE TABLE articles(id INTEGER PRIMARY KEY, title TEXT, description TEXT)');
    }, version: 1);
  }
}
