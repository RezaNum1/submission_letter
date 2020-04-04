import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_letter/Animation/fade_animation.dart';
import 'package:submission_letter/Auth/presenter/login_presenter.dart';
import 'package:submission_letter/Auth/presenter/resgister_presenter.dart';
import 'package:submission_letter/Auth/presenter/userAuth_presenter.dart';
import 'package:submission_letter/Auth/views/login_views.dart';
import 'package:submission_letter/Auth/views/register_views.dart';
import 'package:submission_letter/Auth/views/userAuth_views.dart';
import 'package:submission_letter/Util/util_auth.dart';

class HomeBase extends StatefulWidget {
  @override
  _HomeBaseState createState() => _HomeBaseState();
}

class _HomeBaseState extends State<HomeBase> {
  Future getDataTest() async {
    Response response;
    Dio dio = new Dio();
    response = await dio.get("http://192.168.43.75:8000/api/test");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[300],
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              height: 320,
              width: double.infinity,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 10,
                    top: 10,
                    child: FadeAnimation(
                      1,
                      Text(
                        'Aplikasi Pengajuan',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 80,
                    top: 50,
                    child: FadeAnimation(
                      1.5,
                      Text(
                        'Surat Warga',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 80,
                    top: 100,
                    child: FadeAnimation(
                      1.7,
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        height: 150,
                        width: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/dki.png'),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 30, left: 30),
              child: Column(
                children: <Widget>[
                  FadeAnimation(
                    1.8,
                    Container(
                      width: double.infinity,
                      child: RaisedButton(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.white),
                        ),
                        child: Text(
                          "BUAT PENGAJUAN SURAT",
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        onPressed: () async {
                          UtilAuth.movePage(
                            context,
                            UserAuth(
                              presenter: UserAuthPresenter(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FadeAnimation(
                    1.8,
                    Container(
                      width: double.infinity,
                      child: RaisedButton(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.white),
                        ),
                        child: Text(
                          "AKSES RT / RW",
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        onPressed: () {
                          UtilAuth.movePage(
                              context, LoginViews(LoginPresenter()));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            FadeAnimation(
              2,
              Container(
                height: 180,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/building.png'),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
