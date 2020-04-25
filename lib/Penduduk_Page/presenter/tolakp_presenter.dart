import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_letter/main.dart';

class TolakpPresenter {
  TolakpPresenter() {}

  Future<List<Map<String, dynamic>>> getTolakSurat() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var url = "${MyApp.route}/api/penduduk/getAllDataTolak";
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
