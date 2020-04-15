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
    String tanggal) async {
  final Document pdf = Document();

  PdfImage logoImage = await pdfImageFromImageProvider(
    pdf: pdf.document,
    image: AssetImage('assets/images/dki.png'),
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
                      SizedBox(width: 40),
                      Column(children: <Widget>[
                        Text("RUKUN TETANGGA. $rtText RW. $rwText",
                            style: TextStyle(fontSize: 15)),
                        Text("KEL. CIPINANG CEMPEDAK KEC. JATINEGARA",
                            style: TextStyle(fontSize: 15)),
                        Text("KOTA ADMINISTRASI JAKARTA TIMUR",
                            style: TextStyle(fontSize: 15)),
                      ])
                    ]))),
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
                child: Text(
                    "Kecamatan Jatinegara, dengan ini menerangkan bahwa:")),
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
                        Text("TEMPAT/TGL LAHIR",
                            style: TextStyle(fontSize: 14)),
                        SizedBox(width: 28),
                        Text(":", style: TextStyle(fontSize: 14)),
                        SizedBox(width: 10),
                        Text("$ttl", style: TextStyle(fontSize: 14))
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
                        Text("MAKSUD/KEPERLUAN",
                            style: TextStyle(fontSize: 14)),
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
                margin: EdgeInsets.only(bottom: 10),
                child: Text("Selanjutnya")),
            SizedBox(height: 10),
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
              margin: EdgeInsets.only(top: 5),
              child: Row(
                children: <Widget>[
                  Column(children: <Widget>[
                    Text("Mengetahui"),
                    SizedBox(height: 5),
                    Text("Pengurus RW $rwText"),
                    SizedBox(height: 60),
                    Text("....................."),
                  ]),
                  Container(
                    margin: EdgeInsets.only(left: 255),
                    child: Column(children: <Widget>[
                      Text("Pengurus RT $rtText/RW $rwText"),
                      SizedBox(height: 5),
                      Text("Ketua"),
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

// import 'package:flutter_letter/pdf.dart';
// import 'package:pdf/pdf.dart';
// import 'dart:io';
// import 'package:pdf/widgets.dart';
// import 'package:path_provider/path_provider.dart';

// import 'package:flutter/material.dart' as material;

// reportView(context) async {
//   final Document pdf = Document();

//   pdf.addPage(MultiPage(
//       pageFormat:
//           PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
//       crossAxisAlignment: CrossAxisAlignment.start,
//       header: (Context context) {
//         if (context.pageNumber == 1) {
//           return null;
//         }
//         return Container(
//             alignment: Alignment.centerRight,
//             margin: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
//             padding: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
//             decoration: const BoxDecoration(
//                 border:
//                     BoxBorder(bottom: true, width: 0.5, color: PdfColors.grey)),
//             child: Text('Report',
//                 style: Theme.of(context)
//                     .defaultTextStyle
//                     .copyWith(color: PdfColors.grey)));
//       },
//       footer: (Context context) {
//         return Container(
//             alignment: Alignment.centerRight,
//             margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
//             child: Text('Page ${context.pageNumber} of ${context.pagesCount}',
//                 style: Theme.of(context)
//                     .defaultTextStyle
//                     .copyWith(color: PdfColors.grey)));
//       },
//       build: (Context context) => <Widget>[
//             Header(
//                 level: 0,
//                 child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       Text('Report', textScaleFactor: 2),
//                       PdfLogo()
//                     ])),
//             Header(level: 1, text: 'What is Lorem Ipsum?'),
//             Paragraph(
//                 text:
//                     'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.'),
//             Paragraph(
//                 text:
//                     'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using "Content here, content here", making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for "lorem ipsum" will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).'),
//             Header(level: 1, text: 'Where does it come from?'),
//             Paragraph(
//                 text:
//                     'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.'),
//             Paragraph(
//                 text:
//                     'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.'),
//             Padding(padding: const EdgeInsets.all(10)),
//             Table.fromTextArray(context: context, data: const <List<String>>[
//               <String>['Year', 'Ipsum', 'Lorem'],
//               <String>['2000', 'Ipsum 1.0', 'Lorem 1'],
//               <String>['2001', 'Ipsum 1.1', 'Lorem 2'],
//               <String>['2002', 'Ipsum 1.2', 'Lorem 3'],
//               <String>['2003', 'Ipsum 1.3', 'Lorem 4'],
//               <String>['2004', 'Ipsum 1.4', 'Lorem 5'],
//               <String>['2004', 'Ipsum 1.5', 'Lorem 6'],
//               <String>['2006', 'Ipsum 1.6', 'Lorem 7'],
//               <String>['2007', 'Ipsum 1.7', 'Lorem 8'],
//               <String>['2008', 'Ipsum 1.7', 'Lorem 9'],
//             ]),
//           ]));

//   //save PDF
//   var dir = await getExternalStorageDirectory();
//   final String path = '${dir.path}/report.pdf';
//   final File file = File(path);
//   await file.writeAsBytes(pdf.save());
//   material.Navigator.of(context).push(
//     material.MaterialPageRoute(
//       builder: (_) => PdfViewerPage(path: path),
//     ),
//   );
// }
