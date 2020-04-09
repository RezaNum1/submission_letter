import 'dart:io';

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
      String idSurat,
      String tipe,
      Map<String, dynamic> dataKtp,
      String dataKK,
      File ktp,
      File kk,
      File depanRumah,
      File belakangRumah,
      File spptTerbaru,
      File lampiranPer,
      File ktportu1,
      File ktportu2,
      File lunaspbb1,
      File aktecerai,
      File lunaspbb2,
      File skks,
      File skkdrs,
      File skck) async {
    var url = "http://192.168.43.75:8000/api/penduduk/perbaikanData";
    Dio dio = new Dio();
    FormData formData = new FormData.fromMap({
      "idSurat": idSurat,
      "tipe": tipe,
      "ktp": dataKtp,
      "kk": dataKK,
      "ktpImage": ktp != null
          ? await MultipartFile.fromFile(ktp.path, filename: "ktpImage")
          : null,
      "kkImage": kk != null
          ? await MultipartFile.fromFile(kk.path, filename: "kkImage")
          : null,
      "depanRumah": depanRumah != null
          ? await MultipartFile.fromFile(
              depanRumah.path,
              filename: "depanrumah",
            )
          : null,
      "belakangRumah": belakangRumah != null
          ? await MultipartFile.fromFile(
              belakangRumah.path,
              filename: "belakangrumah",
            )
          : null,
      "spptTerbaru": spptTerbaru != null
          ? await MultipartFile.fromFile(
              spptTerbaru.path,
              filename: "spptTerbaru",
            )
          : null,
      "lampiranPer": lampiranPer != null
          ? await MultipartFile.fromFile(
              lampiranPer.path,
              filename: "lampiranPer",
            )
          : null,
      "ktpOrtu1": ktportu1 != null
          ? await MultipartFile.fromFile(
              ktportu1.path,
              filename: "ktportu1",
            )
          : null,
      "ktpOrtu2": ktportu2 != null
          ? await MultipartFile.fromFile(
              ktportu2.path,
              filename: "ktportu2",
            )
          : null,
      "lunaspbb1": lunaspbb1 != null
          ? await MultipartFile.fromFile(
              lunaspbb1.path,
              filename: "lunaspbb1",
            )
          : null,
      "aktecerai": aktecerai != null
          ? await MultipartFile.fromFile(
              aktecerai.path,
              filename: "aktecerai",
            )
          : null,
      "lunaspbb2": lunaspbb2 != null
          ? await MultipartFile.fromFile(
              lunaspbb2.path,
              filename: "lunaspbb2",
            )
          : null,
      "skks": skks != null
          ? await MultipartFile.fromFile(
              skks.path,
              filename: "skks",
            )
          : null,
      "skkdrs": skkdrs != null
          ? await MultipartFile.fromFile(
              skkdrs.path,
              filename: "skkdrs",
            )
          : null,
      "skck": skck != null
          ? await MultipartFile.fromFile(
              skck.path,
              filename: "skck",
            )
          : null,
    });

    var response = await dio.post(url, data: formData);
    return response;
  }
}
