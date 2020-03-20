import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_letter/Theme/theme_emp.dart';

class AccountEmp extends StatefulWidget {
  @override
  _AccountEmpState createState() => _AccountEmpState();
}

class _AccountEmpState extends State<AccountEmp> {
  String nama;
  String jabatanText;
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
    });

    print(nama);
    print(jabatanText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          height: 60,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/dki.png'),
            ),
          ),
        ),
      ),
      drawer:
          ThemeApp.sideBar(context, nama.toString(), jabatanText.toString()),
      body: Center(
        child: Text(
          'Account Page',
          style: TextStyle(fontSize: 30, color: Colors.orange),
        ),
      ),
    );
  }
}
