import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_letter/Animation/fade_animation.dart';
import 'package:submission_letter/Auth/presenter/userAuth_presenter.dart';
import 'package:submission_letter/Auth/views/AuthComponent/phone_widget.dart';
import 'package:submission_letter/Auth/views/ocrPenduduk_views.dart';
import 'package:submission_letter/Auth/views/otp_views.dart';
import 'package:submission_letter/Notification/UtilToken/getToken.dart';
import 'package:submission_letter/Penduduk_Page/views/home_penduduk.dart';
import 'package:submission_letter/Util/util_auth.dart';
import 'package:submission_letter/home_page.dart';

class UserAuth extends StatefulWidget {
  UserAuthPresenter presenter;
  UserAuth({this.presenter});
  @override
  _UserAuthState createState() => _UserAuthState();
}

class _UserAuthState extends State<UserAuth> {
  String noTelepon;

  bool _validateNoTelepon;

  void callBackNoTelepon(String tlp) {
    setState(() {
      noTelepon = tlp;
    });
  }

  void processData(String tlpNumber) async {
    String tokens;
    UtilAuth.loading(context);
    GetToken getToken = new GetToken();
    tokens = await getToken.getFCMToken();
    var response = await widget.presenter.cekPhoneNumber(tlpNumber, tokens);
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    if (response.data['exist'] == false) {
      Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(
              builder: (context) => OtpViews(
                    noTelepon: noTelepon,
                  )),
          (Route<dynamic> route) => false);
    } else {
      if (response.data['Message'] == true) {
        UtilAuth.failedPopupDialog(
            context, "Akun Anda Telah Login Di Perangkat Lain!");
      } else {
        // lgsng masuk
        preferences.setInt("Id", response.data['data']['Id']);
        preferences.setString("NoTelepon", response.data['data']['NoTelepon']);
        preferences.setString("Nik", response.data['data']['Nik']);
        UtilAuth.successPopupDialog(context, 'Login Berhasil', HomePenduduk());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          child: ListView(
        children: <Widget>[
          Container(
            height: 200,
            width: double.infinity,
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: 140,
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/dki.png'),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  top: 130,
                  child: Text(
                    'Masukkan No Telepon Anda',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[300],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20, left: 20),
            child: Column(
              children: <Widget>[
                Container(
                  child: PhoneWidget(
                    callBackName: callBackNoTelepon,
                    vals: _validateNoTelepon,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.orange[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.orange[300]),
                    ),
                    child: Text(
                      "Masuk",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    onPressed: () async {
                      if (noTelepon != null) {
                        setState(() {
                          _validateNoTelepon = true;
                        });
                        processData(noTelepon);
                      } else {
                        setState(() {
                          _validateNoTelepon = false;
                        });
                      }
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.orange[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.orange[300]),
                    ),
                    child: Text(
                      "Kembali",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    onPressed: () async {
                      UtilAuth.movePage(context, HomeBase());
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          Container(
            height: 180,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/building.png'),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
