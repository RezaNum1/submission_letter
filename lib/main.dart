import 'package:flutter/material.dart';
import 'package:submission_letter/Penduduk_Page/views/buat_Suratp.dart';
import 'package:submission_letter/Penduduk_Page/views/search_penduduk.dart';
import 'package:submission_letter/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  static var route = "http://192.168.43.75:8000";
  static var routeOCR = "http://192.168.43.75";
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Submission Letter App',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: HomeBase());
  }
}
