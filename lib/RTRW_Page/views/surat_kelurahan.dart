import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:submission_letter/RTRW_Page/presenter/detailEmployeeSelesai_presenter.dart';
import 'package:submission_letter/RTRW_Page/presenter/detailEmployee_presenter.dart';
import 'package:submission_letter/RTRW_Page/presenter/selesai_presenter.dart';
import 'package:submission_letter/RTRW_Page/presenter/surat_kelurahan_presenter.dart';
import 'package:submission_letter/RTRW_Page/presenter/todo_presenter.dart';
import 'package:submission_letter/RTRW_Page/views/detai_empSelesai.dart';
import 'package:submission_letter/RTRW_Page/views/detail_emp.dart';
import 'package:submission_letter/RTRW_Page/views/detail_surat_kelurahan.dart';
import 'package:submission_letter/Theme/theme_emp.dart';
import 'package:submission_letter/Util/util_auth.dart';
import 'package:submission_letter/Util/util_rtrw.dart';

class SuratKelurahan extends StatefulWidget {
  @override
  _SuratKelurahanState createState() => _SuratKelurahanState();
}

class _SuratKelurahanState extends State<SuratKelurahan> {
  String nama;
  String jabatanText;

  @override
  void initState() {
    setPreference();
    super.initState();
  }

  Future<void> setPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      nama = pref.getString('Nama');
      jabatanText = pref.getString('Jabatan');
    });
  }

  void dispose() {
    super.dispose();
  }

  Widget suratWidget(
      String idPenerima, String idSurat, String noSurat, String tanggal) {
    // Custom Text

    return Card(
      child: ListTile(
        title: Row(
          children: <Widget>[
            Container(
              child: Center(
                child: Text(
                  "SK",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              height: 60,
              width: 60,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.orange),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Surat Masuk Kelurahan",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "No Surat  : $noSurat",
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                ),
                Text(
                  "Tanggal    : $tanggal",
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ],
            )
          ],
        ),
        onTap: () {
          UtilAuth.movePage(
              context,
              DetailSuratKelurahan(
                idSurat: idSurat,
              ));
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getListDataSurat() async {
    SuratKelurahanPresenter presenter = new SuratKelurahanPresenter();
    var allData = await presenter.getAll();
    if (allData.isEmpty) {
      return null;
    } else {
      return allData;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Container(
          margin: EdgeInsets.only(right: 50),
          height: 50,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/dki.png'),
            ),
          ),
        ),
      ),
      drawer:
          ThemeApp.sideBar(context, nama.toString(), jabatanText.toString()),
      body: Container(
        child: FutureBuilder(
          future: _getListDataSurat(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Container(
                child: Center(
                  child: Text('Loading...'),
                ),
              );
            } else {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return suratWidget(
                        snapshot.data[index]["id"].toString(),
                        snapshot.data[index]["idSurat"].toString(),
                        snapshot.data[index]["noSurat"].toString(),
                        UtilRTRW.convertDateTime(
                          snapshot.data[index]["tanggal"],
                        ),
                      );
                    });
              } else {
                return Container(
                  child: Center(
                    child: Text('Data Kosong'),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
