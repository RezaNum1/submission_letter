import 'package:flutter/material.dart';
import 'package:submission_letter/RTRW_Page/widget/form_widget.dart';

class BerkasWidget extends StatefulWidget {
  List namaFile;
  String tipe;
  String idSurat;
  BerkasWidget({this.namaFile, this.tipe, this.idSurat});

  @override
  _BerkasWidgetState createState() => _BerkasWidgetState();
}

class _BerkasWidgetState extends State<BerkasWidget> {
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
                      print("Hello"); // posisi 0
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
                      print("Hello"); // posisi 1
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
                      posisi: "2",
                    ),
                    FormWidget(
                      judul: "Foto Belakang Rumah",
                      buttonText: "Lihat Foto Belakang Rumah",
                      posisi: "3",
                    ),
                  ],
                )
              : Container(), // End SKCK
          widget.tipe == "2" //SKU
              ? FormWidget(
                  judul: "SPPT Terbaru",
                  buttonText: "Lihat Foto SPPT Terbaru",
                )
              : Container(), //END SKU
          widget.tipe == "3" // Surat izin keramaian
              ? FormWidget(
                  judul: "Lampiran Pernyataan",
                  buttonText: "Lihat Lampiran Pernyatan Persetujuan Setempat",
                  posisi: "2",
                )
              : Container(), // End Surat Keramaian
          widget.tipe == "4" // SK Belum Menikah
              ? Column(
                  children: <Widget>[
                    FormWidget(
                      judul: "KTP Orang Tua-1 (Ayah)",
                      buttonText: "Lihat KTP Orang Tua 1",
                      posisi: "2",
                    ),
                    FormWidget(
                      judul: "KTP Orang Tua-2 (Ibu)",
                      buttonText: "Lihat KTP Orang Tua 2",
                      posisi: "3",
                    ),
                    FormWidget(
                      judul: "Tanda Lunas PBB Tahun Berjalan",
                      buttonText: "Lihat Tanda Lunas PBB Tahun Berjalan",
                      posisi: "4",
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
                      posisi: "2",
                    ),
                    FormWidget(
                      judul: "Pelunasan PBB Tahun Berjalan",
                      buttonText: "Lihat Pelunasan PBB Tahun Berjalan",
                      posisi: "4",
                    ),
                    FormWidget(
                      judul:
                          "Surat Keterangan Kematian Suami / Istri (Untuk Cerai Mati)",
                      buttonText: "Lihat Surat Keterangan Kematian",
                      posisi: "3",
                    ),
                  ],
                )
              : Container(), // End
          widget.tipe == "7"
              ? FormWidget(
                  judul:
                      "Surat Keterangan Kematian Dari Rumah Sakit (Jika Ada)",
                  buttonText: "Lihat Surat Keterangan Kematian",
                  posisi: "2",
                )
              : Container(),
          widget.tipe == "8"
              ? FormWidget(
                  judul: "SKCK (Untuk Pindahan Dari Kabupaten / Provinsi)",
                  buttonText: "Lihat SKCK",
                  posisi: "2",
                )
              : Container()
        ],
      ),
    );
  }
}
