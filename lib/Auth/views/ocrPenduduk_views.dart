import 'dart:io';
import 'dart:typed_data';

import 'package:camera_camera/page/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:network_image_to_byte/network_image_to_byte.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:submission_letter/Auth/presenter/userAuth_presenter.dart';
import 'package:submission_letter/Auth/views/AuthComponent/nik_widget.dart';
import 'package:tesseract_ocr/tesseract_ocr.dart';

class OcrPenduduk extends StatefulWidget {
  String noTelepon;
  UserAuthPresenter presenter;
  OcrPenduduk({this.noTelepon, this.presenter});
  @override
  _OcrPendudukState createState() => _OcrPendudukState();
}

class _OcrPendudukState extends State<OcrPenduduk> {
  String nik;
  bool _validateNIK;

  void callBackNIK(String niks) {
    setState(() {
      nik = niks;
    });
  }

  bool before = true;

  //OCR
  String _extractText;
  bool stat = false;

  String nikText;
  //******** */
  // KAMERA
  File val;
  var url = "http://192.168.43.75:8000/api/cropnik";
  bool status = false;
  //************* */

  Future<void> sendToServer() async {
    Dio dio = new Dio();
    var datas = FormData.fromMap(
        {"ktp": await MultipartFile.fromFile(val.path), "nama": 'KtpTmp'});

    var response = await dio.post(url, data: datas);
    print(response.data['message']);
    if (response.data['message'] == true) {
      initPlatformState();
    }
  }

  initPlatformState() async {
    String extractText;
    final Directory directory = await getTemporaryDirectory();
    final String imagePath = join(
      directory.path,
      "new.jpg",
    );

    Uint8List bytes = await networkImageToByte(
        "http://192.168.43.75/auth/file/Ktp/KtpTmp.jpeg");
    await File(imagePath).writeAsBytes(bytes);

    extractText = await TesseractOcr.extractText(imagePath, language: "ind");

    if (!mounted) return;

    setState(() {
      _extractText = extractText;
    });
    normalization();
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  void normalization() {
    List<String> arrOCR = _extractText.split("\n");
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
    // if (isNumeric(nik[1].toString())) {
    //   // ADA translete value ? i atau yg lain

    // }

    setState(() {
      nikText = arrNIK.join();
      stat = true;
    });

    print(nikText);
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
          before
              ? Container(
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
                      val = await showDialog(
                          context: context,
                          builder: (context) => Camera(
                                mode: CameraMode.normal,
                                orientationEnablePhoto: CameraOrientation.all,
                                imageMask: Stack(
                                  children: <Widget>[
                                    Positioned(
                                      top: 10,
                                      left: 25,
                                      child: Container(
                                        height: 530,
                                        width: 310,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 3, color: Colors.white)),
                                      ),
                                    ),
                                    Positioned(
                                      top: 24,
                                      right: 75,
                                      child: Container(
                                        width: 30,
                                        height: 365,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 2, color: Colors.white)),
                                      ),
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 340,
                                      child: Container(
                                        width: 40,
                                        height: 500,
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
                              ));
                      setState(() {});
                      sendToServer();
                    },
                  ),
                )
              : Padding(
                  padding: EdgeInsets.only(right: 20, left: 20),
                  child: Column(
                    children: <Widget>[
                      Container(
                          child: NikWidget(
                        callBackName: callBackNIK,
                        vals: _validateNIK,
                      )),
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
                          onPressed: () async {},
                        ),
                      ),
                    ],
                  ),
                ),
          SizedBox(
            height: 20,
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
