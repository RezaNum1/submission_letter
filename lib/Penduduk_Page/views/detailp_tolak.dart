import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera_camera/camera_camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:network_image_to_byte/network_image_to_byte.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_letter/Penduduk_Page/presenter/detailp_tolak_presenter.dart';
import 'package:submission_letter/Penduduk_Page/viewmodel/detailp_tolak_viewmodel.dart';
import 'package:submission_letter/Penduduk_Page/views/home_penduduk.dart';
import 'package:submission_letter/Penduduk_Page/widget/file_picker.dart';
import 'package:submission_letter/Theme/theme_penduduk.dart';
import 'package:submission_letter/Util/util_auth.dart';
import 'package:submission_letter/Util/util_rtrw.dart';
import 'package:tesseract_ocr/tesseract_ocr.dart';

class DetailpTolak extends StatefulWidget {
  String idSurat;
  String tipe;
  DetailpTolak({this.idSurat, this.tipe});
  @override
  _DetailpTolakState createState() => _DetailpTolakState();
}

class _DetailpTolakState extends State<DetailpTolak> {
  // Note: Tambahin validasi di popup agar semua data terisi sebelum ok
  int idUser;
  String noTelepon;
  String nikPref;

  //*********** COMPONEN OCR *****************************/

  bool okPressKtp = false;
  bool okPressKK = false;

  String _extractText = 'Unknown';
  List<String> dataOCR = [];
  bool stat = false;

  //KTP REQ VAR;
  String nikText;
  String provText;
  String kota_kecText;
  String tgl_lahirText;
  String jenis_kelaminText;

  String namaText;
  String alamatText;
  String rtrwText;
  String kelText;
  String agamaText;
  String spText;
  String workText;
  String pendidikanText;

  var _nikController = TextEditingController();
  var _kelurahanController = TextEditingController();
  var _rtrwController = TextEditingController();
  var _spController = TextEditingController();
  var _workController = TextEditingController();
  var _alamatController = TextEditingController();
  var _namaController = TextEditingController();
  var _agamaController = TextEditingController();
  var _pendidikanController = TextEditingController();

  // KAMERA
  File val;
  var urlKtp = "http://192.168.43.75:8000/api/cropktp";
  bool status = false;
  //************* */

  bool normProcess = false;

  Map<String, dynamic> prov = {'31': 'Jakarta'};
  //BBCC
  Map<String, dynamic> kota_kecamatan = {
    '01': {
      '01': 'Kep Seribu Utara',
      '02': 'Kep Seribu Selatan',
    },
    '71': {
      '01': 'Gambir',
      '02': 'Sawah besar',
      '03': 'Kemayoran',
      '04': 'Senen',
      '05': 'Cempaka Putih',
      '06': 'Menteng',
      '07': 'Tanah Abang',
      '08': 'Johar Baru'
    },
    '72': {
      '01': 'Penjaringan',
      '02': 'Tanjung Priok',
      '03': 'Koja',
      '04': 'Cilincing',
      '05': 'Pademangan',
      '06': 'Kelapa Gading'
    },
    '73': {
      '01': 'Cengkareng',
      '02': 'Gerogol Petamburan',
      '03': 'Taman Sari',
      '04': 'Tambora',
      '05': 'Kebon Jeruk',
      '06': 'Kali Deres',
      '07': 'Pal Merah',
      '08': 'Kembangan'
    },
    '74': {
      '01': 'Tebet',
      '02': 'Setia Budi',
      '03': 'Mapang Perapatan',
      '04': 'Pasar Minggu',
      '05': 'Kebayoran Lama',
      '06': 'Cilandak',
      '07': 'Kebayoran Baru',
      '08': 'Pancoran',
      '09': 'Jagakarsa',
      '10': 'Pesanggrahan',
    },
    '75': {
      '01': 'Matraman',
      '02': 'Pulo Gadung',
      '03': 'Jatinegara',
      '04': 'Kramatjati',
      '05': 'Pasar Rebo',
      '06': 'Cakung',
      '07': 'Duren Sawit',
      '08': 'Makasar',
      '09': 'Ciracas',
      '10': 'Cipayung'
    },
  };

