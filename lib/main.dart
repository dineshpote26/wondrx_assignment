import 'package:flutter/material.dart';
import 'package:test_flutter/ui/home_page.dart';
import 'package:test_flutter/utility/ConnectionStatusSingleton.dart';

void main() {

  ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
  connectionStatus.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Test Flutter",
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        canvasColor: Colors.transparent
      ),
      home: HomePage(),
    );
  }
}
