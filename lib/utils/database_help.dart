
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:todocarendarapp/models/todo.dart';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper;    // Singleton DatabaseHelper
  static Database db;                // Singleton Database

  static String tableName = 'todo';
  static String colId = 'id';
  static String colTitle = 'title';
  static String colCheck = 'check';
  static String colTimeLimit = 'timeLimit';
  static String colLongTerm = 'longTerm';


  DatabaseHelper._createInstance(); // DatabaseHelperのインスタンスを作成するための名前付きコンストラクタ

  factory DatabaseHelper() {

    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance(); // これは1回だけ実行されます。
    }
    return _databaseHelper;
  }

  Database get database{
    return db;
  }

  static Future<Database> initializeDatabase() async {
    // データベースを保存するためのAndroidとiOSの両方のディレクトリパスを取得する
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + '/todo.db';

    // Open/指定されたパスにデータベースを作成する
    var database = await openDatabase(path, version: 1, onCreate: _createDb);
    return database;
  }

  static void _createDb(Database db, int newVersion) async {

    await db.execute('CREATE TABLE $tableName($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, '
        '$colCheck INTEGER, $colTimeLimit TEXT, $colLongTerm INTEGER)');
    await db.insert(tableName,Todo("筋トレ",0,null,0).toMap());

  }

  // Fetch Operation: データベースからすべてのカレンダーオブジェクトを取得します
  Future<List<Map<String, dynamic>>> getTodoMapList() async {
    var result = await this.database.query(tableName, orderBy: '$colId ASC');
    return result;
  }
  //選択月を全て持ってくる
//  Future<Map<String,dynamic>> getTodoMonthInt(date) async{
//    String _text = DateFormat('yyyy-MM').format(date);
//    var result = await this.database.rawQuery("SELECT COALESCE(SUM($colMoney),0) AS SUM,"
//        "COALESCE(SUM(CASE WHEN $colMoney >= 0 THEN $colMoney ELSE 0 END),0) AS PLUS,"
//        "COALESCE(SUM(CASE WHEN $colMoney <  0 THEN $colMoney ELSE 0 END),0) AS MINUS "
//        "FROM $tableName WHERE $colDate LIKE ?" ,[_text+"%"]);
//    return  result[0];
//  }

//挿入　更新　削除
  // Insert Operation: Insert a Note object to database
  Future<int> insertTodo(Todo todo) async {
    var result = await this.database.insert(tableName, todo.toMap());
    return result;
  }

  // Update Operation: Update a Note object and save it to database
  Future<int> updateTodo(Todo todo) async {
    var result = await this.database.update(tableName, todo.toMap(), where: '$colId = ?', whereArgs: [todo.id]);
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteTodo(int id) async {
    int result = await this.database.rawDelete('DELETE FROM $tableName WHERE $colId = $id');
    return result;
  }

  //データベース内のNoteオブジェクトの数を取得します
  Future<int> getCount() async {
    //rawQuery括弧ないにSQL文が使える。
    List<Map<String, dynamic>> x = await this.database.rawQuery('SELECT COUNT (*) from $tableName');
    //firstIntValueはlist型からint型に変更している。
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // 'Map List' [List <Map>]を取得し、それを 'Calendar List' [List <Note>]に変換します
  Future<List<Todo>> getTodoList() async {
    //全てのデータを取得
    var todoMapList = await getTodoMapList(); // Get 'Map List' from database
    int count = todoMapList.length;         // Count the number of map entries in db table

    List<Todo> todoList = List<Todo>();
    for (int i = 0; i < count; i++) {
      todoList.add(Todo.fromMapObject(todoMapList[i]));
    }
    return todoList;
  }
}