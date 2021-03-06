import 'dart:io';
import 'dart:typed_data';

import 'package:camera_camera/camera_camera.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:network_image_to_byte/network_image_to_byte.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_letter/Auth/views/AuthComponent/text_widget.dart';
import 'package:submission_letter/Notification/api/messaging.dart';
import 'package:submission_letter/Notification/model/message.dart';
import 'package:submission_letter/Penduduk_Page/presenter/buatSurat_presenter.dart';

import 'package:submission_letter/Penduduk_Page/views/home_penduduk.dart';
import 'package:submission_letter/Penduduk_Page/widget/cancle_btn.dart';
import 'package:submission_letter/Penduduk_Page/widget/dropdown_widget.dart';

import 'package:submission_letter/Penduduk_Page/widget/file_picker_new.dart';
import 'package:submission_letter/Theme/theme_penduduk.dart';
import 'package:submission_letter/Util/util_auth.dart';
import 'package:submission_letter/main.dart';
import 'package:tesseract_ocr/tesseract_ocr.dart';

class BuatSuratP extends StatefulWidget {
  String tipe;
  BuatSuratP({this.tipe});
  @override
  _BuatSuratPState createState() => _BuatSuratPState();
}

class _BuatSuratPState extends State<BuatSuratP> {
  // ******************** Notif

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final List<Message> messages = [];
  final TextEditingController titleController =
      TextEditingController(text: 'Surat Masuk');
  final TextEditingController bodyController = TextEditingController(
      text: 'Periksa TODO Anda untuk segera proses surat');

  //*************************** */
  // ******************  Drop Down Data
  String rwTextDrop;
  String rtTextDrop;

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

  // ********* END DROPDOWN

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

  Map<String, dynamic> prov = {'31': 'JAKARTA'};
  //BBCC
  Map<String, dynamic> kota_kecamatan = {
    '01': {
      '01': 'KEP SERIBU UTARA',
      '02': 'KEP SERIBU SELATAN',
    },
    '71': {
      '01': 'GAMBIR',
      '02': 'SAWAH BESAR',
      '03': 'KEMAYORAN',
      '04': 'SENEN',
      '05': 'CEMPAKA PUTIH',
      '06': 'MENTENG',
      '07': 'TANAH ABANG',
      '08': 'JOHAR BARU'
    },
    '72': {
      '01': 'PENJARINGAN',
      '02': 'TANJUNG PRIOK',
      '03': 'KOJA',
      '04': 'CILINCING',
      '05': 'PADEMANGAN',
      '06': 'KELAPA GADING'
    },
    '73': {
      '01': 'CENGKARENG',
      '02': 'GEROGOL PETAMBURAN',
      '03': 'TAMAN SARI',
      '04': 'TAMBORA',
      '05': 'KEBON JERUK',
      '06': 'KALI DERES',
      '07': 'PAL MERAH',
      '08': 'KEMBANGAN'
    },
    '74': {
      '01': 'TEBET',
      '02': 'SETIA BUDI',
      '03': 'MAMPANG PRAPATAN',
      '04': 'PASAR MINGGU',
      '05': 'KEBAYORAN LAMA',
      '06': 'CILANDAK',
      '07': 'KEBAYORAN BARU',
      '08': 'PANCORAN',
      '09': 'JAGAKARSA',
      '10': 'PESANGGRAHAN',
    },
    '75': {
      '01': 'MATRAMAN',
      '02': 'PULO GADUNG',
      '03': 'JATINEGARA',
      '04': 'KRAMATJATI',
      '05': 'PASAR REBO',
      '06': 'CAKUNG',
      '07': 'DUREN SAWIT',
      '08': 'MAKASAR',
      '09': 'CIRACAS',
      '10': 'CIPAYUNG'
    },
  };

