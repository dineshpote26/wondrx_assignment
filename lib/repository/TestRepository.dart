import 'package:test_flutter/dao/TestDao.dart';
import 'package:test_flutter/model/Patient.dart';

class TestRepository{

  final testDao = new TestDao();

  Future getAllPatients() => testDao.getPatients();

  Future insertPatient(Patients patients) => testDao.createPatients(patients);

  Future deletePatientByID(int id)=> testDao.deleteTodo(id);
}