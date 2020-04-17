import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpWidgetNumber extends StatefulWidget {
  Function(String) callBackName;
  bool vals;
  OtpWidgetNumber({this.callBackName, this.vals});
  @override
  _OtpWidgetNumberState createState() => _OtpWidgetNumberState();
}

class _OtpWidgetNumberState extends State<OtpWidgetNumber> {
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
            color: Colors.grey[100],
          ),
        ),
      ),
      child: TextField(
        maxLength: 6,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        onChanged: (text) {
          setState(() {
            widget.callBackName(text);
          });
        },
        decoration: InputDecoration(
          hintText: 'Masukkan Kode Aktivasi',
          labelText: 'Kode OTP',
          labelStyle: TextStyle(
            color: Colors.grey[400],
          ),
          hintStyle: TextStyle(
            color: Colors.grey[400],
          ),
          errorText:
              (widget.vals == false) ? 'No Telepon Tidak Boleh Kosong' : null,
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}
