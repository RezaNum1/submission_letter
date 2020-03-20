import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:submission_letter/Animation/fade_animation.dart';
import 'package:submission_letter/Auth/presenter/login_presenter.dart';
import 'package:submission_letter/Auth/presenter/resgister_presenter.dart';
import 'package:submission_letter/Auth/views/AuthComponent/phone_widget.dart';
import 'package:submission_letter/Auth/views/AuthComponent/text_widget.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:submission_letter/Auth/views/AuthComponent/uploadButton.dart';
import 'package:submission_letter/Auth/views/login_views.dart';
import 'package:submission_letter/Util/util_auth.dart';
import 'package:submission_letter/home_page.dart';

class RegisterViews extends StatefulWidget {
  final RegisterPresenter presenter;
  RegisterViews(this.presenter);
  @override
  _RegisterViewsState createState() => _RegisterViewsState();
}

class _RegisterViewsState extends State<RegisterViews> {
  var urls = 'http://192.168.43.75:8000/api/register';
  String rwText;
  String rtText;
  String namaPegawai;
  String username;
  String passwords;
  String email;
  String noTelepon;

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

  void callBackRt(String texts) {
    setState(() {
      rtText = texts;
    });
  }

  void callBackRw(String texts) {
    setState(() {
      rwText = texts;
    });
  }

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
    print('Success');
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
                            fontSize: 30,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                      FadeAnimation(
                        0.7,
                        TextWidget(
                          callBackName: callBackNamaPegawai,
                          hintTexts: 'Masukkan Nama Lengkap Anda',
                          labelTexts: 'Nama Lengkap',
                          messageEmpty: 'Nama Pegawai Tidak Boleh Kosong',
                          val: _validate,
                        ),
                      ),
                      FadeAnimation(
                        0.8,
                        TextWidget(
                          callBackName: callBackUsername,
                          hintTexts: 'Masukkan Username Anda',
                          labelTexts: 'Username',
                          messageEmpty: 'Username Tidak Boleh Kosong!',
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
                          messageEmpty: "Password Tidak Boleh Kosong",
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
                        TextWidget(
                          callBackName: callBackRw,
                          hintTexts: 'Contoh: RW 01',
                          labelTexts: 'Rukun Warga (RW)',
                          messageEmpty: 'RW Tidak Boleh Kosong!',
                          val: _validateRw,
                          emails: false,
                          pass: false,
                        ),
                      ),
                      FadeAnimation(
                        1.3,
                        TextWidget(
                          callBackName: callBackRt,
                          hintTexts: 'Contoh: RT 001',
                          labelTexts: 'Rukun Tetangga (RT)',
                          messageEmpty: '',
                          val: _validateRt,
                          emails: false,
                          pass: false,
                        ),
                      ),
                      FadeAnimation(
                        1.3,
                        UploadButton(
                          title: 'Upload File Surat Jabatan',
                          textButton: 'Surat Jabatan Dari Kelurahan',
                          redText:
                              'Bentuk FIle Yang Diterima: .jpg / .jpeg / .png',
                          setFile: getImage,
                        ),
                      ),
                      FadeAnimation(
                        1.3,
                        UploadButton(
                          title: 'Upload File Tanda Tangan',
                          textButton: 'Tanda Tangan Elektronik Anda',
                          redText:
                              'Bentuk File Yang Diterima: .jpg / .jpeg / .png',
                          setFile: getImages,
                        ),
                      ),
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
                              processData(namaPegawai, username, passwords,
                                  email, noTelepon, rtText, rwText);
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
                              fontSize: 18,
                            ),
                          ),
                          onPressed: () {
                            UtilAuth.movePage(
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
