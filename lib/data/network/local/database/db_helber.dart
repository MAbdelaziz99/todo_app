import 'package:sqflite/sqflite.dart';
import 'package:todo_app/data/models/task_model.dart';
import 'package:todo_app/data/network/local/data.dart';

class DBHelper {
  static DBHelper? instance;

  static init() async {
    instance = DBHelper();
  }

  static Database? database;

  static Future<Database?> createDatabase(
      {required Function(Database db, int version) onCreate,
      required Function(Database db) onOpen}) async {
    database = await openDatabase(
      'todo_db',
      version: 2,
      onCreate: (db, version) => onCreate(db, version),
      onOpen: (db) => onOpen(db),
    );
    return database;
  }

  static Future<void> createTaskTableInDB(Database db) async {
    await db.execute(
        'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)');
  }

  static insertDatabase(
      {required context,
      required title,
      required time,
      required date,
      required Function(int value) onSuccess,
      required Function(dynamic error) onFailed}) async {
    await database?.transaction((txn) async {
      await insertRowInTaskTable(txn, title, time, date)
          .then(onSuccess)
          .catchError(onFailed);
    });
  }

  static Future<int> insertRowInTaskTable(Transaction txn, title, time, date) {
    return txn.rawInsert(
        'INSERT INTO Tasks(title, time, date, status) VALUES("$title", "$time","$date", "still")');
  }

  static getStillTasks({required database, required Function listen}) async {
    List<Map> stillTasks = await database
        .rawQuery('SELECT * FROM Tasks WHERE status=?', ['still']);
    for (Map json in stillTasks) {
      stillTaskModels.add(TaskModel.fromJson(json));
    }
    listen();
  }

  static Future<List<Map>> getDoneTasks(
      {required database, required Function listen}) async {
    List<Map> doneTasks = await database!
        .rawQuery('SELECT * FROM Tasks WHERE status=?', ['done']);
    for (Map json in doneTasks) {
      doneTaskModels.add(TaskModel.fromJson(json));
    }
    listen();
    return doneTasks;
  }

  static Future<List<Map>> getArchivedTasks(
      {required database, required Function listen}) async {
    List<Map> archiveTasks = await database!
        .rawQuery('SELECT * FROM Tasks WHERE status=?', ['archive']);
    for (Map json in archiveTasks) {
      archiveTaskModels.add(TaskModel.fromJson(json));
    }
    listen();
    return archiveTasks;
  }

  static getAllTasks({required database, required Function listen}) async {
    clearTaskList();
    getStillTasks(database: database, listen: listen);
    getArchivedTasks(database: database, listen: listen);
    getDoneTasks(database: database, listen: listen);
  }

  static clearTaskList() {
    stillTaskModels = [];
    doneTaskModels = [];
    archiveTaskModels = [];
  }

  static updateTask({required database, required status, required id}) async {
    await database
        .rawUpdate('UPDATE Tasks SET status=? WHERE id=?', ['$status', '$id']);
  }
}
