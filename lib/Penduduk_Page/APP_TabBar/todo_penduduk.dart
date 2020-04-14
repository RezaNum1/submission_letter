import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_letter/Penduduk_Page/presenter/todop_presenter.dart';
import 'package:submission_letter/Penduduk_Page/views/detailp_todo.dart';
import 'package:submission_letter/Util/util_auth.dart';
import 'package:submission_letter/Util/util_rtrw.dart';

class ToDoPenduduk extends StatefulWidget {
  @override
  _ToDoPendudukState createState() => _ToDoPendudukState();
}

class _ToDoPendudukState extends State<ToDoPenduduk> {
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

  Widget suratWidget(
      String idSurat, String tipe, String noPengajuan, String tanggal) {
    String titleName;
    String subTitleName;

    // Custom Text
    if (tipe == "1") {
      titleName = "SKTM";
      subTitleName = "Pengajuan Surat Keterangan Kemiskinan";
    } else if (tipe == "2") {
      titleName = "SD";
      subTitleName = "Pengajuan Surat Keterangan Domisili";
    } else if (tipe == "3") {
      titleName = "SPIK";
      subTitleName = "Pengajuan Surat Pengantar Izin Keramaian";
    } else if (tipe == "4") {
      titleName = "SKBM";
      subTitleName = "Pengajuan Surat Keterangan Belum Menikah";
    } else if (tipe == "5") {
      titleName = "SKC";
      subTitleName = "Pengajuan Surat Keterangan Cerai Hidup / Mati";
    } else if (tipe == "6") {
      titleName = "SKD";
      subTitleName = "Pengajuan Surat Keterangan Domisili";
    } else if (tipe == "7") {
      titleName = "SKK";
      subTitleName = "Pengajuan Surat Keterangan Kematian";
    } else if (tipe == "8") {
      titleName = "SKP";
      subTitleName = "Pengajuan Surat Keterangan Pindah";
    }
    return Card(
      child: ListTile(
        title: Row(
          children: <Widget>[
            Container(
              child: Center(
                child: Text(
                  "$titleName",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              height: 60,
              width: 60,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.orange),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "$subTitleName",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "No Pengajuan : $noPengajuan",
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                ),
                Text(
                  "Tanggal    : $tanggal",
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ],
            )
          ],
        ),
        onTap: () {
          UtilAuth.movePage(
              context,
              DetailpTodo(
                idSurat: idSurat,
                tipe: tipe,
              ));
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getListData() async {
    TodopPresenter todoPresenter = new TodopPresenter();
    var allData = await todoPresenter.getAllTodo(idUser);
    if (allData.isEmpty) {
      return null;
    } else {
      return allData;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: _getListData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Container(
              child: Center(
                child: Text('Loading...'),
              ),
            );
          } else {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return suratWidget(
                      snapshot.data[index]["idSurat"].toString(),
                      snapshot.data[index]["tipe"].toString(),
                      snapshot.data[index]["noPengajuan"],
                      UtilRTRW.convertDateTime(
                        snapshot.data[index]["tanggal"],
                      ),
                    );
                  });
            } else {
              return Container(
                child: Center(
                  child: Text('Data Kosong'),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
