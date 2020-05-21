import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:submission_letter/Animation/fade_animation.dart';
import 'package:submission_letter/Auth/presenter/login_presenter.dart';
import 'package:submission_letter/Auth/presenter/resgister_presenter.dart';
import 'package:submission_letter/Auth/views/AuthComponent/dropdownregis_widget.dart';
import 'package:submission_letter/Auth/views/AuthComponent/filePickerRegis_widget.dart';
import 'package:submission_letter/Auth/views/AuthComponent/phone_widget.dart';
import 'package:submission_letter/Auth/views/AuthComponent/text_widget.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:submission_letter/Auth/views/AuthComponent/uploadButton.dart';
import 'package:submission_letter/Auth/views/login_views.dart';
import 'package:submission_letter/Penduduk_Page/widget/cancle_btn.dart';
import 'package:submission_letter/Util/util_auth.dart';
import 'package:submission_letter/home_page.dart';
import 'package:submission_letter/main.dart';

class RegisterViews extends StatefulWidget {
  final RegisterPresenter presenter;
  RegisterViews(this.presenter);
  @override
  _RegisterViewsState createState() => _RegisterViewsState();
}

class _RegisterViewsState extends State<RegisterViews> {
  var urls = '${MyApp.route}/api/register';
  String rwTextDrop;
  String rtTextDrop;
  String namaPegawai;
  String username;
  String passwords;
  String email;
  String noTelepon;

  // ******************  Drop Down Data

  void setRwText(String val) {
    setState(() {
      rwTextDrop = val;
    });
  }

  void setRtText(String val) {
    setState(() {
      rtTextDrop = val;
    });
  }

  File _image1;
  File _image2;

  bool _validateRw = true;
  bool _validateRt = true;
  bool _validate = true;
  bool _validateUsername = true;
  bool _validatePass = true;
  bool _validateemail = true;
  bool _validateNoTelepon = true;
  bool _validateFile1 = true;
  bool _validateFile2 = true;

  //................

  void callBackNamaPegawai(String texts) {
    setState(() {
      namaPegawai = texts;
    });
  }

  void callBackUsername(String texts) {
    setState(() {
      username = texts;
    });
  }

  void callBackPassword(String texts) {
    setState(() {
      passwords = texts;
    });
  }

  void callBackEmail(String texts) {
    setState(() {
      email = texts;
    });
  }

  void callBackNoTelp(String texts) {
    setState(() {
      noTelepon = texts;
    });
  }

  void callBackFile1(File val) {
    setState(() {
      _image1 = val;
    });
  }

  void callBackFile2(File val) {
    setState(() {
      _image2 = val;
    });
  }

  // ******** Cancle Btn Function

  void cancleFile1() {
    setState(() {
      _image1 = null;
    });
  }

  void cancleFile2() {
    setState(() {
      _image2 = null;
    });
  }

  // void callBackRt(String texts) {
  //   setState(() {
  //     rtText = texts;
  //   });
  // }

  // void callBackRw(String texts) {
  //   setState(() {
  //     rwText = texts;
  //   });
  // }

  Future<void> processData(
    String namas,
    String usernames,
    String passwords,
    String emails,
    String noTelepons,
    String rts,
    String rws,
  ) async {
    UtilAuth.loading(context);

    var fileName = _image1.path.split('/').last;
    var fileNames = _image2.path.split('/').last;
    var allData = FormData.fromMap({
      "NamaPegawai": namas,
      "Ussername": usernames,
      "password": passwords,
      "email": emails,
      "phone": noTelepons,
      "rw": rws,
      "rt": rts,
      // "signature": MultipartFile.fromBytes(img1).finalize(),
      "file": await MultipartFile.fromFile(
        _image1.path,
        filename: fileName,
      ),
      "files": await MultipartFile.fromFile(
        _image2.path,
        filename: fileNames,
      ),
    });

    Dio dio = new Dio();

    var response = await dio.post(urls, data: allData);

    if (response.data['error'] == false) {
      UtilAuth.successPopupDialog(
          context, response.data['message'], HomeBase());
    } else {
      // UtilLetterU.stayPage(context);
      UtilAuth.failedPopupDialog(context, response.data['message']);
    }
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50, // <- Reduce Image quality
      maxHeight: 500, // <- reduce the image size
      maxWidth: 500,
    );
    setState(() {
      _image1 = image;
    });

