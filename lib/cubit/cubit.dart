import 'package:bloc/bloc.dart';
import 'package:ddd/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../screens/archieve screen.dart';
import '../screens/done_screen.dart';
import '../screens/tasks_screen.dart';

class AppCubits extends Cubit<AppState> {
  AppCubits() : super(InitialState());

  static AppCubits get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  IconData fabIcon = Icons.edit;
  bool isBottomSheetShown = false;
  List<Map> newTasks = [];
  List<Map> archievedTasks = [];
  List<Map> doneTasks = [];
  List<Map> list = [];


  List titles = ['TasksScreen', 'DoneScreen', 'ArchieveScreen'];
  List<Widget> screens = [TasksScreen(), DoneScreen(), ArchieveScreen()];


  void changeBottomNavbarShow({required IconData icon, required bool shown}) {
    isBottomSheetShown = shown;
    fabIcon = icon;
    emit(ChangeBottomnavbarShowState());
  }


  void changeIndex(index) {
    currentIndex = index;
    emit(ChangeBottomnavbarState());
  }


  initSql() async {
    var databasepath = await getDatabasesPath();
    String path = join(databasepath, 'demop.db');
    Database database = await openDatabase(
        path,
        version: 2,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db
              .execute(
              'CREATE TABLE IF NOT EXISTS Tosk (id INTEGER PRIMARY KEY, task TEXT, date Text , status TEXT )');
        },
        // onOpen: (db) {
        //   getDataFromDatabase().then((val) {
        //   });
        // }
    );
  }

  getDataFromDatabase() async {
    newTasks = [];
    archievedTasks = [];
    doneTasks = [];
    list = [];

    var databasepath = await getDatabasesPath();
    String path = join(databasepath, 'demop.db');
    Database database = await openDatabase(path);
     emit(AppGetDatabaseLoadingState());

    await database.rawQuery('SELECT * FROM Tosk').then((value) {
      list = value;

      list.forEach((element) {
        if (element['status'] == 'new')
          newTasks.add(element);
        else if (element['status'] == 'done')
          doneTasks.add(element);
        else
          archievedTasks.add(element);
      });
      emit(AppGetDatabaseState());
      print('get data success');
    }).catchError((onError) {
      print(onError.toString());
      emit(AppErrorState());
    });
    database.close();
  }

  insertToDatabese({
    required String title,
    required String date}) async {
    var databasepath = await getDatabasesPath();
    String path = join(databasepath, 'demop.db');
    Database database = await openDatabase(path);
     emit(AppGetDatabaseLoadingState());
    await database.rawInsert(
        'INSERT INTO Tosk(task , date , status ) VALUES("${title}", "$date" , "new"  )')
        .then((value) {
      getDataFromDatabase();
      emit(AppInsertDatabaseState());
      print('insert successs');
    })
        .catchError((onError) {
      print(onError.toString());
      emit(AppErrorState());
    });
    database.close();
  }

  void deleteData({required int id }) async {
    var databasepath = await getDatabasesPath();
    String path = join(databasepath, 'demop.db');
    Database database = await openDatabase(path);

    database.rawDelete(
        ' DELETE FROM Tosk where id=?',
        ['$id'])

        .then((value) {
      emit(AppDeleteDatabaseSuccessfullyState());
    })
        .catchError((onError) {
      emit(AppDeleteDatabaseErrorState());
      print(onError.toString());
    });
  }

  void updateData({required int id, required String status}) async {
    var databasepath = await getDatabasesPath();
    String path = join(databasepath, 'demop.db');
    Database database = await openDatabase(path);

    database.rawUpdate(' UPDATE Tosk SET status=? where id=?',
        ['$status', '$id']).then((value) {
      getDataFromDatabase();
      emit(AppUpdateDatabaseSuccessfullyState());
    });
    print('updateddddddddd');
  }
}

