import 'package:attendance/pages/qrview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]
    );

    return MaterialApp(
      title: 'Attendance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const QRViewPage(),
    );
  }
}
