import 'package:firebase_messaging/firebase_messaging.dart';

class GetToken {
  GetToken() {}

  Future<String> getFCMToken() {
    FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
    var data = firebaseMessaging.getToken();
    return data;
  }
}
