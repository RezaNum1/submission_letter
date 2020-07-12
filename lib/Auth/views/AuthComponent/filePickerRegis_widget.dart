import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FilePickerRegis extends StatefulWidget {
  String title;
  Function(File) setFileAtt;
  FilePickerRegis({this.title, this.setFileAtt});
  @override
  _FilePickerRegisState createState() => _FilePickerRegisState();
}

class _FilePickerRegisState extends State<FilePickerRegis> {
  bool valFile = true;
  void getMyFile() async {
    File val = await FilePicker.getFile(
        type: FileType.custom, allowedExtensions: ['jpg', 'png', 'jpeg']);
    print(val.lengthSync());
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
    double height = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "${widget.title}:",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: height == 716 ? 15 : 17),
          ),
          Container(
            width: double.infinity,
            child: RaisedButton(
                child: Text(
                  "Upload",
                  style: TextStyle(fontSize: height == 716 ? 15 : 20),
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
              ? Text("Bentuk File Yang Diterima: .jpg / .jpeg / .png",
                  style: TextStyle(
                      color: Colors.red, fontSize: height == 716 ? 10 : 12))
              : Text(
                  "Tipe File Tidak Di izinkan, Upload File .jpg, .jpeg atau .png & < 3mb",
                  style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}
