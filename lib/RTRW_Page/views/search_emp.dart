import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_letter/Animation/fade_animation.dart';
import 'package:submission_letter/RTRW_Page/presenter/selesai_presenter.dart';
import 'package:submission_letter/RTRW_Page/views/detai_empSelesai.dart';
import 'package:submission_letter/RTRW_Page/widget/dropdown_searchEmp.dart';
import 'package:submission_letter/Theme/theme_emp.dart';
import 'package:submission_letter/Util/util_auth.dart';
import 'package:submission_letter/Util/util_rtrw.dart';

class SearchEmp extends StatefulWidget {
  @override
  _SearchEmpState createState() => _SearchEmpState();
}

class _SearchEmpState extends State<SearchEmp> {
  bool clicked = false;
  bool noPengajuanStat = false;
  bool nikStat = false;
  bool noSuratRTRWStat = false;
  bool startDateStat = false;
  bool toDateStat = false;

  //validate
  bool _valNoPengajuan = true;
  bool _valNik = true;
  bool _valSuratRTRW = true;
  bool _valStartDateStat = true;
  bool _valToDateStat = true;

  // Controller
  var noPengajuanController = new TextEditingController();
  var nikController = new TextEditingController();
  var noSuratRTRWController = new TextEditingController();
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

  String nama;
  String jabatanText;
  int id;
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
      id = pref.getInt("Id");
    });
  }

  void dispose() {
    super.dispose();
  }

  void resetData() {
    setState(() {
      clicked = false;
      noPengajuanStat = false;
      nikStat = false;
      noSuratRTRWStat = false;
      startDateStat = false;
      toDateStat = false;

      //validate
      _valNoPengajuan = true;
      _valNik = true;
      _valSuratRTRW = true;
      _valStartDateStat = true;
      _valToDateStat = true;

      // Controller
      noPengajuanController.text = "";
      nikController.text = "";
      noSuratRTRWController.text = "";
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
        nikStat = false;
        noSuratRTRWStat = false;
        startDateStat = false;
        toDateStat = false;
      });
    } else if (txt == "2") {
      setState(() {
        nikStat = true;
        searchCode = txt;
        noPengajuanStat = false;
        noSuratRTRWStat = false;
        startDateStat = false;
        toDateStat = false;
      });
    } else if (txt == "3") {
      setState(() {
        noSuratRTRWStat = true;
        searchCode = txt;
        noPengajuanStat = false;
        nikStat = false;
        startDateStat = false;
        toDateStat = false;
      });
    } else if (txt == "4") {
      setState(() {
        startDateStat = true;
        toDateStat = true;
        searchCode = txt;
        noSuratRTRWStat = false;
        noPengajuanStat = false;
        nikStat = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
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
                                    fontSize: height == 716 ? 20 : 30,
                                    color: Colors.orange),
                              ),
                              Divider(
                                color: Colors.orange,
                                thickness: 2,
                              )
                            ],
                          ),
                        ),
                        DropDownSearchEmp(
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
                        nikStat
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
                                        labelText: 'NIK Pemohon',
                                        hintText: "Masukkan Nik Pemohon",
                                        hintStyle: TextStyle(
                                          color: Colors.grey[400],
                                        ),
                                        errorText: _valNik == false
                                            ? "Masukkan Nama Pemohon!"
                                            : null),
                                    controller: nikController,
                                  ),
                                ))
                            : Container(),
                        noSuratRTRWStat
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
                                        labelText: 'No Surat RT / RW',
                                        hintText: "Masukkan No Surat RT / RW",
                                        hintStyle: TextStyle(
                                          color: Colors.grey[400],
                                        ),
                                        errorText: _valSuratRTRW == false
                                            ? "Masukkan No Surat RT / RW!"
                                            : null),
                                    controller: noSuratRTRWController,
                                  ),
                                ))
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
                                      if (nikController.text.isNotEmpty) {
                                        setState(() {
                                          _valNik = true;
                                        });
                                        _findDataSelesai();
                                      } else {
                                        setState(() {
                                          _valNik = false;
                                        });
                                      }
                                    } else if (searchCode == "3") {
                                      if (noSuratRTRWController
                                          .text.isNotEmpty) {
                                        setState(() {
                                          _valSuratRTRW = true;
                                        });
                                        _findDataSelesai();
                                      } else {
                                        setState(() {
                                          _valSuratRTRW = false;
                                        });
                                      }
                                    } else if (searchCode == "4") {
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
                          dataFull[index]["idJobPos"].toString(),
                          dataFull[index]["idSurat"].toString(),
                          dataFull[index]["tipe"].toString(),
                          dataFull[index]["penduduk"],
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
    SelesaiPresenter presenter = new SelesaiPresenter();
    List<Map<String, dynamic>> allData;
    if (searchCode == "1") {
      allData = await presenter.findDataSelesaiApi(
          noPengajuanController.text, searchCode, id);
    } else if (searchCode == "2") {
      allData = await presenter.findDataSelesaiApi(
          nikController.text, searchCode, id);
    } else if (searchCode == "3") {
      print(noSuratRTRWController.text);
      allData = await presenter.findDataSelesaiApi(
          noSuratRTRWController.text, searchCode, id);
    } else if (searchCode == "4") {
      var startEnd = "$startDate $toDate";
      allData = await presenter.findDataSelesaiApi(startEnd, searchCode, id);
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

  Widget suratWidget(String idJobPos, String idSurat, String tipe, String nama,
      String tanggal) {
    String titleName;
    String subTitleName;

    // Custom Text
    if (tipe == "1") {
      titleName = "SKTM";
      subTitleName = "Pengajuan Surat Keterangan Kemiskinan";
    } else if (tipe == "2") {
      titleName = "SD";
      subTitleName = "Pengajuan Surat Keterangan Domisili";
    } // kurnng
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
                  "Pemohon : $nama",
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
              DetailEmpSelesai(
                idJobPos: idJobPos,
                idSurat: idSurat,
                namaPenduduk: nama,
                tanggal: tanggal,
                tipe: tipe,
              ));
        },
      ),
    );
  }
}