  //EE
  Map<String, dynamic> bulan = {
    '01': 'Januari',
    '02': 'Februari',
    '03': 'Maret',
    '04': 'April',
    '05': 'Mei',
    '06': 'Juni',
    '07': 'Juli',
    '08': 'Agustus',
    '09': 'September',
    '10': 'Oktober',
    '11': 'November',
    '12': 'Desember',
  };

  // OCR KK VARIABLE
  String _extractTextkk;
  bool statkk = false;
  bool kkNormProc = false;

  String nokkText;
  var _kkController = TextEditingController();
  //******** */
  // KAMERA
  File valkk;
  var urlkk = "http://192.168.43.75:8000/api/cropkk";

//******************* ***************************************/

//************************************** File Perbaikan ******** */
//Base
  File ktpImage;
  File kkImage;
//1
  File _depanRumah;
  File _belakangRumah;
//2
  File _spptTerbaru;
//3
  File _lampiranPer;
//4
  File _ktpOrtu1;
  File _ktpOrtu2;
  File _lunasPbb1;
//5
  File _akteCerai;
  File _lunasPbb2;
  File _skks;
//7
  File _skksdrs;
//8
  File _skck;

  void setdepanRumah(File vals) {
    setState(() {
      _depanRumah = vals;
    });
  }

  void setbelakangRumah(File vals) {
    setState(() {
      _belakangRumah = vals;
    });
  }

  void setspptTerbaru(File vals) {
    setState(() {
      _spptTerbaru = vals;
    });
  }

  void setlamper(File vals) {
    setState(() {
      _lampiranPer = vals;
    });
  }

  void setktportu1(File vals) {
    setState(() {
      _ktpOrtu1 = vals;
    });
  }

  void setktportu2(File vals) {
    setState(() {
      _ktpOrtu2 = vals;
    });
  }

  void setlunaspbb1(File vals) {
    setState(() {
      _lunasPbb1 = vals;
    });
  }

  void setaktecerai(File vals) {
    setState(() {
      _akteCerai = vals;
    });
  }

  void setlunaspbb2(File vals) {
    setState(() {
      _lunasPbb2 = vals;
    });
  }

  void setskks(File vals) {
    setState(() {
      _skks = vals;
    });
  }

  void setskksdrs(File vals) {
    setState(() {
      _skksdrs = vals;
    });
  }

  void setskck(File vals) {
    setState(() {
      _skck = vals;
    });
  }

//************************************** END File Perbaikan ******** */
  @override
  void initState() {
    setPreference();
    super.initState();
  }

