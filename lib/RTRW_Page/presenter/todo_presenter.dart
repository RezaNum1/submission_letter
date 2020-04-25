import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TODOPresenter {
  TODOPresenter() {}

  // List<Map<String, dynamic>> getAllDatas() {
  //   var listSurat = <Map<String, dynamic>>[];
  //   Map<String, dynamic> mapData = {
  //     "id": 1,
  //     "tipe": 1,
  //     "nama": "Jhon Doe",
  //     "tanggal": "14/02/2020"
  //   };
  //   listSurat.add(mapData);
  //   print("success1");
  //   return listSurat;
  // }

  Future<List<Map<String, dynamic>>> getAll() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var url = "http://192.168.1.106:8000/api/rtrw/getAllData";
    var listSurat = <Map<String, dynamic>>[];

    // Disini Nanti Dikasih If Else untuk membedakan step antara rw = 2 dan rt = 1

    Dio dio = new Dio();
    FormData formData;
    var tipeJobPos = preferences.getInt("IdJobPos");
    if (tipeJobPos > 13) {
      formData = new FormData.fromMap({
        "id": preferences.getInt("Id"),
        "step": 1,
        "email": preferences.getString("Email")
      });
    } else {
      formData = new FormData.fromMap({
        "id": preferences.getInt("Id"),
        "step": 2,
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
