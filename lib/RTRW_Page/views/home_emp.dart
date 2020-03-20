import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_letter/RTRW_Page/APP_TabBar/selesai_emp.dart';
import 'package:submission_letter/RTRW_Page/APP_TabBar/todo_emp.dart';
import 'package:submission_letter/Theme/theme_emp.dart';

class HomeEmp extends StatefulWidget {
  @override
  _HomeEmpState createState() => _HomeEmpState();
}

class _HomeEmpState extends State<HomeEmp> with SingleTickerProviderStateMixin {
  TabController controller;
  String nama;
  String jabatanText;

  @override
  void initState() {
    controller = TabController(length: 2, vsync: this);
    setPreference();
    super.initState();
  }

  Future<void> setPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      nama = pref.getString('Nama');
      jabatanText = pref.getString('Jabatan');
    });

    // print(nama);
    // print(jabatanText);
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
          ],
        ),
      ),
      drawer:
          ThemeApp.sideBar(context, nama.toString(), jabatanText.toString()),
      body: TabBarView(
        controller: controller,
        children: <Widget>[
          TODOEmp(),
          SelesaiEmp(),
        ],
      ),
    );
  }
}
