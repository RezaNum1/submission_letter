import 'dart:io';
import 'dart:typed_data';

import 'package:camera_camera/page/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:network_image_to_byte/network_image_to_byte.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_letter/Auth/presenter/userAuth_presenter.dart';
import 'package:submission_letter/Auth/views/AuthComponent/nik_widget.dart';
import 'package:submission_letter/Notification/UtilToken/getToken.dart';
import 'package:submission_letter/Penduduk_Page/views/home_penduduk.dart';
import 'package:submission_letter/Util/util_auth.dart';
import 'package:submission_letter/main.dart';
import 'package:tesseract_ocr/tesseract_ocr.dart';

class OcrPenduduk extends StatefulWidget {
  String noTelepon;
  UserAuthPresenter presenter;
  OcrPenduduk({this.noTelepon, this.presenter});
  @override
  _OcrPendudukState createState() => _OcrPendudukState();
}

class _OcrPendudukState extends State<OcrPenduduk> {
  var nikController = TextEditingController();
  bool _validateNIK;

  //OCR
  String _extractText;
  bool stat = false;

  String nikText;
  //******** */
  // KAMERA
  File val;
  var url = "${MyApp.route}/api/cropnik";
  bool status = false;
  //************* */

  Future<void> sendToServer(BuildContext context, double sizes) async {
    if (val == null) {
      return;
    }
    UtilAuth.loading(context);
    Dio dio = new Dio();
    var datas = FormData.fromMap({
      "ktp": await MultipartFile.fromFile(val.path),
      "nama": 'KtpTmp',
      "size": sizes
    });

    var response = await dio.post(url, data: datas);
    if (response.data['message'] == true) {
      initPlatformState(context);
    }
  }

