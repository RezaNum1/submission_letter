import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:submission_letter/Util/util_auth.dart';

class ForgetPasswordPresenter {
  ForgetPasswordPresenter() {}

  Future<Response> forgetProcess(String emailUser, String noTeleponUser) async {
    var url = 'http://192.168.43.75:8000/api/forgetPassword';

    Dio dio = new Dio();

    FormData formData = new FormData.fromMap({
      "email": emailUser,
      "phone": noTeleponUser,
    });

    var response = await dio.post(url, data: formData);

    if (response.data['error'] == true) {
      return response;
    } else {
      UtilAuth.emails(response.data['data']['email'],
          response.data['data']['username'], response.data['data']['password']);
      return response;
    }
  }
}
