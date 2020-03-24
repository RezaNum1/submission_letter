import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class Messaging {
  static final Client client = Client();

  static const String serverKey =
      'AAAAxMhADXw:APA91bECq26dNxDr1eifU714EMwV9NuWPwMfLlcqZFMTwUqkR_wuKE37PNfwGqCc4DHj_u8UoA_j-JFf4RQdZkui_dlKfJoj5KV2-W1-FnVBcoBoEEPTgz8UfiQRldwWn5cbmSmOrEnp';

  static Future<Response> sendToAll({
    @required String title,
    @required String body,
  }) =>
      sendToTopic(title: title, body: body, topic: 'all');

  static Future<Response> sendToTopic(
          {@required String title,
          @required String body,
          @required String topic}) =>
      sendTo(title: title, body: body, fcmToken: '/topics/$topic');

  static Future<Response> sendTo({
    @required String title,
    @required String body,
    @required String fcmToken,
  }) =>
      client.post(
        'https://fcm.googleapis.com/fcm/send',
        body: json.encode({
          'notification': {
            'body': '$body',
            'title': '$title',
            'sound': 'default'
          },
          'priority': 'high',
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': '$fcmToken',
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
      );
}
