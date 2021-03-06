import 'package:flutter/material.dart';
import 'package:submission_letter/Penduduk_Page/presenter/todop_presenter.dart';
import 'package:submission_letter/Penduduk_Page/presenter/tolakp_presenter.dart';
import 'package:submission_letter/Penduduk_Page/views/detailp_tolak.dart';
import 'package:submission_letter/Util/util_auth.dart';
import 'package:submission_letter/Util/util_rtrw.dart';

class TolakPenduduk extends StatefulWidget {
  @override
  _TolakPendudukState createState() => _TolakPendudukState();
}

class _TolakPendudukState extends State<TolakPenduduk> {
  Widget suratWidget(
      String idSurat, String tipe, String noPengajuan, String tanggal) {
    String titleName;
    String subTitleName;
    double height = MediaQuery.of(context).size.height;

    // Custom Text
    if (tipe == "1") {
      titleName = "SKTM";
      subTitleName = "Pengajuan Surat Keterangan Tidak Mampu";
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
    } else if (tipe == "15") {
      titleName = "SP";
      subTitleName = "Pengajuan Surat Penghantar RT&RW";
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
                    fontSize: height == 716 ? 15 : 20,
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
                    fontSize: height == 716 ? 9 : 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "No Pengajuan : $noPengajuan",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: height == 716 ? 10 : 13,
                  ),
                ),
                Text(
                  "Tanggal    : $tanggal",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: height == 716 ? 10 : 13,
                  ),
                ),
              ],
            )
          ],
        ),
        onTap: () {
          UtilAuth.movePage(
              context,
              DetailpTolak(
                idSurat: idSurat,
                tipe: tipe,
              ));
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getListData() async {
    TolakpPresenter todoPresenter = new TolakpPresenter();
    var allData = await todoPresenter.getTolakSurat();
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
