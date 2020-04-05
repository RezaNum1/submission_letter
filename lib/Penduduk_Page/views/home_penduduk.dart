import 'package:flutter/material.dart';
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

  @override
  void initState() {
    controller = TabController(length: 3, vsync: this);
    super.initState();
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
              text: "TODO",
            ),
            Tab(
              icon: Icon(Icons.check_box),
              text: "SELESAI",
            ),
            Tab(
              icon: Icon(Icons.cancel),
              text: "KEMBALI",
            ),
          ],
        ),
      ),
      drawer: ThemeAppPenduduk.sideBar(context),
      body: TabBarView(
        controller: controller,
        children: <Widget>[ToDoPenduduk(), SelesaiPenduduk(), TolakPenduduk()],
      ),
    );
  }
}
