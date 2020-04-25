import 'package:flutter/material.dart';

class DropDownSearchPend extends StatefulWidget {
  Function(String) changeFunc;
  DropDownSearchPend({this.changeFunc});
  @override
  _DropDownSearchPendState createState() => _DropDownSearchPendState();
}

class _DropDownSearchPendState extends State<DropDownSearchPend> {
  String _mySelection;
  bool stat = false;

  // List data = List(); //edited line
  var data = [
    {'item_name': 'No Pengajuan', 'id': '1'},
    {'item_name': 'Tanggal', 'id': '2'},
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Cari Surat Berdasarkan:",
            style: TextStyle(fontSize: 14),
          ),
          Container(
            padding: EdgeInsets.all(1),
            margin: EdgeInsets.symmetric(vertical: 10),
            width: double.infinity,
            child: new DropdownButton(
              iconEnabledColor: Colors.orange,
              isExpanded: true,
              items: data.map((item) {
                return new DropdownMenuItem(
                  child: new Text(item['item_name']),
                  value: item['id'].toString(),
                );
              }).toList(),
              onChanged: (newVals) {
                setState(() {
                  _mySelection = newVals;
                  widget.changeFunc(newVals);
                });
              },
              value: _mySelection,
            ),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: Colors.orange, width: 1.0, style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
