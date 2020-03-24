import 'package:dio/dio.dart';
import 'package:submission_letter/Notification/widget_function/messaging_widget.dart';
import 'package:submission_letter/RTRW_Page/viewmodel/detailemp_viewmodel.dart';

class DetailEmployeePresenter {
  DetailEmployeePresenter() {}

  Future<DetailEmpViewModel> getDetailDataSurat(
      String idApprover, String idSurat) async {
    var url = "http://192.168.43.75:8000/api/rtrw/getDetailSurat";
    Dio dio = new Dio();
    FormData formData = new FormData.fromMap({
      "idApprover": idApprover,
      "idSurat": idSurat,
    });

    var response = await dio.post(url, data: formData);
    DetailEmpViewModel detailEmpViewModel = new DetailEmpViewModel();
    detailEmpViewModel.keterangan = response.data['data']['Ket'];
    detailEmpViewModel.rtrw = response.data['data']['RTRWText'];
    detailEmpViewModel.noSuratRt = response.data['data']['noSuratRT'];
    detailEmpViewModel.noSuratRw = response.data['data']['noSuratRW'];
    return detailEmpViewModel;
  }

  Future<Response> approveSurat(
      String idSurat, int id, String keterangan, String komentar) async {
    var url = "http://192.168.43.75:8000/api/rtrw/approveSurat";
    Dio dio = new Dio();
    FormData formData = new FormData.fromMap({
      "idSurat": idSurat,
      "idUser": id.toString(),
      "keterangan": keterangan.toString(),
      "komentar": komentar.toString(),
    });
    var response = await dio.post(url, data: formData);

    return response;
  }

  Future<String> tolakSurat(String idSurat) async {
    var url = "http://192.168.43.75:8000/api/rtrw/tolakSurat";
    Dio dio = new Dio();
    FormData formData = new FormData.fromMap({
      "idSurat": idSurat,
    });
    var response = await dio.post(url, data: formData);

    return response.data['message'];
  }
}
