import 'package:dio/dio.dart';

class UserAuthPresenter {
  UserAuthPresenter() {}

  Future<Response> cekPhoneNumber(String phoneNum, String token) async {
    var url = "http://192.168.43.75:8000/api/cekPhoneNumber";
    Dio dio = new Dio();

    FormData formData = new FormData.fromMap({
      "noTelepon": phoneNum,
      "token": token,
    });

    var response = await dio.post(url, data: formData);
    return response;
  }

  Future<Response> regisData(String phone, String nik, String tokens) async {
    var url = "http://192.168.43.75:8000/api/resgisPenduduk";
    Dio dio = new Dio();

    FormData formData = new FormData.fromMap({
      "noTelepon": phone,
      "nik": nik,
      "token": tokens,
    });

    var response = await dio.post(url, data: formData);
    return response;
  }
}
