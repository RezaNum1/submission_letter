import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_letter/Penduduk_Page/presenter/detailp_todo_presenter.dart';
import 'package:submission_letter/Penduduk_Page/viewmodel/detailp_todo_viewmodel.dart';
import 'package:submission_letter/Theme/theme_penduduk.dart';
import 'package:submission_letter/Util/util_rtrw.dart';

class DetailpTodo extends StatefulWidget {
  String idSurat;
  String tipe;
  DetailpTodo({this.idSurat, this.tipe});
  @override
  _DetailpTodoState createState() => _DetailpTodoState();
}

class _DetailpTodoState extends State<DetailpTodo> {
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
      idUser = pref.getInt("Id");
      noTelepon = pref.getString("NoTelepon");
      nik = pref.getString("Nik");
    });
  }

  void dispose() {
    super.dispose();
  }

  Widget _detailWidget(String keterangan, String rtrwText, String noPengajuan,
      String tglBuat, String noSuratRT, String noSuratRW, List history) {
    String judulDetail;
    double height = MediaQuery.of(context).size.height;
    double fontSizes = height == 716 ? 13 : 15;
    double titleSizes = height == 716 ? 18 : 20;
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
    } else if (widget.tipe == "15") {
      judulDetail = "Pengajuan Surat Penghantar RT&RW";
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
                    fontSize: titleSizes),
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
                  "${UtilRTRW.convertDateTime(tglBuat)}",
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
            height: 5,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "No Surat RT: ",
                  style: TextStyle(
                      fontSize: fontSizes, fontWeight: FontWeight.bold),
                ),
                Text(
                  noSuratRT != null ? "$noSuratRT" : "",
                  style: TextStyle(fontSize: fontSizes),
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
                  "No Surat RW:",
                  style: TextStyle(
                      fontSize: fontSizes, fontWeight: FontWeight.bold),
                ),
                Text(
                  noSuratRW != null ? "$noSuratRW" : "",
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
              "History Pengajuan",
              style:
                  TextStyle(fontSize: titleSizes, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(
            thickness: 3,
          ),
          DataTable(
            dataRowHeight: 90,
            columnSpacing: 1,
            columns: [
              DataColumn(
                  label: Text(
                "Tingkatan",
                style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: fontSizes),
              )),
              DataColumn(
                label: Text(
                  "Status",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: fontSizes),
                ),
              ),
              DataColumn(
                label: Text(
                  "Komentar",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: fontSizes),
                ),
              )
            ],
            rows: [
              for (var i = 0; i < history.length; i++)
                DataRow(
                  cells: [
                    DataCell(Text(
                      history[i]['tingkatan'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: fontSizes),
                    )),
                    DataCell(
                      history[i]['status'] == 'Setuju'
                          ? Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            )
                          : Icon(Icons.close, color: Colors.red),
                    ),
                    DataCell(Text(
                      history[i]['komentar'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: fontSizes),
                    )),
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

  Future<DetailpTodoViewModel> _getDetailSurat() async {
    DetailpTodoPresenter presentesrs = new DetailpTodoPresenter();
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
              print(snapshot.data.dataHistory);
              return _detailWidget(
                snapshot.data.keterangan,
                snapshot.data.rtrw,
                snapshot.data.noPengajuan,
                snapshot.data.tglBuat,
                snapshot.data.noSuratRt,
                snapshot.data.noSuratRw,
                snapshot.data.dataHistory,
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
