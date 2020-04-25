import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart' show AssetImage;
import 'package:printing/printing.dart';
import 'package:submission_letter/RTRW_Page/widget/pdf_viewer_page.dart';

reportViewPenduduk(
    context,
    String nama,
    String ttl,
    String jk,
    String agama,
    String ktp,
    String alamat,
    String pekerjaan,
    String body,
    String tanggal,
    String nosk) async {
  final Document pdf = Document();

  PdfImage logoImage = await pdfImageFromImageProvider(
    pdf: pdf.document,
    image: AssetImage('assets/images/dki_bw.png'),
  );

  pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4,
      crossAxisAlignment: CrossAxisAlignment.start,
      build: (Context context) => <Widget>[
            Header(
                child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Row(children: <Widget>[
                      Container(
                        child: Image(logoImage),
                        height: 80,
                        width: 80,
                      ),
                      SizedBox(width: 20),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                "PEMERINTAH PROPINSI DAERAH KHUSUS IBUKOTA JAKARTA",
                                style: TextStyle(fontSize: 13)),
                            Row(children: <Widget>[
                              Text("KOTA MADYA",
                                  style: TextStyle(fontSize: 13)),
                              SizedBox(width: 90),
                              Text(":", style: TextStyle(fontSize: 13)),
                              Text(" Jakarta Timur",
                                  style: TextStyle(fontSize: 11))
                            ]),
                            Row(children: <Widget>[
                              Text("KELURAHAN", style: TextStyle(fontSize: 13)),
                              SizedBox(width: 95),
                              Text(":", style: TextStyle(fontSize: 13)),
                              Text(" Cipinang Cempedak",
                                  style: TextStyle(fontSize: 11))
                            ]),
                            SizedBox(height: 10),
                            Container(
                              margin: EdgeInsets.only(left: 284),
                              child: Row(children: <Widget>[
                                Text("Model", style: TextStyle(fontSize: 10)),
                                SizedBox(width: 23),
                                Text(":", style: TextStyle(fontSize: 10)),
                                Text(" PM.I WNI",
                                    style: TextStyle(fontSize: 10)),
                              ]),
                            ),
                            Row(children: <Widget>[
                              Text("Alamat", style: TextStyle(fontSize: 10)),
                              SizedBox(width: 15),
                              Text(":", style: TextStyle(fontSize: 10)),
                              Text(" Jl. Panti Asuhan RT 014/01",
                                  style: TextStyle(fontSize: 10)),
                              SizedBox(width: 110),
                              Text("Kode Kel", style: TextStyle(fontSize: 10)),
                              SizedBox(width: 10),
                              Text(":", style: TextStyle(fontSize: 10)),
                              Text(" 09.04.021004",
                                  style: TextStyle(fontSize: 10)),
                            ]),
                          ])
                    ]))),
            Center(
                child: Container(
                    child: Column(children: <Widget>[
              Container(child: Text("SURAT KETERANGAN")),
              Container(
                  margin: EdgeInsets.only(top: -5, bottom: -5),
                  width: 130,
                  child: Header(child: Container())),
              Text("Nomor   : $nosk")
            ]))),
            SizedBox(height: 30),
            Container(
                child: Text(
                    "Yang bertanda tangan di bawah ini, Menerangkan Bahwa",
                    style: TextStyle(fontSize: 12))),
            SizedBox(height: 10),
            Container(
                child: Column(children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(children: <Widget>[
                  Text("Nama Lengkap", style: TextStyle(fontSize: 13)),
                  SizedBox(width: 105),
                  Text(":", style: TextStyle(fontSize: 13)),
                  SizedBox(width: 10),
                  Text("$nama", style: TextStyle(fontSize: 13))
                ]),
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Row(children: <Widget>[
                    Text("Tempat / Tanggal Lahir",
                        style: TextStyle(fontSize: 13)),
                    SizedBox(width: 59),
                    Text(":", style: TextStyle(fontSize: 13)),
                    SizedBox(width: 10),
                    Text("$ttl", style: TextStyle(fontSize: 13))
                  ])),
              Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Row(children: <Widget>[
                    Text("Jenis Kelamin", style: TextStyle(fontSize: 13)),
                    SizedBox(width: 111),
                    Text(":", style: TextStyle(fontSize: 13)),
                    SizedBox(width: 10),
                    Text("$jk", style: TextStyle(fontSize: 13))
                  ])),
              Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Row(children: <Widget>[
                    Text("Agama", style: TextStyle(fontSize: 13)),
                    SizedBox(width: 150),
                    Text(":", style: TextStyle(fontSize: 13)),
                    SizedBox(width: 10),
                    Text("$agama", style: TextStyle(fontSize: 13))
                  ])),
              Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Row(children: <Widget>[
                    Text("Kewarganegaraan", style: TextStyle(fontSize: 13)),
                    SizedBox(width: 85),
                    Text(":", style: TextStyle(fontSize: 13)),
                    SizedBox(width: 10),
                    Text("INDONESIA", style: TextStyle(fontSize: 13))
                  ])),
              Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Row(children: <Widget>[
                    Text("KTP / Tanda Lapor Diri",
                        style: TextStyle(fontSize: 13)),
                    SizedBox(width: 58),
                    Text(":", style: TextStyle(fontSize: 13)),
                    SizedBox(width: 10),
                    Text("$ktp", style: TextStyle(fontSize: 13))
                  ])),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Alamat", style: TextStyle(fontSize: 13)),
                    SizedBox(width: 150),
                    Text(":", style: TextStyle(fontSize: 13)),
                    SizedBox(width: 10),
                    Container(
                        width: 300,
                        height: 40,
                        child: Text("$alamat", style: TextStyle(fontSize: 13)))
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Row(children: <Widget>[
                    Text("Pekerjaan", style: TextStyle(fontSize: 13)),
                    SizedBox(width: 131),
                    Text(":", style: TextStyle(fontSize: 13)),
                    SizedBox(width: 10),
                    Text("$pekerjaan", style: TextStyle(fontSize: 13))
                  ])),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Maksud / Keperluan", style: TextStyle(fontSize: 14)),
                    SizedBox(width: 64),
                    Text(":", style: TextStyle(fontSize: 14)),
                    SizedBox(width: 10),
                    Container(
                        width: 300,
                        height: 50,
                        child: Text("$body", style: TextStyle(fontSize: 14)))
                  ],
                ),
              ),
            ])),
            Container(
                child: Text(
                    "Demikian surat keterangan ini dibuat untuk dipergunakan sebagaimana mestinya")),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(bottom: 1),
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 360),
                    child: Text("Jakarta, $tanggal"),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              child: Row(
                children: <Widget>[
                  Column(children: <Widget>[
                    Text("Mengetahui"),
                    SizedBox(height: 65),
                    Text("$nama"),
                  ]),
                  Container(
                    margin: EdgeInsets.only(left: 235),
                    child: Column(children: <Widget>[
                      Text("LURAH CIPINANG CEMPEDAK"),
                      SizedBox(height: 60),
                      Text("....................."),
                    ]),
                  ),
                ],
              ),
            ),
            Padding(padding: const EdgeInsets.all(10)),
          ]));

  //save PDF
  var dir = await getExternalStorageDirectory();
  final String path = '${dir.path}/SuratKeterangan.pdf';
  final File file = File(path);
  await file.writeAsBytes(pdf.save());
  material.Navigator.of(context).push(
    material.MaterialPageRoute(
      builder: (_) => PdfViewerPage(
        path: path,
      ),
    ),
  );
}
