import 'package:dio/dio.dart';
import 'dart:math' as math;

import 'package:submission_letter/main.dart';

class UserAuthPresenter {
  UserAuthPresenter() {}

  Future<Response> cekPhoneNumber(String phoneNum, String token) async {
    var url = "${MyApp.route}/api/cekPhoneNumber";
    Dio dio = new Dio();

    FormData formData = new FormData.fromMap({
      "noTelepon": phoneNum,
      "token": token,
    });

    var response = await dio.post(url, data: formData);
    return response;
  }

  Future<Response> regisData(String phone, String nik, String tokens) async {
    var url = "${MyApp.route}/api/resgisPenduduk";
    Dio dio = new Dio();

    FormData formData = new FormData.fromMap({
      "noTelepon": phone,
      "nik": nik,
      "token": tokens,
    });

    var response = await dio.post(url, data: formData);
    return response;
  }

  Future<String> generateOTP() async {
    var rnd = new math.Random();
    int randoms = rnd.nextInt(1000000) + 10000;
    var otp = randoms.toString();

    //Simpan dulu
    var url =
        'https://rest.nexmo.com/sms/json?api_key=74d5af9d&api_secret=IMP5chxxcpNhBFOx&to=6285156473893&from="Pengajuan Surat"&text="Kode Aktivasi Anda: $otp. Jangan Berikan Kesiapapun"';
    Dio dio = new Dio();
    var response = await dio.post(url);
    return otp;
  }
}
