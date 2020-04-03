import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:submission_letter/RTRW_Page/presenter/detailEmployee_presenter.dart';

class DisplayFile extends StatefulWidget {
  String berkas;
  String idSurat;

  DisplayFile({this.berkas, this.idSurat});
  @override
  _DisplayFileState createState() => _DisplayFileState();
}

class _DisplayFileState extends State<DisplayFile> {
  Future<Uint8List> callFile() async {
    DetailEmployeePresenter presenter = new DetailEmployeePresenter();
    var response =
        await presenter.callFileToServer(widget.berkas, widget.idSurat);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Berkas"),
      ),
      body: FutureBuilder(
        future: callFile(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return RotatedBox(
              quarterTurns: 1,
              child: Container(
                child: Image.memory(snapshot.data),
              ),
            );
          } else {
            return Container(
              child: Center(
                child: Text('Loading...'),
              ),
            );
          }
        },
      ),
    );
  }
}
