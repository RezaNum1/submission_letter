import 'package:dio/dio.dart';

class SettingPresenter {
  SettingPresenter() {}

  Future<Response> changeMyPassword(
      int id, String oldPassword, String newPassword) async {
    var url = 'http://192.168.43.75:8000/api/changePassword';

    Dio dio = new Dio();

    FormData formData = new FormData.fromMap(
        {"id": id, "oldPass": oldPassword, "newPass": newPassword});

    var response = await dio.post(url, data: formData);

    return response;
  }
}
