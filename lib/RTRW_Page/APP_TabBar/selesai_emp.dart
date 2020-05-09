import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:submission_letter/RTRW_Page/presenter/detailEmployeeSelesai_presenter.dart';
import 'package:submission_letter/RTRW_Page/presenter/detailEmployee_presenter.dart';
import 'package:submission_letter/RTRW_Page/presenter/selesai_presenter.dart';
import 'package:submission_letter/RTRW_Page/presenter/todo_presenter.dart';
import 'package:submission_letter/RTRW_Page/views/detai_empSelesai.dart';
import 'package:submission_letter/RTRW_Page/views/detail_emp.dart';
import 'package:submission_letter/Util/util_auth.dart';
import 'package:submission_letter/Util/util_rtrw.dart';

class SelesaiEmp extends StatefulWidget {
  @override
  _SelesaiEmpState createState() => _SelesaiEmpState();
}

class _SelesaiEmpState extends State<SelesaiEmp> {
  Widget suratWidget(String idJobPos, String idSurat, String tipe, String nama,
      String tanggal) {
    String titleName;
    String subTitleName;

    // Custom Text
    if (tipe == "1") {
      titleName = "SKTM";
      subTitleName = "Pengajuan Surat Keterangan Tidak Mampu";
    } else if (tipe == "2") {
      titleName = "SKU";
      subTitleName = "Pengajuan Surat Keterangan Usaha";
    } else if (tipe == "3") {
      titleName = "SPIK";
      subTitleName = "Pengajuan Surat Pengantar Izin Keramaian";
    } else if (tipe == "4") {
      titleName = "SKB,";
      subTitleName = "Pengajuan Surat Keterangan Belum Menikah";
    } else if (tipe == "5") {
      titleName = "SKC";
      subTitleName = "Pengajuan Surat Keterangan Cerai";
    } else if (tipe == "6") {
      titleName = "SKD";
      subTitleName = "Pengajuan Surat Keterangan Domisili";
    } else if (tipe == "7") {
      titleName = "SKM";
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
          UtilAuth.movePage(
              context,
              DetailEmpSelesai(
                idJobPos: idJobPos,
                idSurat: idSurat,
                namaPenduduk: nama,
                tanggal: tanggal,
                tipe: tipe,
              ));
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getListDataSelesai() async {
    SelesaiPresenter presenter = new SelesaiPresenter();
    var allData = await presenter.getAllSelesai();
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
                      snapshot.data[index]["idJobPos"].toString(),
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
