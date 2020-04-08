import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:submission_letter/Util/util_auth.dart';

class TestForm extends StatefulWidget {
  @override
  _TestFormState createState() => _TestFormState();
}

class _TestFormState extends State<TestForm> {
  var _nikController = TextEditingController();
  var _kkController = TextEditingController();
  var _alamatController = TextEditingController();
  var _namaController = TextEditingController();
  var _agamaController = TextEditingController();

  String nik;
  String kk;
  String alamat;
  String nama;
  String agama;

  Widget popups(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        // return Dialog(
        return AlertDialog(
          title: Text('Peringatan!'),
          content: ListView(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Username',
                  hintText: "Masukkan Username Anda",
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                ),
                controller: _nikController,
              ),
              TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'No KK',
                  hintText: "Masukkan No KK Anda",
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                ),
                controller: _kkController,
              ),
              TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Alamat',
                  hintText: "Masukkan Alamat Anda",
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                ),
                controller: _alamatController,
              ),
              TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Nama',
                  hintText: "Masukkan Nama Anda",
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                ),
                controller: _namaController,
              ),
              TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Agama',
                  hintText: "Masukkan Agama Anda",
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                ),
                controller: _agamaController,
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                //SetState di sini
                Navigator.of(context).pop();
              },
            )
          ],
        );
        // );
      },
    );
  }

  void process(BuildContext context) async {
    UtilAuth.loading(context);
    var url = "http://192.168.43.75:8000/test/surats";
    Map<String, dynamic> data = {"nama": 'hello', "nik": '1234'};
    Dio dio = new Dio();
    FormData formData = new FormData.fromMap({
      "data": data,
    });
    var response = await dio.post(url, data: formData);
    if (response.data['message'] == true) {
      popups(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Form"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text("Test"),
              onPressed: () {
                process(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
