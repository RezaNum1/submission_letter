import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NikWidget extends StatefulWidget {
  Function(String) callBackName;
  bool vals;
  NikWidget({this.callBackName, this.vals});

  @override
  _NikWidgetState createState() => _NikWidgetState();
}

class _NikWidgetState extends State<NikWidget> {
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
          hintText: 'NIK',
          labelText: 'No NIK',
          labelStyle: TextStyle(
            color: Colors.grey[400],
          ),
          hintStyle: TextStyle(
            color: Colors.grey[400],
          ),
          errorText: (widget.vals == false) ? 'NIK Tidak Boleh Kosong' : null,
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}
