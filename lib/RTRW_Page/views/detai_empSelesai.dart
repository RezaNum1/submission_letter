import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_letter/RTRW_Page/presenter/detailEmployeeSelesai_presenter.dart';
import 'package:submission_letter/RTRW_Page/viewmodel/detaiempSelesai_viewmodel.dart';
import 'package:submission_letter/RTRW_Page/views/home_emp.dart';
import 'package:submission_letter/RTRW_Page/widget/berkas_widget.dart';
import 'package:submission_letter/RTRW_Page/widget/berkas_widgetd.dart';
import 'package:submission_letter/RTRW_Page/widget/report_view.dart';
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
      String keterangan,
      String rtrwText,
      String noSuratRT,
      String noSuratRW,
      List history,
      List namaFile,
      String nama,
      String jk,
      String ttl,
      String ktp,
      String kk,
      String pendidikan,
      String agama,
      String alamat) {
    String judulDetail;
    var arrSplit = rtrwText.split("/");
    var rtText = arrSplit[0].split(" ");
    var rwText = arrSplit[1].split(" ");
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
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      reportView(
                          context,
                          nama,
                          jk,
                          ttl,
                          ktp,
                          kk,
                          pendidikan,
                          agama,
                          alamat,
                          keterangan,
                          noSuratRT,
                          noSuratRW,
                          rtText[1],
                          rwText[1],
                          widget.tanggal);
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
                "$judulDetail",
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
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
            child: Text(
              "Berkas Pengajuan",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(
            color: Colors.orange[200],
            thickness: 3,
          ),
          BerkasWidgetd(
            namaFile: namaFile,
            tipe: "${widget.tipe}",
            idSurat: widget.idSurat,
          ),
          Container(
            margin: EdgeInsets.only(left: 10, top: 20, bottom: 10),
            child: Text(
              "History Pengajuan",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(
            thickness: 3,
          ),
          DataTable(
            columns: [
              DataColumn(
                  label: Text(
                "Tingkatan",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              )),
              DataColumn(
                label: Text(
                  "Status",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              )
            ],
            rows: [
              for (var i = 0; i < history.length; i++)
                DataRow(
                  cells: [
                    DataCell(Text(
                      history[i]['tingkatan'],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    )),
                    DataCell(
                      history[i]['status'] == 'Setuju'
                          ? Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            )
                          : Icon(Icons.close, color: Colors.red),
                    )
                  ],
                ),
            ],
          ),
          SizedBox(
            height: 20,
          )
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
                snapshot.data.noSuratRW,
                snapshot.data.dataHistory,
                snapshot.data.namaFile,
                snapshot.data.nama,
                snapshot.data.jk,
                snapshot.data.ttl,
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