  //EE
  Map<String, dynamic> bulan = {
    '01': 'JANUARI',
    '02': 'FEBRUARI',
    '03': 'MARET',
    '04': 'APRIL',
    '05': 'MEI',
    '06': 'JUNI',
    '07': 'JULI',
    '08': 'AGUSTUS',
    '09': 'SEPTEMBER',
    '10': 'OKTOBER',
    '11': 'NOVEMBER',
    '12': 'DESEMBER',
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

  // ************ Set Null File
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

  void setdepanRumahNull() {
    setState(() {
      _depanRumah = null;
    });
  }

  void setbelakangRumahNull() {
    setState(() {
      _belakangRumah = null;
    });
  }

  void setspptTerbaruNull() {
    setState(() {
      _spptTerbaru = null;
    });
  }

  void setlamperNull() {
    setState(() {
      _lampiranPer = null;
    });
  }

  void setktportu1Null() {
    setState(() {
      _ktpOrtu1 = null;
    });
  }

  void setktportu2Null() {
    setState(() {
      _ktpOrtu2 = null;
    });
  }

  void setlunaspbb1Null() {
    setState(() {
      _lunasPbb1 = null;
    });
  }

  void setakteceraiNull() {
    setState(() {
      _akteCerai = null;
    });
  }

  void setlunaspbb2Null() {
    setState(() {
      _lunasPbb2 = null;
    });
  }

  void setskksNull() {
    setState(() {
      _skks = null;
    });
  }

  void setskksdrsNull() {
    setState(() {
      _skksdrs = null;
    });
  }

  void setskckNull() {
    setState(() {
      _skck = null;
    });
  }

//************************************** END File Perbaikan ******** */
  @override
  void initState() {
    setPreference();
    super.initState();

    _firebaseMessaging.onTokenRefresh.listen(sendTokenToServer);
    _firebaseMessaging.getToken();
    _firebaseMessaging.subscribeToTopic('all');

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");

        final notification = message['notification'];
        setState(() {
          messages.add(Message(
              title: notification['title'], body: notification['body']));
        });
      },
      onLaunch: (Map<String, dynamic> message) {},
      onResume: (Map<String, dynamic> message) async {},
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  Future<void> setPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      idUser = pref.getInt("Id");
      noTelepon = pref.getString("NoTelepon");
      nikPref = pref.getString("Nik");
    });
  }

  void sendNotification(BuildContext context, tokenEndUser) async {
    final response = await Messaging.sendTo(
        title: titleController.text,
        body: bodyController.text,
        fcmToken: '$tokenEndUser');
    if (response.statusCode != 200) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content:
            Text('[${response.statusCode}] Error Message: ${response.body}'),
      ));
    }
  }

  void sendTokenToServer(String fcmToken) {
    print('TokenNya: $fcmToken');
  }

  void dispose() {
    super.dispose();
  }

  //************************* Validate *************************** */
  String keteranganText;

  bool _validateKeterangan = true;
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

  void setKeterangan(String val) {
    setState(() {
      keteranganText = val;
    });
  }

  //************************* OCR FUNCTION *************************** */

  // //KAMERA
  Future<void> sendToServer(BuildContext context, double sizes) async {
    if (val == null) {
      return;
    }
    netralVariable();
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

    if (arrOCR.length > 11) {
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
      } else if (namaFill.contains('"')) {
        var namaArr = List<String>.from(text1.split('"'));
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
        if (arrOCR[4].split(" ")[1].contains("Ala")) {
          arrOCR[4].split(" ").removeAt(0);

          alamatFill = List<String>.from(arrOCR[4].split(''));
        } else {
          alamatFill = ["Alamat", ":", "Isi Alamat"];
        }
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
      } else if (alamatFill.contains('"')) {
        var alamatArr = List<String>.from(text2.split('"'));
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
        // Error di else
        // error samsung
        // Fix else nya
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
      } else if (rtrwFill.contains('"')) {
        var rtrwArr = List<String>.from(text3.split('"'));
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
        kelFill = ["K", "e", "l", "D", "e", "s", "a", "", ":", "Kosong"];
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
      } else if (kelFill.contains('"')) {
        var kelArr = List<String>.from(text4.split('"'));
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
        agamaFill = ["Agama", " ", ":", "Isi Agama"];
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
      } else if (agamaFill.contains('"')) {
        var agamaArr = List<String>.from(text5.split('"'));
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
      } else if (arrOCR.length == 13) {
        print("SP a");
        if (arrOCR[12].split(" ")[0].contains("Statu")) {
          spFill = List<String>.from(arrOCR[12].split(''));
        } else if (arrOCR[12].split(" ")[0].contains("Stat")) {
          spFill = List<String>.from(arrOCR[12].split(''));
        } else if (arrOCR[12].split(" ")[0].contains("tatus")) {
          spFill = List<String>.from(arrOCR[12].split(''));
        } else if (arrOCR[12].split(" ")[0].contains("St")) {
          spFill = List<String>.from(arrOCR[12].split(''));
        } else if (arrOCR[12].split(" ")[0].contains("S")) {
          spFill = List<String>.from(arrOCR[12].split(''));
        } else {
          spFill = ["Status", ":", "Isi Status Perkawinan"];
        }
      } else if (arrOCR.length >= 14) {
        print("SP b");
        if (arrOCR[13].split(" ")[0].contains("Statu")) {
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
          spFill = ["Status", ":", "Isi Status Perkawinan"];
        }
      } else {
        print("SP c");
        spFill = ["Status", ":", "Isi Status Perkawinan"];
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
      } else if (spFill.contains('"')) {
        var spArr = List<String>.from(text6.split('"'));
        setState(() {
          spText = spArr[1];
        });
      } else if (spFill.contains('.')) {
        var spArr = List<String>.from(text6.split('.'));
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
      if (arrOCR[10].split(" ")[0].contains("rjaa")) {
        workFill = List<String>.from(arrOCR[10].split(''));
      } else if (arrOCR[10].split(" ")[0].contains("jaa")) {
        workFill = List<String>.from(arrOCR[10].split(''));
      } else if (arrOCR[10].split(" ")[0].contains("kerja")) {
        workFill = List<String>.from(arrOCR[10].split(''));
      } else if (arrOCR[10].split(" ")[0].contains("ja")) {
        workFill = List<String>.from(arrOCR[10].split(''));
      } else if (arrOCR[10].split(" ")[0].contains("j")) {
        workFill = List<String>.from(arrOCR[10].split(''));
      } else if (arrOCR[11].split(" ")[0].contains("rjaa")) {
        workFill = List<String>.from(arrOCR[11].split(''));
      } else if (arrOCR[11].split(" ")[0].contains("jaa")) {
        workFill = List<String>.from(arrOCR[11].split(''));
      } else if (arrOCR[11].split(" ")[0].contains("kerja")) {
        workFill = List<String>.from(arrOCR[11].split(''));
      } else if (arrOCR[11].split(" ")[0].contains("ja")) {
        workFill = List<String>.from(arrOCR[11].split(''));
      } else if (arrOCR[11].split(" ")[0].contains("j")) {
        workFill = List<String>.from(arrOCR[11].split(''));
      } else if (arrOCR.length == 13) {
        print("WA a");
        if (arrOCR[11].split(" ")[0].contains("rjaa")) {
          workFill = List<String>.from(arrOCR[11].split(''));
        } else if (arrOCR[11].split(" ")[0].contains("jaa")) {
          workFill = List<String>.from(arrOCR[11].split(''));
        } else if (arrOCR[11].split(" ")[0].contains("kerja")) {
          workFill = List<String>.from(arrOCR[11].split(''));
        } else if (arrOCR[11].split(" ")[0].contains("ja")) {
          workFill = List<String>.from(arrOCR[11].split(''));
        } else if (arrOCR[11].split(" ")[0].contains("j")) {
          workFill = List<String>.from(arrOCR[11].split(''));
        } else if (arrOCR[12].split(" ")[0].contains("rjaa")) {
          workFill = List<String>.from(arrOCR[12].split(''));
        } else if (arrOCR[12].split(" ")[0].contains("jaa")) {
          workFill = List<String>.from(arrOCR[12].split(''));
        } else if (arrOCR[12].split(" ")[0].contains("kerja")) {
          workFill = List<String>.from(arrOCR[12].split(''));
        } else if (arrOCR[12].split(" ")[0].contains("ja")) {
          workFill = List<String>.from(arrOCR[12].split(''));
        } else if (arrOCR[12].split(" ")[0].contains("j")) {
          workFill = List<String>.from(arrOCR[12].split(''));
        } else {
          workFill = ['Pekerjaan', ":", "Isi Pekerjaan"];
        }
      } else if (arrOCR.length == 14) {
        print("WA b");
        if (arrOCR[11].split(" ")[0].contains("rjaa")) {
          workFill = List<String>.from(arrOCR[11].split(''));
        } else if (arrOCR[11].split(" ")[0].contains("jaa")) {
          workFill = List<String>.from(arrOCR[11].split(''));
        } else if (arrOCR[11].split(" ")[0].contains("kerja")) {
          workFill = List<String>.from(arrOCR[11].split(''));
        } else if (arrOCR[11].split(" ")[0].contains("ja")) {
          workFill = List<String>.from(arrOCR[11].split(''));
        } else if (arrOCR[11].split(" ")[0].contains("j")) {
          workFill = List<String>.from(arrOCR[11].split(''));
        } else if (arrOCR[12].split(" ")[0].contains("rjaa")) {
          workFill = List<String>.from(arrOCR[12].split(''));
        } else if (arrOCR[12].split(" ")[0].contains("jaa")) {
          workFill = List<String>.from(arrOCR[12].split(''));
        } else if (arrOCR[12].split(" ")[0].contains("kerja")) {
          workFill = List<String>.from(arrOCR[12].split(''));
        } else if (arrOCR[12].split(" ")[0].contains("ja")) {
          workFill = List<String>.from(arrOCR[12].split(''));
        } else if (arrOCR[12].split(" ")[0].contains("j")) {
          workFill = List<String>.from(arrOCR[12].split(''));
        } else if (arrOCR[13].split(" ")[0].contains("rjaa")) {
          workFill = List<String>.from(arrOCR[13].split(''));
        } else if (arrOCR[13].split(" ")[0].contains("jaa")) {
          workFill = List<String>.from(arrOCR[13].split(''));
        } else if (arrOCR[13].split(" ")[0].contains("kerja")) {
          workFill = List<String>.from(arrOCR[13].split(''));
        } else if (arrOCR[13].split(" ")[0].contains("ja")) {
          workFill = List<String>.from(arrOCR[13].split(''));
        } else if (arrOCR[13].split(" ")[0].contains("j")) {
          workFill = List<String>.from(arrOCR[13].split(''));
        } else {
          workFill = ["Pekerjaan", ":", "Isi Pekerjaan"];
        }
      } else if (arrOCR.length >= 15) {
        print("WA c");
        if (arrOCR[11].split(" ")[0].contains("rjaa")) {
          workFill = List<String>.from(arrOCR[11].split(''));
        } else if (arrOCR[11].split(" ")[0].contains("jaa")) {
          workFill = List<String>.from(arrOCR[11].split(''));
        } else if (arrOCR[11].split(" ")[0].contains("kerja")) {
          workFill = List<String>.from(arrOCR[11].split(''));
        } else if (arrOCR[11].split(" ")[0].contains("ja")) {
          workFill = List<String>.from(arrOCR[11].split(''));
        } else if (arrOCR[11].split(" ")[0].contains("j")) {
          workFill = List<String>.from(arrOCR[11].split(''));
        } else if (arrOCR[12].split(" ")[0].contains("rjaa")) {
          workFill = List<String>.from(arrOCR[12].split(''));
        } else if (arrOCR[12].split(" ")[0].contains("jaa")) {
          workFill = List<String>.from(arrOCR[12].split(''));
        } else if (arrOCR[12].split(" ")[0].contains("kerja")) {
          workFill = List<String>.from(arrOCR[12].split(''));
        } else if (arrOCR[12].split(" ")[0].contains("ja")) {
          workFill = List<String>.from(arrOCR[12].split(''));
        } else if (arrOCR[12].split(" ")[0].contains("j")) {
          workFill = List<String>.from(arrOCR[12].split(''));
        } else if (arrOCR[13].split(" ")[0].contains("rjaa")) {
          workFill = List<String>.from(arrOCR[13].split(''));
        } else if (arrOCR[13].split(" ")[0].contains("jaa")) {
          workFill = List<String>.from(arrOCR[13].split(''));
        } else if (arrOCR[13].split(" ")[0].contains("kerja")) {
          workFill = List<String>.from(arrOCR[13].split(''));
        } else if (arrOCR[13].split(" ")[0].contains("ja")) {
          workFill = List<String>.from(arrOCR[13].split(''));
        } else if (arrOCR[13].split(" ")[0].contains("j")) {
          workFill = List<String>.from(arrOCR[13].split(''));
        } else if (arrOCR[14].split(" ")[0].contains("rjaa")) {
          workFill = List<String>.from(arrOCR[14].split(''));
        } else if (arrOCR[14].split(" ")[0].contains("jaa")) {
          workFill = List<String>.from(arrOCR[14].split(''));
        } else if (arrOCR[14].split(" ")[0].contains("kerja")) {
          workFill = List<String>.from(arrOCR[14].split(''));
        } else if (arrOCR[14].split(" ")[0].contains("ja")) {
          workFill = List<String>.from(arrOCR[14].split(''));
        } else if (arrOCR[14].split(" ")[0].contains("j")) {
          workFill = List<String>.from(arrOCR[14].split(''));
        } else {
          workFill = ["Pekerjaan", ":", "Isi Pekerjaan"];
        }
      } else {
        print("WA d");
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
  }

  // void manageData(List<String> arrFill, String setText) {
  //   var texts = arrFill.join('');
  //   if (arrFill.contains(":")) {
  //     var workArr = List<String>.from(texts.split(':'));
  //     setState(() {
  //       workText = workArr[1];
  //     });
  //   } else {
  //     var workArr = List<String>.from(texts.split(' '));
  //     workArr.removeAt(0);
  //     setState(() {
  //       workText = workArr.join(' ');
  //     });
  //   }
  // }

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
                    height: 80,
                    child: TextField(
                      maxLength: 17,
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
                            ? "Masukkan NIK Anda Dengan Benar!"
                            : null,
                      ),
                      controller: _nikController,
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 80,
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Nama',
                        hintText: "Masukkan Nama Anda",
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                        ),
                        errorText: (_valpnama == false)
                            ? "Masukkan Nama Anda Dengan Benar"
                            : null,
                      ),
                      controller: _namaController,
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 80,
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Alamat',
                        hintText: "Masukkan Alamat Anda",
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                        ),
                        errorText: (_valpalamat == false)
                            ? "Masukkan Alamat Anda Dengan Benar"
                            : null,
                      ),
                      controller: _alamatController,
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 80,
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
                    height: 80,
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Kelurahan',
                        hintText: "Masukkan Kelurahan Anda",
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                        ),
                        errorText: (_valpkelurahan == false)
                            ? "Masukkan Kelurahan Anda Dengan Benar!"
                            : null,
                      ),
                      controller: _kelurahanController,
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 80,
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
                    height: 80,
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
                    height: 80,
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
                    height: 80,
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
                                              if (UtilAuth.checkStringRTRW(
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
                                                  if (UtilAuth.checkStringPassword(
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
        jenis_kelaminText = 'PEREMPUAN';
        var tgl = int.parse(tmpNIK[3]) - 40;
        tgl_lahirText =
            "${prov[tmpNIK[0]]}, $tgl ${bulan[tmpNIK[4]]} 19${tmpNIK[5]}";
      } else if (int.parse(tmpNIK[3]) < 40) {
        jenis_kelaminText = 'LAKI-LAKI';
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
    if (valkk == null) {
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
    print(arrOCR);

    var kk;
    if (arrOCR.length >= 2) {
      if (arrOCR[1].contains("-")) {
        kk = arrOCR[1].split('-');
      } else if (arrOCR[1].contains(".")) {
        kk = arrOCR[1].split('.');
      } else if (arrOCR[1].contains(":")) {
        kk = arrOCR[1].split(':');
      } else if (arrOCR[1].contains(" ")) {
        kk = arrOCR[1].split(" ");
      } else if (arrOCR[1].contains("B")) {
        setState(() {
          nokkText = "Not Good";
          statkk = true;
        });
        return false;
      } else if (arrOCR[1].contains("H")) {
        setState(() {
          nokkText = "Not Good";
          statkk = true;
          kkNormProc = true;
        });
        if (kkNormProc == true) {
          popupskk(context);
        }
        return false;
      } else {
        setState(() {
          nokkText = "Not Good";
          statkk = true;
          kkNormProc = true;
        });
        if (kkNormProc == true) {
          popupskk(context);
        }
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
    } else {
      setState(() {
        nokkText = "Not Good";
        statkk = true;
        kkNormProc = true;
      });
      if (kkNormProc == true) {
        popupskk(context);
      }
      return false;
    }
  }

  Widget popupskk(BuildContext context) {
    _kkController.text = nokkText;
    bool _valpkk = true;

    Navigator.of(context, rootNavigator: true).pop();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Form No KK'),
              content: Container(
                width: 100,
                height: 95,
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
                        ? "Masukkan No KK Anda Dengan Benar!"
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
                    //SetState di sini

                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          },
        );
      },
    );
  }

  //******************************************************************* */

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double fontSizes = height == 716 ? 13 : 15;
    double titleSizes = height == 716 ? 18 : 20;
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

    // KK
    double topFramekk;
    double rightFramekk;
    double widthFramekk;
    double heightFramekk;

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
    } else if (widget.tipe == "15") {
      judulDetail = "Pengajuan Surat Penghantar RT&RW";
    }
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
        child: ListView(
          children: <Widget>[
            Divider(
              color: Colors.orange,
              thickness: 2,
            ),
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  "$judulDetail",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                    fontSize: titleSizes,
                  ),
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
            DropDownWidget(
              dataRt: setRtText,
              dataRw: setRwText,
            ),
            Divider(
              color: Colors.orange[200],
              thickness: 3,
            ),
            Container(
              margin: EdgeInsets.only(left: 10, top: 10, bottom: 5),
              child: Text(
                "Berkas Pengajuan",
                style: TextStyle(
                    fontSize: titleSizes, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              color: Colors.orange[200],
              thickness: 3,
            ),
            _validateKeterangan ||
                    _valKtpImage ||
                    _valKkImage ||
                    _valDepanRumahImage ||
                    _valBelakangRumahImage ||
                    _valLampiranPer ||
                    _valktpOrtu1 ||
                    _valktportu2 ||
                    _valLunasPbb1 ||
                    _valAkteCerai ||
                    _valLunasPbb2 ||
                    _valskks ||
                    _valspptTerbaru ||
                    _valskkdrs ||
                    _valskck ||
                    _valrwText ||
                    _valrtText == false
                ? Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _valKtpImage == false
                            ? Text(
                                "* Foto KTP Tidak Boleh Kosong !",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              )
                            : Container(),
                        _valKkImage == false
                            ? Text(
                                "* Foto KK Tidak Boleh Kosong !",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              )
                            : Container(),
                        _valDepanRumahImage == false
                            ? Text(
                                "* Foto Depan Rumah Tidak Boleh Kosong !",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              )
                            : Container(),
                        _valBelakangRumahImage == false
                            ? Text(
                                "* Foto Belakang Rumah Tidak Boleh Kosong !",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              )
                            : Container(),
                        _valAkteCerai == false
                            ? Text(
                                "* File Akta Cerai Tidak Boleh Kosong !",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              )
                            : Container(),
                        _valLampiranPer == false
                            ? Text(
                                "* File Lampiran Pernyataan Tidak Boleh Kosong !",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              )
                            : Container(),
                        _valLunasPbb1 == false
                            ? Text(
                                "* File Bukti Lunas PBB Tahun Berjalan Tidak Boleh Kosong !",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              )
                            : Container(),
                        _valLunasPbb2 == false
                            ? Text(
                                "* File Bukti Lunas PBB Tahun Berjalan Tidak Boleh Kosong !",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              )
                            : Container(),
                        _valktpOrtu1 == false
                            ? Text(
                                "* File KTP Orang Tua-1 (Ayah) Tidak Boleh Kosong !",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              )
                            : Container(),
                        _valktportu2 == false
                            ? Text(
                                "* File KTP Orang Tua-2 (Ibu) Tidak Boleh Kosong !",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              )
                            : Container(),
                        _valskck == false
                            ? Text(
                                "* File SKCK Tidak Boleh Kosong !",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              )
                            : Container(),
                        _valskkdrs == false
                            ? Text(
                                "* File Surat Keterangan Kematian Dari Rumah Sakit Tidak Boleh Kosong !",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              )
                            : Container(),
                        _valskks == false
                            ? Text(
                                "* File Surat Keterangan Kematian Suami / Istri Tidak Boleh Kosong !",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              )
                            : Container(),
                        _valspptTerbaru == false
                            ? Text(
                                "* File SPPT Terbaru Tidak Boleh Kosong !",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              )
                            : Container(),
                        _valrwText == false
                            ? Text(
                                "* Kolom RW Belum Anda Dipilih !",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              )
                            : Container(),
                        _valrtText == false
                            ? Text(
                                "* Kolom RT Belum Anda Dipilih !",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              )
                            : Container(),
                      ],
                    ),
                  )
                : Container(),
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
                                  widthBigBox =
                                      MediaQuery.of(context).size.width;
                                  topFrame = 65;
                                  rightFrame = 50;
                                  heightFrame = height - 340;
                                  topText = 70;
                                  rightText = 340;
                                  heightText = 550;
                                }
                                if (height >= 850) {
                                  bigBoxHeight = MediaQuery.of(context)
                                          .size
                                          .height
                                          .ceil() -
                                      200.0;
                                  topBigBox = 60;
                                  leftBigBox = 0;
                                  widthBigBox =
                                      MediaQuery.of(context).size.width;
                                  topFrame = 80;
                                  rightFrame = 60;
                                  heightFrame = MediaQuery.of(context)
                                          .size
                                          .height
                                          .ceil() -
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
                                                            color:
                                                                Colors.white)),
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
                                                            color:
                                                                Colors.white)),
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
                                                                FontWeight
                                                                    .bold),
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
                                valkk = await showDialog(
                                    context: context,
                                    builder: (context) => Camera(
                                          mode: height < 650
                                              ? CameraMode.fullscreen
                                              : CameraMode.normal,
                                          orientationEnablePhoto:
                                              CameraOrientation.landscape,
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
                            _depanRumah == null
                                ? FilePickerNew(
                                    title: "Foto Depan Rumah",
                                    setFileAtt: setdepanRumah,
                                  )
                                : CancleBtn(
                                    title: "Foto Depan Rumah",
                                    setFileNull: setdepanRumahNull,
                                  ),
                            _belakangRumah == null
                                ? FilePickerNew(
                                    title: "Foto Belakang Rumah",
                                    setFileAtt: setbelakangRumah,
                                  )
                                : CancleBtn(
                                    title: "Foto Belakang Rumah",
                                    setFileNull: setbelakangRumahNull,
                                  )
                          ],
                        )
                      : Container(),
                  widget.tipe == "2"
                      ? _spptTerbaru == null
                          ? FilePickerNew(
                              title: "SPPT Terbaru",
                              setFileAtt: setspptTerbaru,
                            )
                          : CancleBtn(
                              title: "SPPT Terbaru",
                              setFileNull: setspptTerbaruNull,
                            )
                      : Container(),
                  widget.tipe == "3"
                      ? _lampiranPer == null
                          ? FilePickerNew(
                              title: "Lampiran Pernyataan",
                              setFileAtt: setlamper,
                            )
                          : CancleBtn(
                              title: "Lampiran Pernyataan",
                              setFileNull: setlamperNull,
                            )
                      : Container(),
                  widget.tipe == "4"
                      ? Column(
                          children: <Widget>[
                            _ktpOrtu1 == null
                                ? FilePickerNew(
                                    title: "KTP Orang Tua-1 (Ayah)",
                                    setFileAtt: setktportu1,
                                  )
                                : CancleBtn(
                                    title: "KTP Orang Tua-1 (Ayah)",
                                    setFileNull: setktportu1Null,
                                  ),
                            _ktpOrtu2 == null
                                ? FilePickerNew(
                                    title: "KTP Orang Tua-2 (Ibu)",
                                    setFileAtt: setktportu2,
                                  )
                                : CancleBtn(
                                    title: "KTP Orang Tua-2 (Ibu)",
                                    setFileNull: setktportu2Null,
                                  ),
                            _lunasPbb1 == null
                                ? FilePickerNew(
                                    title: "Tanda Lunas PBB Tahun Berjalan",
                                    setFileAtt: setlunaspbb1,
                                  )
                                : CancleBtn(
                                    title: "Tanda Lunas PBB Tahun Berjalan",
                                    setFileNull: setlunaspbb1Null,
                                  )
                          ],
                        )
                      : Container(),
                  widget.tipe == "5"
                      ? Column(
                          children: <Widget>[
                            _akteCerai == null
                                ? FilePickerNew(
                                    title: "Akte Cerai",
                                    setFileAtt: setaktecerai,
                                  )
                                : CancleBtn(
                                    title: "Akte Cerai",
                                    setFileNull: setakteceraiNull,
                                  ),
                            _lunasPbb2 == null
                                ? FilePickerNew(
                                    title: "Pelunasan PBB Tahun Berjalan",
                                    setFileAtt: setlunaspbb2)
                                : CancleBtn(
                                    title: "Pelunasan PBB Tahun Berjalan",
                                    setFileNull: setlunaspbb2Null,
                                  ),
                            _skks == null
                                ? FilePickerNew(
                                    title:
                                        "Surat Keterangan Kematian Suami / Istri",
                                    setFileAtt: setskks,
                                  )
                                : CancleBtn(
                                    title:
                                        "Surat Keterangan Kematian Suami / Istri",
                                    setFileNull: setskksNull,
                                  )
                          ],
                        )
                      : Container(),
                  widget.tipe == "7"
                      ? _skksdrs == null
                          ? FilePickerNew(
                              title:
                                  "Surat Keterangan Kematian Dari Rumah Sakit",
                              setFileAtt: setskksdrs,
                            )
                          : CancleBtn(
                              title:
                                  "Surat Keterangan Kematian Dari Rumah Sakit",
                              setFileNull: setskksdrsNull,
                            )
                      : Container(),
                  widget.tipe == "8"
                      ? _skck == null
                          ? FilePickerNew(
                              title:
                                  "SKCK (Untuk Pindahan Dari Kabupaten / Provinsi)",
                              setFileAtt: setskck,
                            )
                          : CancleBtn(
                              title:
                                  "SKCK (Untuk Pindahan Dari Kabupaten / Provinsi)",
                              setFileNull: setskckNull,
                            )
                      : Container()
                ],
              ),
            ),
            Divider(
              color: Colors.orange[200],
              thickness: 3,
            ),
            TextWidget(
              labelTexts: "Keterangan Pembuatan Surat",
              hintTexts: "Masukkan Tujuan Anda Ingin Melakukan Pengajuan Ini",
              messageEmpty: "Keterangan Tidak Boleh Kosong!",
              pass: false,
              emails: false,
              callBackName: setKeterangan,
              val: _validateKeterangan,
            ),
            Divider(
              color: Colors.orange[200],
              thickness: 3,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20, top: 10),
              width: double.infinity,
              child: RaisedButton(
                  color: Colors.orange,
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.orange)),
                  child: Text(
                    "Buat Surat",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    validateForm(context);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void prosesData(BuildContext context) async {
    UtilAuth.loading(context);
    Map<String, dynamic> data;
    var datakk;

    if (widget.tipe != "7") {
      if (nikPref != nikText) {
        UtilAuth.failedPopupDialog(
            context, "Pengajuan Harus Menggunakan KTP Pribadi");
        return;
      }
    }

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
    BuatSuratPresenter presenter = new BuatSuratPresenter();
    var response = await presenter.buatSuratProcess(
      widget.tipe,
      idUser,
      rwTextDrop,
      rtTextDrop,
      data,
      datakk,
      keteranganText,
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
    if (response.data['token'] != null) {
      sendNotification(context, response.data['token']);
    } else {
      UtilAuth.emailsFlat(response.data['email']);
    }
    UtilAuth.successPopupDialog(
        context, response.data['message'], HomePenduduk());
  }

  void validateForm(BuildContext context) {
    if (keteranganText != null) {
      setState(() {
        _validateKeterangan = true;
      });
      if (ktpImage != null) {
        setState(() {
          _valKtpImage = true;
        });
        if (kkImage != null) {
          setState(() {
            _valKkImage = true;
          });
          if (rwTextDrop != null) {
            setState(() {
              _valrwText = true;
            });
            if (rtTextDrop != null) {
              setState(() {
                _valrtText = true;
              });

              //
              //

              if (widget.tipe == "1") {
                if (_depanRumah != null) {
                  setState(() {
                    _valDepanRumahImage = true;
                  });
                  if (_belakangRumah != null) {
                    setState(() {
                      _valBelakangRumahImage = true;
                    });
                    prosesData(context);
                  } else {
                    setState(() {
                      _valBelakangRumahImage = false;
                    });
                  }
                } else {
                  setState(() {
                    _valDepanRumahImage = false;
                  });
                }
              } else if (widget.tipe == "2") {
                if (_spptTerbaru != null) {
                  setState(() {
                    _valspptTerbaru = true;
                  });
                  prosesData(context);
                } else {
                  setState(() {
                    _valspptTerbaru = false;
                  });
                }
              } else if (widget.tipe == "3") {
                if (_lampiranPer != null) {
                  setState(() {
                    _valLampiranPer = true;
                  });
                  prosesData(context);
                } else {
                  setState(() {
                    _valLampiranPer = false;
                  });
                }
              } else if (widget.tipe == "4") {
                if (_ktpOrtu1 != null) {
                  setState(() {
                    _valktpOrtu1 = true;
                  });
                  if (_ktpOrtu2 != null) {
                    setState(() {
                      _valktportu2 = true;
                    });
                    if (_lunasPbb1 != null) {
                      setState(() {
                        _valLunasPbb1 = true;
                      });
                      prosesData(context);
                    } else {
                      setState(() {
                        _valLunasPbb1 = false;
                      });
                    }
                  } else {
                    setState(() {
                      _valktportu2 = false;
                    });
                  }
                } else {
                  setState(() {
                    _valktpOrtu1 = false;
                  });
                }
              } else if (widget.tipe == "5") {
                if (_akteCerai != null) {
                  setState(() {
                    _valAkteCerai = true;
                  });
                  if (_lunasPbb2 != null) {
                    setState(() {
                      _valLunasPbb2 = true;
                    });
                    if (_skks != null) {
                      setState(() {
                        _valskks = true;
                      });
                      prosesData(context);
                    } else {
                      setState(() {
                        _valskks = false;
                      });
                    }
                  } else {
                    setState(() {
                      _valLunasPbb2 = false;
                    });
                  }
                } else {
                  setState(() {
                    _valAkteCerai = false;
                  });
                }
              } else if (widget.tipe == "6") {
                prosesData(context);
              } else if (widget.tipe == "7") {
                if (_skksdrs != null) {
                  setState(() {
                    _valskkdrs = true;
                  });
                  prosesData(context);
                } else {
                  setState(() {
                    _valskkdrs = false;
                  });
                }
              } else if (widget.tipe == "8") {
                if (_skck != null) {
                  setState(() {
                    _valskck = true;
                  });
                  prosesData(context);
                } else {
                  setState(() {
                    _valskck = false;
                  });
                }
              } else if (widget.tipe == "15") {
                prosesData(context);
              }
              //
              //
            } else {
              setState(() {
                _valrtText = false;
              });
            }
          } else {
            setState(() {
              _valrwText = false;
            });
          }
        } else {
          setState(() {
            _valKkImage = false;
          });
        }
      } else {
        setState(() {
          _valKtpImage = false;
        });
      }
    } else {
      setState(() {
        _validateKeterangan = false;
      });
    }
  }
}
