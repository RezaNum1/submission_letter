import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelesaiEmp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text("Print Preference Data"),
              onPressed: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                print(preferences.getString('Nama'));
                print(preferences.getString('Jabatan'));
                print(preferences.getInt('Id'));
                print(preferences.getString("token"));
              },
            )
            // Padding(
            //   padding: EdgeInsets.all(20.0),
            // ),
            // Padding(
            //   padding: EdgeInsets.all(20.0),
            // ),
            // Icon(
            //   Icons.assignment_turned_in,
            //   size: 90.0,
            //   color: Colors.orange,
            // ),
            // Text(
            //   "SURAT SELESAI",
            //   style: TextStyle(
            //     fontSize: 30.0,
            //     color: Colors.orange,
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
