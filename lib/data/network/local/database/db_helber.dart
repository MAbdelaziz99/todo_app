import 'package:sqflite/sqflite.dart';
import 'package:todo_app/data/models/task_model.dart';
import 'package:todo_app/data/network/local/data.dart';

class DBHelper {
  static DBHelper? instance;

  static DBHelper? getInstance() {
    instance ??= DBHelper();
    return instance;
  }

  Database? database;

  Future<Database?> createDatabase(
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

  Future<void> createTaskTableInDB(Database db) async {
    await db.execute(
        'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)');
  }

  insertDatabase(
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

  clearTaskList() {
    allTaskModels = [];
    doneTaskModels = [];
    archiveTaskModels = [];
  }

  getAllTasks({required database, required Function listen}) async {
    clearTaskList();
    List<Map> tasks = await database!.rawQuery('SELECT * FROM Tasks');
    for (Map json in tasks) {
      allTaskModels.add(TaskModel.fromJson(json));
    }
    listen();
  }

  Future<int> insertRowInTaskTable(Transaction txn, title, time, date) {
    return txn.rawInsert(
        'INSERT INTO Tasks(title, time, date, status) VALUES("$title", "$time","$date", "still")');
  }

  updateTask({required database, required status, required id}) async {
    await database
        .rawUpdate('UPDATE Tasks SET status=? WHERE id=?', ['$status', '$id']);
  }
}
