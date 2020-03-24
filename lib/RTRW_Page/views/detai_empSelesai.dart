import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_letter/RTRW_Page/presenter/detailEmployeeSelesai_presenter.dart';
import 'package:submission_letter/RTRW_Page/viewmodel/detaiempSelesai_viewmodel.dart';
import 'package:submission_letter/RTRW_Page/views/home_emp.dart';
import 'package:submission_letter/Theme/theme_emp.dart';
import 'package:submission_letter/Util/util_auth.dart';

class DetailEmpSelesai extends StatefulWidget {
  String idJobPos;
  String idSurat;
  String namaPenduduk;
  String tanggal;
  String tipe;

  DetailEmpSelesai(
      {this.idJobPos,
      this.idSurat,
      this.namaPenduduk,
      this.tanggal,
      this.tipe});
  @override
  _DetailEmpSelesaiState createState() => _DetailEmpSelesaiState();
}

class _DetailEmpSelesaiState extends State<DetailEmpSelesai> {
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
      String keterangan, String rtrwText, String noSuratRT, String noSuratRW) {
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
              ])),
          Divider(
            color: Colors.orange,
            thickness: 2,
          ),
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                "Pengajuan Surat Keterangan Miskin",
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
            height: 5,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: <Widget>[
                Text(
                  "No Surat RT: ",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  noSuratRT != null ? "$noSuratRT" : "",
                  style: TextStyle(fontSize: 15),
                )
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: <Widget>[
                Text(
                  "No Surat RW:",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  noSuratRW != null ? "$noSuratRW" : "",
                  style: TextStyle(fontSize: 15),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<DetailEmpSelesaiViewModel> _getDetailSurat() async {
    DetailEmpSelesaiPresenter presentesrs = new DetailEmpSelesaiPresenter();
    var response =
        presentesrs.getAllDetailSelesai(widget.idJobPos, widget.idSurat);
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
            if (snapshot.hasData) {
              return _detailWidget(
                  snapshot.data.keterangan,
                  snapshot.data.rtrwText,
                  snapshot.data.noSuratRT,
                  snapshot.data.noSuratRW);
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
