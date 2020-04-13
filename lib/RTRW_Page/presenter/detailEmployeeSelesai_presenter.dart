import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
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

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  Future<String> download(String idSurat, String berkas) async {
    Dio dio = new Dio();
    var urlDownload = "http://192.168.43.75:8000/api/rtrw/download";
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
}
