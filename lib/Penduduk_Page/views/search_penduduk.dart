import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_letter/Animation/fade_animation.dart';
import 'package:submission_letter/Penduduk_Page/APP_TabBar/selesai_penduduk.dart';
import 'package:submission_letter/Penduduk_Page/presenter/selesaip_presenter.dart';
import 'package:submission_letter/Penduduk_Page/views/detailp_selesai.dart';
import 'package:submission_letter/Penduduk_Page/widget/dropdown_searchpend.dart';
import 'package:submission_letter/Theme/theme_emp.dart';
import 'package:submission_letter/Theme/theme_penduduk.dart';
import 'package:submission_letter/Util/util_auth.dart';
import 'package:submission_letter/Util/util_rtrw.dart';

class SearchPenduduk extends StatefulWidget {
  @override
  _SearchPendudukState createState() => _SearchPendudukState();
}

class _SearchPendudukState extends State<SearchPenduduk> {
  bool clicked = false;
  bool noPengajuanStat = false;
  bool startDateStat = false;
  bool toDateStat = false;

  //validate
  bool _valNoPengajuan = true;
  bool _valStartDateStat = true;
  bool _valToDateStat = true;

  // Controller
  var noPengajuanController = new TextEditingController();
  String startDate;
  String toDate;

  //Search Code
  String searchCode;
  bool searchMode = false;

  //
  bool master = false;

  //data
  List<Map<String, dynamic>> dataFull = [];

  // label name date picker;
  String startDateText = "Pilih Tanggal Mulai";
  String toDateText = "Pilih Tanggal Selesai";

  int idUserPenduduk;
  String noTelepon;
  String nik;
  int tipeUser;

  @override
  void initState() {
    setPreference();
    super.initState();
  }

