import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/data/network/local/database/db_helber.dart';
import 'package:todo_app/shared/constants/components.dart';
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
  DBHelper? dbHelper = DBHelper.getInstance();
  createDatabase() async {

    await dbHelper?.createDatabase(onCreate: (db, version) async {
      await dbHelper?.createTaskTableInDB(db);
      emit(HomeCreateDatabaseState());
    }, onOpen: (db) {
      getTasks(database: db);
    }).then((value) {
      database = value;
      emit(HomeCreateDatabaseState());
    }).catchError((error) {
      print('Error:: $error');
    });
  }

  insertDatabase(
      {required context, required title, required time, required date}) async {
    dbHelper?.insertDatabase(
      context: context,
      title: title,
      time: time,
      date: date,
      onSuccess: (value) {
        defaultSuccessSnackBar(
            message: 'Task has been added', context: context);
        Navigator.pop(context);
        emit(HomeInsertTaskSuccessState());
      },
      onFailed: (error) {
        defaultErrorSnackBar(
            message: 'Task not been added, try again', context: context);
        emit(HomeInsertDataErrorState());
      },
    );
  }

  getTasks({required database}) async {
    dbHelper?.getAllTasks(database: database, listen: (){
      emit(HomeGetDataSuccessState());
    });
  }
  updateTask({required id, required status}) async {
    dbHelper?.updateTask(database: database, status: status, id: id);
    emit(HomeUpdateTaskState());
  }
}
