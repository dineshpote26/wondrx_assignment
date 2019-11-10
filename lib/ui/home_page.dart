import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test_flutter/bloc/PatientBloc.dart';
import 'package:test_flutter/model/Patient.dart';
import 'package:test_flutter/utility/ConnectionStatusSingleton.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  bool isOffline = false;

  @override
  void initState() {
    super.initState();
    ConnectionStatusSingleton connectionStatus =
        ConnectionStatusSingleton.getInstance();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;

      if(!isOffline){
        showToast("Network available");
        patientBloc.syncRemoteData();
      }else{
        showToast("Network unavailable");
      }

    });
  }

  void showToast(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  final PatientBloc patientBloc = PatientBloc();

  StreamSubscription _connectionChangeStream;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 2, right: 2, bottom: 2),
            child: Container(
              child: getPatientWidget(),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 25),
          child: FloatingActionButton(
            elevation: 5.0,
            onPressed: () {
              _showAddPatientSheet(context);
            },
            backgroundColor: Colors.white,
            child: Icon(
              Icons.add,
              size: 32,
              color: Colors.indigoAccent,
            ),
          ),
        ));
  }

  void _showAddPatientSheet(BuildContext context) {
    final _nameFormController = TextEditingController();
    final _mobileFormController = TextEditingController();
    final _ageFormController = TextEditingController();
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: new Container(
              color: Colors.transparent,
              child: new Container(
                height: 330,
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 15, top: 25.0, right: 15, bottom: 30),
                  child: ListView(
                    children: <Widget>[
                      Form(
                        key: _formKey ,
                        child: Column(
                          children: <Widget>[
                            StreamBuilder<Object>(
                              stream: null,
                              builder: (context, snapshot) {
                                return new TextFormField(
                                    controller: _nameFormController,
                                    keyboardType: TextInputType
                                        .text, // Use email input type for emails.
                                    decoration: new InputDecoration(
                                        hintText: 'Dinesh',
                                        labelText: 'Enter Username'),
                                    validator: (value) {
                                      value = value.trim();
                                      if (value.isEmpty) {
                                        return "";
                                      }
                                      return null;
                                    }
                                );
                              }
                            ),
                            new TextFormField(
                                controller: _mobileFormController,
                                keyboardType: TextInputType
                                    .number, // Use email input type for emails.
                                decoration: new InputDecoration(
                                    hintText: '9167933674',
                                    labelText: 'Enter Mobile Number'),
                                validator: (value) {
                                  value = value.trim();
                                  if (value.isEmpty) {
                                    return "";
                                  }
                                  return null;
                                }
                            ),
                            new TextFormField(
                                controller: _ageFormController,
                                keyboardType: TextInputType
                                    .number, // Use email input type for emails.
                                decoration: new InputDecoration(
                                    hintText: '28', labelText: 'Enter Age'),
                                validator: (value) {
                                  value = value.trim();
                                  if (value.isEmpty) {
                                    return "";
                                  }
                                  return null;
                                }
                            ),
                            new Container(
                              child: new RaisedButton(
                                child: new Text(
                                  'ADD',
                                  style: new TextStyle(color: Colors.white),
                                ),
                                onPressed: () {

                                  if(_formKey.currentState.validate()){

                                    Patients patients = new Patients(
                                        name: _nameFormController.value.text,
                                        age: _ageFormController.value.text,
                                        mobileNo: _mobileFormController.value.text);

                                    if(isOffline){
                                      patientBloc.addPatient(patients);
                                      Navigator.pop(context);
                                      showToast("data added in local db");
                                    }else{
                                      Navigator.pop(context);
                                      showToast("data added in remote db");
                                    }

                                  }
                                },
                                color: Colors.blue,
                              ),
                              margin: new EdgeInsets.only(top: 20.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget getPatientWidget() {
    return StreamBuilder(
      stream: patientBloc.patients,
      builder: (BuildContext context, AsyncSnapshot<List<Patients>> snapshot) {
        return getCardWidget(snapshot);
      },
    );
  }

  Widget getCardWidget(AsyncSnapshot<List<Patients>> snapshot) {
    if (snapshot.hasData) {
      return snapshot.data.length != 0
          ? ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, itemPosition) {
                Patients patients = snapshot.data[itemPosition];

                return Container(
                  child: Card(
                    child: Text(patients.name),
                  ),
                );
              })
          : Container(
              child: Center(
                child: Container(
                  child: Text(
                    "Local DB Empty",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            );
    } else {
      return Center(
        child: loadingData(),
      );
    }
  }

  Widget loadingData() {
    patientBloc.getPatients();
    return Container(
      child: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              Text("Loading...",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500))
            ],
          ),
        ),
      ),
    );
  }
}
