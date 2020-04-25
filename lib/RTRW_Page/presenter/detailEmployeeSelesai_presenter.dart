import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:submission_letter/RTRW_Page/viewmodel/detaiempSelesai_viewmodel.dart';
import 'package:submission_letter/main.dart';

class DetailEmpSelesaiPresenter {
  DetailEmpSelesaiPresenter() {}

  Future<DetailEmpSelesaiViewModel> getAllDetailSelesai(
      String idJobPos, String idSurat) async {
    var url = "${MyApp.route}/api/rtrw/getDetailSuratSelesai";
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
    viewModel.nama = response.data['data']['nama'];
    viewModel.jk = response.data['data']['jk'];
    viewModel.ttl = response.data['data']['ttl'];
    viewModel.ktp = response.data['data']['ktp'];
    viewModel.kk = response.data['data']['kk'];
    viewModel.pendidikan = response.data['data']['pendidikan'];
    viewModel.agama = response.data['data']['agama'];
    viewModel.alamat = response.data['data']['alamat'];

    return viewModel;
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  Future<String> download(String idSurat, String berkas) async {
    Dio dio = new Dio();
    var urlDownload = "${MyApp.route}/api/rtrw/download";
    FormData formData = new FormData.fromMap({
      "idSurat": idSurat,
      "berkas": berkas,
    });
    try {
      Response response = await dio.post(
        urlDownload,
        data: formData,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
      );
      print(response.headers);
      var arr = response.headers['content-disposition'][0];
      var namaFile = arr.split("=");

      var tempDir = await getExternalStorageDirectory();
      var namaDirectory = tempDir.path + "/${namaFile[1]}";
      print(namaDirectory);
      File file = File(tempDir.path + "/${namaFile[1]}");
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
      return namaDirectory;
    } catch (e) {
      print(e);
    }
  }

  Future<String> getSignatureRT() async {
    var url = "${MyApp.route}/api/rtrw/getSignatureRT";

    Dio dio = new Dio();

    var response = await dio.get(url);
    // var base = Base64Decoder().convert(response.data['data']);
    return response.data['data'];
  }

  Future<String> getSignatureRW() async {
    var url = "${MyApp.route}/api/rtrw/getSignatureRW";

    Dio dio = new Dio();

    var response = await dio.get(url);
    // var base = Base64Decoder().convert(response.data['data']);
    return response.data['data'];
  }
}
