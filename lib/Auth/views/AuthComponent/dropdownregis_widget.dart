import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DropDownRegis extends StatefulWidget {
  Function(String) dataRw;
  Function(String) dataRt;
  DropDownRegis({this.dataRw, this.dataRt});
  @override
  _DropDownRegisState createState() => _DropDownRegisState();
}

class _DropDownRegisState extends State<DropDownRegis> {
  String _mySelection;
  String _mySelections;
  int index;
  bool stat = false;

  final String url = "http://192.168.43.75:8000/api/auth/getJabatanRegis";

  List data = List(); //edited line
  List<dynamic> tmp = List();
  List sec = List();

  Future<String> getAllData() async {
    Dio dio = new Dio();
    var res = await dio.get(url);
    setState(() {
      data = res.data[0];
      tmp = res.data[1];
    });
    return "Sucess";
  }

  @override
  void initState() {
    super.initState();
    this.getAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Pilih RW (Rukun Warga) Anda:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          new DropdownButton(
            items: data.map((item) {
              return new DropdownMenuItem(
                child: new Text(item['item_name']),
                value: item['id'].toString(),
              );
            }).toList(),
            onChanged: (newVal) {
              setState(() {
                _mySelection = newVal;
                index = int.parse(newVal);
                widget.dataRw(data[int.parse(newVal)]['item_name']);
                sec = tmp[index];
                _mySelections = sec[0];
                stat = true;
              });
            },
            value: _mySelection,
          ),
          stat
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Pilih RT (Rukun Tetangga) Anda:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    new DropdownButton(
                      items: sec.map((items) {
                        return new DropdownMenuItem(
                          child: new Text(items),
                          value: items,
                        );
                      }).toList(),
                      onChanged: (newVals) {
                        setState(() {
                          _mySelections = newVals;
                          widget.dataRt(newVals);
                        });
                      },
                      value: _mySelections,
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
