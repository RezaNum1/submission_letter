import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodopPresenter {
  TodopPresenter() {}

  Future<List<Map<String, dynamic>>> getAllTodo(int idUser) async {
    var url = "http://192.168.1.106:8000/api/penduduk/getAllDataTodo";
    var listSurat = <Map<String, dynamic>>[];

    Dio dio = new Dio();
    FormData formData;
    formData = new FormData.fromMap({
      "id": idUser,
    });
    var response = await dio.post(url, data: formData);
    var allData = response.data['data'];

    for (var i = 0; i < allData.length; i++) {
      listSurat.add(allData[i]);
    }

    return listSurat;
  }
}
