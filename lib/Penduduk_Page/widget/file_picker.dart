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
  bool valFile = true;
  void getMyFile() async {
    File val = await FilePicker.getFile(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'png', 'jpeg']);
    var filenameVal = val.path.split("/").last.split(".");
    if (filenameVal[1] != 'jpg') {
      setState(() {
        valFile = false;
      });
    }
    if (filenameVal[1] != 'png') {
      setState(() {
        valFile = false;
      });
    }
    if (filenameVal[1] != 'jpeg') {
      setState(() {
        valFile = false;
      });
    }

    if (filenameVal[1] == 'jpeg' ||
        filenameVal[1] == 'png' ||
        filenameVal[1] == 'jpg') {
      if (val.lengthSync() > 30000000) {
        setState(() {
          valFile = false;
        });
      } else {
        setState(() {
          valFile = true;
          widget.setFileAtt(val);
        });
      }
    }
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
          valFile
              ? Container()
              : Text(
                  "Tipe File Tidak Di izinkan, Upload File .jpg, .jpeg atau .png & Harus < 3mb",
                  style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}
