import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera_camera/camera_camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:submission_letter/main.dart';
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
  var urlKtp = "${MyApp.route}/api/cropktp";
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
  var urlkk = "${MyApp.route}/api/cropkk";

//******************* ***************************************/

//************************* Validate *************************** */

  bool _valKtpImage = true;
  bool _valKkImage = true;
  bool _valDepanRumahImage = true;
  bool _valBelakangRumahImage = true;
  bool _valspptTerbaru = true;
  bool _valLampiranPer = true;
  bool _valktpOrtu1 = true;
  bool _valktportu2 = true;
  bool _valLunasPbb1 = true;
  bool _valAkteCerai = true;
  bool _valLunasPbb2 = true;
  bool _valskks = true;
  bool _valskkdrs = true;
  bool _valskck = true;
  bool _valrtText = true;
  bool _valrwText = true;

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

  void setKtpImageNull() {
    setState(() {
      okPressKtp = false;
      ktpImage = null;

      nikText = null;
      provText = null;
      kota_kecText = null;
      tgl_lahirText = null;
      jenis_kelaminText = null;
      namaText = null;
      alamatText = null;
      rtrwText = null;
      kelText = null;
      agamaText = null;
      spText = null;
      workText = null;
      pendidikanText = null;
    });
  }

  void setKKImageNull() {
    setState(() {
      okPressKK = false;
      kkImage = null;
      nokkText = null;
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

  //************************* VALIDATE POPUP */

  bool _valpnik = true;
  bool _valpnama = true;
  bool _valpalamat = true;
  bool _valpkelurahan = true;
  bool _valprtrw = true;
  bool _valpjk = true;
  bool _valppendidikan = true;
  bool _valp = true;
  bool _valpagama = true;
  bool _valppekerjaan = true;
  bool _valpperkawawinan = true;
  bool _valpkk = true;

  //****************************** */

  //************************* Validate *************************** */

  //************************* OCR FUNCTION *************************** */

  //KAMERA
  Future<void> sendToServer(BuildContext context, double sizes) async {
    netralVariable();
    if (val == null) {
      return;
    }
    UtilAuth.loading(context);
    Dio dio = new Dio();

    var datas = FormData.fromMap({
      "ktp": await MultipartFile.fromFile(val.path),
      "nama": "KTPME",
      "size": sizes
    });

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

    Uint8List bytes =
        await networkImageToByte("${MyApp.routeOCR}/auth/file/Ktp/KTPME.jpeg");
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
      var alamatFill;
      if (arrOCR[4].split(" ")[0].contains("Alamat")) {
        alamatFill = List<String>.from(arrOCR[4].split(''));
      } else if (arrOCR[4].split(" ")[0].contains("Ala")) {
        alamatFill = List<String>.from(arrOCR[4].split(''));
      } else if (arrOCR[4].split(" ")[0].contains("lamat")) {
        alamatFill = List<String>.from(arrOCR[4].split(''));
      } else if (arrOCR[4].split(" ")[0].contains("mat")) {
        alamatFill = List<String>.from(arrOCR[4].split(''));
      } else if (arrOCR[4].split(" ")[0].contains("Alam")) {
        alamatFill = List<String>.from(arrOCR[4].split(''));
      } else if (arrOCR[5].split(" ")[0].contains("Alamat")) {
        alamatFill = List<String>.from(arrOCR[5].split(''));
      } else if (arrOCR[5].split(" ")[0].contains("Aal")) {
        alamatFill = List<String>.from(arrOCR[5].split(''));
      } else if (arrOCR[5].split(" ")[0].contains("lamat")) {
        alamatFill = List<String>.from(arrOCR[5].split(''));
      } else if (arrOCR[5].split(" ")[0].contains("mat")) {
        alamatFill = List<String>.from(arrOCR[5].split(''));
      } else if (arrOCR[5].split(" ")[0].contains("Alam")) {
        alamatFill = List<String>.from(arrOCR[5].split(''));
      } else {
        alamatFill = ["Alamat", ":", "Isi Alamat"];
      }
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
      var rtrwFill;

      if (arrOCR[7].split(" ")[0].contains("RT")) {
        rtrwFill = List<String>.from(arrOCR[7].split(''));
      } else if (arrOCR[7].split(" ")[0].contains("W")) {
        rtrwFill = List<String>.from(arrOCR[7].split(''));
      } else if (arrOCR[7].split(" ")[0].contains("/")) {
        rtrwFill = List<String>.from(arrOCR[7].split(''));
      } else if (arrOCR[6].split(" ")[0].contains("RT")) {
        rtrwFill = List<String>.from(arrOCR[6].split(''));
      } else if (arrOCR[6].split(" ")[0].contains("W")) {
        rtrwFill = List<String>.from(arrOCR[6].split(''));
      } else if (arrOCR[6].split(" ")[0].contains("/")) {
        rtrwFill = List<String>.from(arrOCR[6].split(''));
      } else if (arrOCR[5].split(" ")[0].contains("RT")) {
        rtrwFill = List<String>.from(arrOCR[5].split(''));
      } else if (arrOCR[5].split(" ")[0].contains("W")) {
        rtrwFill = List<String>.from(arrOCR[5].split(''));
      } else if (arrOCR[5].split(" ")[0].contains("/")) {
        rtrwFill = List<String>.from(arrOCR[5].split(''));
      } else {
        rtrwFill = ["R", "T", "/", "R", "W", " ", ":", "00", "/", "00"];
      }
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
      var kelFill;
      if (arrOCR[6].split(" ")[0].contains("Kel")) {
        kelFill = List<String>.from(arrOCR[6].split(''));
      } else if (arrOCR[6].split(" ")[0].contains("Desa")) {
        kelFill = List<String>.from(arrOCR[6].split(''));
      } else if (arrOCR[6].split(" ")[0].contains("De")) {
        kelFill = List<String>.from(arrOCR[6].split(''));
      } else if (arrOCR[6].split(" ")[0].contains("D")) {
        kelFill = List<String>.from(arrOCR[6].split(''));
      } else if (arrOCR[6].split(" ")[0].contains("Ke")) {
        kelFill = List<String>.from(arrOCR[6].split(''));
      } else if (arrOCR[7].split(" ")[0].contains("Kel")) {
        kelFill = List<String>.from(arrOCR[7].split(''));
      } else if (arrOCR[7].split(" ")[0].contains("Desa")) {
        kelFill = List<String>.from(arrOCR[7].split(''));
      } else if (arrOCR[7].split(" ")[0].contains("De")) {
        kelFill = List<String>.from(arrOCR[7].split(''));
      } else if (arrOCR[7].split(" ")[0].contains("D")) {
        kelFill = List<String>.from(arrOCR[7].split(''));
      } else if (arrOCR[7].split(" ")[0].contains("Ke")) {
        kelFill = List<String>.from(arrOCR[7].split(''));
      } else if (arrOCR[8].split(" ")[0].contains("Kel")) {
        kelFill = List<String>.from(arrOCR[8].split(''));
      } else if (arrOCR[8].split(" ")[0].contains("Desa")) {
        kelFill = List<String>.from(arrOCR[8].split(''));
      } else if (arrOCR[8].split(" ")[0].contains("De")) {
        kelFill = List<String>.from(arrOCR[8].split(''));
      } else if (arrOCR[8].split(" ")[0].contains("D")) {
        kelFill = List<String>.from(arrOCR[8].split(''));
      } else if (arrOCR[8].split(" ")[0].contains("Ke")) {
        kelFill = List<String>.from(arrOCR[8].split(''));
      } else if (arrOCR[9].split(" ")[0].contains("Kel")) {
        kelFill = List<String>.from(arrOCR[9].split(''));
      } else if (arrOCR[9].split(" ")[0].contains("Desa")) {
        kelFill = List<String>.from(arrOCR[9].split(''));
      } else if (arrOCR[9].split(" ")[0].contains("De")) {
        kelFill = List<String>.from(arrOCR[9].split(''));
      } else if (arrOCR[9].split(" ")[0].contains("D")) {
        kelFill = List<String>.from(arrOCR[9].split(''));
      } else if (arrOCR[9].split(" ")[0].contains("Ke")) {
        kelFill = List<String>.from(arrOCR[9].split(''));
      } else {
        kelFill = ["K", "e", "l", "D", "e", "s", "a", " ", ":", "Isi Desa"];
      }
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
      var agamaFill;

      if (arrOCR[8].split(" ")[0].contains("Agama")) {
        agamaFill = List<String>.from(arrOCR[8].split(''));
      } else if (arrOCR[8].split(" ")[0].contains("Agam")) {
        agamaFill = List<String>.from(arrOCR[8].split(''));
      } else if (arrOCR[8].split(" ")[0].contains("gama")) {
        agamaFill = List<String>.from(arrOCR[8].split(''));
      } else if (arrOCR[8].split(" ")[0].contains("ag")) {
        agamaFill = List<String>.from(arrOCR[8].split(''));
      } else if (arrOCR[8].split(" ")[0].contains("g")) {
        agamaFill = List<String>.from(arrOCR[8].split(''));
      } else if (arrOCR[9].split(" ")[0].contains("Agama")) {
        agamaFill = List<String>.from(arrOCR[9].split(''));
      } else if (arrOCR[9].split(" ")[0].contains("Agam")) {
        agamaFill = List<String>.from(arrOCR[9].split(''));
      } else if (arrOCR[9].split(" ")[0].contains("gama")) {
        agamaFill = List<String>.from(arrOCR[9].split(''));
      } else if (arrOCR[9].split(" ")[0].contains("ag")) {
        agamaFill = List<String>.from(arrOCR[9].split(''));
      } else if (arrOCR[9].split(" ")[0].contains("g")) {
        agamaFill = List<String>.from(arrOCR[9].split(''));
      } else if (arrOCR[10].split(" ")[0].contains("Agama")) {
        agamaFill = List<String>.from(arrOCR[10].split(''));
      } else if (arrOCR[10].split(" ")[0].contains("Agam")) {
        agamaFill = List<String>.from(arrOCR[10].split(''));
      } else if (arrOCR[10].split(" ")[0].contains("gama")) {
        agamaFill = List<String>.from(arrOCR[10].split(''));
      } else if (arrOCR[10].split(" ")[0].contains("ag")) {
        agamaFill = List<String>.from(arrOCR[10].split(''));
      } else if (arrOCR[10].split(" ")[0].contains("g")) {
        agamaFill = List<String>.from(arrOCR[10].split(''));
      } else if (arrOCR[11].split(" ")[0].contains("Agama")) {
        agamaFill = List<String>.from(arrOCR[11].split(''));
      } else if (arrOCR[11].split(" ")[0].contains("Agam")) {
        agamaFill = List<String>.from(arrOCR[11].split(''));
      } else if (arrOCR[11].split(" ")[0].contains("gama")) {
        agamaFill = List<String>.from(arrOCR[11].split(''));
      } else if (arrOCR[11].split(" ")[0].contains("ag")) {
        agamaFill = List<String>.from(arrOCR[11].split(''));
      } else if (arrOCR[11].split(" ")[0].contains("g")) {
        agamaFill = List<String>.from(arrOCR[11].split(''));
      } else if (arrOCR[12].split(" ")[0].contains("Agama")) {
        agamaFill = List<String>.from(arrOCR[12].split(''));
      } else if (arrOCR[12].split(" ")[0].contains("Agam")) {
        agamaFill = List<String>.from(arrOCR[12].split(''));
      } else if (arrOCR[12].split(" ")[0].contains("gama")) {
        agamaFill = List<String>.from(arrOCR[12].split(''));
      } else if (arrOCR[12].split(" ")[0].contains("ag")) {
        agamaFill = List<String>.from(arrOCR[12].split(''));
      } else if (arrOCR[12].split(" ")[0].contains("g")) {
        agamaFill = List<String>.from(arrOCR[12].split(''));
      } else {
        agamaFill = ["A", "g", "a", "m", "a", " ", ":", "Isi Agama"];
      }
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
      var spFill;
      if (arrOCR[9].split(" ")[0].contains("Statu")) {
        spFill = List<String>.from(arrOCR[9].split(''));
      } else if (arrOCR[9].split(" ")[0].contains("Stat")) {
        spFill = List<String>.from(arrOCR[9].split(''));
      } else if (arrOCR[9].split(" ")[0].contains("tatus")) {
        spFill = List<String>.from(arrOCR[9].split(''));
      } else if (arrOCR[9].split(" ")[0].contains("St")) {
        spFill = List<String>.from(arrOCR[9].split(''));
      } else if (arrOCR[9].split(" ")[0].contains("S")) {
        spFill = List<String>.from(arrOCR[9].split(''));
      } else if (arrOCR[10].split(" ")[0].contains("Statu")) {
        spFill = List<String>.from(arrOCR[10].split(''));
      } else if (arrOCR[10].split(" ")[0].contains("Stat")) {
        spFill = List<String>.from(arrOCR[10].split(''));
      } else if (arrOCR[10].split(" ")[0].contains("tatus")) {
        spFill = List<String>.from(arrOCR[10].split(''));
      } else if (arrOCR[10].split(" ")[0].contains("St")) {
        spFill = List<String>.from(arrOCR[10].split(''));
      } else if (arrOCR[10].split(" ")[0].contains("S")) {
        spFill = List<String>.from(arrOCR[10].split(''));
      } else if (arrOCR[11].split(" ")[0].contains("Statu")) {
        spFill = List<String>.from(arrOCR[11].split(''));
      } else if (arrOCR[11].split(" ")[0].contains("Stat")) {
        spFill = List<String>.from(arrOCR[11].split(''));
      } else if (arrOCR[11].split(" ")[0].contains("tatus")) {
        spFill = List<String>.from(arrOCR[11].split(''));
      } else if (arrOCR[11].split(" ")[0].contains("St")) {
        spFill = List<String>.from(arrOCR[11].split(''));
      } else if (arrOCR[11].split(" ")[0].contains("S")) {
        spFill = List<String>.from(arrOCR[11].split(''));
      } else if (arrOCR[12].split(" ")[0].contains("Statu")) {
        spFill = List<String>.from(arrOCR[12].split(''));
      } else if (arrOCR[12].split(" ")[0].contains("Stat")) {
        spFill = List<String>.from(arrOCR[12].split(''));
      } else if (arrOCR[12].split(" ")[0].contains("tatus")) {
        spFill = List<String>.from(arrOCR[12].split(''));
      } else if (arrOCR[12].split(" ")[0].contains("St")) {
        spFill = List<String>.from(arrOCR[12].split(''));
      } else if (arrOCR[12].split(" ")[0].contains("S")) {
        spFill = List<String>.from(arrOCR[12].split(''));
      } else if (arrOCR[13].split(" ")[0].contains("Statu")) {
        spFill = List<String>.from(arrOCR[13].split(''));
      } else if (arrOCR[13].split(" ")[0].contains("Stat")) {
        spFill = List<String>.from(arrOCR[13].split(''));
      } else if (arrOCR[13].split(" ")[0].contains("tatus")) {
        spFill = List<String>.from(arrOCR[13].split(''));
      } else if (arrOCR[13].split(" ")[0].contains("St")) {
        spFill = List<String>.from(arrOCR[13].split(''));
      } else if (arrOCR[13].split(" ")[0].contains("S")) {
        spFill = List<String>.from(arrOCR[13].split(''));
      } else {
        spFill = ["Status", ":", "Isi Status"];
      }
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
      var workFill;
      if (arrOCR[10].split(" ")[0].contains("Pek")) {
        workFill = List<String>.from(arrOCR[10].split(''));
      } else if (arrOCR[10].split(" ")[0].contains("ker")) {
        workFill = List<String>.from(arrOCR[10].split(''));
      } else if (arrOCR[10].split(" ")[0].contains("jaan")) {
        workFill = List<String>.from(arrOCR[10].split(''));
      } else if (arrOCR[10].split(" ")[0].contains("Ke")) {
        workFill = List<String>.from(arrOCR[10].split(''));
      } else if (arrOCR[10].split(" ")[0].contains("K")) {
        workFill = List<String>.from(arrOCR[10].split(''));
      } else if (arrOCR[11].split(" ")[0].contains("Pek")) {
        workFill = List<String>.from(arrOCR[11].split(''));
      } else if (arrOCR[11].split(" ")[0].contains("ker")) {
        workFill = List<String>.from(arrOCR[11].split(''));
      } else if (arrOCR[11].split(" ")[0].contains("jaan")) {
        workFill = List<String>.from(arrOCR[11].split(''));
      } else if (arrOCR[11].split(" ")[0].contains("Ke")) {
        workFill = List<String>.from(arrOCR[11].split(''));
      } else if (arrOCR[11].split(" ")[0].contains("K")) {
        workFill = List<String>.from(arrOCR[11].split(''));
      } else if (arrOCR[12].split(" ")[0].contains("Pek")) {
        workFill = List<String>.from(arrOCR[12].split(''));
      } else if (arrOCR[12].split(" ")[0].contains("ker")) {
        workFill = List<String>.from(arrOCR[12].split(''));
      } else if (arrOCR[12].split(" ")[0].contains("jaan")) {
        workFill = List<String>.from(arrOCR[12].split(''));
      } else if (arrOCR[12].split(" ")[0].contains("Ke")) {
        workFill = List<String>.from(arrOCR[12].split(''));
      } else if (arrOCR[12].split(" ")[0].contains("K")) {
        workFill = List<String>.from(arrOCR[12].split(''));
      } else if (arrOCR[13].split(" ")[0].contains("Pek")) {
        workFill = List<String>.from(arrOCR[13].split(''));
      } else if (arrOCR[13].split(" ")[0].contains("ker")) {
        workFill = List<String>.from(arrOCR[13].split(''));
      } else if (arrOCR[13].split(" ")[0].contains("jaan")) {
        workFill = List<String>.from(arrOCR[13].split(''));
      } else if (arrOCR[13].split(" ")[0].contains("Ke")) {
        workFill = List<String>.from(arrOCR[13].split(''));
      } else if (arrOCR[13].split(" ")[0].contains("K")) {
        workFill = List<String>.from(arrOCR[13].split(''));
      } else if (arrOCR[14].split(" ")[0].contains("Pek")) {
        workFill = List<String>.from(arrOCR[14].split(''));
      } else if (arrOCR[14].split(" ")[0].contains("ker")) {
        workFill = List<String>.from(arrOCR[14].split(''));
      } else if (arrOCR[14].split(" ")[0].contains("jaan")) {
        workFill = List<String>.from(arrOCR[14].split(''));
      } else if (arrOCR[14].split(" ")[0].contains("Ke")) {
        workFill = List<String>.from(arrOCR[14].split(''));
      } else if (arrOCR[14].split(" ")[0].contains("K")) {
        workFill = List<String>.from(arrOCR[14].split(''));
      } else {
        workFill = ["Pekerjaan", ":", "Isi Pekerjaan"];
      }
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
      } else if (workFill.contains('"')) {
        var workArr = List<String>.from(text7.split('"'));
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

    //************************* VALIDATE POPUP */
    bool _valpnik = true;
    bool _valpnama = true;
    bool _valpalamat = true;
    bool _valpkelurahan = true;
    bool _valprtrw = true;
    bool _valppendidikan = true;
    bool _valpagama = true;
    bool _valppekerjaan = true;
    bool _valpperkawawinan = true;

    //****************************** */

    Navigator.of(context, rootNavigator: true).pop();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('Form Biodata KTP'),
            content: Container(
              width: 150,
              height: 350,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 60,
                    child: TextField(
                      maxLength: 16,
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'NIK',
                        hintText: "Masukkan NIK Anda",
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                        ),
                        errorText: _valpnik == false
                            ? "Nik Tidak Boleh Kosong!"
                            : null,
                      ),
                      controller: _nikController,
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 60,
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Nama',
                        hintText: "Masukkan Nama Anda",
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                        ),
                        errorText: (_valpnama == false)
                            ? "Masukan Nama Anda Dengan Benar!"
                            : null,
                      ),
                      controller: _namaController,
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 60,
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Alamat',
                        hintText: "Masukkan Alamat Anda",
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                        ),
                        errorText: (_valpalamat == false)
                            ? "Masukkan Alamat Anda Dengan Benar!"
                            : null,
                      ),
                      controller: _alamatController,
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 60,
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'RT/RW',
                        hintText: "Masukkan RTRW Anda",
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                        ),
                        errorText: (_valprtrw == false)
                            ? "Masukkan RT/RW Anda Dengan Benar!"
                            : null,
                      ),
                      controller: _rtrwController,
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 60,
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Kelurahan',
                        hintText: "Masukkan Kelurahan Anda",
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                        ),
                        errorText: (_valpkelurahan == false)
                            ? "Masukkan Kelurahan Anda Degan Benar!"
                            : null,
                      ),
                      controller: _kelurahanController,
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 60,
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Agama',
                        hintText: "Masukkan Agama Anda",
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                        ),
                        errorText: (_valpagama == false)
                            ? "Masukkan Agama Anda Dengan Benar!"
                            : null,
                      ),
                      controller: _agamaController,
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 60,
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Status Perkawinan',
                        hintText: "Masukkan Status Perkawinan Anda",
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                        ),
                        errorText: (_valpperkawawinan == false)
                            ? "Masukkan Status Perkawinan Anda Dengan Benar!"
                            : null,
                      ),
                      controller: _spController,
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 60,
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Pekerjaan',
                        hintText: "Masukkan Pekerjaan Anda",
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                        ),
                        errorText: (_valppekerjaan == false)
                            ? "Masukkan Pekerjaan Anda Dengan Benar!"
                            : null,
                      ),
                      controller: _workController,
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 60,
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Pendidikan Terakhir',
                        hintText: "Contoh: SMA, S1, S2",
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                        ),
                        errorText: (_valppendidikan == false)
                            ? "Masukkan Pendidikan Terakhir Anda Dengan Benar!"
                            : null,
                      ),
                      controller: _pendidikanController,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  if (_nikController.text != "") {
                    setState(() {
                      _valpnik = true;
                    });

                    if (_namaController.text.isNotEmpty) {
                      setState(() {
                        _valpnama = true;
                      });
                      if (UtilAuth.checkString(
                              _namaController.text.toString()) ==
                          true) {
                        setState(() {
                          _valpnama = true;
                        });
                        if (_alamatController.text.isNotEmpty) {
                          setState(() {
                            _valpalamat = true;
                          });
                          if (UtilAuth.checkAlamat(
                                  _alamatController.text.toString()) ==
                              true) {
                            setState(() {
                              _valpalamat = true;
                            });
                            if (_rtrwController.text.isNotEmpty) {
                              setState(() {
                                _valprtrw = true;
                              });
                              if (UtilAuth.checkStringRTRW(
                                      _rtrwController.text.toString()) ==
                                  true) {
                                setState(() {
                                  _valprtrw = true;
                                });
                                if (_kelurahanController.text.isNotEmpty) {
                                  setState(() {
                                    _valpkelurahan = true;
                                  });
                                  if (UtilAuth.checkString(_kelurahanController
                                          .text
                                          .toString()) ==
                                      true) {
                                    setState(() {
                                      _valpkelurahan = true;
                                    });
                                    if (_agamaController.text.isNotEmpty) {
                                      setState(() {
                                        _valpagama = true;
                                      });
                                      if (UtilAuth.checkString(_agamaController
                                              .text
                                              .toString()) ==
                                          true) {
                                        setState(() {
                                          _valpagama = true;
                                        });
                                        if (_spController.text.isNotEmpty) {
                                          setState(() {
                                            _valpperkawawinan = true;
                                          });
                                          if (UtilAuth.checkString(_spController
                                                  .text
                                                  .toString()) ==
                                              true) {
                                            setState(() {
                                              _valpperkawawinan = true;
                                            });
                                            if (_workController
                                                .text.isNotEmpty) {
                                              setState(() {
                                                _valppekerjaan = true;
                                              });
                                              if (UtilAuth.checkString(
                                                      _workController.text
                                                          .toString()) ==
                                                  true) {
                                                setState(() {
                                                  _valppekerjaan = true;
                                                });
                                                if (_pendidikanController
                                                    .text.isNotEmpty) {
                                                  setState(() {
                                                    _valppendidikan = true;
                                                  });
                                                  if (UtilAuth.checkUsername(
                                                          _pendidikanController
                                                              .text
                                                              .toString()) ==
                                                      true) {
                                                    setState(() {
                                                      _valppendidikan = true;
                                                    });
                                                    var arrNIK =
                                                        new List<String>.from(
                                                            _nikController.text
                                                                .toString()
                                                                .split(''));
                                                    transleteNIK(arrNIK);
                                                    //SetState di sini
                                                    setState(() {
                                                      nikText =
                                                          _nikController.text;
                                                      namaText =
                                                          _namaController.text;
                                                      alamatText =
                                                          _alamatController
                                                              .text;
                                                      rtrwText =
                                                          _rtrwController.text;
                                                      kelText =
                                                          _kelurahanController
                                                              .text;
                                                      agamaText =
                                                          _agamaController.text;
                                                      spText =
                                                          _spController.text;
                                                      workText =
                                                          _workController.text;
                                                      pendidikanText =
                                                          _pendidikanController
                                                              .text;
                                                      okPressKtp = true;
                                                      ktpImage = val;
                                                    });
                                                    Navigator.of(context).pop();
                                                  } else {
                                                    setState(() {
                                                      _valppendidikan = false;
                                                    });
                                                  }
                                                } else {
                                                  setState(() {
                                                    _valppendidikan = false;
                                                  });
                                                }
                                              } else {
                                                setState(() {
                                                  _valppekerjaan = false;
                                                });
                                              }
                                            } else {
                                              setState(() {
                                                _valppekerjaan = false;
                                              });
                                            }
                                          } else {
                                            setState(() {
                                              _valpperkawawinan = false;
                                            });
                                          }
                                        } else {
                                          setState(() {
                                            _valpperkawawinan = false;
                                          });
                                        }
                                      } else {
                                        setState(() {
                                          _valpagama = false;
                                        });
                                      }
                                    } else {
                                      setState(() {
                                        _valpagama = false;
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      _valpkelurahan = false;
                                    });
                                  }
                                } else {
                                  setState(() {
                                    _valpkelurahan = false;
                                  });
                                }
                              } else {
                                setState(() {
                                  _valprtrw = false;
                                });
                              }
                            } else {
                              setState(() {
                                _valprtrw = false;
                              });
                            }
                          } else {
                            setState(() {
                              _valpalamat = false;
                            });
                          }
                        } else {
                          setState(() {
                            _valpalamat = false;
                          });
                        }
                      } else {
                        setState(() {
                          _valpnama = false;
                        });
                      }
                    } else {
                      setState(() {
                        _valpnama = false;
                      });
                    }
                  } else {
                    setState(() {
                      _valpnik = false;
                    });
                  }
                },
              )
            ],
          );
        });
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

  Future<void> sendToServerkk(BuildContext context, double size) async {
    if (val == null) {
      return;
    }
    UtilAuth.loading(context);
    Dio dio = new Dio();

    var datas = FormData.fromMap({
      "kk": await MultipartFile.fromFile(valkk.path),
      "nama": "KKME",
      "size": size
    });

    var response = await dio.post(urlkk, data: datas);
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

    Uint8List bytes =
        await networkImageToByte("${MyApp.routeOCR}/auth/file/Ktp/KKME.jpeg");
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
    bool _valpkk = true;

    Navigator.of(context, rootNavigator: true).pop();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        // return Dialog(
        return AlertDialog(
          title: Text('Form No KK'),
          content: Container(
            width: 100,
            height: 60,
            child: TextField(
              maxLength: 17,
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'No Kartu Keluarga',
                hintText: "Masukkan No KK Anda",
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                ),
                errorText: (_valpkk == false)
                    ? "No KK Anda Tidak Boleh Kosong!"
                    : null,
              ),
              controller: _kkController,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                if (_kkController.text != "") {
                  setState(() {
                    _valpkk = true;
                    kkImage = valkk;
                    nokkText = _kkController.text;
                    okPressKK = true;
                  });
                } else {
                  setState(() {
                    _valpkk = false;
                  });
                }
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
    String judulDetail;

    // KK
    double topFramekk;
    double rightFramekk;
    double widthFramekk;
    double heightFramekk;
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
          // _valKtpImage ||
          //         _valKkImage ||
          //         _valDepanRumahImage ||
          //         _valBelakangRumahImage ||
          //         _valLampiranPer ||
          //         _valktpOrtu1 ||
          //         _valktportu2 ||
          //         _valLunasPbb1 ||
          //         _valAkteCerai ||
          //         _valLunasPbb2 ||
          //         _valskks ||
          //         _valspptTerbaru ||
          //         _valskkdrs ||
          //         _valskck ||
          //         _valrwText ||
          //         _valrtText == false
          //     ? Container(
          //         margin: EdgeInsets.only(left: 10, right: 10),
          //         padding: EdgeInsets.all(10),
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: <Widget>[
          //             _valKtpImage == false
          //                 ? Text(
          //                     "* Foto KTP Tidak Boleh Kosong !",
          //                     style: TextStyle(
          //                         fontSize: 15,
          //                         color: Colors.red,
          //                         fontWeight: FontWeight.bold),
          //                   )
          //                 : Container(),
          //             _valKkImage == false
          //                 ? Text(
          //                     "* Foto KK Tidak Boleh Kosong !",
          //                     style: TextStyle(
          //                         fontSize: 15,
          //                         color: Colors.red,
          //                         fontWeight: FontWeight.bold),
          //                   )
          //                 : Container(),
          //             _valDepanRumahImage == false
          //                 ? Text(
          //                     "* Foto Depan Rumah Tidak Boleh Kosong !",
          //                     style: TextStyle(
          //                         fontSize: 15,
          //                         color: Colors.red,
          //                         fontWeight: FontWeight.bold),
          //                   )
          //                 : Container(),
          //             _valBelakangRumahImage == false
          //                 ? Text(
          //                     "* Foto Belakang Rumah Tidak Boleh Kosong !",
          //                     style: TextStyle(
          //                         fontSize: 15,
          //                         color: Colors.red,
          //                         fontWeight: FontWeight.bold),
          //                   )
          //                 : Container(),
          //             _valAkteCerai == false
          //                 ? Text(
          //                     "* File Akta Cerai Tidak Boleh Kosong !",
          //                     style: TextStyle(
          //                         fontSize: 15,
          //                         color: Colors.red,
          //                         fontWeight: FontWeight.bold),
          //                   )
          //                 : Container(),
          //             _valLampiranPer == false
          //                 ? Text(
          //                     "* File Lampiran Pernyataan Tidak Boleh Kosong !",
          //                     style: TextStyle(
          //                         fontSize: 15,
          //                         color: Colors.red,
          //                         fontWeight: FontWeight.bold),
          //                   )
          //                 : Container(),
          //             _valLunasPbb1 == false
          //                 ? Text(
          //                     "* File Bukti Lunas PBB Tahun Berjalan Tidak Boleh Kosong !",
          //                     style: TextStyle(
          //                         fontSize: 15,
          //                         color: Colors.red,
          //                         fontWeight: FontWeight.bold),
          //                   )
          //                 : Container(),
          //             _valLunasPbb2 == false
          //                 ? Text(
          //                     "* File Bukti Lunas PBB Tahun Berjalan Tidak Boleh Kosong !",
          //                     style: TextStyle(
          //                         fontSize: 15,
          //                         color: Colors.red,
          //                         fontWeight: FontWeight.bold),
          //                   )
          //                 : Container(),
          //             _valktpOrtu1 == false
          //                 ? Text(
          //                     "* File KTP Orang Tua-1 (Ayah) Tidak Boleh Kosong !",
          //                     style: TextStyle(
          //                         fontSize: 15,
          //                         color: Colors.red,
          //                         fontWeight: FontWeight.bold),
          //                   )
          //                 : Container(),
          //             _valktportu2 == false
          //                 ? Text(
          //                     "* File KTP Orang Tua-2 (Ibu) Tidak Boleh Kosong !",
          //                     style: TextStyle(
          //                         fontSize: 15,
          //                         color: Colors.red,
          //                         fontWeight: FontWeight.bold),
          //                   )
          //                 : Container(),
          //             _valskck == false
          //                 ? Text(
          //                     "* File SKCK Tidak Boleh Kosong !",
          //                     style: TextStyle(
          //                         fontSize: 15,
          //                         color: Colors.red,
          //                         fontWeight: FontWeight.bold),
          //                   )
          //                 : Container(),
          //             _valskkdrs == false
          //                 ? Text(
          //                     "* File Surat Keterangan Kematian Dari Rumah Sakit Tidak Boleh Kosong !",
          //                     style: TextStyle(
          //                         fontSize: 15,
          //                         color: Colors.red,
          //                         fontWeight: FontWeight.bold),
          //                   )
          //                 : Container(),
          //             _valskks == false
          //                 ? Text(
          //                     "* File Surat Keterangan Kematian Suami / Istri Tidak Boleh Kosong !",
          //                     style: TextStyle(
          //                         fontSize: 15,
          //                         color: Colors.red,
          //                         fontWeight: FontWeight.bold),
          //                   )
          //                 : Container(),
          //             _valspptTerbaru == false
          //                 ? Text(
          //                     "* File SPPT Terbaru Tidak Boleh Kosong !",
          //                     style: TextStyle(
          //                         fontSize: 15,
          //                         color: Colors.red,
          //                         fontWeight: FontWeight.bold),
          //                   )
          //                 : Container(),
          //             _valrwText == false
          //                 ? Text(
          //                     "* Kolom RW Belum Anda Dipilih !",
          //                     style: TextStyle(
          //                         fontSize: 15,
          //                         color: Colors.red,
          //                         fontWeight: FontWeight.bold),
          //                   )
          //                 : Container(),
          //             _valrtText == false
          //                 ? Text(
          //                     "* Kolom RT Belum Anda Dipilih !",
          //                     style: TextStyle(
          //                         fontSize: 15,
          //                         color: Colors.red,
          //                         fontWeight: FontWeight.bold),
          //                   )
          //                 : Container(),
          //           ],
          //         ),
          //       )
          //     : Container(),
          Container(
            margin: EdgeInsets.only(left: 10, top: 10, bottom: 5, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "KTP:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                ktpImage == null
                    ? Container(
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
                              if (height < 650) {
                                setState(() {
                                  bigBoxHeight = 530;
                                  topBigBox = 10;
                                  leftBigBox = 25;
                                  widthBigBox = 310;
                                  topFrame = 30;
                                  rightFrame = 70;
                                  heightFrame = 330;
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
                                    MediaQuery.of(context).size.height.ceil() -
                                        200.0;
                                topBigBox = 60;
                                leftBigBox = 0;
                                widthBigBox = MediaQuery.of(context).size.width;
                                topFrame = 80;
                                rightFrame = 60;
                                heightFrame =
                                    MediaQuery.of(context).size.height.ceil() -
                                        420.0;
                                topText = 70;
                                rightText = 390;
                                heightText = 550;
                              }
                              val = await showDialog(
                                  context: context,
                                  builder: (context) => Camera(
                                        mode: CameraMode.normal,
                                        orientationEnablePhoto:
                                            CameraOrientation.all,
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
                                                          width: 3,
                                                          color: Colors.white)),
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
                                                          width: 2,
                                                          color: Colors.white)),
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
                                                          fontWeight:
                                                              FontWeight.bold),
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
                              setKtpImageNull();
                            }),
                      ),
                Text(
                  "KK:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                kkImage == null
                    ? Container(
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
                              if (height < 650) {
                                setState(() {
                                  topFramekk = 200.0;
                                  rightFramekk = 20.0;
                                  widthFramekk = 20.0;
                                  heightFramekk = 200.0;
                                });
                              }
                              if (height >= 716) {
                                setState(() {
                                  topFramekk = 250.0;
                                  rightFramekk = 20.0;
                                  widthFramekk = 20.0;
                                  heightFramekk = 200.0;
                                });
                              }
                              if (height >= 850) {
                                setState(() {
                                  topFramekk = 330.0;
                                  rightFramekk = 30.0;
                                  widthFramekk = 25.0;
                                  heightFramekk = 220.0;
                                });
                              }
                              val = await showDialog(
                                  context: context,
                                  builder: (context) => Camera(
                                        mode: height < 650
                                            ? CameraMode.fullscreen
                                            : CameraMode.normal,
                                        orientationEnablePhoto:
                                            CameraOrientation.all,
                                        imageMask: Stack(
                                          children: <Widget>[
                                            Positioned(
                                              top: topFramekk,
                                              right: rightFramekk,
                                              child: Container(
                                                width: widthFramekk,
                                                height: heightFramekk,
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
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ));
                              setState(() {});
                              sendToServerkk(context, height);
                            }),
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
                              setKKImageNull();
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
