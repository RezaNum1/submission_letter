import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_letter/Penduduk_Page/viewmodel/detailp_selesai_viewmodel.dart';

class DetailPSelesaiPresenter {
  DetailPSelesaiPresenter() {}

  Future<DetailpSelesaiViewModel> getDetailDataSuratPenduduk(
      String idSurat) async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // var idUser = preferences.getInt("Id");
    var url = "http://192.168.43.75:8000/api/penduduk/getDetailSuratSel";
    Dio dio = new Dio();
    FormData formData = new FormData.fromMap({
      "idSurat": idSurat,
    });

    var response = await dio.post(url, data: formData);
    DetailpSelesaiViewModel detailpSelesaiViewModel =
        new DetailpSelesaiViewModel();
    detailpSelesaiViewModel.keterangan = response.data['data']['ket'];
    detailpSelesaiViewModel.rtrw = response.data['data']['rtrwText'];
    detailpSelesaiViewModel.noPengajuan = response.data['data']['noPengajuan'];
    detailpSelesaiViewModel.tglBuat = response.data['data']['tglBuat'];

    detailpSelesaiViewModel.nama = response.data['data']['nama'];
    detailpSelesaiViewModel.jk = response.data['data']['jk'];
    detailpSelesaiViewModel.ttl = response.data['data']['ttl'];
    detailpSelesaiViewModel.ktp = response.data['data']['ktp'];
    detailpSelesaiViewModel.agama = response.data['data']['agama'];
    detailpSelesaiViewModel.alamat = response.data['data']['alamat'];
    detailpSelesaiViewModel.pekerjaan = response.data['data']['pekerjaan'];
    detailpSelesaiViewModel.body = response.data['data']['body'];
    detailpSelesaiViewModel.nosk = response.data['data']['nosk'];

    return detailpSelesaiViewModel;
  }
}
