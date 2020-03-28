import 'package:flutter/material.dart';

class FormWidget extends StatefulWidget {
  String judul;
  String buttonText;
  String tipe;
  String posisi;
  FormWidget({this.judul, this.buttonText, this.tipe, this.posisi});
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
                print("Hello"); // proses manggil halamanya di sini
              },
            ),
          ),
        ],
      ),
    );
  }
}
