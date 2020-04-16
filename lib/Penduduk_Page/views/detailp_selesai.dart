import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_letter/Penduduk_Page/presenter/detailp_selesai_presenter.dart';
import 'package:submission_letter/Penduduk_Page/viewmodel/detailp_selesai_viewmodel.dart';
import 'package:submission_letter/Penduduk_Page/widget/report_view_penduduk.dart';
import 'package:submission_letter/RTRW_Page/widget/report_view.dart';
import 'package:submission_letter/Theme/theme_penduduk.dart';
import 'package:submission_letter/Util/util_auth.dart';
import 'package:submission_letter/Util/util_rtrw.dart';

class DetailpSelesai extends StatefulWidget {
  String idSurat;
  String tipe;

  DetailpSelesai({this.idSurat, this.tipe});
  @override
  _DetailpSelesaiState createState() => _DetailpSelesaiState();
}

class _DetailpSelesaiState extends State<DetailpSelesai> {
  int idUser;
  String noTelepon;
  String nik;

  @override
  void initState() {
    setPreference();
    super.initState();
  }

  Future<void> setPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      idUser = pref.getInt("id");
      noTelepon = pref.getString("NoTelepon");
      nik = pref.getString("Nik");
    });
  }

  void dispose() {
    super.dispose();
  }

  Widget _detailWidget(
      String keterangan,
      String rtrwText,
      String noPengajuan,
      String tglBuat,
      String nama,
      String jk,
      String ttl,
      String ktp,
      String agama,
      String alamat,
      String pekerajaan,
      String body,
      int nosk) {
    String judulDetail;
    String tglConv = UtilRTRW.convertDateTime(tglBuat);
    if (widget.tipe == "1") {
      judulDetail = "Pengajuan Surat Keterangan Tidak Mampu";
    } else if (widget.tipe == "2") {
      judulDetail = "Pengajuan Surat Keterangan Usaha";
    } else if (widget.tipe == "3") {
      judulDetail = "Pengajuan Surat Pengantar Izin Keramaian";
    } else if (widget.tipe == "4") {
      judulDetail = "Pengajuan Surat Keterangan Belum Menikah";
    } else if (widget.tipe == "5") {
      judulDetail = "Pengajuan Surat Keterangan Cerai Hidup / Mati";
    } else if (widget.tipe == "6") {
      judulDetail = "Pengajuan Surat Keterangan Domisili";
    } else if (widget.tipe == "7") {
      judulDetail = "Pengajuan Surat Keterangan Kematian";
    } else if (widget.tipe == "8") {
      judulDetail = "Pengajuan Surat Keterangan Pindah";
    }
    return Container(
      child: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: <Widget>[],
            ),
          ),
          Divider(
            color: Colors.orange,
            thickness: 2,
          ),
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                "$judulDetail",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                    fontSize: 20),
              ),
            ),
          ),
          Divider(
            color: Colors.orange,
            thickness: 2,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Keterangan: ",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Container(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 300.0,
                      maxWidth: 300.0,
                      minHeight: 30.0,
                      maxHeight: 100.0,
                    ),
                    child: AutoSizeText(
                      "$keterangan",
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "No Pengajuan: ",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  "$noPengajuan",
                  style: TextStyle(fontSize: 15),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Tanggal Pengajuan: ",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${UtilRTRW.convertDateTime(tglBuat)}",
                  style: TextStyle(fontSize: 15),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "RT/RW: ",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  "$rtrwText",
                  style: TextStyle(fontSize: 15),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            color: Colors.orange[200],
            thickness: 3,
          ),
          Container(
            margin: EdgeInsets.only(left: 10, top: 20, bottom: 10),
            child: Text(
              "Surat Keterangan",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(
            color: Colors.orange[200],
            thickness: 3,
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
                "Akses Surat Keterangan Dengan Menekan Tombol Di Bawah:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            child: RaisedButton(
                child: Text(
                  "Preview & Download Surat Keterangan",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                textColor: Colors.white,
                color: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.orange),
                ),
                onPressed: () {
                  reportViewPenduduk(context, nama, ttl, jk, agama, ktp, alamat,
                      pekerajaan, body, tglConv, nosk);
                }),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  Future<DetailpSelesaiViewModel> _getDetailSurat() async {
    DetailPSelesaiPresenter presentesrs = new DetailPSelesaiPresenter();
    var response = await presentesrs.getDetailDataSuratPenduduk(widget.idSurat);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Container(
          margin: EdgeInsets.only(right: 50),
          height: 50,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/dki.png'),
            ),
          ),
        ),
      ),
      drawer: ThemeAppPenduduk.sideBar(context, nik, noTelepon),
      body: Container(
        child: FutureBuilder(
          future: _getDetailSurat(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return _detailWidget(
                  snapshot.data.keterangan,
                  snapshot.data.rtrw,
                  snapshot.data.noPengajuan,
                  snapshot.data.tglBuat,
                  snapshot.data.nama,
                  snapshot.data.jk,
                  snapshot.data.ttl,
                  snapshot.data.ktp,
                  snapshot.data.agama,
                  snapshot.data.alamat,
                  snapshot.data.pekerjaan,
                  snapshot.data.body,
                  snapshot.data.nosk);
            } else {
              return Container(
                child: Center(
                  child: Text('Loading...'),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
