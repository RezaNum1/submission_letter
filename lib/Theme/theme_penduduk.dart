import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:submission_letter/Auth/presenter/login_presenter.dart';
import 'package:submission_letter/Auth/presenter/userAuth_presenter.dart';
import 'package:submission_letter/Auth/views/userAuth_views.dart';
import 'package:submission_letter/Penduduk_Page/views/home_penduduk.dart';
import 'package:submission_letter/Penduduk_Page/views/search_penduduk.dart';
import 'package:submission_letter/Penduduk_Page/widget/rule_page.dart';
import 'package:submission_letter/RTRW_Page/presenter/setting_presenter.dart';
import 'package:submission_letter/Util/util_auth.dart';
import 'package:expandable/expandable.dart';

import '../RTRW_Page/views/home_emp.dart' as homeEmp;
import '../RTRW_Page/views/setting_views.dart' as settings;
import '../Auth/views/login_views.dart' as loginPage;

class ThemeAppPenduduk {
  static sideBar(context, String nik, String noTelepon) {
    double height = MediaQuery.of(context).size.height;
    double fontSizes = height == 716 ? 17 : 20;
    double titleSize = height == 716 ? 20 : 30;
    double infoBioSize = height == 716 ? 10 : 15;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 150,
            child: DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.people,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 20),
                        child: Text(
                          'Masyarakat',
                          style: TextStyle(
                            fontSize: titleSize,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/dki.png'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.white,
                    thickness: 8,
                  ),
                  Text(
                    '$nik | $noTelepon',
                    style: TextStyle(
                      fontSize: infoBioSize,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.orange,
              ),
            ),
          ),
          Card(
              child: Container(
            child: ExpandablePanel(
              tapBodyToCollapse: true,
              header: Container(
                height: 50,
                margin: EdgeInsets.only(left: 15, top: 5),
                child: Text(
                  "Buat Pengajuan Surat",
                  style: TextStyle(
                    fontSize: fontSizes,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              expanded: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300])),
                    child: ListTile(
                      title: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          "Surat Keterangan Tidak Mampu",
                          style: TextStyle(
                            fontSize: fontSizes,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => RulePage(
                              tipe: "1",
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300])),
                    child: ListTile(
                      title: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          "Surat Keterangan Usaha",
                          style: TextStyle(
                            fontSize: fontSizes,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => RulePage(
                              tipe: "2",
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300])),
                    child: ListTile(
                      title: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          "Surat Pengantar Izin Keramaian",
                          style: TextStyle(
                            fontSize: fontSizes,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => RulePage(
                              tipe: "3",
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300])),
                    child: ListTile(
                      title: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          "Surat Keterangan Belum Menikah",
                          style: TextStyle(
                            fontSize: fontSizes,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => RulePage(
                              tipe: "4",
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300])),
                    child: ListTile(
                      title: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          "Surat Keterangan Hidup/Mati",
                          style: TextStyle(
                            fontSize: fontSizes,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => RulePage(
                              tipe: "5",
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300])),
                    child: ListTile(
                      title: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          "Surat Keterangan Domisili",
                          style: TextStyle(
                            fontSize: fontSizes,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => RulePage(
                              tipe: "6",
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300])),
                    child: ListTile(
                      title: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          "Surat Keterangan Kematian",
                          style: TextStyle(
                            fontSize: fontSizes,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => RulePage(
                              tipe: "7",
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300])),
                    child: ListTile(
                      title: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          "Surat Keterangan Pindah (Keluar / Datang)",
                          style: TextStyle(
                            fontSize: fontSizes,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => RulePage(
                              tipe: "8",
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              tapHeaderToExpand: true,
              hasIcon: true,
            ),
          )),
          Card(
            child: ListTile(
              title: Text(
                "Halaman Utama",
                style: TextStyle(
                  fontSize: fontSizes,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                UtilAuth.movePage(context, HomePenduduk());
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text(
                "Cari Surat Seleasi",
                style: TextStyle(
                  fontSize: fontSizes,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                UtilAuth.movePage(context, SearchPenduduk());
              },
            ),
          ),
          // Card(
          //   child: ListTile(
          //     title: Text(
          //       "Akun",
          //       style: TextStyle(
          //         fontSize: fontSizes,
          //         color: Colors.orange,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //     onTap: () {
          //       UtilAuth.movePage(
          //           context, settings.SettingViews(SettingPresenter()));
          //     },
          //   ),
          // ),
          Card(
            child: ListTile(
              title: Text(
                "Keluar",
                style: TextStyle(
                  fontSize: fontSizes,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                UtilAuth.clearUserPreferencePenduduk();
                UtilAuth.movePage(
                    context,
                    UserAuth(
                      presenter: UserAuthPresenter(),
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
