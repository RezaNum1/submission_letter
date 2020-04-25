import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

class LoginPresenter {
  LoginPresenter() {}

  Future<Response> loginProcess(
      String username, String password, String tokens) async {
    var url = "http://192.168.1.106:8000/api/logins";
    Dio dio = new Dio();

    FormData formData = new FormData.fromMap(
        {"Ussername": username, "password": password, "tokens": tokens});

    var response = await dio.post(url, data: formData);
    return response;
  }
}
