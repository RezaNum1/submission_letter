import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart' show AssetImage;
import 'package:printing/printing.dart';
import 'package:submission_letter/RTRW_Page/widget/pdf_viewer_page.dart';

reportView(
  context,
  String nama,
  String jk,
  String ttl,
  String pekerjaan,
  String ktp,
  String kk,
  String pendidikan,
  String agama,
  String alamat,
  String ket,
  String nort,
  String norw,
  String rtText,
  String rwText,
  String tanggal,
  Uint8List sigRT,
  Uint8List sigRW,
) async {
  final Document pdf = Document();

  PdfImage logoImage = await pdfImageFromImageProvider(
    pdf: pdf.document,
    image: AssetImage('assets/images/dki.png'),
  );

  final signatureRT = PdfImage.file(
    pdf.document,
    bytes: sigRT,
  );

  final signatureRW = PdfImage.file(
    pdf.document,
    bytes: sigRW,
  );

  pdf.addPage(Page(
      pageFormat: PdfPageFormat.a4,
      margin: EdgeInsets.only(top: -5, left: 35),
      // crossAxisAlignment: CrossAxisAlignment.start,
      build: (Context context) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Header(
              margin: EdgeInsets.only(right: 20),
              child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Row(children: <Widget>[
                    Container(
                      child: Image(logoImage),
                      height: 80,
                      width: 80,
                    ),
                    SizedBox(width: 60),
                    Column(children: <Widget>[
                      Text("RUKUN TETANGGA. $rtText RW. $rwText",
                          style: TextStyle(fontSize: 15)),
                      Text("KEL. CIPINANG CEMPEDAK KEC. JATINEGARA",
                          style: TextStyle(fontSize: 15)),
                      Text("KOTA ADMINISTRASI JAKARTA TIMUR",
                          style: TextStyle(fontSize: 15)),
                    ])
                  ]))),
          SizedBox(height: 20),
          Center(
              child: Container(
                  child: Column(children: <Widget>[
            Container(child: Text("SURAT PENGANTAR")),
            Container(
                margin: EdgeInsets.only(top: -5, bottom: -5),
                width: 130,
                child: Header(child: Container())),
            Text("NO $nort")
          ]))),
          SizedBox(height: 30),
          Container(
              child: Text(
                  "Saya yang bertanda tangan di bawah ini, Ketua RT $rtText / RW $rwText Cipinang Cempedak",
                  style: TextStyle(fontSize: 12))),
          SizedBox(height: 10),
          Container(
              child:
                  Text("Kecamatan Jatinegara, dengan ini menerangkan bahwa:")),
          SizedBox(height: 20),
          Container(
              margin: EdgeInsets.only(left: 30),
              child: Column(children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Row(children: <Widget>[
                    Text("NAMA", style: TextStyle(fontSize: 14)),
                    SizedBox(width: 120),
                    Text(":", style: TextStyle(fontSize: 14)),
                    SizedBox(width: 10),
                    Text("$nama", style: TextStyle(fontSize: 14))
                  ]),
                ),
                Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Row(children: <Widget>[
                      Text("JENIS KELAMIN", style: TextStyle(fontSize: 14)),
                      SizedBox(width: 56),
                      Text(":", style: TextStyle(fontSize: 14)),
                      SizedBox(width: 10),
                      Text("$jk", style: TextStyle(fontSize: 14))
                    ])),
                Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Row(children: <Widget>[
                      Text("TEMPAT/TGL LAHIR", style: TextStyle(fontSize: 14)),
                      SizedBox(width: 28),
                      Text(":", style: TextStyle(fontSize: 14)),
                      SizedBox(width: 10),
                      Text("$ttl", style: TextStyle(fontSize: 14))
                    ])),
                Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Row(children: <Widget>[
                      Text("PEKERJAAN", style: TextStyle(fontSize: 14)),
                      SizedBox(width: 78),
                      Text(":", style: TextStyle(fontSize: 14)),
                      SizedBox(width: 10),
                      Text("$pekerjaan", style: TextStyle(fontSize: 14))
                    ])),
                Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Row(children: <Widget>[
                      Text("NO KTP / KK", style: TextStyle(fontSize: 14)),
                      SizedBox(width: 78),
                      Text(":", style: TextStyle(fontSize: 14)),
                      SizedBox(width: 10),
                      Text("$ktp / $kk", style: TextStyle(fontSize: 14))
                    ])),
                Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Row(children: <Widget>[
                      Text("KEWARGANEGARAAN", style: TextStyle(fontSize: 14)),
                      SizedBox(width: 10),
                      Text(":", style: TextStyle(fontSize: 14)),
                      SizedBox(width: 10),
                      Text("INDONESIA", style: TextStyle(fontSize: 14))
                    ])),
                Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Row(children: <Widget>[
                      Text("PENDIDIKAN", style: TextStyle(fontSize: 14)),
                      SizedBox(width: 75),
                      Text(":", style: TextStyle(fontSize: 14)),
                      SizedBox(width: 10),
                      Text("$pendidikan", style: TextStyle(fontSize: 14))
                    ])),
                Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Row(children: <Widget>[
                      Text("AGAMA", style: TextStyle(fontSize: 14)),
                      SizedBox(width: 110),
                      Text(":", style: TextStyle(fontSize: 14)),
                      SizedBox(width: 10),
                      Text("$agama", style: TextStyle(fontSize: 14))
                    ])),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("ALAMAT", style: TextStyle(fontSize: 14)),
                      SizedBox(width: 105),
                      Text(":", style: TextStyle(fontSize: 14)),
                      SizedBox(width: 10),
                      Container(
                          width: 300,
                          height: 40,
                          child:
                              Text("$alamat", style: TextStyle(fontSize: 14)))
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("MAKSUD/KEPERLUAN", style: TextStyle(fontSize: 14)),
                      SizedBox(width: 12),
                      Text(":", style: TextStyle(fontSize: 14)),
                      SizedBox(width: 10),
                      Container(
                          width: 300,
                          height: 50,
                          child: Text("$ket", style: TextStyle(fontSize: 14)))
                    ],
                  ),
                ),
              ])),
          Container(
              child: Text(
                  "Demikian surat pengantar ini kami berikan guna proses tindak lanjut ke tingkat")),
          SizedBox(height: 10),
          Container(
              margin: EdgeInsets.only(bottom: 10), child: Text("Selanjutnya")),
          SizedBox(height: 30),
          Container(
            margin: EdgeInsets.only(bottom: 1),
            child: Row(
              children: <Widget>[
                Row(children: <Widget>[
                  Text("Nomor :"),
                  Text("$norw"),
                ]),
                Container(
                  margin: EdgeInsets.only(left: 200),
                  child: Text("Jakarta, $tanggal"),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            child: Row(
              children: <Widget>[
                Column(children: <Widget>[
                  Text("Mengetahui"),
                  SizedBox(height: 5),
                  Text("Pengurus RW $rwText"),
                  SizedBox(height: 15),
                  Container(
                    child: Image(signatureRW),
                    height: 100,
                    width: 190,
                  ),
                  // Text("....................."),
                ]),
                Container(
                  margin: EdgeInsets.only(left: 150),
                  child: Column(children: <Widget>[
                    Text("Pengurus RT $rtText/RW $rwText"),
                    SizedBox(height: 5),
                    Text("Ketua"),
                    SizedBox(height: 15),
                    Container(
                      child: Image(signatureRT),
                      height: 100,
                      width: 190,
                    ),
                    // Text("....................."),
                  ]),
                ),
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.all(10)),
        ]);
      }));

  //save PDF
  var dir = await getExternalStorageDirectory();
  final String path = '${dir.path}/SuratPengantar.pdf';
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
