import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_letter/main.dart';

class SelesaiPresenter {
  SelesaiPresenter() {}

  Future<List<Map<String, dynamic>>> getAllSelesai() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var url = "${MyApp.route}/api/rtrw/getAllDataSelesai";
    var listSurat = <Map<String, dynamic>>[];

    // Disini Nanti Dikasih If Else untuk membedakan step antara rw = 2 dan rt = 1

    Dio dio = new Dio();
    FormData formData;
    var tipeJobPos = preferences.getInt("IdJobPos");
    if (tipeJobPos > 13) {
      formData = new FormData.fromMap({
        "id": preferences.getInt("Id"),
        "email": preferences.getString("Email")
      });
    } else {
      formData = new FormData.fromMap({
        "id": preferences.getInt("Id"),
        "email": preferences.getString("Email")
      });
    }

    var response = await dio.post(url, data: formData);
    var arrData = response.data['data'];
    for (var i = 0; i < arrData.length; i++) {
      listSurat.add(arrData[i]);
    }
    return listSurat;
  }

  Future<List<Map<String, dynamic>>> findDataSelesaiApi(
      String keyword, String tipe, int idUser) async {
    var url = "${MyApp.route}/api/rtrw/findDataSuratSelesai";
    var listSurat = <Map<String, dynamic>>[];

    Dio dio = new Dio();
    FormData formData;
    formData = new FormData.fromMap({
      // "idUser": preferences.getInt("Id"),
      "idUser": "$idUser",
      "data": keyword,
      "tipe": tipe,
    });
    var response = await dio.post(url, data: formData);
    var arrData = response.data['data'];
    if (response.data['data'] != null) {
      for (var i = 0; i < arrData.length; i++) {
        listSurat.add(arrData[i]);
      }
    }

    return listSurat;
  }
}
