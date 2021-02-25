import 'package:todo_sqflite/task.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DataBaseHelper {
  static DataBaseHelper _dataBaseHelper;
  static Database _database;

  String taskTable = 'task_table';
  String colID = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colDate = 'date';

  DataBaseHelper._createInstance();

  factory DataBaseHelper() {
    if (_dataBaseHelper == null) {
      _dataBaseHelper = DataBaseHelper._createInstance();
    }
    return _dataBaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initalizeDatabase();
    }
    return _database;
  }

  Future<Database> initalizeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'tasks.db';
    var tasksDatabase = await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );

    return tasksDatabase;
  }

  void _createDatabase(Database db, int newVersion) async {
    await db.execute(
      'CREATE TABLE $taskTable($colID INTEGER PRIMARY KEY AUTOINCREMENT,$colTitle TEXT, $colDescription TEXT, $colDate TEXT)',
    );
  }

  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    Database db = await this.database;
    var result = await db.query(taskTable);
    return result;
  }

  //inserting Task into Database
  Future<int> insertTask(Task task) async {
    Database db = await this.database;
    var result = await db.insert(
      taskTable,
      task.toMap(),
    );
    return result;
  }

  //updating Task in Database
  Future<int> updateTask(Task task) async {
    Database db = await this.database;
    var result = await db.update(
      taskTable,
      task.toMap(),
      where: '$colID = ?',
      whereArgs: [task.id],
    );
    return result;
  }

  //delete the task from database
  Future<int> deleteTask(int id) async {
    Database db = await this.database;
    var result = await db.delete(
      taskTable,
      where: '$colID = ?',
      whereArgs: [id],
    );
    return result;
  }

  // database row count
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) FROM $taskTable');

    int result = Sqflite.firstIntValue(x);
    return result;
  }

  //map list to task list
  Future<List<Task>> getTaskList() async {
    var dbMapList = await getTaskMapList();
    int count = dbMapList.length;
    List<Task> taskList = List<Task>();
    for (var i = 0; i < count; i++) {
      taskList.add(Task.fromMap(dbMapList[i]));
    }

    return taskList;
  }
}
