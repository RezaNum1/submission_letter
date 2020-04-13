import 'package:flutter/material.dart';

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:submission_letter/RTRW_Page/presenter/detailEmployeeSelesai_presenter.dart';
import 'package:submission_letter/RTRW_Page/views/detai_empSelesai.dart';
import 'package:submission_letter/RTRW_Page/views/display_file.dart';
import 'package:submission_letter/RTRW_Page/widget/form_download.dart';
import 'package:submission_letter/RTRW_Page/widget/form_widget.dart';
import 'package:submission_letter/Util/util_auth.dart';

class BerkasWidgetd extends StatefulWidget {
  List namaFile;
  String tipe;
  String idSurat;
  BerkasWidgetd({this.namaFile, this.tipe, this.idSurat});

  @override
  _BerkasWidgetdState createState() => _BerkasWidgetdState();
}

//KODE BERKAS
/**
 * KTP,KK
 * DR (Depan Rumah), BR(belakang rumah),
 * SPPT,LP(Lampi.pernyataan)
 * KTPOL, KTPOP, TLPBB(Tanda lunahs PBB)
 * AC(Akte cerai), PPBB(Pelunasan PBB), SKK(Surt ket kematian)
 * SKKDRS(S. ket kem dari rmh sakit)
 * SKCK
 * 
 */

