import 'package:dio/dio.dart';
import 'package:submission_letter/RTRW_Page/viewmodel/detaiempSelesai_viewmodel.dart';

class DetailEmpSelesaiPresenter {
  DetailEmpSelesaiPresenter() {}

  Future<DetailEmpSelesaiViewModel> getAllDetailSelesai(
      String idJobPos, String idSurat) async {
    var url = "http://192.168.43.75:8000/api/rtrw/getDetailSuratSelesai";
    Dio dio = new Dio();
    FormData formData = new FormData.fromMap({
      "idJobPos": idJobPos,
      "idSurat": idSurat,
    });

    var response = await dio.post(url, data: formData);
    DetailEmpSelesaiViewModel viewModel = new DetailEmpSelesaiViewModel();
    viewModel.keterangan = response.data['data']['Ket'];
    viewModel.rtrwText = response.data['data']['RTRWText'];
    viewModel.noSuratRT = response.data['data']['noSuratRT'];
    viewModel.noSuratRW = response.data['data']['noSuratRW'];
    viewModel.dataHistory = response.data['data']['history'];
    return viewModel;
  }
}
