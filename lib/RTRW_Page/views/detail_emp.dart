import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_letter/Theme/theme_emp.dart';

class DetailEmployeeData extends StatefulWidget {
  @override
  _DetailEmployeeDataState createState() => _DetailEmployeeDataState();
}

class _DetailEmployeeDataState extends State<DetailEmployeeData> {
  String nama;
  String jabatanText;
  int id;

  @override
  void initState() {
    setPreference();
    super.initState();
  }

  Future<void> setPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      nama = pref.getString('Nama');
      jabatanText = pref.getString('Jabatan');
      id = pref.getInt("Id");
    });
  }

  void dispose() {
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
          height: 50,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/dki.png'),
            ),
          ),
        ),
      ),
      drawer:
          ThemeApp.sideBar(context, nama.toString(), jabatanText.toString()),
      body: Container(
        child: Center(
          child: Text(
            "DETAIL EMPLOYEE",
            style: TextStyle(
              color: Colors.orange,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
