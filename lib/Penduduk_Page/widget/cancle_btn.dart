import 'dart:io';

import 'package:flutter/material.dart';

class CancleBtn extends StatefulWidget {
  String title;
  Function setFileNull;
  CancleBtn({this.setFileNull, this.title});
  @override
  _CancleBtnState createState() => _CancleBtnState();
}

class _CancleBtnState extends State<CancleBtn> {
  void setNullFile() {
    widget.setFileNull();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "${widget.title}:",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        Container(
          width: double.infinity,
          child: RaisedButton(
              child: Text(
                "Batal",
                style: TextStyle(fontSize: 20),
              ),
              textColor: Colors.white,
              color: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.red),
              ),
              onPressed: () {
                setNullFile();
              }),
        ),
      ],
    );
  }
}
