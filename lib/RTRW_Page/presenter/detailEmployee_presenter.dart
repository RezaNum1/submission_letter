import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:submission_letter/Notification/widget_function/messaging_widget.dart';
import 'package:submission_letter/RTRW_Page/viewmodel/detailemp_viewmodel.dart';
import 'package:submission_letter/main.dart';

class DetailEmployeePresenter {
  DetailEmployeePresenter() {}

  Future<DetailEmpViewModel> getDetailDataSurat(
      String idApprover, String idSurat) async {
    var url = "${MyApp.route}/api/rtrw/getDetailSurat";
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
    detailEmpViewModel.dataHistory = response.data['data']['history'];
    detailEmpViewModel.namaFile = response.data['data']['namaFile'];
    return detailEmpViewModel;
  }

  Future<Response> approveSurat(
      String idSurat, int id, String keterangan, String komentar) async {
    var url = "${MyApp.route}/api/rtrw/approveSurat";
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

  Future<Response> tolakSurat(String idSurat, int id, String komentar) async {
    var url = "${MyApp.route}/api/rtrw/tolakSurat";
    Dio dio = new Dio();
    FormData formData = new FormData.fromMap({
      "idSurat": idSurat,
      "idUser": id,
      "komentar": komentar,
    });
    var response = await dio.post(url, data: formData);

    return response;
  }

  Future<List<dynamic>> callFileToServer(String berkas, String idSurat) async {
    var url = "${MyApp.route}/api/rtrw/callFile";

    Dio dio = new Dio();

    FormData formData = new FormData.fromMap({
      "berkas": berkas,
      "idSurat": idSurat,
    });

    var response = await dio.post(url, data: formData);
    var base = Base64Decoder().convert(response.data['data']);
    var tipe = response.data['tipe'];
    var arrays = [tipe, base];
    return arrays;
  }
}