  initPlatformState(BuildContext context) async {
    String extractText;
    final Directory directory = await getTemporaryDirectory();
    final String imagePath = join(
      directory.path,
      "new.jpg",
    );

    Uint8List bytes =
        await networkImageToByte("${MyApp.routeOCR}/auth/file/Ktp/KtpTmp.jpeg");
    await File(imagePath).writeAsBytes(bytes);

    extractText = await TesseractOcr.extractText(imagePath, language: "ind");

    if (!mounted) return;

    setState(() {
      _extractText = extractText;
    });
    normalization(context);
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  void normalization(BuildContext context) {
    List<String> arrOCR = _extractText.split("\n");
    if (arrOCR[0].contains(":") == false) {
      UtilAuth.failedPopupDialogWithoutNav(
          context, 'Harap Scan Ulang KTP Anda');
      return;
    }
    var nik = arrOCR[0].split(':');
    var arrNIK = new List<String>.from(nik[1].toString().split(''));
    for (var i = 0; i < arrNIK.length; i++) {
      if (arrNIK[i] == "?") {
        arrNIK[i] = '7';
      } else if (arrNIK[i] == 'D') {
        arrNIK[i] = '0';
      } else if (arrNIK[i] == 'L') {
        arrNIK[i] = '1';
      } else if (arrNIK[i] == 'i') {
        arrNIK[i] = '1';
      } else if (arrNIK[i] == 'I') {
        arrNIK[i] = '1';
      }
      arrNIK.remove(' ');
    }
    setState(() {
      nikText = arrNIK.join();
      stat = true;
    });
    displayPopUp(context);
  }

  Widget displayPopUp(BuildContext context) {
    setState(() {
      nikController.text = nikText;
    });
    Navigator.of(context, rootNavigator: true).pop();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        // return Dialog(
        return AlertDialog(
          title: Text('Pendafdtaran NIK'),
          content: TextField(
            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
            controller: nikController,
            decoration: InputDecoration(
              hintText: 'Masukkan NIK Anda',
              labelText: 'NIK',
              labelStyle: TextStyle(
                color: Colors.grey[400],
              ),
              hintStyle: TextStyle(
                color: Colors.grey[400],
              ),
              errorText:
                  (_validateNIK == false) ? 'NIK Tidak Boleh Kosong' : null,
            ),
            keyboardType: TextInputType.number,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Daftar'),
              onPressed: () {
                if (nikController.text.isNotEmpty) {
                  setState(() {
                    _validateNIK = true;
                  });
                  processData(context, widget.noTelepon, nikController.text);
                } else {
                  setState(() {
                    _validateNIK = false;
                  });
                }
              },
            )
          ],
        );
        // );
      },
    );
  }

  void processData(BuildContext context, String phone, String nik) async {
    String tokens;
    UtilAuth.loading(context);
    GetToken getToken = new GetToken();
    tokens = await getToken.getFCMToken();
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    var response = await widget.presenter.regisData(phone, nik, tokens);
    if (response.data['error'] == true) {
      UtilAuth.failedPopupDialog(context, response.data['message']);
    } else {
      preferences.setInt("Id", response.data['data']['Id']);
      preferences.setString("NoTelepon", response.data['data']['NoTelepon']);
      preferences.setString("Nik", response.data['data']['Nik']);
      UtilAuth.successPopupDialog(
          context, response.data['message'], HomePenduduk());
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double bigBoxHeight;
    double topBigBox;
    double leftBigBox;
    double widthBigBox;

    //Frame
    double topFrame;
    double rightFrame;
    double heightFrame;

    //Text
    double topText;
    double rightText;
    double heightText;
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Hallo, Anda Adalah Pengguna Baru',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[300],
                        ),
                      ),
                      Text(
                        'Silakan Scan KTP Anda',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[300],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
                  "Scan KTP",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                onPressed: () async {
                  if (height < 650) {
                    setState(() {
                      bigBoxHeight = 530;
                      topBigBox = 10;
                      leftBigBox = 25;
                      widthBigBox = 310;
                      topFrame = 25;
                      rightFrame = 70;
                      heightFrame = 350;
                      topText = 70;
                      rightText = 340;
                      heightText = 550;
                    });
                  }
                  if (height >= 716) {
                    bigBoxHeight = height - 150;
                    topBigBox = 50;
                    leftBigBox = 0;
                    widthBigBox = MediaQuery.of(context).size.width;
                    topFrame = 65;
                    rightFrame = 50;
                    heightFrame = height - 340;
                    topText = 70;
                    rightText = 340;
                    heightText = 550;
                  }
                  if (height >= 850) {
                    bigBoxHeight =
                        MediaQuery.of(context).size.height.ceil() - 200.0;
                    topBigBox = 60;
                    leftBigBox = 0;
                    widthBigBox = MediaQuery.of(context).size.width;
                    topFrame = 80;
                    rightFrame = 60;
                    heightFrame =
                        MediaQuery.of(context).size.height.ceil() - 420.0;
                    topText = 70;
                    rightText = 390;
                    heightText = 550;
                  }
                  val = await showDialog(
                      context: context,
                      builder: (context) => Camera(
                            mode: CameraMode.normal,
                            orientationEnablePhoto: CameraOrientation.all,
                            imageMask: SafeArea(
                              top: true,
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    top: topBigBox,
                                    left: leftBigBox,
                                    child: Container(
                                      height: bigBoxHeight,
                                      width: widthBigBox,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 3, color: Colors.white)),
                                    ),
                                  ),
                                  Positioned(
                                    top: topFrame,
                                    right: rightFrame,
                                    child: Container(
                                      width: 30,
                                      height: heightFrame,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.white)),
                                    ),
                                  ),
                                  Positioned(
                                    top: topText,
                                    right: rightText,
                                    child: Container(
                                      width: 40,
                                      height: heightText,
                                      child: RotatedBox(
                                        quarterTurns: 1,
                                        child: Text(
                                          "*Pastikan KTP & NIK Anda Berada Di Dalam Kotak Yang Telah Ditentukan",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));
                  setState(() {});

                  sendToServer(context, height);
                }),
          ),
          SizedBox(
            height: 100,
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
