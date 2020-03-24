import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_letter/Notification/api/messaging.dart';
import 'package:submission_letter/Notification/model/message.dart';
import 'package:submission_letter/RTRW_Page/presenter/detailEmployee_presenter.dart';
import 'package:submission_letter/RTRW_Page/viewmodel/detailemp_viewmodel.dart';
import 'package:submission_letter/RTRW_Page/views/home_emp.dart';
import 'package:submission_letter/Theme/theme_emp.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:submission_letter/Util/util_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DetailEmployeeData extends StatefulWidget {
  String id;
  String idSurat;
  String namaPenduduk;
  String tanggal;
  String tipe;

  DetailEmployeeData(
      {this.id, this.idSurat, this.namaPenduduk, this.tanggal, this.tipe});
  @override
  _DetailEmployeeDataState createState() => _DetailEmployeeDataState();
}

class _DetailEmployeeDataState extends State<DetailEmployeeData> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final List<Message> messages = [];
  final TextEditingController titleController =
      TextEditingController(text: 'Surat Masuk');
  final TextEditingController bodyController = TextEditingController(
      text: 'Periksa TODO Anda untuk segera proses surat');
  //-------------------------
  String nama;
  String jabatanText;
  int id;
  var keteranganController = TextEditingController();
  var komentarController = TextEditingController();

  bool _validateKeterangan = false;
  bool _validateKomentar = false;

  @override
  void initState() {
    setPreference();
    super.initState();

    _firebaseMessaging.onTokenRefresh.listen(sendTokenToServer);
    _firebaseMessaging.getToken();
    _firebaseMessaging.subscribeToTopic('all');

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");

        final notification = message['notification'];
        setState(() {
          messages.add(Message(
              title: notification['title'], body: notification['body']));
        });
      },
      onLaunch: (Map<String, dynamic> message) {},
      onResume: (Map<String, dynamic> message) async {},
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  Future<void> setPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      nama = pref.getString('Nama');
      jabatanText = pref.getString('Jabatan');
      id = pref.getInt("Id");
    });
  }

  void sendNotification(tokenEndUser) async {
    final response = await Messaging.sendTo(
        title: titleController.text,
        body: bodyController.text,
        fcmToken: '$tokenEndUser');
    if (response.statusCode != 200) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content:
            Text('[${response.statusCode}] Error Message: ${response.body}'),
      ));
    }
  }

  void sendTokenToServer(String fcmToken) {
    print('TokenNya: $fcmToken');
  }

  void dispose() {
    super.dispose();
  }

  void processData() async {
    // Proses Approve
    UtilAuth.loading(context);
    DetailEmployeePresenter presenters = new DetailEmployeePresenter();
    var process = await presenters.approveSurat(
        widget.idSurat, id, keteranganController.text, komentarController.text);
    if (process.data['token'] != null) {
      sendNotification(process.data['token']);
    } else {
      UtilAuth.emailsFlat(process.data['email']);
    }

    UtilAuth.successPopupDialog(context, process.data['message'], HomeEmp());
  }

  Future<void> tolakSurats() async {
    UtilAuth.loading(context);
    DetailEmployeePresenter presenter = new DetailEmployeePresenter();
    var response = await presenter.tolakSurat(widget.idSurat);
    UtilAuth.successPopupDialog(context, response, HomeEmp());
  }

  Widget _detailWidget(
      String keterangan, String rtrwText, String noSuratRT, String noSuratRW) {
    return Container(
      child: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: RaisedButton(
                    color: Colors.red,
                    child: Text(
                      "Tolak",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      if (keteranganController.text.isNotEmpty) {
                        setState(() {
                          _validateKeterangan = false;
                        });
                        if (komentarController.text.isNotEmpty) {
                          setState(() {
                            _validateKomentar = false;
                          });
                          tolakSurats();
                        } else {
                          setState(() {
                            _validateKomentar = true;
                          });
                        }
                      } else {
                        setState(() {
                          _validateKeterangan = true;
                        });
                      }
                    },
                  ),
                ),
                Container(
                  child: RaisedButton(
                    color: Colors.green,
                    child: Text(
                      "Setuju",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      if (keteranganController.text.isNotEmpty) {
                        setState(() {
                          _validateKeterangan = false;
                        });
                        if (komentarController.text.isNotEmpty) {
                          setState(() {
                            _validateKomentar = false;
                          });
                          processData();
                        } else {
                          setState(() {
                            _validateKomentar = true;
                          });
                        }
                      } else {
                        setState(() {
                          _validateKeterangan = true;
                        });
                      }
                    },
                  ),
                )
              ],
            ),
          ),
          Divider(
            color: Colors.orange,
            thickness: 2,
          ),
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                "Pengajuan Surat Keterangan Miskin",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                    fontSize: 20),
              ),
            ),
          ),
          Divider(
            color: Colors.orange,
            thickness: 2,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Keterangan: ",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Container(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 300.0,
                      maxWidth: 300.0,
                      minHeight: 30.0,
                      maxHeight: 100.0,
                    ),
                    child: AutoSizeText(
                      "$keterangan",
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "RT/RW: ",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  "$rtrwText",
                  style: TextStyle(fontSize: 15),
                )
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: <Widget>[
                Text(
                  "No Surat RT: ",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  noSuratRT != null ? "$noSuratRT" : "",
                  style: TextStyle(fontSize: 15),
                )
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: <Widget>[
                Text(
                  "No Surat RW:",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  noSuratRW != null ? "$noSuratRW" : "",
                  style: TextStyle(fontSize: 15),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: TextField(
              decoration: InputDecoration(
                  labelText: 'Keterangan Surat',
                  hintText: "Masukkan Keterangan Surat Ini",
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                  errorText: _validateKeterangan
                      ? "Keterangan Surat tidak boleh kosong!"
                      : null),
              controller: keteranganController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: TextField(
              decoration: InputDecoration(
                  labelText: 'Komentar Surat',
                  hintText: "Masukkan Komentar Untuk Surat Ini",
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                  errorText: _validateKomentar
                      ? "Komentar Surat tidak boleh kosong!"
                      : null),
              controller: komentarController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
          )
        ],
      ),
    );
  }

  Future<DetailEmpViewModel> _getDetailSurat() async {
    DetailEmployeePresenter presentesrs = new DetailEmployeePresenter();
    var response =
        await presentesrs.getDetailDataSurat(widget.id, widget.idSurat);
    return response;
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
          future: _getDetailSurat(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return _detailWidget(snapshot.data.keterangan, snapshot.data.rtrw,
                  snapshot.data.noSuratRt, snapshot.data.noSuratRw);
            } else {
              return Container(
                child: Center(
                  child: Text('Loading...'),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
