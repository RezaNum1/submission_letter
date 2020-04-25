import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TolakpPresenter {
  TolakpPresenter() {}

  Future<List<Map<String, dynamic>>> getTolakSurat() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var url = "http://192.168.1.106:8000/api/penduduk/getAllDataTolak";
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
}
