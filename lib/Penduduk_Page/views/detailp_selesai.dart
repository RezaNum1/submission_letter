import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_letter/Theme/theme_penduduk.dart';

class DetailpSelesai extends StatefulWidget {
  @override
  _DetailpSelesaiState createState() => _DetailpSelesaiState();
}

class _DetailpSelesaiState extends State<DetailpSelesai> {
  int idUser;
  String noTelepon;
  String nik;

  @override
  void initState() {
    setPreference();
    super.initState();
  }

  Future<void> setPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      idUser = pref.getInt("id");
      noTelepon = pref.getString("NoTelepon");
      nik = pref.getString("Nik");
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
            height: 60,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/dki.png'),
              ),
            ),
          ),
        ),
        drawer: ThemeAppPenduduk.sideBar(context, nik, noTelepon),
        body: Container(
          child: Center(
            child: Text("Detail Selesai Penduduk"),
          ),
        ));
  }
}
