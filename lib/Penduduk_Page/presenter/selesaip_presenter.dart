import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_letter/main.dart';

class SelesaipPresenter {
  SelesaipPresenter() {}

  Future<List<Map<String, dynamic>>> getSelesaiSurat() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var url = "${MyApp.route}/api/penduduk/getAllDataSelesai";
    var listSurat = <Map<String, dynamic>>[];

    Dio dio = new Dio();
    FormData formData;
    formData = new FormData.fromMap({
      "id": preferences.getInt("Id"),
    });
    var response = await dio.post(url, data: formData);
    var allData = response.data['data'];

    for (var i = 0; i < allData.length; i++) {
      listSurat.add(allData[i]);
    }

    return listSurat;
  }

  Future<List<Map<String, dynamic>>> findDataSelesaiApiPenduduk(
      String keyword, String tipe, int idPenduduk) async {
    var url = "${MyApp.route}/api/penduduk/findAllDataSelesaiAnd";
    var listSurat = <Map<String, dynamic>>[];

    Dio dio = new Dio();
    FormData formData;
    formData = new FormData.fromMap({
      // "idUser": preferences.getInt("Id"),
      "idPenduduk": "$idPenduduk",
      "data": keyword,
      "tipe": tipe,
    });
    var response = await dio.post(url, data: formData);
    var arrData = response.data['data'];
    for (var i = 0; i < arrData.length; i++) {
      listSurat.add(arrData[i]);
    }
    return listSurat;
  }
}
