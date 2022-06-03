import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/cubit/states.dart';

import '../screens/archived_tasks_Screen.dart';
import '../screens/done_tasks_screen.dart';
import '../screens/new_tasks_screen.dart';

class TodoCubit extends Cubit<AppStates> {
  TodoCubit() : super(AppInitialState());

  static TodoCubit get(context) => BlocProvider.of(context);
  Database? database;
  int val = 0;
  String? date;
  String? time;
  String? title;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  IconData fabIcon = Icons.edit;
  bool isBottomSheetVisible = false;

  /// list to change screen
  List<Widget> screenToggle = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  /// list to change screen title
  List<String> screenTitle = [
    'New tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  /// method to change bottom bar icon and screen
  void changeValue(int value) {
    val = value;
    emit(AppChangeBottomBarState());
  }

  /// creating database and opening it
  void createDatabase() async {
    database = await openDatabase(
      'new_tasks.db',
      version: 1,
      onCreate: (db, version) {
        print('Data Base created');
        db.execute(
            'CREATE TABLE task (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT ,status TEXT )');
        print('table created');
      },
      onOpen: (db) {
        print('Data Base opened');
        getDataFromDataBase(db);
      },
    );
    emit(AppCreateDatabaseState());
  }

  /// inserting into database
  insertIntoDB(
      {required String? time,
      required String? date,
      required String? title}) async {
    await database?.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO task(title, date, time ,status) VALUES("$title", "$date", "$time" ,"new")')
          .then((value) {
        emit(AppInsertIntoDBState());
        getDataFromDataBase(database);
        print('$value inserted successfully');
      }).catchError((error) {
        print('error on inserting new record $error');
      });
    });
  }

  /// getting data from data base
  void getDataFromDataBase(db) {
    db.rawQuery('SELECT * FROM task').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          print(element);
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });
      emit(AppGetDataFromDataBaseState());
    });
  }

  /// opening and closing bottom sheet and changing fab icon
  void changeBottomSheet(IconData icon, bool isVis) {
    fabIcon = icon;
    isBottomSheetVisible = isVis;
    emit(AppChangeBottomBarState());
  }

  /// updating data
  void updateData(String status, int id) async {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    database!.rawUpdate(
        'UPDATE task SET status = ? WHERE id = ?', [status, id]).then((value) {
      getDataFromDataBase(database);
      emit(AppUpdateDataFromDataBaseState());
    });
  }

  /// updating data
  void deleteData(int id) async {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    database!.rawDelete('DELETE FROM task WHERE id = ?', [id]).then((value) {
      print(value);
      getDataFromDataBase(database);
      emit(AppDeleteDataFromDataBaseState());
    });
  }
}
