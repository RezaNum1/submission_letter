import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_letter/main.dart';

class SuratKelurahanPresenter {
  SuratKelurahanPresenter() {}
  Future<List<Map<String, dynamic>>> getAll() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var url = "${MyApp.route}/api/rtrw/getAllSuratExternalApi";
    var listSurat = <Map<String, dynamic>>[];

    // Disini Nanti Dikasih If Else untuk membedakan step antara rw = 2 dan rt = 1

    Dio dio = new Dio();

    FormData formData = new FormData.fromMap({
      "idUser": preferences.getInt("Id"),
    });

    var response = await dio.post(url, data: formData);
    var arrData = response.data['data'];
    for (var i = 0; i < arrData.length; i++) {
      listSurat.add(arrData[i]);
    }
    return listSurat;
  }
}
