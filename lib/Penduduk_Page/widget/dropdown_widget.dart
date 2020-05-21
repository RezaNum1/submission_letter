import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:submission_letter/main.dart';

class DropDownWidget extends StatefulWidget {
  Function(String) dataRw;
  Function(String) dataRt;
  DropDownWidget({this.dataRw, this.dataRt});
  @override
  _DropDownWidgetState createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  String _mySelection;
  String _mySelections;
  int index;
  bool stat = false;

  final String url = "${MyApp.route}/api/penduduk/getJabatan";

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
    double height = MediaQuery.of(context).size.height;

    double titleSizes = height == 716 ? 14 : 18;
    return Container(
      margin: EdgeInsets.only(left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Pilih RW (Rukun Warga) Anda:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: titleSizes),
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
