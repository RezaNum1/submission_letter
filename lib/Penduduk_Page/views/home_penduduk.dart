import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_letter/Penduduk_Page/APP_TabBar/selesai_penduduk.dart';
import 'package:submission_letter/Penduduk_Page/APP_TabBar/todo_penduduk.dart';
import 'package:submission_letter/Penduduk_Page/APP_TabBar/tolak_penduduk.dart';
import 'package:submission_letter/Theme/theme_emp.dart';
import 'package:submission_letter/Theme/theme_penduduk.dart';

class HomePenduduk extends StatefulWidget {
  @override
  _HomePendudukState createState() => _HomePendudukState();
}

class _HomePendudukState extends State<HomePenduduk>
    with SingleTickerProviderStateMixin {
  TabController controller;
  int idUser;
  String noTelepon;
  String nik;

  @override
  void initState() {
    controller = TabController(length: 3, vsync: this);
    setPreference();
    super.initState();
  }

  Future<void> setPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      idUser = pref.getInt("Id");
      noTelepon = pref.getString("NoTelepon");
      nik = pref.getString("Nik");
    });
  }

  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Container(
          margin: EdgeInsets.only(right: 50),
          height: 60,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/dki.png'),
            ),
          ),
        ),
        bottom: TabBar(
          labelColor: Colors.white,
          indicatorWeight: 5,
          controller: controller,
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.assignment),
              text: "DI PROSES",
            ),
            Tab(
              icon: Icon(Icons.check_box),
              text: "KEMBALI",
            ),
            Tab(
              icon: Icon(Icons.cancel),
              text: "SELESAI",
            ),
          ],
        ),
      ),
      drawer: ThemeAppPenduduk.sideBar(context, nik, noTelepon),
      body: TabBarView(
        controller: controller,
        children: <Widget>[ToDoPenduduk(), TolakPenduduk(), SelesaiPenduduk()],
      ),
    );
  }
}
