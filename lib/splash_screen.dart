import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_letter/Penduduk_Page/views/home_penduduk.dart';
import 'package:submission_letter/RTRW_Page/views/home_emp.dart';
import 'package:submission_letter/Util/util_auth.dart';
import 'package:submission_letter/home_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () {
      startApp();
    });
  }

  void startApp() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (preferences.getInt("TipeUser") != null) {
          if (preferences.getInt("TipeUser") == 1) {
            UtilAuth.movePage(context, HomeEmp());
          } else {
            UtilAuth.movePage(context, HomePenduduk());
          }
        } else {
          UtilAuth.movePage(context, HomeBase());
        }
      }
    } on SocketException catch (_) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Koneksi Internet"),
                  Divider(
                    thickness: 2,
                  ),
                ],
              ),
              content: Container(
                width: double.infinity,
                height: 100,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      child: Text(
                        "Tidak Ada Koneksi Internet, Silahkan Coba Kembali !",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        children: <Widget>[
                          new FlatButton(
                            onPressed: () {
                              exit(0);
                            },
                            child: new Text(
                              "Tutup",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "|",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          new FlatButton(
                            onPressed: () {
                              UtilAuth.movePage(context, SplashScreen());
                            },
                            child: new Text("OK",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[300],
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 100,
              ),
              Container(
                height: 230,
                width: 350,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/dki.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 200,
              ),
              Container(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(Colors.orange[300]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
