import 'package:dio/dio.dart';
import 'package:submission_letter/main.dart';

class SettingPresenter {
  SettingPresenter() {}

  Future<Response> changeMyPassword(
      int id, String oldPassword, String newPassword) async {
    var url = '${MyApp.route}/api/changePassword';

    Dio dio = new Dio();

    FormData formData = new FormData.fromMap(
        {"id": id, "oldPass": oldPassword, "newPass": newPassword});

    var response = await dio.post(url, data: formData);

    return response;
  }
}
