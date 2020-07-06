
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:todocarendarapp/models/clear.dart';

class DatabaseHelperExpired {

  static DatabaseHelperExpired _databaseHelper;    // Singleton DatabaseHelper
  static Database db;                // Singleton Database

  static String tableName = 'expired';
  static String colId = 'id';
  static String colTitle = 'title';
  static String colClear = 'clear';
  static String colTimeLimit = 'timeLimit';
  static String colTodoId = 'todoId';



  DatabaseHelperExpired._createInstance(); // DatabaseHelperのインスタンスを作成するための名前付きコンストラクタ

  factory DatabaseHelperExpired() {

    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelperExpired._createInstance(); // これは1回だけ実行されます。
    }
    return _databaseHelper;
  }

  Database get database{
    return db;
  }

  static Future<Database> initializeDatabase() async {
    // データベースを保存するためのAndroidとiOSの両方のディレクトリパスを取得する
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + '/expired.db';

    // Open/指定されたパスにデータベースを作成する
    var database = await openDatabase(path, version: 1, onCreate: _createDb);
    return database;
  }

  static void _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $tableName($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colClear TEXT, $colTimeLimit TEXT, $colTodoId INTEGER)');
  }

  // Fetch Operation: データベースからすべてのオブジェクトを取得します
  Future<List<Map<String, dynamic>>> getExpiredMapList() async {
    var result = await this.database.query(tableName, orderBy: '$colId ASC');
    return result;
  }

  Future<int> insertExpired(Expired expired) async {
    var result = await this.database.insert(tableName, expired.toMap());
    return result;
  }

  Future<int> updateExpired(Expired expired) async {
    var result = await this.database.update(tableName, expired.toMap(), where: '$colId = ?', whereArgs: [expired.id]);
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteExpired(int id) async {
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
  Future<List<Expired>> getExpiredList() async {
    //全てのデータを取得
    var expiredMapList = await getExpiredMapList(); // Get 'Map List' from database
    int count = expiredMapList.length;         // Count the number of map entries in db table

    List<Expired> expiredList = List<Expired>();
    for (int i = 0; i < count; i++) {
      expiredList.add(Expired.fromMapObject(expiredMapList[i]));
    }
    return expiredList;
  }
}