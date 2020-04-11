import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:submission_letter/test.dart';

class CallPage extends StatefulWidget {
  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  String rwText;
  String rtText;
  // List<dynamic> arrayRT;
  // List<dynamic> arrayRW;

  void setRwText(String val) {
    setState(() {
      rwText = val;
    });
  }

  void setRtText(String val) {
    setState(() {
      rtText = val;
    });
  }

  // Widget formRTRW(List<dynamic> arrayRW, List<dynamic> arrayRT) {
  //   print("lalalal");
  //   print(arrayRW);
  //   for (var i = 0; i < arrayRW.length; i++) {
  //     arrRw.add({
  //       "display": arrayRW[i],
  //       "value": i,
  //     });
  //   }

  //   print("sdasadasdsds");
  //   for (var i = 0; i < arrayRT.length; i++) {
  //     for (var l = 0; l < arrayRT[i].length; l++) {
  //       tmpRt.add({
  //         "display": arrayRT[i][l],
  //         "value": arrayRT[i][l],
  //       });
  //     }
  //     arrRt.add(tmpRt);

  //     tmpRt = [];
  //   }
  //   print("wkwkwk");

  //   return
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Drop Down"),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            TestPages(
              dataRw: setRwText,
              dataRt: setRtText,
            ),
            RaisedButton(
              child: Text("Print Rw"),
              onPressed: () {
                print(rwText);
              },
            ),
            RaisedButton(
              child: Text("Print Rt"),
              onPressed: () {
                print(rtText);
              },
            ),
            RaisedButton(
              child: Text("Print Data"),
              onPressed: () {
                // data();
              },
            ),
          ],
        ),
      ),
    );
  }
}
