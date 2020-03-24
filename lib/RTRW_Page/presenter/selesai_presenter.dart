import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelesaiPresenter {
  SelesaiPresenter() {}

  Future<List<Map<String, dynamic>>> getAllSelesai() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var url = "http://192.168.43.75:8000/api/rtrw/getAllDataSelesai";
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
}
