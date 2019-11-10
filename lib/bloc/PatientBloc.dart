import 'dart:async';

import 'package:test_flutter/model/Patient.dart';
import 'package:test_flutter/network/PatientProvider.dart';
import 'package:test_flutter/repository/TestRepository.dart';

class PatientBloc{

  final _testRepository = TestRepository();

  final _patientProvider = PatientProvider();

  final _patientController =  StreamController<List<Patients>>.broadcast();

  final StreamController<String> _nameCOntroller = StreamController<String>();

  final StreamController<String> _mobileCOntroller = StreamController<String>();

  final StreamController<String> _ageCOntroller = StreamController<String>();

  get patients => _patientController.stream;


  PatientBloc(){
    getPatients();
  }

  getPatients() async{
    _patientController.sink.add(await _testRepository.getAllPatients());
  }

  addPatient(Patients patients) async{
    await _testRepository.insertPatient(patients);
    getPatients();
  }

  syncRemoteData() async{

    List<Patients> patientsList = await _testRepository.getAllPatients();

    for (Patients patient in patientsList){

        //send data to server
        /*var response = _patientProvider.sendData(patient.toDatabaseJson());
        if(response!=null){
          _testRepository.deletePatientByID(patient.id);
        }*/

      _testRepository.deletePatientByID(patient.id);

    }
    getPatients();

  }

  deletePatient(int id) async{
    _testRepository.deletePatientByID(id);
    getPatients();
  }

  dispose(){
    _patientController.close();
    _nameCOntroller.close();
    _mobileCOntroller.close();
    _ageCOntroller.close();
  }
}