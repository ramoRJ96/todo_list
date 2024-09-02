// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart' as sqflite;

import 'datetime_converter.dart';
import 'todo.dart';
import 'todo_dao.dart';

part 'app_database.g.dart';

@TypeConverters([DateTimeConverter])
@Database(version: 1, entities: [
  Todo
])
abstract class AppDatabase extends FloorDatabase {
  TodoDao get todoDao;

  static Future<AppDatabase> getInstance() async {
    return await $FloorAppDatabase.databaseBuilder('.todo.db').build();
  }
}