  Future<void> setPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      idUser = pref.getInt("Id");
      noTelepon = pref.getString("NoTelepon");
      nikPref = pref.getString("Nik");
    });
  }

  void dispose() {
    super.dispose();
  }

  //************************* OCR FUNCTION *************************** */

  //KAMERA
  Future<void> sendToServer(BuildContext context) async {
    netralVariable();
    if (val == null) {
      return;
    }
    UtilAuth.loading(context);
    Dio dio = new Dio();

    var datas = FormData.fromMap(
        {"ktp": await MultipartFile.fromFile(val.path), "nama": "KTPME"});

    var response = await dio.post(urlKtp, data: datas);
    if (response.data['message'] == true) {
      initPlatformState(context);
    }
  }

  initPlatformState(BuildContext context) async {
    String extractText;
    // Platform messages may fail, so we use a try/catch PlatformException.

    final Directory directory = await getTemporaryDirectory();
    final String imagePath = join(
      directory.path,
      "new.jpg",
    );

    Uint8List bytes = await networkImageToByte(
        "http://192.168.43.75/auth/file/Ktp/KTPME.jpeg");
    await File(imagePath).writeAsBytes(bytes);

    extractText = await TesseractOcr.extractText(imagePath, language: "ind");

    if (!mounted) return;

    setState(() {
      dataOCR.add(extractText.toString());
      _extractText = extractText;
      stat = true;
    });
    print(_extractText);

    if (stat == true) {
      normalizationData(context);
    }
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  void normalizationData(BuildContext context) {
    //AA

    List<String> arrOCR = _extractText.split("\n");

    if (arrOCR.length >= 11) {
      //NIK

      if (arrOCR[0].contains(":")) {
        var nik = arrOCR[0].split(':');
        var arrNIK = new List<String>.from(nik[1].toString().split(''));
        // if (isNumeric(nik[1].toString()) && arrNIK.length <= 18) {
        // ADA translete value ? i atau yg lain
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
        }

        for (var i = 0; i < arrNIK.length; i++) {
          arrNIK.remove(" ");
          arrNIK.remove(" ");
          arrNIK.remove("");
          arrNIK.remove(' ');
          arrNIK.remove('"');
        }

        // for (var i = 0; i < arrNIK.length; i++) {
        //   if (isNumeric(arrNIK[i]) == false) {
        //     arrNIK.removeAt(i);
        //   }
        // }
        // Length harus < 17
        setState(() {
          nikText = arrNIK.join();
        });
      } else if (arrOCR[0].contains('"')) {
        var nik = arrOCR[0].split('"');
        var arrNIK = new List<String>.from(nik[1].toString().split(''));
        // if (isNumeric(nik[1].toString()) && arrNIK.length <= 18) {
        // ADA translete value ? i atau yg lain
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
        }

        for (var i = 0; i < arrNIK.length; i++) {
          arrNIK.remove(" ");
          arrNIK.remove(" ");
          arrNIK.remove("");
          arrNIK.remove(' ');
          arrNIK.remove('"');
        }

        // for (var i = 0; i < arrNIK.length; i++) {
        //   if (isNumeric(arrNIK[i]) == false) {
        //     arrNIK.removeAt(i);
        //   }
        // }
        // Length harus < 17
        setState(() {
          nikText = arrNIK.join();
        });
      } else {
        var nik = arrOCR[0].split(' ');
        var arrNIK = new List<String>.from(nik[1].toString().split(''));
        // if (isNumeric(nik[1].toString()) && arrNIK.length <= 18) {
        // ADA translete value ? i atau yg lain
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
        }

        for (var i = 0; i < arrNIK.length; i++) {
          arrNIK.remove(" ");
          arrNIK.remove(" ");
          arrNIK.remove("");
          arrNIK.remove(' ');
          arrNIK.remove('"');
        }

        // for (var i = 0; i < arrNIK.length; i++) {
        //   if (isNumeric(arrNIK[i]) == false) {
        //     arrNIK.removeAt(i);
        //   }
        // }
        // Length harus < 17
        setState(() {
          nikText = arrNIK.join();
        });
      }

      //

      // if (isNumeric(arrNIK.join()) && arrNIK.length < 17) {}
      // }

      // ETC
      // Nama
      var namaFill = List<String>.from(arrOCR[1].split(''));
      for (var i = 0; i < namaFill.length; i++) {
        namaFill.remove('.');
        namaFill.remove('_');
        namaFill.remove('!');
        namaFill.remove("-");
        namaFill.remove('"');
      }

      var text1 = namaFill.join('');

      if (namaFill.contains(":")) {
        var namaArr = List<String>.from(text1.split(':'));
        setState(() {
          namaText = namaArr[1];
        });
      } else {
        var namaArr = List<String>.from(text1.split(' '));
        namaArr.removeAt(0);
        setState(() {
          namaText = namaArr.join(' ');
        });
      }

      //Alamat
      var alamatFill = List<String>.from(arrOCR[4].split(''));
      for (var i = 0; i < alamatFill.length; i++) {
        alamatFill.remove('.');
        alamatFill.remove('_');
        alamatFill.remove('!');
        alamatFill.remove("-");
        alamatFill.remove('"');
      }

      var text2 = alamatFill.join('');
      if (alamatFill.contains(":")) {
        var alamatArr = List<String>.from(text2.split(':'));
        setState(() {
          alamatText = alamatArr[1];
        });
      } else {
        var alamatArr = List<String>.from(text2.split(' '));
        alamatArr.removeAt(0);
        setState(() {
          alamatText = alamatArr.join(' ');
        });
      }

      //RTRW
      var rtrwFill = List<String>.from(arrOCR[5].split(''));
      for (var i = 0; i < rtrwFill.length; i++) {
        rtrwFill.remove('.');
        rtrwFill.remove('_');
        rtrwFill.remove('!');
        rtrwFill.remove("-");
        rtrwFill.remove('"');
      }

      var text3 = rtrwFill.join('');
      if (rtrwFill.contains(":")) {
        var rtrwArr = List<String>.from(text3.split(':'));
        setState(() {
          rtrwText = rtrwArr[1];
        });
      } else {
        var rtrwArr = List<String>.from(text3.split(' '));
        rtrwArr.removeAt(0);
        setState(() {
          rtrwText = rtrwArr.join(' ');
        });
      }

      //Kelurahan
      var kelFill = List<String>.from(arrOCR[6].split(''));
      for (var i = 0; i < kelFill.length; i++) {
        kelFill.remove('.');
        kelFill.remove('_');
        kelFill.remove('!');
        kelFill.remove("-");
        kelFill.remove('"');
      }
      var text4 = kelFill.join('');
      if (kelFill.contains(":")) {
        var kelArr = List<String>.from(text4.split(':'));
        setState(() {
          kelText = kelArr[1];
        });
      } else {
        var kelArr = List<String>.from(text4.split(' '));
        kelArr.removeAt(0);
        setState(() {
          kelText = kelArr.join(' ');
        });
      }

      //Agama
      var agamaFill = List<String>.from(arrOCR[8].split(''));
      for (var i = 0; i < agamaFill.length; i++) {
        agamaFill.remove('.');
        agamaFill.remove('_');
        agamaFill.remove('!');
        agamaFill.remove("-");
        agamaFill.remove('"');
      }

      var text5 = agamaFill.join('');
      if (agamaFill.contains(":")) {
        var agamaArr = List<String>.from(text5.split(':'));
        setState(() {
          agamaText = agamaArr[1];
        });
      } else {
        var agamaArr = List<String>.from(text5.split(' '));
        agamaArr.removeAt(0);
        setState(() {
          agamaText = agamaArr.join(' ');
        });
      }

      //SP
      var spFill = List<String>.from(arrOCR[9].split(''));
      for (var i = 0; i < spFill.length; i++) {
        spFill.remove('.');
        spFill.remove('_');
        spFill.remove('!');
        spFill.remove("-");
        spFill.remove('"');
      }

      var text6 = spFill.join('');
      if (spFill.contains(":")) {
        var spArr = List<String>.from(text6.split(':'));
        setState(() {
          spText = spArr[1];
        });
      } else {
        var spArr = List<String>.from(text6.split(' '));
        spArr.removeAt(0);
        setState(() {
          spText = spArr.join(' ');
        });
      }

      //Pekerjaan
      var workFill = List<String>.from(arrOCR[10].split(''));
      for (var i = 0; i < workFill.length; i++) {
        workFill.remove('.');
        workFill.remove('_');
        workFill.remove('!');
        workFill.remove("-");
        workFill.remove('"');
      }

      var text7 = workFill.join('');
      if (workFill.contains(":")) {
        var workArr = List<String>.from(text7.split(':'));
        setState(() {
          workText = workArr[1];
        });
      } else {
        var workArr = List<String>.from(text7.split(' '));
        workArr.removeAt(0);
        setState(() {
          workText = workArr.join(' ');
        });
      }
    } else {
      nikText = "-";
      provText = "-";
      kota_kecText = "-";
      tgl_lahirText = "-";
      jenis_kelaminText = "-";
      namaText = "-";
      alamatText = "-";
      rtrwText = "-";
      kelText = "-";
      agamaText = "-";
      spText = "-";
      workText = "-";
    }

    setState(() {
      normProcess = true;
    });

    if (normProcess == true) {
      popups(context);
    }
    // print("Nama : ${namaText}");
    // print("RT/RW : ${rtrwText}");
    // print("Kelurahan: ${kelText}");
    // print("Agama: ${agamaText}");
    // print("Status Perkawinan: ${spText}");
    // print("Pekerjaan: ${workText}");
    //
  }

  void manageData(List<String> arrFill, String setText) {
    var texts = arrFill.join('');
    if (arrFill.contains(":")) {
      var workArr = List<String>.from(texts.split(':'));
      setState(() {
        workText = workArr[1];
      });
    } else {
      var workArr = List<String>.from(texts.split(' '));
      workArr.removeAt(0);
      setState(() {
        workText = workArr.join(' ');
      });
    }
  }

  //POP UP

  Widget popups(BuildContext context) {
    _nikController.text = nikText;
    _namaController.text = namaText;
    _alamatController.text = alamatText;
    _rtrwController.text = rtrwText;
    _kelurahanController.text = kelText;
    _agamaController.text = agamaText;
    _spController.text = spText;
    _workController.text = workText;

    Navigator.of(context, rootNavigator: true).pop();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        // return Dialog(
        return AlertDialog(
          title: Text('Peringatan!'),
          content: ListView(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'NIK',
                  hintText: "Masukkan NIK Anda",
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                ),
                controller: _nikController,
              ),
              TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Nama',
                  hintText: "Masukkan Nama Anda",
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                ),
                controller: _namaController,
              ),
              TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Alamat',
                  hintText: "Masukkan Alamat Anda",
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                ),
                controller: _alamatController,
              ),
              TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'RT/RW',
                  hintText: "Masukkan RTRW Anda",
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                ),
                controller: _rtrwController,
              ),
              TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Kelurahan',
                  hintText: "Masukkan Kelurahan Anda",
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                ),
                controller: _kelurahanController,
              ),
              TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Agama',
                  hintText: "Masukkan Agama Anda",
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                ),
                controller: _agamaController,
              ),
              TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Status Perkawinan',
                  hintText: "Masukkan Status Perkawinan Anda",
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                ),
                controller: _spController,
              ),
              TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Pekerjaan',
                  hintText: "Masukkan Pekerjaan Anda",
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                ),
                controller: _workController,
              ),
              TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Pendidikan Terakhir',
                  hintText: "Contoh: SMA, S1, S2",
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                ),
                controller: _pendidikanController,
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                var arrNIK = new List<String>.from(
                    _nikController.text.toString().split(''));
                transleteNIK(arrNIK);
                //SetState di sini
                setState(() {
                  nikText = _nikController.text;
                  namaText = _namaController.text;
                  alamatText = _alamatController.text;
                  rtrwText = _rtrwController.text;
                  kelText = _kelurahanController.text;
                  agamaText = _agamaController.text;
                  spText = _spController.text;
                  workText = _workController.text;
                  okPressKtp = true;
                  ktpImage = val;
                });
                Navigator.of(context).pop();
              },
            )
          ],
        );
        // );
      },
    );
  }

  void transleteNIK(List<String> arrNIK) {
    arrNIK.insert(2, 's');
    arrNIK.insert(5, 's');
    arrNIK.insert(8, 's');
    arrNIK.insert(11, 's');
    arrNIK.insert(14, 's');
    arrNIK.insert(17, 's');
    arrNIK.insert(20, 's');
    var tmpNIK = List<String>.from(arrNIK.join().split('s'));
    setState(() {
      provText = prov[tmpNIK[0]];
      kota_kecText = kota_kecamatan[tmpNIK[1]][tmpNIK[2]];
      if (int.parse(tmpNIK[3]) > 40) {
        jenis_kelaminText = 'Perempuan';
        var tgl = int.parse(tmpNIK[3]) - 40;
        tgl_lahirText =
            "${prov[tmpNIK[0]]}, $tgl ${bulan[tmpNIK[4]]} 19${tmpNIK[5]}";
      } else if (int.parse(tmpNIK[3]) < 40) {
        jenis_kelaminText = 'Laki-Laki';
        tgl_lahirText = "${tmpNIK[3]} ${bulan[tmpNIK[4]]} 19${tmpNIK[5]}";
      } else {
        jenis_kelaminText = 'NULL';
        tgl_lahirText = "NULL";
      }
    });
  }

  void netralVariable() {
    setState(() {
      _extractText = 'Unknown';
      dataOCR = [];
      stat = false;
      normProcess = false;

      //KTP REQ VAR;
      nikText = "";
      provText = "";
      kota_kecText = "";
      tgl_lahirText = "";
      jenis_kelaminText = "";

      namaText = "";
      alamatText = "";
      rtrwText = "";
      kelText = "";
      agamaText = "";
      spText = "";
      workText = "";
    });
  }
  //***************************************************************** */
  //********************************* OCR KK FUNCTION ******************/

  Future<void> sendToServerkk(BuildContext context) async {
    if (val == null) {
      return;
    }
    UtilAuth.loading(context);
    Dio dio = new Dio();

    var datas = FormData.fromMap(
        {"kk": await MultipartFile.fromFile(valkk.path), "nama": "KKME"});

    var response = await dio.post(urlkk, data: datas);
    print(response.data['message']);
    if (response.data['message'] == true) {
      initPlatformStatekk(context);
    }
  }

  initPlatformStatekk(BuildContext context) async {
    String extractText;
    // Platform messages may fail, so we use a try/catch PlatformException.

    final Directory directory = await getTemporaryDirectory();
    final String imagePath = join(
      directory.path,
      "new.jpg",
    );
    // final ByteData data = await rootBundle.load('assets/images/bee.jpg');
    // final Uint8List bytes = data.buffer.asUint8List(
    //   data.offsetInBytes,
    //   data.lengthInBytes,
    // );

    Uint8List bytes = await networkImageToByte(
        "http://192.168.43.75/auth/file/Ktp/KKME.jpeg");
    await File(imagePath).writeAsBytes(bytes);

    extractText = await TesseractOcr.extractText(imagePath, language: "ind");

    if (!mounted) return;

    setState(() {
      _extractText = extractText;
      statkk = true;
    });

    if (statkk == true) {
      normalizationkk(context);
    }
  }

  bool normalizationkk(BuildContext context) {
    List<String> arrOCR = _extractText.split("\n");

    var kk;
    if (arrOCR[1].contains("-")) {
      kk = arrOCR[1].split('-');
    } else if (arrOCR[1].contains(".")) {
      kk = arrOCR[1].split('.');
    } else if (arrOCR[1].contains(":")) {
      kk = arrOCR[1].split(':');
    } else {
      setState(() {
        nokkText = "Not Good";
        statkk = true;
      });
      return false;
    }

    var arrKK = new List<String>.from(kk[1].toString().split(''));
    for (var i = 0; i < arrKK.length; i++) {
      if (arrKK[i] == "?") {
        arrKK[i] = '7';
      } else if (arrKK[i] == 'D') {
        arrKK[i] = '0';
      } else if (arrKK[i] == 'L') {
        arrKK[i] = '1';
      } else if (arrKK[i] == 'i') {
        arrKK[i] = '1';
      } else if (arrKK[i] == 'I') {
        arrKK[i] = '1';
      }
      arrKK.remove(' ');
    }

    setState(() {
      nokkText = arrKK.join();
      kkNormProc = true;
    });

    if (kkNormProc == true) {
      popupskk(context);
    }
    return true;
  }

  Widget popupskk(BuildContext context) {
    _kkController.text = nokkText;

    Navigator.of(context, rootNavigator: true).pop();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        // return Dialog(
        return AlertDialog(
          title: Text('Form No KK'),
          content: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              labelText: 'No Kartu Keluarga',
              hintText: "Masukkan No KK Anda",
              hintStyle: TextStyle(
                color: Colors.grey[400],
              ),
            ),
            controller: _kkController,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                //SetState di sini
                setState(() {
                  kkImage = valkk;
                  nokkText = _kkController.text;
                  okPressKK = true;
                });
                Navigator.of(context).pop();
              },
            )
          ],
        );
        // );
      },
    );
  }

  //******************************************************************* */

  Widget _detailWidget(
      BuildContext context,
      String keterangan,
      String rtrwText,
      String noPengajuan,
      String tglBuat,
      String noSuratRT,
      String noSuratRW,
      List history) {
    String judulDetail;
    if (widget.tipe == "1") {
      judulDetail = "Pengajuan Surat Keterangan Tidak Mampu";
    } else if (widget.tipe == "2") {
      judulDetail = "Pengajuan Surat Keterangan Usaha";
    } else if (widget.tipe == "3") {
      judulDetail = "Pengajuan Surat Pengantar Izin Keramaian";
    } else if (widget.tipe == "4") {
      judulDetail = "Pengajuan Surat Keterangan Belum Menikah";
    } else if (widget.tipe == "5") {
      judulDetail = "Pengajuan Surat Keterangan Cerai Hidup / Mati";
    } else if (widget.tipe == "6") {
      judulDetail = "Pengajuan Surat Keterangan Domisili";
    } else if (widget.tipe == "7") {
      judulDetail = "Pengajuan Surat Keterangan Kematian";
    } else if (widget.tipe == "8") {
      judulDetail = "Pengajuan Surat Keterangan Pindah";
    }
    return Container(
      child: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: RaisedButton(
                    color: Colors.orange,
                    child: Text(
                      "Pengajuan Kembali",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      perbaikiData(context);
                    },
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.orange,
            thickness: 2,
          ),
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                "$judulDetail",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                    fontSize: 20),
              ),
            ),
          ),
          Divider(
            color: Colors.orange,
            thickness: 2,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Keterangan: ",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Container(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 300.0,
                      maxWidth: 300.0,
                      minHeight: 30.0,
                      maxHeight: 100.0,
                    ),
                    child: AutoSizeText(
                      "$keterangan",
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "No Pengajuan: ",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  "$noPengajuan",
                  style: TextStyle(fontSize: 15),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Tanggal Pengajuan: ",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${UtilRTRW.convertDateTime(tglBuat)}",
                  style: TextStyle(fontSize: 15),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "RT/RW: ",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  "$rtrwText",
                  style: TextStyle(fontSize: 15),
                )
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "No Surat RT: ",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  noSuratRT != null ? "$noSuratRT" : "",
                  style: TextStyle(fontSize: 15),
                )
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "No Surat RW:",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  noSuratRW != null ? "$noSuratRW" : "",
                  style: TextStyle(fontSize: 15),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            color: Colors.orange[200],
            thickness: 3,
          ),
          Container(
            margin: EdgeInsets.only(left: 10, top: 10, bottom: 5),
            child: Text(
              "Berkas Pengajuan",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            color: Colors.orange[200],
            thickness: 3,
          ),
          Container(
            margin: EdgeInsets.only(left: 10, top: 10, bottom: 5, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "KTP:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                Container(
                  width: double.infinity,
                  child: RaisedButton(
                      child: Text(
                        "Scan KTP",
                        style: TextStyle(fontSize: 20),
                      ),
                      textColor: Colors.white,
                      color: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.orange),
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
                                        left: 20,
                                        child: Container(
                                          height: 530,
                                          width: 330,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 3,
                                                  color: Colors.white)),
                                        ),
                                      ),
                                      Positioned(
                                        top: 30,
                                        right: 60,
                                        child: Container(
                                          width: 30,
                                          height: 350,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 2,
                                                  color: Colors.white)),
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

                        sendToServer(context);
                      }),
                ),
                Text(
                  "KK:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                Container(
                  width: double.infinity,
                  child: RaisedButton(
                      child: Text(
                        "Scan Kartu Keluarga (KK)",
                        style: TextStyle(fontSize: 20),
                      ),
                      textColor: Colors.white,
                      color: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.orange),
                      ),
                      onPressed: () async {
                        valkk = await showDialog(
                            context: context,
                            builder: (context) => Camera(
                                  mode: CameraMode.fullscreen,
                                  orientationEnablePhoto: CameraOrientation.all,
                                  imageMask: Stack(
                                    children: <Widget>[
                                      Positioned(
                                        top: 200,
                                        right: 20,
                                        child: Container(
                                          width: 20,
                                          height: 200,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 2,
                                                  color: Colors.white)),
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
                                              "*Pastikan No KK Anda Berada Di Dalam Kotak Yang Telah Ditentukan",
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
                        sendToServerkk(context);
                      }),
                ),
                widget.tipe == "1"
                    ? Column(
                        children: <Widget>[
                          FilePickerForm(
                            title: "Foto Depan Rumah",
                            setFileAtt: setdepanRumah,
                          ),
                          FilePickerForm(
                            title: "Foto Belakang Rumah",
                            setFileAtt: setbelakangRumah,
                          ),
                        ],
                      )
                    : Container(),
                widget.tipe == "2"
                    ? FilePickerForm(
                        title: "SPPT Terbaru",
                        setFileAtt: setspptTerbaru,
                      )
                    : Container(),
                widget.tipe == "3"
                    ? FilePickerForm(
                        title: "Lampiran Pernyataan",
                        setFileAtt: setlamper,
                      )
                    : Container(),
                widget.tipe == "4"
                    ? Column(
                        children: <Widget>[
                          FilePickerForm(
                            title: "KTP Orang Tua-1 (Ayah)",
                            setFileAtt: setktportu1,
                          ),
                          FilePickerForm(
                            title: "KTP Orang Tua-2 (Ibu)",
                            setFileAtt: setktportu2,
                          ),
                          FilePickerForm(
                            title: "Tanda Lunas PBB Tahun Berjalan",
                            setFileAtt: setlunaspbb1,
                          )
                        ],
                      )
                    : Container(),
                widget.tipe == "5"
                    ? Column(
                        children: <Widget>[
                          FilePickerForm(
                            title: "Akte Cerai",
                            setFileAtt: setaktecerai,
                          ),
                          FilePickerForm(
                              title: "Pelunasan PBB Tahun Berjalan",
                              setFileAtt: setlunaspbb2),
                          FilePickerForm(
                            title: "Surat Keterangan Kematian Suami / Istri",
                            setFileAtt: setskks,
                          ),
                        ],
                      )
                    : Container(),
                widget.tipe == "7"
                    ? FilePickerForm(
                        title: "Surat Keterangan Kematian Dari Rumah Sakit",
                        setFileAtt: setskksdrs,
                      )
                    : Container(),
                widget.tipe == "8"
                    ? FilePickerForm(
                        title:
                            "SKCK (Untuk Pindahan Dari Kabupaten / Provinsi)",
                        setFileAtt: setskck,
                      )
                    : Container()
              ],
            ),
          ),
          Divider(
            color: Colors.orange[200],
            thickness: 3,
          ),
          Container(
            margin: EdgeInsets.only(left: 10, top: 20, bottom: 10),
            child: Text(
              "History Pengajuan",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(
            thickness: 3,
          ),
          DataTable(
            dataRowHeight: 90,
            columnSpacing: 1,
            columns: [
              DataColumn(
                  label: Text(
                "Tingkatan",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              )),
              DataColumn(
                label: Text(
                  "Status",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              DataColumn(
                label: Text(
                  "Komentar",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              )
            ],
            rows: [
              for (var i = 0; i < history.length; i++)
                DataRow(
                  cells: [
                    DataCell(Text(
                      history[i]['tingkatan'],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    )),
                    DataCell(
                      history[i]['status'] == 'Setuju'
                          ? Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            )
                          : Icon(Icons.close, color: Colors.red),
                    ),
                    DataCell(Text(
                      history[i]['komentar'],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    )),
                  ],
                ),
            ],
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  Future<DetailpTolakViewModel> _getDetailSurat() async {
    DetailpTolakPresenter presentesrs = new DetailpTolakPresenter();
    var response =
        await presentesrs.getDetailDataSuratTolakPenduduk(widget.idSurat);
    return response;
  }

  void perbaikiData(BuildContext context) async {
    UtilAuth.loading(context);
    Map<String, dynamic> data;
    var datakk;
    if (okPressKtp == true) {
      data = {
        "nik": nikText,
        "nama": namaText,
        "jk": jenis_kelaminText,
        "tgl": tgl_lahirText,
        "alamat":
            "${alamatText} ${rtrwText} Kel.${kelText} Kec.${kota_kecText}",
        "agama": agamaText,
        "sp": spText,
        "pekerjaan": workText,
        "pendidikan": pendidikanText
      };
    } else {
      data = {
        "nik": null,
      };
    }

    if (okPressKK == true) {
      datakk = nokkText;
    } else {
      datakk = null;
    }
    DetailpTolakPresenter presenter = new DetailpTolakPresenter();
    var response = await presenter.perbaikiDataToServer(
      widget.idSurat,
      widget.tipe,
      data,
      datakk,
      ktpImage,
      kkImage,
      _depanRumah,
      _belakangRumah,
      _spptTerbaru,
      _lampiranPer,
      _ktpOrtu1,
      _ktpOrtu2,
      _lunasPbb1,
      _akteCerai,
      _lunasPbb2,
      _skks,
      _skksdrs,
      _skck,
    );
    UtilAuth.successPopupDialog(
        context, response.data['message'], HomePenduduk());
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
      drawer: ThemeAppPenduduk.sideBar(context, nikPref, noTelepon),
      body: Container(
        child: FutureBuilder(
          future: _getDetailSurat(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data.dataHistory);
              return _detailWidget(
                context,
                snapshot.data.keterangan,
                snapshot.data.rtrw,
                snapshot.data.noPengajuan,
                snapshot.data.tglBuat,
                snapshot.data.noSuratRt,
                snapshot.data.noSuratRw,
                snapshot.data.dataHistory,
              );
            } else {
              return Container(
                child: Center(
                  child: Text('Loading...'),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
