import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart' show AssetImage;
import 'package:printing/printing.dart';
import 'package:submission_letter/RTRW_Page/widget/pdf_viewer_page.dart';

suratKelurahanReportView(
  context,
  String bodySurat,
  String noSuratKelurahan,
  String keterangan,
  String tanggal,
  String lurah,
  List<dynamic> listKepada,
  List<dynamic> listTembusan,
  double widthScreen,
) async {
  final Document pdf = Document();

  PdfImage logoImage = await pdfImageFromImageProvider(
    pdf: pdf.document,
    image: AssetImage('assets/images/dki_bw.png'),
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
                  margin: EdgeInsets.only(bottom: 20, top: 5),
                  child: Row(children: <Widget>[
                    Container(
                      child: Image(logoImage),
                      height: 100,
                      width: 100,
                    ),
                    SizedBox(width: 10),
                    Column(children: <Widget>[
                      Text("PEMERINTAH PROVINSI DAERAH KHUSUS IBUKOTA JAKARTA",
                          style: TextStyle(fontSize: 15)),
                      Text("KOTA ADMINISTRASI JAKARTA TIMUR",
                          style: TextStyle(fontSize: 15)),
                      Text("KECAMATAN JATINEGARA",
                          style: TextStyle(fontSize: 15)),
                      Text("KELURAHAN CIPINANG CEMPEDAK",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(
                          "Jalan Panti Asuhan Telp. 021-8194853 Fax. 021-8516059 | KodePos : 13340",
                          style: TextStyle(fontSize: 10)),
                      Text("J A K A R T A", style: TextStyle(fontSize: 15)),
                    ])
                  ]))),
          SizedBox(height: 20),
          Container(
              margin: EdgeInsets.only(left: widthScreen),
              child: Text("$tanggal", style: TextStyle(fontSize: 14))),
          SizedBox(height: 10),
          Container(
              margin: EdgeInsets.only(left: 40),
              child: Row(children: <Widget>[
                Text("Nomor", style: TextStyle(fontSize: 14)),
                SizedBox(width: 30),
                Text(":", style: TextStyle(fontSize: 14)),
                SizedBox(width: 10),
                Text("$noSuratKelurahan", style: TextStyle(fontSize: 14))
              ])),
          Container(
              margin: EdgeInsets.only(left: 40),
              child: Row(children: <Widget>[
                Text("Sifat", style: TextStyle(fontSize: 14)),
                SizedBox(width: 44),
                Text(":", style: TextStyle(fontSize: 14)),
                SizedBox(width: 10),
                Text("Umum", style: TextStyle(fontSize: 14))
              ])),
          Container(
              margin: EdgeInsets.only(left: 40),
              child: Row(children: <Widget>[
                Text("Lampiran", style: TextStyle(fontSize: 14)),
                SizedBox(width: 14),
                Text(":", style: TextStyle(fontSize: 14)),
                SizedBox(width: 10),
                Text("1 (satu) lembar", style: TextStyle(fontSize: 14))
              ])),
          Container(
              margin: EdgeInsets.only(left: 40),
              child: Row(children: <Widget>[
                Text("Hal", style: TextStyle(fontSize: 14)),
                SizedBox(width: 52),
                Text(":", style: TextStyle(fontSize: 14)),
                SizedBox(width: 10),
                Text("$keterangan", style: TextStyle(fontSize: 14))
              ])),
          Container(
              margin: EdgeInsets.only(left: widthScreen - 50),
              child: Column(children: <Widget>[
                Text("Kepada Yth.", style: TextStyle(fontSize: 14)),
                Text("Camat Kecamatan Jatinegara",
                    style: TextStyle(fontSize: 14)),
                for (var i = 0; i < listKepada.length; i++)
                  Text("${listKepada[i]}", style: TextStyle(fontSize: 14)),
                Text("Jl. DI Panjaitan", style: TextStyle(fontSize: 14)),
                Text("di", style: TextStyle(fontSize: 14)),
                Text("Jakarta", style: TextStyle(fontSize: 14)),
              ])),
          SizedBox(height: 30),
          Container(
              width: widthScreen + 50,
              margin: EdgeInsets.only(left: 80),
              child: Column(children: <Widget>[
                Container(
                    child: Text("$bodySurat.",
                        textAlign: TextAlign.justify,
                        tightBounds: true,
                        style: TextStyle(fontSize: 14))),
              ])),
          SizedBox(height: 20),
          Container(
              child: Center(
                  child: Text(
                      "Demikian atas perhatiannya kami ucapkan terimakasih",
                      style: TextStyle(fontSize: 14)))),
          SizedBox(height: 30),
          Container(
            margin: EdgeInsets.only(left: widthScreen - 100),
            child: Column(children: <Widget>[
              Text("Lurah Kelurahan Cipinang Cempedak",
                  style: TextStyle(fontSize: 14)),
              SizedBox(height: 70),
              Text("$lurah", style: TextStyle(fontSize: 14)),
              Text("NIP. 19288928898392983", style: TextStyle(fontSize: 14)),

              // Text("....................."),
            ]),
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Tembusan:", style: TextStyle(fontSize: 14)),
                  for (var i = 0; i < listTembusan.length; i++)
                    Text("${listTembusan[i]}", style: TextStyle(fontSize: 14)),
                ]),
          ),
          Padding(padding: const EdgeInsets.all(10)),
        ]);
      }));

  //save PDF
  var dir = await getExternalStorageDirectory();
  final String path = '${dir.path}/SuratKelurahan.pdf';
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
