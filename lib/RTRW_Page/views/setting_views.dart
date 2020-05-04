import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_letter/Animation/fade_animation.dart';
import 'package:submission_letter/Auth/presenter/login_presenter.dart';
import 'package:submission_letter/Auth/views/AuthComponent/phone_widget.dart';
import 'package:submission_letter/Auth/views/AuthComponent/text_widget.dart';
import 'package:submission_letter/Auth/views/login_views.dart';
import 'package:submission_letter/RTRW_Page/presenter/setting_presenter.dart';
import 'package:submission_letter/RTRW_Page/views/home_emp.dart';
import 'package:submission_letter/Theme/theme_emp.dart';
import 'package:submission_letter/Util/util_auth.dart';

class SettingViews extends StatefulWidget {
  SettingPresenter presenter;
  SettingViews(this.presenter);
  @override
  _SettingViewsState createState() => _SettingViewsState();
}

class _SettingViewsState extends State<SettingViews> {
  String nama;
  String jabatanText;
  int id;

  var _oldPassword = new TextEditingController();
  var _newPassword = new TextEditingController();
  var _reNewPassword = new TextEditingController();

  bool _validateOldPass = false;
  bool _validateNewPass = false;
  bool _validateReNewPass = false;

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

  Future<void> ChangePassPro() async {
    UtilAuth.loading(context);

    if (_newPassword.text != _reNewPassword.text) {
      UtilAuth.failedPopupDialog(
          context, "Kedua Kolom Password Baru Anda Tidak Sama!");
      return;
    }

    String oldPassData = _oldPassword.text.toString();
    String newPassData = _newPassword.text.toString();

    var response =
        await widget.presenter.changeMyPassword(id, oldPassData, newPassData);

    if (response.data['error'] == true) {
      UtilAuth.failedPopupDialog(context, response.data['message']);
    } else {
      UtilAuth.successPopupDialog(context, response.data['message'], HomeEmp());
    }
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
        child: ListView(
          children: <Widget>[
            Center(
              child: FadeAnimation(
                0.4,
                Container(
                  margin: EdgeInsets.only(
                    top: 10,
                  ),
                  height: 80,
                  child: Icon(
                    Icons.account_circle,
                    size: 70,
                    color: Colors.orange,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 30, left: 30),
              child: Column(
                children: <Widget>[
                  FadeAnimation(
                    0.5,
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(143, 148, 251, .2),
                            blurRadius: 20.0,
                            offset: Offset(0, 10),
                          )
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Text(
                              'Ganti Password',
                              style:
                                  TextStyle(color: Colors.orange, fontSize: 35),
                            ),
                          ),
                          Divider(
                            height: 1,
                            color: Colors.orange,
                            thickness: 2,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey[300],
                                ),
                              ),
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: TextField(
                              obscureText: true,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Password Lama',
                                  hintText: "Masukkan Password Lama Anda",
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                  ),
                                  errorText: _validateOldPass
                                      ? "Masukkan Password lama anda!"
                                      : null),
                              controller: _oldPassword,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey[300],
                                ),
                              ),
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: TextField(
                              obscureText: true,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Password Baru',
                                  hintText:
                                      "Masukkan Password Baru Anda Dengan Benar",
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                  ),
                                  errorText: _validateNewPass
                                      ? "Masukkan Password Baru Anda!"
                                      : null),
                              controller: _newPassword,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey[300],
                                ),
                              ),
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: TextField(
                              obscureText: true,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Ulangi Password Baru',
                                  hintText:
                                      "Masukkan iUlang Password Baru Anda",
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                  ),
                                  errorText: _validateReNewPass
                                      ? "Masukkan Ulang Password Baru Anda Dengan Benar!"
                                      : null),
                              controller: _reNewPassword,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FadeAnimation(
                    0.6,
                    Container(
                      width: double.infinity,
                      child: RaisedButton(
                        color: Colors.orange[300],
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.orange[300])),
                        child: Text(
                          "Ganti Password",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        onPressed: () {
                          if (_oldPassword.text.isNotEmpty) {
                            setState(() {
                              _validateOldPass = false;
                            });
                            if (UtilAuth.checkStringPassword(
                                    _oldPassword.text.toString()) ==
                                true) {
                              setState(() {
                                _validateOldPass = false;
                              });
                              if (_newPassword.text.isNotEmpty) {
                                setState(() {
                                  _validateNewPass = false;
                                });
                                if (UtilAuth.checkStringPassword(
                                        _newPassword.text.toString()) ==
                                    true) {
                                  setState(() {
                                    _validateNewPass = false;
                                  });
                                  if (_reNewPassword.text.isNotEmpty) {
                                    setState(() {
                                      _validateReNewPass = false;
                                    });
                                    // Disini
                                    ChangePassPro();
                                  } else {
                                    setState(() {
                                      _validateReNewPass = true;
                                    });
                                  }
                                } else {
                                  setState(() {
                                    _validateNewPass = true;
                                  });
                                }
                              } else {
                                setState(() {
                                  _validateNewPass = true;
                                });
                              }
                            } else {
                              setState(() {
                                _validateOldPass = true;
                              });
                            }
                          } else {
                            setState(() {
                              _validateOldPass = true;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            FadeAnimation(
              1,
              Container(
                margin: EdgeInsets.only(top: 10),
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
