import 'dart:io';

import 'package:flutter/material.dart';

class UploadButton extends StatefulWidget {
  String title;
  String textButton;
  String redText;
  Function setFile;

  UploadButton({this.title, this.textButton, this.redText, this.setFile});
  @override
  _UploadButtonState createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${widget.title}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          RaisedButton(
            color: Colors.grey[200],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.white),
            ),
            child: Row(
              children: <Widget>[
                Icon(Icons.cloud_upload),
                SizedBox(
                  width: 5,
                ),
                Text('${widget.textButton}')
              ],
            ),
            onPressed: widget.setFile,
          ),
          Text(
            '( ${widget.redText} )',
            style: TextStyle(color: Colors.red),
          )
        ],
      ),
    );
  }
}