  Future<void> setPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      idUserPenduduk = pref.getInt("Id");
      noTelepon = pref.getString("NoTelepon");
      nik = pref.getString("Nik");
      tipeUser = pref.getInt("TipeUser");
    });
  }

  void dispose() {
    super.dispose();
  }

  void resetData() {
    setState(() {
      clicked = false;
      noPengajuanStat = false;
      startDateStat = false;
      toDateStat = false;

      //validate
      _valNoPengajuan = true;
      _valStartDateStat = true;
      _valToDateStat = true;

      // Controller
      noPengajuanController.text = "";
      startDate = "";
      toDate = "";
      //Search Code
      searchCode = "";
      searchMode = false;

      //
      master = false;

      //data
      dataFull = [];

      //Text
      startDateText = "Pilih Tanggal Mulai";
      toDateText = "Pilih Tanggal Selesai";
    });
  }

  void changeFuncStat(String txt) {
    setState(() {
      clicked = true;
    });
    if (txt == "1") {
      setState(() {
        noPengajuanStat = true;
        searchCode = txt;
        startDateStat = false;
        toDateStat = false;
      });
    } else if (txt == "2") {
      setState(() {
        startDateStat = true;
        toDateStat = true;
        searchCode = txt;
        noPengajuanStat = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double fontSizes = height == 716 ? 13 : 15;
    double titleSizes = height == 716 ? 20 : 30;
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
      drawer: ThemeAppPenduduk.sideBar(context, "31992039290192", "0188291881"),
      body: Container(
        child: master == false
            ? ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 30, left: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Cari Surat Selesai",
                                style: TextStyle(
                                    fontSize: titleSizes, color: Colors.orange),
                              ),
                              Divider(
                                color: Colors.orange,
                                thickness: 2,
                              )
                            ],
                          ),
                        ),
                        DropDownSearchPend(
                          changeFunc: changeFuncStat,
                        ),
                        noPengajuanStat
                            ? FadeAnimation(
                                0.1,
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                  ),
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  child: TextField(
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelText: 'No Pengajuan',
                                        hintText: "Masukkan No Pengajuan",
                                        hintStyle: TextStyle(
                                          color: Colors.grey[400],
                                        ),
                                        errorText: _valNoPengajuan == false
                                            ? "Masukkan No Pengajuan!"
                                            : null),
                                    controller: noPengajuanController,
                                  ),
                                ),
                              )
                            : Container(),
                        startDateStat
                            ? FadeAnimation(
                                0.1,
                                Column(
                                  children: <Widget>[
                                    Text("MULAI:"),
                                    Center(
                                      child: FlatButton(
                                          onPressed: () {
                                            DatePicker.showDatePicker(context,
                                                showTitleActions: true,
                                                minTime: DateTime(2018, 3, 5),
                                                maxTime: DateTime(2045, 1, 1),
                                                onConfirm: (date) {
                                              setState(() {
                                                var dt =
                                                    date.toString().split(" ");
                                                startDateText = "${dt[0]}";
                                                startDate = dt[0].toString();
                                              });
                                            },
                                                currentTime: DateTime.now(),
                                                locale: LocaleType.id);
                                          },
                                          child: Text(
                                            '$startDateText',
                                            style:
                                                TextStyle(color: Colors.blue),
                                          )),
                                    ),
                                    Text("SAMPAI:"),
                                    Center(
                                      child: FlatButton(
                                          onPressed: () {
                                            DatePicker.showDatePicker(context,
                                                showTitleActions: true,
                                                minTime: DateTime(2018, 3, 5),
                                                maxTime: DateTime(2045, 1, 1),
                                                onConfirm: (date) {
                                              setState(() {
                                                var dtt =
                                                    date.toString().split(" ");
                                                toDateText = "${dtt[0]}";
                                                toDate = dtt[0].toString();
                                              });
                                            },
                                                currentTime: DateTime.now(),
                                                locale: LocaleType.id);
                                          },
                                          child: Text(
                                            '$toDateText',
                                            style:
                                                TextStyle(color: Colors.blue),
                                          )),
                                    ),
                                    _valStartDateStat == false ||
                                            _valToDateStat == false
                                        ? Text(
                                            "Pilih Tanggal Mulai Dan Selesai!",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : Container()
                                  ],
                                ),
                              )
                            : Container(),
                        clicked
                            ? Container(
                                margin: EdgeInsets.only(top: 10),
                                width: double.infinity,
                                child: RaisedButton(
                                  color: Colors.orange[300],
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color: Colors.orange[300])),
                                  child: Text(
                                    "Cari",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  onPressed: () {
                                    if (searchCode == "1") {
                                      if (noPengajuanController
                                          .text.isNotEmpty) {
                                        setState(() {
                                          _valNoPengajuan = true;
                                        });

                                        _findDataSelesai();
                                      } else {
                                        setState(() {
                                          _valNoPengajuan = false;
                                        });
                                      }
                                    } else if (searchCode == "2") {
                                      if (startDate != null) {
                                        setState(() {
                                          _valStartDateStat = true;
                                        });
                                        if (toDate != null) {
                                          setState(() {
                                            _valToDateStat = true;
                                          });
                                          _findDataSelesai();
                                        } else {
                                          _valToDateStat = false;
                                        }
                                      } else {
                                        setState(() {
                                          _valStartDateStat = false;
                                        });
                                      }
                                    }
                                  },
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 2,
                    color: Colors.orange,
                  ),
                ],
              )
            : Column(
                children: <Widget>[
                  Flexible(
                    child: ListView.builder(
                      itemCount: dataFull.length,
                      itemBuilder: (BuildContext context, int index) {
                        return suratWidget(
                          dataFull[index]["idSurat"].toString(),
                          dataFull[index]["tipe"].toString(),
                          dataFull[index]["noPengajuan"],
                          UtilRTRW.convertDateTime(
                            dataFull[index]["tanggal"],
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 30),
                    child: new GestureDetector(
                      onTap: () {
                        resetData();
                      },
                      child: new Text(
                        "Cari Surat Kembali?",
                        style: TextStyle(
                            color: Colors.orange,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }

  Future<void> _findDataSelesai() async {
    SelesaipPresenter presenter = new SelesaipPresenter();
    List<Map<String, dynamic>> allData;
    if (searchCode == "1") {
      allData = await presenter.findDataSelesaiApiPenduduk(
          noPengajuanController.text, searchCode, idUserPenduduk);
    } else if (searchCode == "2") {
      var startEnd = "$startDate $toDate";
      allData = await presenter.findDataSelesaiApiPenduduk(
          startEnd, searchCode, idUserPenduduk);
    }

    if (allData.isEmpty) {
      dataFull = [];
    } else {
      setState(() {
        for (var i = 0; i < allData.length; i++) {
          dataFull.add(allData[i]);
        }
      });
    }

    setState(() {
      master = true;
    });
  }

  Widget suratWidget(
      String idSurat, String tipe, String noPengajuan, String tanggal) {
    String titleName;
    String subTitleName;

    // Custom Text
    if (tipe == "1") {
      titleName = "SKTM";
      subTitleName = "Pengajuan Surat Keterangan Kemiskinan";
    } else if (tipe == "2") {
      titleName = "SD";
      subTitleName = "Pengajuan Surat Keterangan Domisili";
    } else if (tipe == "3") {
      titleName = "SPIK";
      subTitleName = "Pengajuan Surat Pengantar Izin Keramaian";
    } else if (tipe == "4") {
      titleName = "SKBM";
      subTitleName = "Pengajuan Surat Keterangan Belum Menikah";
    } else if (tipe == "5") {
      titleName = "SKC";
      subTitleName = "Pengajuan Surat Keterangan Cerai Hidup / Mati";
    } else if (tipe == "6") {
      titleName = "SKD";
      subTitleName = "Pengajuan Surat Keterangan Domisili";
    } else if (tipe == "7") {
      titleName = "SKK";
      subTitleName = "Pengajuan Surat Keterangan Kematian";
    } else if (tipe == "8") {
      titleName = "SKP";
      subTitleName = "Pengajuan Surat Keterangan Pindah";
    }
    return Card(
      child: ListTile(
        title: Row(
          children: <Widget>[
            Container(
              child: Center(
                child: Text(
                  "$titleName",
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
                  "$subTitleName",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "No Pengajuan : $noPengajuan",
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
              DetailpSelesai(
                idSurat: idSurat,
                tipe: tipe,
              ));
        },
      ),
    );
  }
}
