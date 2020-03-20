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
    var url = "http://192.168.43.75:8000/api/rtrw/getAllData";
    var listSurat = <Map<String, dynamic>>[];

    // Disini Nanti Dikasih If Else untuk membedakan step antara rw = 2 dan rt = 1

    Dio dio = new Dio();
    FormData formData;
    var tipeUser = preferences.getInt("IdJobPos");
    if (tipeUser > 13) {
      formData = new FormData.fromMap(
          {"id": 11, "step": 1, "email": "rezafh19@gmail.com"});
    } else {
      formData = new FormData.fromMap(
          {"id": 2, "step": 2, "email": "delcanosbastian@gmail.com"});
    }

    var response = await dio.post(url, data: formData);
    var arrData = response.data['data'];
    for (var i = 0; i < arrData.length; i++) {
      listSurat.add(arrData[i]);
    }
    return listSurat;
  }
}
