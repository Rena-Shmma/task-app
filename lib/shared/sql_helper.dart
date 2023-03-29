// _onCreate(Database db, int version) async {
//   // Database is created, create the table
//   await db.execute(
//       "CREATE TABLE Test (id INTEGER PRIMARY KEY, value TEXT)");
// }
//
// var db = await openDatabase(path,
// version: 1,
// onCreate: _onCreate);
//
// _onOpen(Database db) async {
//   // Database is open, print its version
//   print('db version ${await db.getVersion()}');
// }
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _db;

  DatabaseHelper._instance();

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'my_database.db');
    final db = await openDatabase(path, version: 1, onCreate: _createDb);
    return db;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, date TEXT, priority TEXT, status INTEGER)');
  }

  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    final Database db = await instance.db;
    final List<Map<String, dynamic>> result = await db.query('tasks');
    return result;
  }

  Future<int> insertTask(Map<String, dynamic> task) async {
    final Database db = await instance.db;
    final int result = await db.insert('tasks', task);
    return result;
  }

  Future<int> updateTask(Map<String, dynamic> task) async {
    final Database db = await instance.db;
    final int result = await db.update('tasks', task,
        where: 'id = ?', whereArgs: [task['id']]);
    return result;
  }

  Future<int> deleteTask(int id) async {
    final Database db = await instance.db;
    final int result =
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
    return result;
  }
}
