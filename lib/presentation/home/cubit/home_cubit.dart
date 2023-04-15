import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared/constants/components.dart';

import '../../../data/models/task_model.dart';
import '../../archived/archived_screen.dart';
import '../../done/done_screen.dart';
import '../../tasks/tasks_screen.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [
    const TasksScreen(),
    const DoneScreen(),
    const ArchivedScreen()
  ];

  List<BottomNavigationBarItem> screenItems = [
    const BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.check_circle_outline), label: 'Done'),
    const BottomNavigationBarItem(icon: Icon(Icons.archive), label: 'Archived'),
  ];

  changeScreen({required index}) {
    currentIndex = index;
    emit(HomeChangeScreenState());
  }

  bool isBottomSheetShown = false;

  changeBottomSheetButtonIcon() {
    isBottomSheetShown = !isBottomSheetShown;
    emit(HomeChangeBottomSheetButtonIcon());
  }

  Database? database;

  createDatabase() {
    openDatabase(
      'todo_db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)');
      },
      onOpen: (db) {
        getTasks(database: db);
      },
    ).then((value) {
      database = value;
      emit(HomeCreateDatabaseState());
    });
  }

  insertDatabase(
      {required context, required title, required time, required date}) async {
    await database?.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO Tasks(title, time, date, status) VALUES("$title", "$time","$date", "still")')
          .then((value) {
        defaultSuccessSnackBar(
            message: 'Task has been added', context: context);
        getTasks(database: database!);
        Navigator.pop(context);
        emit(HomeInsertDataSuccessState());
      }).catchError((error) {
        defaultErrorSnackBar(
            message: 'Task not been added, try again', context: context);
        emit(HomeInsertDataErrorState());
      });
    });
  }

  List<TaskModel> stillTaskModels = [];
  List<TaskModel> doneTaskModels = [];
  List<TaskModel> archiveTaskModels = [];

  getTasks({required Database database}) async {
    clearTaskList();
    List<Map> stillTasks = await database
        .rawQuery('SELECT * FROM Tasks WHERE status=?', ['still']);
    List<Map> doneTasks =
        await database.rawQuery('SELECT * FROM Tasks WHERE status=?', ['done']);
    List<Map> archiveTasks = await database
        .rawQuery('SELECT * FROM Tasks WHERE status=?', ['archive']);

    for (var json in stillTasks) {
      stillTaskModels.add(TaskModel.fromJson(json));
    }
    for (var json in doneTasks) {
      doneTaskModels.add(TaskModel.fromJson(json));
    }
    for (var json in archiveTasks) {
      archiveTaskModels.add(TaskModel.fromJson(json));
    }
    emit(HomeGetDataSuccessState());
  }



  clearTaskList() {
    stillTaskModels = [];
    doneTaskModels = [];
    archiveTaskModels = [];
  }

  updateTask({required id, required status}) async {
    await database!
        .rawUpdate('UPDATE Tasks SET status=? WHERE id=?', ['$status', '$id']);
    getTasks(database: database!);
    emit(HomeDoneTaskState());
  }
}
