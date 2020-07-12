import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_letter/Util/scale_route.dart';
import 'package:submission_letter/main.dart';

class UtilAuth {
  static bool emailValidate(String text) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(text)) {
      return true;
    } else {
      return false;
    }
  }

  static movePage(context, Widget widget) {
    Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(builder: (context) => widget),
        (Route<dynamic> route) => false);
  }

  static movePageScale(context, Widget widget) {
    Navigator.of(context).pushAndRemoveUntil(
        ScaleRoute(
          page: widget,
        ),
        (Route<dynamic> route) => false);
  }

  static loading(context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Center(
          child: SpinKitChasingDots(
            color: Colors.blue,
            size: 80.0,
          ),
        );
      },
    );
  }

  static failedPopupDialogWithoutNav(context, var texts) {
    Navigator.of(context, rootNavigator: true).pop();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        // return Dialog(
        return AlertDialog(
          title: Text('Peringatan!'),
          content: Text(
            '$texts',
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
        // );
      },
    );
  }

  static failedPopupDialog(context, var texts) {
    Navigator.of(context, rootNavigator: true).pop();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        // return Dialog(
        return AlertDialog(
          title: Text('Peringatan!'),
          content: Text(
            '$texts',
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
        // );
      },
    );
  }

  static successPopupDialog(context, var texts, Widget widget) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        // return Dialog(
        return AlertDialog(
          title: Text('Peringatan!'),
          content: Text(
            '$texts',
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => widget),
                    (Route<dynamic> route) => false);
              },
            )
          ],
        );
        // );
      },
    );
  }

  static void emails(
      String emailUser, String userUsername, String userPassword) async {
    String username = 'letteryou@gmail.com';
    String password = 'letteryou1988';

    final smtpServer = gmail(username, password);
    // Creating the Gmail server

    // Create our email message.
    final message = Message()
      ..from = Address(username)
      ..recipients.add(emailUser) //recipent email
      ..subject =
          'ULETTER :: Permohonan Lupa Password :: ${DateTime.now()}' //subject of the email
      ..text =
          'Pemulihan Akun Baru Anda:: Username:  ${userUsername} | Password: ${userPassword}'; //body of the email

    try {
      final sendReport = await send(message, smtpServer);
      // print('Message sent: ' +
      //     sendReport.toString()); //print if the email is sent
    } on MailerException catch (e) {
      // print('Message not sent. \n' +
      //     e.toString()); //print if the email is not sent
      // e.toString() will show why the email is not sending
    }
  }

  static void emailsFlat(String emailUser) async {
    String username = 'letteryou20@gmail.com';
    String password = 'letteryou2020';

    final smtpServer = gmail(username, password);
    // Creating the Gmail server

    // Create our email message.
    final message = Message()
      ..from = Address(username)
      ..recipients.add(emailUser) //recipent email
      ..subject =
          'ULETTER :: Surat Masuk :: Mohon untuk segera di proses}' //subject of the email
      ..text =
          'Periksa TODO Index Anda, Ada Surat Masuk Butuh Di Proses'; //body of the email

    try {
      final sendReport = await send(message, smtpServer);
      // print('Message sent: ' +
      //     sendReport.toString()); //print if the email is sent
    } on MailerException catch (e) {
      // print('Message not sent. \n' +
      //     e.toString()); //print if the email is not sent
      // e.toString() will show why the email is not sending
    }
  }

  static void clearUserPreference() async {
    var url = "${MyApp.route}/api/removeToken";
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var id = preferences.getInt('Id');
    Dio dio = new Dio();
    FormData formData = new FormData.fromMap({"id": id});
    var response = await dio.post(url, data: formData);

    preferences.clear();
  }

  static void clearUserPreferencePenduduk() async {
    var url = "${MyApp.route}/api/removeTokenPenduduk";
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var id = preferences.getInt('Id');
    Dio dio = new Dio();
    FormData formData = new FormData.fromMap({"id": id});
    var response = await dio.post(url, data: formData);

    preferences.clear();
  }

  static bool checkString(String text) {
    if (RegExp(r'[!@#<>?":_`~;[\]/\\|=+)(*&^%-]').hasMatch(text) == false) {
      return true;
    } else {
      return false;
    }
  }

  static bool checkEmail(String text) {
    if (RegExp(r'[!#<>?":`~;[\]\\/|=+)(*&^%-]').hasMatch(text) == false) {
      return true;
    } else {
      return false;
    }
  }

  static bool checkStringPassword(String text) {
    if (RegExp(r'[!#<>?":`~;[\]\\/|=+)(*&^%-]').hasMatch(text) == false) {
      return true;
    } else {
      return false;
    }
  }

  static bool checkAlamat(String text) {
    if (RegExp(r'[!@#<>?":_`~;[\]\\/|=+)(*&^%0-9]').hasMatch(text) == false) {
      return true;
    } else {
      return false;
    }
  }

  static bool checkUsername(String text) {
    if (RegExp(r'[!@#<>?":_`~;[\]/\\|=+)(*&^%0-9-]').hasMatch(text) == false) {
      return true;
    } else {
      return false;
    }
  }

  static bool checkStringRTRW(String text) {
    if (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%-]').hasMatch(text) == false) {
      return true;
    } else {
      return false;
    }
  }
}
