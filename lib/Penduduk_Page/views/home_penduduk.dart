import 'package:flutter/material.dart';

class HomePenduduk extends StatefulWidget {
  @override
  _HomePendudukState createState() => _HomePendudukState();
}

class _HomePendudukState extends State<HomePenduduk> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Penduduk'),
      ),
      body: Container(
        child: Center(
          child: Text('Hallo, Selamat Datang'),
        ),
      ),
    );
  }
}
