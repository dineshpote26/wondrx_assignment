import 'dart:async';

import 'package:test_flutter/database/database.dart';
import 'package:test_flutter/model/Patient.dart';

class TestDao {
  final dbProvider = DatabaseProvider.dbProvider;

  //Add patients Entry
  Future<int> createPatients(Patients patients) async {
    final db = await dbProvider.database;
    var result = db.insert(dbProvider.testTABLE, patients.toDatabaseJson());

    return result;
  }

  //get all Patients
  Future<List<Patients>> getPatients(
      {List<String> columns, String query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (query != null) {
      if (query.isNotEmpty)
        result = await db.query(dbProvider.testTABLE,
            columns: columns, where: 'name LIKE ?', whereArgs: ["%$query%"]);
    } else {
      result = await db.query(dbProvider.testTABLE, columns: columns);
    }

    List<Patients> patients = result.isNotEmpty
        ? result.map((item) => Patients.fromDatabaseJson(item)).toList()
        : [];
    return patients;
  }

  //Delete Patients
  Future<int> deleteTodo(int id) async {
    final db = await dbProvider.database;
    var result =
        await db.delete(dbProvider.testTABLE, where: 'id = ?', whereArgs: [id]);
    return result;
  }
}
