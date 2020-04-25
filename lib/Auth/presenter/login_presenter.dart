import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:submission_letter/main.dart';

class LoginPresenter {
  LoginPresenter() {}

  Future<Response> loginProcess(
      String username, String password, String tokens) async {
    var url = "${MyApp.route}/api/logins";
    Dio dio = new Dio();

    FormData formData = new FormData.fromMap(
        {"Ussername": username, "password": password, "tokens": tokens});

    var response = await dio.post(url, data: formData);
    return response;
  }
}
