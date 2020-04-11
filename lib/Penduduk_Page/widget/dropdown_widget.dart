import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';

class DropDownWidget extends StatefulWidget {
  Function(String) dataRw;
  Function(String) dataRt;
  DropDownWidget({this.dataRw, this.dataRt});
  @override
  _DropDownWidgetState createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  String _myRw;
  String _myRt;
  int index;

  final formKey = new GlobalKey<FormState>();

  bool statRt = false;

  @override
  void initState() {
    super.initState();
    _myRw = '';
    _myRt = '';
  }

  List<dynamic> rw = [
    {
      "display": "RW 01",
      "value": "0",
    },
    {
      "display": "RW 02",
      "value": "1",
    },
    {
      "display": "RW 03",
      "value": "2",
    },
  ];

  List<dynamic> rt = [
    {
      "display": "RT 001",
      "value": "RT 001",
    },
    {
      "display": "RT 002",
      "value": "RT 002",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              child: DropDownFormField(
                required: true,
                titleText: 'Pilih RW',
                hintText: 'Pilih RW Setempat',
                value: _myRw,
                onSaved: (value) {
                  setState(() {
                    _myRw = value;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    _myRw = value;
                    widget.dataRw(rw[int.parse(value)]['display']);
                    statRt = true;
                  });
                },
                dataSource: rw,
                textField: 'display',
                valueField: 'value',
              ),
            ),
            statRt
                ? Container(
                    padding: EdgeInsets.all(16),
                    child: DropDownFormField(
                      required: true,
                      titleText: 'Pilih RT',
                      hintText: 'Pilih RT Tempat Tinggal Anda',
                      value: _myRt,
                      onSaved: (value) {
                        setState(() {
                          _myRt = value;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          _myRt = value;
                          widget.dataRt(value);
                        });
                      },
                      dataSource: rt,
                      textField: 'display',
                      valueField: 'value',
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
