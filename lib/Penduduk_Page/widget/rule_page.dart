import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:submission_letter/Theme/theme_penduduk.dart';

class RulePage extends StatefulWidget {
  String tipe;
  RulePage({this.tipe});

  @override
  _RulePageState createState() => _RulePageState();
}

class _RulePageState extends State<RulePage> {
  @override
  Widget build(BuildContext context) {
    String titleText;
    if (widget.tipe == "1") {
      titleText = "Surat Keterangan Tanda Miskin";
    } else if (widget.tipe == "2") {
      titleText = "Surat Keterangan Usaha";
    } else if (widget.tipe == "3") {
      titleText = "Surat Pengantar Izin Keramaian";
    } else if (widget.tipe == "4") {
      titleText = "Surat Keterangan Belum Menikah";
    } else if (widget.tipe == "5") {
      titleText = "Surat Keterangan Cerai Hidup / Mati";
    } else if (widget.tipe == "6") {
      titleText = "Surat Keterangan Domisili";
    } else if (widget.tipe == "7") {
      titleText = "Surat Keterangan Kematian";
    } else if (widget.tipe == "8") {
      titleText = "Surat Keterangan Pindah (Keluar / Datang)";
    }

    return Scaffold(
      backgroundColor: Colors.orange[200],
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Container(
          margin: EdgeInsets.only(right: 50),
          height: 60,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/dki.png'),
            ),
          ),
        ),
      ),
      drawer: ThemeAppPenduduk.sideBar(context),
      body: Container(
        child: ListView(
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Persyaratan Pembuatan",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AutoSizeText(
                      "$titleText",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 2,
              color: Colors.white,
            ),
            Container(
              margin: EdgeInsets.only(left: 20, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Berikut persyaratan berkas yang harus dipenuhi:",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "1. KTP (Kartu Tanda Penduduk)",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "2. KK (Kartu Keluarga)",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  widget.tipe == "1"
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AutoSizeText(
                              "3. Foto Sisi Depan Rumah",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            AutoSizeText(
                              "4. Foto Sisi Belakang Rumah",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  widget.tipe == "2"
                      ? AutoSizeText(
                          "3. SPPT Terbaru",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Container(),
                  widget.tipe == "3"
                      ? AutoSizeText(
                          "3. Lampiran Pernyataan Persetujuan Dari Warga Setempat ( Dimana Keramaian Akan Dilangsungkan )",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 3,
                        )
                      : Container(),
                  widget.tipe == "4"
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AutoSizeText(
                              "3. KTP Orang Tua-1 (Ayah)",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            AutoSizeText(
                              "4. KTP Orang Tua-2 (Ibu)",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            AutoSizeText(
                              "5. Tanda Lunas PBB Tahun Berjalan",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  widget.tipe == "5"
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AutoSizeText(
                              "3. Akte Cerai",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            AutoSizeText(
                              "4. Pelunasan PBB Tahun Berjalan",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            AutoSizeText(
                              "5. Surat Keterangan Kematian Suami / Istri (Untuk Cerai Mati)",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  widget.tipe == "7"
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AutoSizeText(
                              "3. Surat Keterangan Kematian Dari Rumah Sakit (Jika Ada)",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  widget.tipe == "8"
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AutoSizeText(
                              "3. SKCK (Untuk Pindahan Dari Kabupaten / Provinsi)",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: double.infinity,
              child: RaisedButton(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.orange[300]),
                ),
                child: Text(
                  "Lanjutkan",
                  style: TextStyle(
                    color: Colors.orange[300],
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                onPressed: () async {
                  // UtilAuth.movePage(context, HomeBase());
                },
              ),
            ),
            Container(
              height: 180,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/building.png'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
