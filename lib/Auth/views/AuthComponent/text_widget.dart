import 'package:flutter/material.dart';

class TextWidget extends StatefulWidget {
  // TextEditingController namaController;
  String hintTexts;
  String labelTexts;
  Function(String) callBackName;
  String messageEmpty;
  bool val;
  bool pass;
  bool emails;

  TextWidget(
      {this.hintTexts,
      this.labelTexts,
      this.callBackName,
      this.messageEmpty,
      this.val,
      this.pass,
      this.emails});

  @override
  _TextWidgetState createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  void changeCallBack(String texts) {
    setState(() {
      widget.callBackName(texts);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[400],
          ),
        ),
      ),
      child: TextField(
        obscureText: (widget.pass == true) ? true : false,
        keyboardType:
            (widget.emails == true) ? TextInputType.emailAddress : null,
        onChanged: (text) {
          setState(() {
            widget.callBackName(text);
          });
        },
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.hintTexts,
            labelText: widget.labelTexts,
            labelStyle: TextStyle(
              color: Colors.grey[400],
            ),
            hintStyle: TextStyle(
              color: Colors.grey[400],
            ),
            errorText: (widget.val == false) ? '${widget.messageEmpty}' : null),
      ),
    );
  }
}
