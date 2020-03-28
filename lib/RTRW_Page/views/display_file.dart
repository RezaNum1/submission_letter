import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:submission_letter/RTRW_Page/presenter/detailEmployee_presenter.dart';

class DisplayFile extends StatefulWidget {
  String tipe;
  String posisi;
  String idSurat;

  DisplayFile({this.tipe, this.posisi, this.idSurat});
  @override
  _DisplayFileState createState() => _DisplayFileState();
}

class _DisplayFileState extends State<DisplayFile> {
  Future<Uint8List> callFile() async {
    DetailEmployeePresenter presenter = new DetailEmployeePresenter();
    var response = await presenter.callFileToServer(
        widget.posisi, widget.idSurat);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
