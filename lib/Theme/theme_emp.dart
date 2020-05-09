import 'package:flutter/material.dart';
import 'package:submission_letter/Auth/presenter/login_presenter.dart';
import 'package:submission_letter/RTRW_Page/presenter/setting_presenter.dart';
import 'package:submission_letter/RTRW_Page/views/search_emp.dart';
import 'package:submission_letter/RTRW_Page/views/surat_kelurahan.dart';
import 'package:submission_letter/Util/util_auth.dart';

import '../RTRW_Page/views/home_emp.dart' as homeEmp;
import '../RTRW_Page/views/setting_views.dart' as settings;
import '../Auth/views/login_views.dart' as loginPage;

class ThemeApp {
  static sideBar(context, String nama, String jabatan) {
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
                      Container(
                        margin: EdgeInsets.only(right: 20),
                        child: Text(
                          '${nama[0].toUpperCase()}${nama.substring(1)}',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 40,
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
                    jabatan,
                    style: TextStyle(
                      fontSize: 20,
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
            child: ListTile(
              title: Text(
                "Halaman Utama",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                UtilAuth.movePage(context, homeEmp.HomeEmp());
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text(
                "Cari Surat Selesai",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                UtilAuth.movePage(context, SearchEmp());
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text(
                "Akun",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                UtilAuth.movePage(
                    context, settings.SettingViews(SettingPresenter()));
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text(
                "Surat Kelurahan",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                UtilAuth.movePage(context, SuratKelurahan());
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text(
                "LogOut",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                UtilAuth.clearUserPreference();
                UtilAuth.movePage(
                    context, loginPage.LoginViews(LoginPresenter()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