// static Database? _db ;
//   Future<Database?> get db async{
//     if( _db ==null){
//       _db = await intialDb();
//       return _db;
//     }else{
//       return _db;
//     }
//   }
//
//   intialDb() async{
//     String databasepath =await getDatabasesPath();
//     String path= join (databasepath, 'wael.db');
//     Database mydb= await openDatabase(
//         path , onCreate: _onCreate);
//   }
//
//   _onUpgrade(Database db , int oldVersion , int newVersion){
//
//   }
//
//
//   _onCreate(Database db , int version) async{
//     await db.execute('''
//             CREATE TABLE "Task" (
//            id INTEGER PRIMARY KEY,
//              task TEXT, date Text)
//     ''');
//     print('create table==============');
//   }
//
//   read(String table) async{
//     Database? mydb = await db;
//     List<Map> response = await mydb!.query(table);
//     emit(AppCreateDatabaseState());
//     //'SELECT * FROM "Task" '
//     return response;
//   }
//
//   insert(String table, Map<String, Object?> values
//     //  {
//     // required String title,
//     // required String date}
//       ) async{
//     Database? mydb = await db;
//     int response = await mydb!.insert(table, values );
//     //'INSERT INTO Task(task , date) VALUES("${title}", "$date")'
//     emit(AppInsertDatabaseState());
//     return response;
//   }
//
//   update(String table, Map<String, Object?> values, String? mywhere) async{
//     Database? mydb = await db;
//     int response = await mydb!.update(table, values, where: mywhere );
//     return response;
//   }

//   delete(String table, String? mywhere) async{
//     Database? mydb = await db;
//     int response = await mydb!.delete(table, where:  mywhere );
//     return response;
//   }


//////////////
//
//   void createDatabase(database) async{
//     // open the database
//    db= await openDatabase(
//       'task.db',
//       version: 1,
//       onCreate: (database, version) {
//         // When creating the db, create the table
//         database
//             .execute(
//                 'CREATE TABLE Task (id INTEGER PRIMARY KEY, task TEXT, date Text)');
//       },
//       onOpen: (database) {
//         getDataFromDatabase(database);
//         print('opened database');
//       },
//     ).then((value) {
//       database = value;
//       emit(AppCreateDatabaseState());
//     });
//   }
//
//   insertToDatabese({
//     required String title,
//     required String date}) async {
//
//     await db!.transaction((txn)async {
//      await txn.rawInsert(
//           'INSERT INTO Task(task , date) VALUES("${title}", "$date")')
//           .then((value)  {
//       emit(AppInsertDatabaseState());
//        getDataFromDatabase(database);
//
//       });
//       } );
//       // emit(AppInsertDatabaseState());
//       // getDataFromDatabase(database).then((value) {
//       //   newTasks = value;
//       //   print(newTasks);
//       //   emit(AppGetDatabaseState());
//       // });
//       // });
//      return null;
//    // });
//   }
//
//   void getDataFromDatabase(database) async{
//     newTasks = [];
//     doneTasks = [];
//     archievedTasks = [];
//
//     emit(AppGetDatabaseLoadingState());
//
//     await database.rawQuery('SELECT * FROM Task').then((val) {
//       val.forEach((element) {
//         if (element['status'] == 'new')
//           newTasks.add(element);
//         else if (element['status'] == 'done')
//           doneTasks.add(element);
//         else
//           archievedTasks.add(element);
//       });
//     });
//   }
//
//   void updateData({required int id, required String status}) async {
//    await db!.rawUpdate(' UPDATE Task SET status=? where id=?',
//         ['$status', '$id']).then((value) {
//       getDataFromDatabase(database);
//       emit(AppUpdateDatabaseLoadingState());
//     });
//        // : print('nooooooooooo');
//   }
//
//   void deleteData({required int id }) async {
//     database != null? database!.rawDelete(
//         ' DELETE FROM Task where id=?',
//         [id]).then((value) {
//       getDataFromDatabase(database);
//       emit(AppDeleteDatabaseState());
//     })
//         : print('nooooooooooo');
//   }
//

