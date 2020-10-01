import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:device_simulator/device_simulator.dart';

import 'ui/screens/home/HomePage.dart';
import 'ui/screens/register/Register.dart';
import 'ui/screens/login/Login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  bool _simulateDevices;

  MyApp({simulateDevices = false}) : _simulateDevices = simulateDevices;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bonobo',
      home: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Bonobo",
        theme: ThemeData(primarySwatch: Colors.pink),
        home: DeviceSimulator(
          enable: _simulateDevices,
          child: Login(),
        ),
        routes: <String, WidgetBuilder>{
          "/Register": (context) => Register(),
          "/Login": (context) => Login(),
        },
      ),
    );
  }
}
