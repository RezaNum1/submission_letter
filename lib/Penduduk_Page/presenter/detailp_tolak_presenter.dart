import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_letter/Penduduk_Page/viewmodel/detailp_tolak_viewmodel.dart';

class DetailpTolakPresenter {
  DetailpTolakPresenter() {}

  Future<DetailpTolakViewModel> getDetailDataSuratTolakPenduduk(
      String idSurat) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var idUser = preferences.getInt("Id");
    var url = "http://192.168.43.75:8000/api/penduduk/getDetailSuratTolak";
    Dio dio = new Dio();
    FormData formData = new FormData.fromMap({
      "idUser": idUser,
      "idSurat": idSurat,
    });

    var response = await dio.post(url, data: formData);
    DetailpTolakViewModel detailpTolakViewModel = new DetailpTolakViewModel();
    detailpTolakViewModel.keterangan = response.data['data']['ket'];
    detailpTolakViewModel.rtrw = response.data['data']['rtrwText'];
    detailpTolakViewModel.noPengajuan = response.data['data']['noPengajuan'];
    detailpTolakViewModel.tglBuat = response.data['data']['tglBuat'];
    detailpTolakViewModel.noSuratRt = response.data['data']['noSuratRt'];
    detailpTolakViewModel.noSuratRw = response.data['data']['noSuratRw'];
    detailpTolakViewModel.dataHistory = response.data['data']['history'];

    return detailpTolakViewModel;
  }

  Future<Response> perbaikiDataToServer(
      String idSurat, Map<String, dynamic> dataKtp, String dataKK) async {
    var url = "http://192.168.43.75:8000/api/penduduk/perbaikanData";
    Dio dio = new Dio();
    FormData formData = new FormData.fromMap(
        {"idSurat": idSurat, "ktp": dataKtp, "kk": dataKK});

    var response = await dio.post(url, data: formData);
    return response;
  }
}
