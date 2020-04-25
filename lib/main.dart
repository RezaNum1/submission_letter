import 'package:flutter/material.dart';
import 'package:submission_letter/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
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
