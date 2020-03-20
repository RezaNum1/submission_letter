import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneWidget extends StatefulWidget {
  Function(String) callBackName;
  bool vals;
  PhoneWidget({this.callBackName, this.vals});

  @override
  _PhoneWidgetState createState() => _PhoneWidgetState();
}

class _PhoneWidgetState extends State<PhoneWidget> {
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
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        onChanged: (text) {
          setState(() {
            widget.callBackName(text);
          });
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Masukkan No Telepon Aktif Anda',
          labelText: 'No Telepon',
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
