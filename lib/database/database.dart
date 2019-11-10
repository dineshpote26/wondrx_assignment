import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider{

  static final DatabaseProvider dbProvider = DatabaseProvider();

  Database _database;
  final testTABLE = "TEST";

  Future<Database> get database async{

    if(_database != null) return _database;
    _database = await createDatabase();
    return _database;

  }

  createDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    //db name
    String path  = join(documentDirectory.path,"Test.db");

    var database = await openDatabase(
        path,
        version: 1,
        onCreate: initDB,
        onUpgrade: onUpgrade
    );

    return database;
  }

  void onUpgrade(Database database,int oldVersion,int newVersion){

  }

  void initDB(Database database,int version) async{
    await database.execute(
      "CREATE TABLE $testTABLE ("
          "id INTEGER PRIMARY KEY, "
          "name TEXT, "
          "mobileNo TEXT, "
          "age TEXT, "
          "is_done INTEGER "
          ")"
    );
  }

}