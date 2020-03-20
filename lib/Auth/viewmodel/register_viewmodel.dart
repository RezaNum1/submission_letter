import 'dart:convert';
import 'package:dio/dio.dart';

class RegisterViewModel {
  String nama;
  String username;
  String password;
  String email;
  String noTelepon;
  String rt;
  String rw;

  RegisterViewModel(
      {this.nama,
      this.username,
      this.password,
      this.email,
      this.noTelepon,
      this.rt,
      this.rw});
}
