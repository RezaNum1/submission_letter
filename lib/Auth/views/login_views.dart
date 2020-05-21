import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:submission_letter/Animation/fade_animation.dart';
import 'package:submission_letter/Auth/presenter/forget_presenter.dart';
import 'package:submission_letter/Auth/presenter/login_presenter.dart';
import 'package:submission_letter/Auth/presenter/resgister_presenter.dart';
import 'package:submission_letter/Auth/views/forget_views.dart';
import 'package:submission_letter/Auth/views/register_views.dart';
import 'package:submission_letter/Notification/UtilToken/getToken.dart';
import 'package:submission_letter/RTRW_Page/views/home_emp.dart';
import 'package:submission_letter/Util/util_auth.dart';
import 'package:submission_letter/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViews extends StatefulWidget {
  LoginPresenter presenter;
  LoginViews(this.presenter);
  @override
  _LoginViewsState createState() => _LoginViewsState();
}

class _LoginViewsState extends State<LoginViews> {
  var _usernameController = TextEditingController();
  var _passwordController = TextEditingController();

  bool _validateUsername = false;
  bool _validatePassword = false;

  Future<void> loginProcessView(String usernames, String passwords) async {
    String tokens;
    UtilAuth.loading(context);
    GetToken getToken = new GetToken();
    tokens = await getToken.getFCMToken();
    var response =
        await widget.presenter.loginProcess(usernames, passwords, tokens);
    final SharedPreferences pref = await SharedPreferences.getInstance();

    if (response.data['error'] == false) {
      pref.setString('Nama', response.data['data']['Nama']);
      pref.setString('Jabatan', response.data['data']['JabatanText']);
      pref.setString('Email', response.data['data']['Email']);
      pref.setInt('Id', response.data['data']['Id']);
      pref.setInt("IdJobPos", response.data["IdJobPos"]);
      pref.setString("token", tokens);
      pref.setInt("TipeUser", 1);
      UtilAuth.successPopupDialog(context, response.data['message'], HomeEmp());
    } else {
      tokens = "";
      UtilAuth.failedPopupDialog(context, response.data['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: ListView(
          children: <Widget>[
            Center(
              child: FadeAnimation(
                0.5,
                Container(
                  margin: EdgeInsets.only(
                    top: 10,
                  ),
                  height: 80,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/dki.png'),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                right: 20,
                top: 12,
                left: 20,
                bottom: 0,
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange[400],
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        FadeAnimation(
                          0.6,
                          Text(
                            'Login',
                            style: GoogleFonts.sniglet(
                              fontSize: 30,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                        FadeAnimation(
                          0.7,
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
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Username',
                                  hintText: "Masukkan Username Anda",
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                  ),
                                  errorText: _validateUsername
                                      ? "Username tidak boleh kosong!"
                                      : null),
                              controller: _usernameController,
                            ),
                          ),
                        ),
                        FadeAnimation(
                          0.8,
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
                                  labelText: 'Password',
                                  hintText: "Masukkan Password Anda",
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                  ),
                                  errorText: _validatePassword
                                      ? "Masukkan Password Anda"
                                      : null),
                              controller: _passwordController,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        FadeAnimation(
                          0.9,
                          Container(
                            margin: EdgeInsets.only(right: 5, left: 5),
                            width: double.infinity,
                            child: RaisedButton(
                              color: Colors.orange[400],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: Colors.orange)),
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: height == 716 ? 20 : 30,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () async {
                                if (_usernameController.text.isNotEmpty) {
                                  setState(() {
                                    _validateUsername = false;
                                  });
                                  if (UtilAuth.checkUsername(_usernameController
                                          .text
                                          .toString()) ==
                                      true) {
                                    setState(() {
                                      _validateUsername = false;
                                    });
                                    if (_passwordController.text.isNotEmpty) {
                                      setState(() {
                                        _validatePassword = false;
                                      });
                                      if (UtilAuth.checkStringPassword(
                                          _passwordController.text
                                              .toString())) {
                                        setState(() {
                                          _validatePassword = false;
                                        });
                                        loginProcessView(
                                            _usernameController.text.toString(),
                                            _passwordController.text
                                                .toString());
                                      } else {
                                        setState(() {
                                          _validatePassword = true;
                                        });
                                      }
                                    } else {
                                      setState(() {
                                        _validatePassword = true;
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      _validateUsername = true;
                                    });
                                  }
                                } else {
                                  setState(() {
                                    _validateUsername = true;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        FadeAnimation(
                          1,
                          Container(
                            height: 100,
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                  child: FlatButton(
                                    child: Text(
                                      "Registrasi Akun RT / RW",
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontSize: height == 716 ? 15 : 18,
                                      ),
                                    ),
                                    onPressed: () {
                                      UtilAuth.movePageScale(context,
                                          RegisterViews(RegisterPresenter()));
                                    },
                                  ),
                                ),
                                Positioned(
                                  top: 30,
                                  left: 40,
                                  child: FlatButton(
                                    child: Text(
                                      "Lupa Password",
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontSize: height == 716 ? 16 : 18,
                                      ),
                                    ),
                                    onPressed: () {
                                      UtilAuth.movePageScale(
                                        context,
                                        ForgetPassword(
                                            ForgetPasswordPresenter()),
                                      );
                                    },
                                  ),
                                ),
                                Positioned(
                                  top: 60,
                                  left: 70,
                                  child: FlatButton(
                                    child: Text(
                                      "Kembali",
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontSize: height == 716 ? 16 : 18,
                                      ),
                                    ),
                                    onPressed: () {
                                      UtilAuth.movePage(context, HomeBase());
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