class _BerkasWidgetdState extends State<BerkasWidgetd> {
  void downloadFile(BuildContext context, String idSurat, String berkas) async {
    UtilAuth.loading(context);
    DetailEmpSelesaiPresenter detailEmpSelesaiPresenter =
        new DetailEmpSelesaiPresenter();
    var res = await detailEmpSelesaiPresenter.download(idSurat, berkas);
    if (res != '') {
      return UtilAuth.failedPopupDialog(context, res);
    } else {
      return UtilAuth.failedPopupDialog(context, "Download Gagal");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "KTP:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                Container(
                  width: double.infinity,
                  child: RaisedButton(
                    child: Text("Lihat Berkas KTP"),
                    textColor: Colors.white,
                    color: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.orange),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => DisplayFile(
                            berkas: "KTP",
                            idSurat: widget.idSurat,
                          ),
                        ),
                      ); // posisi 0
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: RaisedButton(
                    child: Text("Download Berkas KTP"),
                    textColor: Colors.white,
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.green),
                    ),
                    onPressed: () async {
                      downloadFile(context, widget.idSurat, "KTP");
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "KK:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                Container(
                  width: double.infinity,
                  child: RaisedButton(
                    child: Text("Lihat Berkas KK"),
                    textColor: Colors.white,
                    color: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.orange),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => DisplayFile(
                            berkas: "KK",
                            idSurat: widget.idSurat,
                          ),
                        ),
                      ); // posisi 1
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: RaisedButton(
                    child: Text("Download Berkas KK"),
                    textColor: Colors.white,
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.green),
                    ),
                    onPressed: () {
                      downloadFile(context, widget.idSurat, "KK"); // posisi 1
                    },
                  ),
                ),
              ],
            ),
          ),
          widget.tipe == "1" // SKCK
              ? Column(
                  children: <Widget>[
                    FormWidget(
                      judul: "Foto Depan Rumah",
                      buttonText: "Lihat Foto Depan Rumah",
                      berkas: "DR",
                      idSurat: widget.idSurat,
                    ),
                    FormDownload(
                      buttonText: "Download Foto Depan Rumah",
                      berkas: "DR",
                      idSurat: widget.idSurat,
                    ),
                    FormWidget(
                      judul: "Foto Belakang Rumah",
                      buttonText: "Lihat Foto Belakang Rumah",
                      berkas: "BR",
                      idSurat: widget.idSurat,
                    ),
                    FormDownload(
                      buttonText: "Download Foto Belakang Rumah",
                      berkas: "BR",
                      idSurat: widget.idSurat,
                    ),
                  ],
                )
              : Container(), // End SKCK
          widget.tipe == "2" //SKU
              ? Column(
                  children: <Widget>[
                    FormWidget(
                      judul: "SPPT Terbaru",
                      buttonText: "Lihat Foto SPPT Terbaru",
                      berkas: "SPPT",
                      idSurat: widget.idSurat,
                    ),
                    FormDownload(
                      buttonText: "Download Foto SPPT Terbaru",
                      berkas: "SPPT",
                      idSurat: widget.idSurat,
                    ),
                  ],
                )
              : Container(), //END SKU
          widget.tipe == "3" // Surat izin keramaian
              ? Column(
                  children: <Widget>[
                    FormWidget(
                      judul: "Lampiran Pernyataan",
                      buttonText:
                          "Lihat Lampiran Pernyatan Persetujuan Setempat",
                      berkas: "LP",
                      idSurat: widget.idSurat,
                    ),
                    FormDownload(
                      buttonText:
                          "Download Lampiran Pernyatan Persetujuan Setempat",
                      berkas: "LP",
                      idSurat: widget.idSurat,
                    ),
                  ],
                )
              : Container(), // End Surat Keramaian
          widget.tipe == "4" // SK Belum Menikah
              ? Column(
                  children: <Widget>[
                    FormWidget(
                      judul: "KTP Orang Tua-1 (Ayah)",
                      buttonText: "Lihat KTP Orang Tua 1",
                      berkas: "KTPOL",
                      idSurat: widget.idSurat,
                    ),
                    FormDownload(
                      buttonText: "Download KTP Orang Tua 1",
                      berkas: "KTPOL",
                      idSurat: widget.idSurat,
                    ),
                    FormWidget(
                      judul: "KTP Orang Tua-2 (Ibu)",
                      buttonText: "Lihat KTP Orang Tua 2",
                      berkas: "KTPOP",
                      idSurat: widget.idSurat,
                    ),
                    FormDownload(
                      buttonText: "Download KTP Orang Tua 2",
                      berkas: "KTPOP",
                      idSurat: widget.idSurat,
                    ),
                    FormWidget(
                      judul: "Tanda Lunas PBB Tahun Berjalan",
                      buttonText: "Lihat Tanda Lunas PBB Tahun Berjalan",
                      berkas: "TLPBB",
                      idSurat: widget.idSurat,
                    ),
                    FormDownload(
                      buttonText: "Download Tanda Lunas PBB Tahun Berjalan",
                      berkas: "TLPBB",
                      idSurat: widget.idSurat,
                    ),
                  ],
                )
              : Container(), // End SK Belum Menikah
          widget.tipe == "5" //SK Cerai Hidup / Mati
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FormWidget(
                      judul: "Akte Cerai",
                      buttonText: "Lihat Akte Cerai",
                      berkas: "AC",
                      idSurat: widget.idSurat,
                    ),
                    FormDownload(
                      buttonText: "Download Akte Cerai",
                      berkas: "AC",
                      idSurat: widget.idSurat,
                    ),
                    FormWidget(
                      judul: "Pelunasan PBB Tahun Berjalan",
                      buttonText: "Lihat Pelunasan PBB Tahun Berjalan",
                      berkas: "PPBB",
                      idSurat: widget.idSurat,
                    ),
                    FormDownload(
                      buttonText: "Download Pelunasan PBB Tahun Berjalan",
                      berkas: "PPBB",
                      idSurat: widget.idSurat,
                    ),
                    FormWidget(
                      judul:
                          "Surat Keterangan Kematian Suami / Istri (Untuk Cerai Mati)",
                      buttonText: "Lihat Surat Keterangan Kematian",
                      berkas: "SKK",
                      idSurat: widget.idSurat,
                    ),
                    FormDownload(
                      buttonText: "Lihat Surat Keterangan Kematian",
                      berkas: "SKK",
                      idSurat: widget.idSurat,
                    ),
                  ],
                )
              : Container(), // End
          widget.tipe == "7"
              ? Column(
                  children: <Widget>[
                    FormWidget(
                      judul:
                          "Surat Keterangan Kematian Dari Rumah Sakit (Jika Ada)",
                      buttonText: "Lihat Surat Keterangan Kematian",
                      berkas: "SKKDRS",
                      idSurat: widget.idSurat,
                    ),
                    FormDownload(
                      buttonText: "Download Surat Keterangan Kematian",
                      berkas: "SKKDRS",
                      idSurat: widget.idSurat,
                    ),
                  ],
                )
              : Container(),
          widget.tipe == "8"
              ? Column(
                  children: <Widget>[
                    FormWidget(
                      judul: "SKCK (Untuk Pindahan Dari Kabupaten / Provinsi)",
                      buttonText: "Lihat SKCK",
                      berkas: "SKCK",
                      idSurat: widget.idSurat,
                    ),
                    FormDownload(
                      buttonText: "Download SKCK",
                      berkas: "SKCK",
                      idSurat: widget.idSurat,
                    ),
                  ],
                )
              : Container()
        ],
      ),
    );
  }
}
