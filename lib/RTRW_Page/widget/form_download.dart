import 'package:flutter/material.dart';
import 'package:submission_letter/RTRW_Page/presenter/detailEmployeeSelesai_presenter.dart';
import 'package:submission_letter/Util/util_auth.dart';

class FormDownload extends StatefulWidget {
  String buttonText;
  String berkas;
  String idSurat;
  FormDownload({this.buttonText, this.berkas, this.idSurat});
  @override
  _FormDownloadState createState() => _FormDownloadState();
}

class _FormDownloadState extends State<FormDownload> {
  void downloadFile(BuildContext context, String idSurat, String berkas) async {
    UtilAuth.loading(context);
    DetailEmpSelesaiPresenter detailEmpSelesaiPresenter =
        new DetailEmpSelesaiPresenter();
    var res = await detailEmpSelesaiPresenter.download(idSurat, berkas);
    if (res != '') {
      return UtilAuth.failedPopupDialog(context, res);
    } else {
      return UtilAuth.failedPopupDialog(context, "Download Gagal");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            child: RaisedButton(
              child: Text("${widget.buttonText}"),
              textColor: Colors.white,
              color: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.green),
              ),
              onPressed: () async {
                downloadFile(context, widget.idSurat, widget.berkas);
              },
            ),
          ),
        ],
      ),
    );
  }
}
