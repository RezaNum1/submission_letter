import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FilePickerForm extends StatefulWidget {
  String title;
  Function(File) setFileAtt;
  FilePickerForm({this.title, this.setFileAtt});
  @override
  _FilePickerFormState createState() => _FilePickerFormState();
}

class _FilePickerFormState extends State<FilePickerForm> {
  void getMyFile() async {
    File val = await FilePicker.getFile(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'png', 'jpeg']);
    setState(() {
      widget.setFileAtt(val);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
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
                  "Perbaiki",
                  style: TextStyle(fontSize: 20),
                ),
                textColor: Colors.white,
                color: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.orange),
                ),
                onPressed: () {
                  getMyFile();
                }),
          ),
        ],
      ),
    );
  }
}
