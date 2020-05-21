import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_letter/RTRW_Page/presenter/surat_kelurahan_presenter.dart';
import 'package:submission_letter/RTRW_Page/viewmodel/detailSuratKelurahan_viewmodel.dart';
import 'package:submission_letter/RTRW_Page/views/home_emp.dart';
import 'package:submission_letter/RTRW_Page/widget/surat_kelurahan_report.dart';
import 'package:submission_letter/Theme/theme_emp.dart';
import 'package:submission_letter/Util/util_auth.dart';
import 'package:submission_letter/Util/util_rtrw.dart';

class DetailSuratKelurahan extends StatefulWidget {
  String idSurat;
  DetailSuratKelurahan({this.idSurat});
  @override
  _DetailSuratKelurahanState createState() => _DetailSuratKelurahanState();
}

class _DetailSuratKelurahanState extends State<DetailSuratKelurahan> {
  String nama;
  String jabatanText;
  int id;

  @override
  void initState() {
    setPreference();
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  Future<void> setPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      nama = pref.getString('Nama');
      jabatanText = pref.getString('Jabatan');
      id = pref.getInt("Id");
    });
  }

  Widget _detailWidget(
      String bodySurat,
      String noSuratKelurahan,
      String keterangan,
      String tanggal,
      String lurah,
      List<dynamic> listKepada,
      List<dynamic> listTembusan) {
    print(listTembusan);
    double widthScreen = MediaQuery.of(context).size.width;
    return Container(
      child: ListView(
        children: <Widget>[
          Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Row(children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: RaisedButton(
                    color: Colors.red,
                    child: Text(
                      "Kembali",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      UtilAuth.movePage(context, HomeEmp());
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: RaisedButton(
                    color: Colors.blue,
                    child: Text(
                      "Preview & Download Surat",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10),
                    ),
                    onPressed: () {
                      suratKelurahanReportView(
                          context,
                          bodySurat,
                          noSuratKelurahan,
                          keterangan,
                          tanggal,
                          lurah,
                          listKepada,
                          listTembusan,
                          widthScreen);
                    },
                  ),
                ),
              ])),
          Divider(
            color: Colors.orange,
            thickness: 2,
          ),
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                "SURAT KELURAHAN",
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
            child: Center(
              child: AutoSizeText(
                "INFOMRASI DETAIL",
                style: TextStyle(
                    fontSize: 18.0,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 15,
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
                  margin: EdgeInsets.only(left: 20),
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
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Tanggal: ",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Text(
                    "$tanggal",
                    style: TextStyle(fontSize: 15),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "No Surat: ",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Text(
                    "$noSuratKelurahan",
                    style: TextStyle(fontSize: 15),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Kepala Kelurahan :",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Text(
                    '$lurah',
                    style: TextStyle(fontSize: 15),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Kepada :",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                for (var i = 0; i < listKepada.length; i++)
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      '${listKepada[i]}',
                      style: TextStyle(fontSize: 15),
                    ),
                  )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Tembusan :",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                for (var i = 0; i < listTembusan.length; i++)
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      '${listTembusan[i]}',
                      style: TextStyle(fontSize: 15),
                    ),
                  )
              ],
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Divider(
            color: Colors.orange,
            thickness: 2,
          ),
          SizedBox(
            height: 20,
          ),
          Divider(
            color: Colors.orange,
            thickness: 2,
          ),
        ],
      ),
    );
  }

  Future<DetailSuratKelurahanViewModel> _getDetailSurat() async {
    SuratKelurahanPresenter presentesrs = new SuratKelurahanPresenter();
    var response = presentesrs.getDetailSuratKelurahan(widget.idSurat);
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
        drawer:
            ThemeApp.sideBar(context, nama.toString(), jabatanText.toString()),
        body: Container(
          child: FutureBuilder(
            future: _getDetailSurat(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData == true) {
                return _detailWidget(
                  snapshot.data.bodySurat,
                  snapshot.data.noSuratKelurahan,
                  snapshot.data.keterangan,
                  UtilRTRW.convertDateTime(snapshot.data.tanggal),
                  snapshot.data.lurah,
                  snapshot.data.listKepada,
                  snapshot.data.listTembusan,
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
        ));
  }
}