    print(image);
  }

  Future getImages() async {
    var images = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxHeight: 500,
      maxWidth: 500,
    );

    setState(() {
      _image2 = images;
    });
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
                  margin: EdgeInsets.only(top: 10),
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
              padding:
                  EdgeInsets.only(right: 25, left: 25, bottom: 25, top: 25),
              child: Column(children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange[400],
                        blurRadius: 5.0,
                      )
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      FadeAnimation(
                        0.6,
                        Text(
                          'REGISTRASI RT / RW',
                          style: GoogleFonts.sniglet(
                            fontSize: height == 716 ? 25 : 30,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _validateRw == false
                                ? Text(
                                    "*RW Tidak Boleh Kosong !",
                                    style: TextStyle(color: Colors.red),
                                  )
                                : Container(),
                            _validateRt == false
                                ? Text(
                                    "*RT Tidak Boleh Kosong !",
                                    style: TextStyle(color: Colors.red),
                                  )
                                : Container(),
                            _validateFile1 == false
                                ? Text(
                                    "*Foto Surat Jabatan Harus Anda Upload !",
                                    style: TextStyle(color: Colors.red),
                                  )
                                : Container(),
                            _validateFile2 == false
                                ? Text(
                                    "*Sampel TTD Elektronik Harus Anda Upload !",
                                    style: TextStyle(color: Colors.red),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      FadeAnimation(
                        0.7,
                        TextWidget(
                          callBackName: callBackNamaPegawai,
                          hintTexts: 'Masukkan Nama Lengkap Anda',
                          labelTexts: 'Nama Lengkap',
                          messageEmpty: 'Masukkan Nama Pegawai Dengan Benar!',
                          val: _validate,
                        ),
                      ),
                      FadeAnimation(
                        0.8,
                        TextWidget(
                          callBackName: callBackUsername,
                          hintTexts: 'Masukkan Username Anda',
                          labelTexts: 'Username',
                          messageEmpty: 'Masukkan Username Dengan Benar!',
                          val: _validateUsername,
                          emails: false,
                          pass: false,
                        ),
                      ),
                      FadeAnimation(
                        0.9,
                        TextWidget(
                          callBackName: callBackPassword,
                          hintTexts: "Masukkan Password Anda",
                          labelTexts: "Password",
                          messageEmpty: "Masukkan Password Dengan Benar!",
                          val: _validatePass,
                          emails: false,
                          pass: true,
                        ),
                      ),
                      FadeAnimation(
                        1,
                        TextWidget(
                          callBackName: callBackEmail,
                          hintTexts: "Masukkan Email Aktif Anda",
                          labelTexts: "Email",
                          messageEmpty: "Masukkan Email Yang Valid",
                          val: _validateemail,
                          emails: true,
                          pass: false,
                        ),
                      ),
                      FadeAnimation(
                        1.1,
                        PhoneWidget(
                          callBackName: callBackNoTelp,
                          vals: _validateNoTelepon,
                        ),
                      ),
                      // DropDownRW(rwText, callBack, validateDropDownRW),
                      // DropDownRT(rtText, callBack2, validateDropDownRT),
                      FadeAnimation(
                        1.2,
                        DropDownRegis(dataRt: setRtText, dataRw: setRwText),
                      ),
                      _image1 == null
                          ? FadeAnimation(
                              0.1,
                              FilePickerRegis(
                                title: "Surat Jabatan Dari Kelurahan",
                                setFileAtt: callBackFile1,
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              child: RaisedButton(
                                  child: Text(
                                    "Batal",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  textColor: Colors.white,
                                  color: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(color: Colors.red),
                                  ),
                                  onPressed: () {
                                    cancleFile1();
                                  }),
                            ),
                      SizedBox(height: 10),
                      _image2 == null
                          ? FadeAnimation(
                              0.1,
                              FilePickerRegis(
                                title: "File Scan TTD & Stample",
                                setFileAtt: callBackFile2,
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              child: RaisedButton(
                                  child: Text(
                                    "Batal",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  textColor: Colors.white,
                                  color: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(color: Colors.red),
                                  ),
                                  onPressed: () {
                                    cancleFile2();
                                  }),
                            ),
                      SizedBox(height: 20),
                      FadeAnimation(
                        1.4,
                        Container(
                          margin: EdgeInsets.only(bottom: 0),
                          width: double.infinity,
                          child: RaisedButton(
                            color: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: Colors.white),
                            ),
                            child: Text(
                              'Registrasi',
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              if (namaPegawai != null) {
                                setState(() {
                                  _validate = true;
                                });
                                if (UtilAuth.checkString(namaPegawai) == true) {
                                  setState(() {
                                    _validate = true;
                                  });
                                  if (username != null) {
                                    setState(() {
                                      _validateUsername = true;
                                    });
                                    if (UtilAuth.checkUsername(username) ==
                                        true) {
                                      setState(() {
                                        _validateUsername = true;
                                      });
                                      if (passwords != null) {
                                        setState(() {
                                          _validatePass = true;
                                        });
                                        if (UtilAuth.checkStringPassword(
                                                passwords) ==
                                            true) {
                                          setState(() {
                                            _validatePass = true;
                                          });
                                          if (email != null) {
                                            setState(() {
                                              _validateemail = true;
                                            });
                                            if (UtilAuth.checkEmail(email) ==
                                                true) {
                                              setState(() {
                                                _validateemail = true;
                                              });
                                              if (noTelepon != null) {
                                                setState(() {
                                                  _validateNoTelepon = true;
                                                });
                                                if (rwTextDrop != null) {
                                                  setState(() {
                                                    _validateRw = true;
                                                  });
                                                  if (rtTextDrop != null) {
                                                    setState(() {
                                                      _validateRt = true;
                                                    });
                                                    if (_image1 != null) {
                                                      setState(() {
                                                        _validateFile1 = true;
                                                      });
                                                      if (_image2 != null) {
                                                        setState(() {
                                                          _validateFile2 = true;
                                                        });
                                                        processData(
                                                            namaPegawai,
                                                            username,
                                                            passwords,
                                                            email,
                                                            noTelepon,
                                                            rtTextDrop,
                                                            rwTextDrop);
                                                      } else {
                                                        setState(() {
                                                          _validateFile2 =
                                                              false;
                                                        });
                                                      }
                                                    } else {
                                                      setState(() {
                                                        _validateFile1 = false;
                                                      });
                                                    }
                                                  } else {
                                                    setState(() {
                                                      _validateRt = false;
                                                    });
                                                  }
                                                } else {
                                                  setState(() {
                                                    _validateRw = false;
                                                  });
                                                }
                                              } else {
                                                setState(() {
                                                  _validateNoTelepon = false;
                                                });
                                              }
                                            } else {
                                              setState(() {
                                                _validateemail = false;
                                              });
                                            }
                                          } else {
                                            setState(() {
                                              _validateemail = false;
                                            });
                                          }
                                        } else {
                                          setState(() {
                                            _validatePass = false;
                                          });
                                        }
                                      } else {
                                        setState(() {
                                          _validatePass = false;
                                        });
                                      }
                                    } else {
                                      setState(() {
                                        _validateUsername = false;
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      _validateUsername = false;
                                    });
                                  }
                                } else {
                                  setState(() {
                                    _validate = false;
                                  });
                                }
                              } else {
                                setState(() {
                                  _validate = false;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      FadeAnimation(
                        1.5,
                        FlatButton(
                          child: Text(
                            "Kembali",
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: height == 716 ? 15 : 18,
                            ),
                          ),
                          onPressed: () {
                            UtilAuth.movePageScale(
                                context, LoginViews(LoginPresenter()));
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ]),
            ),
            FadeAnimation(
              0.9,
              Container(
                height: 170,
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
