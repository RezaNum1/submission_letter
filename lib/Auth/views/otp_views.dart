import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:submission_letter/Auth/presenter/userAuth_presenter.dart';
import 'package:submission_letter/Auth/views/AuthComponent/otp_widget.dart';
import 'package:submission_letter/Auth/views/ocrPenduduk_views.dart';
import 'package:submission_letter/Util/util_auth.dart';
import 'package:submission_letter/home_page.dart';
import 'package:countdown/countdown.dart';

class OtpViews extends StatefulWidget {
  String noTelepon;
  OtpViews({this.noTelepon});
  @override
  _OtpViewsState createState() => _OtpViewsState();
}

class _OtpViewsState extends State<OtpViews> {
  String otpNumber;
  int realOTP;

  bool _validateotpNumber;

  bool statTerkirim = false;
  String countDowns;

  bool selesai = false;

  void callBackOtpNumber(String otpn) {
    setState(() {
      otpNumber = otpn;
    });
  }

  @override
  initState() {
    super.initState();
    getOtpNumber();
  }

  void getOtpNumber() async {
    setState(() {
      selesai = false;
    });
    UserAuthPresenter presenter = new UserAuthPresenter();
    var res = await presenter.generateOTP();
    print(res);
    setState(() {
      realOTP = int.parse(res);
      statTerkirim = true;
    });
    this.countDown();
  }

  void countDown() {
    CountDown cd = CountDown(Duration(minutes: 2));
    var sub = cd.stream.listen(null);

    sub.onData((Duration m) {
      setState(() {
        countDowns = m.toString().substring(2, 7);
      });
    });
    sub.onDone(() {
      setState(() {
        statTerkirim = false;
        realOTP = 0000000010;
        selesai = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              height: 150,
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
                    left: 30,
                    top: 130,
                    child: Text(
                      'Masukkan No Kode Aktivasi Anda',
                      style: TextStyle(
                        fontSize: 20,
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
                    child: OtpWidgetNumber(
                      callBackName: callBackOtpNumber,
                      vals: _validateotpNumber,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Kode aktivasi telah dikirim, periksa SMS masuk untuk mendapatkan kode $realOTP',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[300],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  statTerkirim
                      ? Text(
                          'Waktu: $countDowns',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[300],
                          ),
                        )
                      : Container(),
                  selesai
                      ? GestureDetector(
                          onTap: () {
                            this.getOtpNumber();
                          },
                          child: Text(
                            "Kirim Ulang Kode?",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      : Container(),
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
                        "Proses",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      onPressed: () async {
                        if (otpNumber != null) {
                          setState(() {
                            _validateotpNumber = true;
                          });
                          UtilAuth.loading(context);
                          if (int.parse(otpNumber) == realOTP) {
                            Navigator.of(context).pushAndRemoveUntil(
                                CupertinoPageRoute(
                                    builder: (context) => OcrPenduduk(
                                          noTelepon: widget.noTelepon,
                                          presenter: UserAuthPresenter(),
                                        )),
                                (Route<dynamic> route) => false);
                          } else {
                            UtilAuth.failedPopupDialog(
                                context, "Kode Aktifasi Anda Salah!");
                          }
                        } else {
                          setState(() {
                            _validateotpNumber = false;
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
        ),
      ),
    );
  }
}
