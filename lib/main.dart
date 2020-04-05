import 'package:flutter/material.dart';
import 'package:submission_letter/Auth/presenter/forget_presenter.dart';
import 'package:submission_letter/Auth/presenter/login_presenter.dart';
import 'package:submission_letter/Auth/presenter/resgister_presenter.dart';
import 'package:submission_letter/Auth/presenter/userAuth_presenter.dart';
import 'package:submission_letter/Auth/views/forget_views.dart';
import 'package:submission_letter/Auth/views/login_views.dart';
import 'package:submission_letter/Auth/views/ocrPenduduk_views.dart';
import 'package:submission_letter/Auth/views/register_views.dart';
import 'package:submission_letter/RTRW_Page/presenter/setting_presenter.dart';
import 'package:submission_letter/RTRW_Page/views/detail_emp.dart';
import 'package:submission_letter/RTRW_Page/views/home_emp.dart';
import 'package:submission_letter/RTRW_Page/views/setting_views.dart';
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
