import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:submission_letter/RTRW_Page/presenter/detailEmployee_presenter.dart';
import 'package:submission_letter/RTRW_Page/widget/pdf_viewer_page.dart';

class DisplayFile extends StatefulWidget {
  String berkas;
  String idSurat;

  DisplayFile({this.berkas, this.idSurat});
  @override
  _DisplayFileState createState() => _DisplayFileState();
}

class _DisplayFileState extends State<DisplayFile> {
  @override
  void initState() {
    super.initState();
    callFile();
  }

  void dispose() {
    super.dispose();
  }

  String tipe;
  bool progress = false;
  Uint8List imageBytes;

  Future<dynamic> callFile() async {
    DetailEmployeePresenter presenter = new DetailEmployeePresenter();
    var response =
        await presenter.callFileToServer(widget.berkas, widget.idSurat);

    setState(() {
      tipe = response[0];
    });

    if (response[0] == 'jpeg' || response[0] == 'jpg' || response[0] == 'png') {
      setState(() {
        progress = true;
        imageBytes = response[1];
      });
    } else {
      var bytes = response[1];
      var fileName = 'pdfPreview.pdf';
      String dir = (await getApplicationDocumentsDirectory()).path;
      var paths = "$dir/$fileName";
      File file = new File(paths);
      await file.writeAsBytes(bytes);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PdfViewerPage(
            path: paths,
          ),
        ),
      );
      setState(() {
        progress = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Berkas"),
      ),
      body: Container(
        child: progress == true
            ? tipe == "jpg" || tipe == "jpeg" || tipe == "png"
                ? Image.memory(imageBytes)
                : Container(
                    child: Center(
                      child: Text("PREVIEW PDF MODE"),
                    ),
                  )
            : Container(
                child: Center(
                  child: Text("Loading..."),
                ),
              ),
      ),
    );
  }
}
