import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

class TestPages extends StatefulWidget {
  Function(String) dataRw;
  Function(String) dataRt;
  TestPages({this.dataRw, this.dataRt});
  @override
  _TestPagesState createState() => _TestPagesState();
}

class _TestPagesState extends State<TestPages> {
  String _myRw;
  // String _myRt;
  int index;
  List<dynamic> arrRw = [];
  // List<dynamic> arrRt = [];
  // List<dynamic> tmpRt = [];
  final formKey = new GlobalKey<FormState>();

  bool statRt = false;

  var url = "http://192.168.43.75:8000/test/jabatan";

  Future<void> data() async {
    Dio dio = new Dio();
    var res = await dio.get(url);

    for (var i = 0; i < res.data[0].length; i++) {
      setState(() {
        arrRw.add({
          "display": res.data[0][i],
          "value": i,
        });
      });
    }

    // // print("sdasadasdsds");
    // // for (var i = 0; i < res.data[1].length; i++) {
    // //   for (var l = 0; l < res.data[1][i].length; l++) {
    // //     tmpRt.add({
    // //       "display": res.data[1][i][l],
    // //       "value": res.data[1][i][l],
    // //     });
    // //   }
    // //   setState(() {
    // //     arrRt.add(tmpRt);
    // //     tmpRt = [];
    // //   });
    // }
  }

  // List<dynamic> bee = [
  //   {
  //     "display": "RW 001",
  //     "value": "0",
  //   },
  //   {
  //     "display": "RW 002",
  //     "value": "1",
  //   },
  //   {
  //     "display": "RW 003",
  //     "value": "2",
  //   },
  // ];

  // List<dynamic> arrRt = [
  //   [
  //     {
  //       "display": "RT 001",
  //       "value": "RT 001",
  //     },
  //     {
  //       "display": "RT 002",
  //       "value": "RT 002",
  //     },
  //   ],
  //   [
  //     {
  //       "display": "RT 003",
  //       "value": "RT 003",
  //     },
  //     {
  //       "display": "RT 004",
  //       "value": "RT 004",
  //     },
  //   ],
  //   [
  //     {
  //       "display": "RT 005",
  //       "value": "RT 005",
  //     },
  //     {
  //       "display": "RT 005",
  //       "value": "RT 005",
  //     },
  //   ]
  // ];

  @override
  void initState() {
    super.initState();
    _myRw = '';
    // _myRt = '';
    data();
  }

  _saveForm1() {
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        widget.dataRw(_myRw);
      });
    }
  }

  // _saveForm2() {
  //   var form = formKey.currentState;
  //   if (form.validate()) {
  //     form.save();
  //     setState(() {
  //       widget.dataRt(_myRt);
  //     });
  //   }
  // }

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
                titleText: 'Pilih RW',
                hintText: 'Pilih RW',
                value: _myRw,
                // onSaved: (value) {
                //   print("eeeee");
                //   setState(() {
                //     _myRw = value;
                //   });
                // },
                onChanged: (value) {
                  print(arrRw);
                  setState(() {
                    _myRw = arrRw[value]['display'];
                    // widget.dataRw(arrRw[value]['display']);
                    // print("heeee");
                    // index = value;
                    // statRt = true;
                  });
                },
                dataSource: arrRw,
                textField: 'display',
                valueField: 'value',
              ),
            ),
            // statRt
            //     ? Container(
            //         padding: EdgeInsets.all(16),
            //         child: DropDownFormField(
            //           titleText: 'Pilih RT',
            //           hintText: 'Pilih RT Tempat Tinggal Anda',
            //           value: _myRt,
            //           onSaved: (value) {
            //             setState(() {
            //               _myRt = value;
            //             });
            //           },
            //           onChanged: (value) {
            //             setState(() {
            //               _myRt = value;
            //               widget.dataRt(value);
            //             });
            //           },
            //           dataSource: arrRt[index],
            //           textField: 'display',
            //           valueField: 'value',
            //         ),
            //       )
            //     : Container(),
            Container(
              padding: EdgeInsets.all(8),
              child: RaisedButton(
                child: Text('Save'),
                onPressed: () {
                  print(arrRw);
                },
              ),
            ),
            // Container(
            //   padding: EdgeInsets.all(8),
            //   child: RaisedButton(
            //     child: Text('Save1'),
            //     onPressed: _saveForm2,
            //   ),
            // ),
            // Container(
            //   padding: EdgeInsets.all(16),
            //   child: Text(_myActivityResult1),
            // ),
            // Container(
            //   padding: EdgeInsets.all(16),
            //   child: Text(_myActivityResult2),
            // )
          ],
        ),
      ),
    );
  }
}
