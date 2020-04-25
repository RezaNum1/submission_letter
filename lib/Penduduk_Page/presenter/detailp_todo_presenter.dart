import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_letter/Penduduk_Page/viewmodel/detailp_todo_viewmodel.dart';
import 'package:submission_letter/main.dart';

class DetailpTodoPresenter {
  DetailpTodoPresenter() {}

  Future<DetailpTodoViewModel> getDetailDataSuratPenduduk(
      String idSurat) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var idUser = preferences.getInt("Id");
    var url = "${MyApp.route}/api/penduduk/getDetailSuratTodo";
    Dio dio = new Dio();
    FormData formData = new FormData.fromMap({
      "idUser": idUser,
      "idSurat": idSurat,
    });

    var response = await dio.post(url, data: formData);
    DetailpTodoViewModel detailpTodoViewModel = new DetailpTodoViewModel();
    detailpTodoViewModel.keterangan = response.data['data']['ket'];
    detailpTodoViewModel.rtrw = response.data['data']['rtrwText'];
    detailpTodoViewModel.noPengajuan = response.data['data']['noPengajuan'];
    detailpTodoViewModel.tglBuat = response.data['data']['tglBuat'];
    detailpTodoViewModel.noSuratRt = response.data['data']['noSuratRt'];
    detailpTodoViewModel.noSuratRw = response.data['data']['noSuratRw'];
    detailpTodoViewModel.dataHistory = response.data['data']['history'];
    return detailpTodoViewModel;
  }
}
