import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:submission_letter/RTRW_Page/presenter/detailEmployee_presenter.dart';
import 'package:submission_letter/RTRW_Page/presenter/selesai_presenter.dart';
import 'package:submission_letter/RTRW_Page/presenter/todo_presenter.dart';
import 'package:submission_letter/RTRW_Page/views/detail_emp.dart';
import 'package:submission_letter/Util/util_auth.dart';
import 'package:submission_letter/Util/util_rtrw.dart';

class SelesaiEmp extends StatefulWidget {
  @override
  _SelesaiEmpState createState() => _SelesaiEmpState();
}

class _SelesaiEmpState extends State<SelesaiEmp> {
  Widget suratWidget(String idSuratRT, String idSurat, String tipe, String nama,
      String tanggal) {
    String titleName;
    String subTitleName;

    // Custom Text
    if (tipe == "1") {
      titleName = "SKTM";
      subTitleName = "Pengajuan Surat Keterangan Kemiskinan";
    } else if (tipe == "2") {
      titleName = "SD";
      subTitleName = "Pengajuan Surat Keterangan Domisili";
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
                  "Pemohon : $nama",
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
          print('Test');
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getListDataSelesai() async {
    SelesaiPresenter presenter = new SelesaiPresenter();
    var allData = await presenter.getAllSelesai();
    print(allData);
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
        future: _getListDataSelesai(),
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
                      snapshot.data[index]["idSuratRT"].toString(),
                      snapshot.data[index]["idSurat"].toString(),
                      snapshot.data[index]["tipe"].toString(),
                      snapshot.data[index]["penduduk"],
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
