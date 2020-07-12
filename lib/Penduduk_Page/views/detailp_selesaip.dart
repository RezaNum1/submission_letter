import 'dart:convert';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_letter/Penduduk_Page/presenter/detailp_selesai_presenter.dart';
import 'package:submission_letter/Penduduk_Page/viewmodel/detailp_selesai_viewmodel.dart';
import 'package:submission_letter/Penduduk_Page/viewmodel/detailp_selesaip_viewmodel.dart';
import 'package:submission_letter/Penduduk_Page/widget/report_view_penduduk.dart';
import 'package:submission_letter/RTRW_Page/presenter/detailEmployeeSelesai_presenter.dart';
import 'package:submission_letter/RTRW_Page/widget/report_view.dart';
import 'package:submission_letter/Theme/theme_penduduk.dart';
import 'package:submission_letter/Util/util_auth.dart';
import 'package:submission_letter/Util/util_rtrw.dart';

class DetailpSelesaiPenghantar extends StatefulWidget {
  String idSurat;
  String tipe;

  DetailpSelesaiPenghantar({this.idSurat, this.tipe});
  @override
  _DetailpSelesaiPenghantarState createState() =>
      _DetailpSelesaiPenghantarState();
}

class _DetailpSelesaiPenghantarState extends State<DetailpSelesaiPenghantar> {
  int idUser;
  String noTelepon;
  String nik;

  String sign1;
  String sign2;

  bool prosesInit = false;

  @override
  void initState() {
    setPreference();
    getAllSign();
    super.initState();
  }

  Future<void> getAllSign() async {
    DetailEmpSelesaiPresenter presenter = new DetailEmpSelesaiPresenter();
    var milRT = await presenter.getSignatureRT();
    var milRW = await presenter.getSignatureRW();

    setState(() {
      sign1 = milRT;
      sign2 = milRW;
      prosesInit = true;
    });
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
      String noSuratRT,
      String noSuratRW,
      String tglBuat,
      String noPengajuan,
      List history,
      List namaFile,
      String nama,
      String jk,
      String ttl,
      String pekerjaan,
      String ktp,
      String kk,
      String pendidikan,
      String agama,
      String alamat) {
    String judulDetail;
    double height = MediaQuery.of(context).size.height;
    double fontSizes = height == 716 ? 13 : 15;
    double titleSizes = height == 716 ? 18 : 20;
    double tinySizes = height == 716 ? 10 : 13;
    String tglConv = UtilRTRW.convertDateTime(tglBuat);

    judulDetail = "Pengajuan Surat Penghantar RT&RW";

    var arrSplit = rtrwText.split("/");
    var rtText = arrSplit[0].split(" ");
    var rwText = arrSplit[1].split(" ");
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
                  style: TextStyle(
                      fontSize: fontSizes, fontWeight: FontWeight.bold),
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
                      style: TextStyle(fontSize: fontSizes),
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
                  style: TextStyle(
                      fontSize: fontSizes, fontWeight: FontWeight.bold),
                ),
                Text(
                  "$noPengajuan",
                  style: TextStyle(fontSize: fontSizes),
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
                  style: TextStyle(
                      fontSize: fontSizes, fontWeight: FontWeight.bold),
                ),
                Text(
                  "$tglConv",
                  style: TextStyle(fontSize: fontSizes),
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
                  style: TextStyle(
                      fontSize: fontSizes, fontWeight: FontWeight.bold),
                ),
                Text(
                  "$rtrwText",
                  style: TextStyle(fontSize: fontSizes),
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
              style:
                  TextStyle(fontSize: titleSizes, fontWeight: FontWeight.bold),
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
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: tinySizes)),
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
                  style: TextStyle(fontSize: titleSizes),
                ),
                textColor: Colors.white,
                color: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.orange),
                ),
                onPressed: () {
                  Uint8List docRT = Base64Decoder().convert(sign1);

                  Uint8List docRW = Base64Decoder().convert(sign2);
                  reportView(
                      context,
                      nama,
                      jk,
                      ttl,
                      pekerjaan,
                      ktp,
                      kk,
                      pendidikan,
                      agama,
                      alamat,
                      keterangan,
                      noSuratRT,
                      noSuratRW,
                      rtText[1],
                      rwText[2],
                      tglBuat,
                      docRT,
                      docRW);
                }),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  Future<DetailpSelesaipViewModel> _getDetailSurat() async {
    DetailPSelesaiPresenter presentesrs = new DetailPSelesaiPresenter();
    var response =
        await presentesrs.getDetailDataSuratPendudukPenghantar(widget.idSurat);
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
                snapshot.data.rtrwText,
                snapshot.data.noSuratRT,
                snapshot.data.noSuratRW,
                snapshot.data.tglBuat,
                snapshot.data.noPengajuan,
                snapshot.data.dataHistory,
                snapshot.data.namaFile,
                snapshot.data.nama,
                snapshot.data.jk,
                snapshot.data.ttl,
                snapshot.data.pekerjaan,
                snapshot.data.ktp,
                snapshot.data.kk,
                snapshot.data.pendidikan,
                snapshot.data.agama,
                snapshot.data.alamat,
              );
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
