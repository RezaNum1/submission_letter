import 'package:dio/dio.dart';

class UserAuthPresenter {
  UserAuthPresenter() {}

  Future<Response> cekPhoneNumber(String phoneNum) async {
    var url = "http://192.168.43.75:8000/api/cekPhoneNumber";
    Dio dio = new Dio();

    FormData formData = new FormData.fromMap({
      "noTelepon": phoneNum,
    });

    var response = await dio.post(url, data: formData);
    return response;
  }
}
