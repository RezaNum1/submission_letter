import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:submission_letter/RTRW_Page/views/display_file.dart';

class FormWidget extends StatefulWidget {
  String judul;
  String buttonText;
  String berkas;
  String idSurat;
  FormWidget({this.judul, this.buttonText, this.berkas, this.idSurat});
  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "${widget.judul}:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          Container(
            width: double.infinity,
            child: RaisedButton(
              child: Text("${widget.buttonText}"),
              textColor: Colors.white,
              color: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.orange),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => DisplayFile(
                      berkas: widget.berkas,
                      idSurat: widget.idSurat,
                    ),
                  ),
                ); // proses manggil halamanya di sini
              },
            ),
          ),
        ],
      ),
    );
  }
}
