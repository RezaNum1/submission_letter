import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class Messaging {
  static final Client client = Client();

  static const String serverKey =
      'AAAAuZcJCZQ:APA91bHOorJQ53UZ5w5l6xNxRtVNEFgd-EaXWPyhVx_GXUnI1vaF2equ9vUqC1xN75ndDPuhqEWinO_C0UgWWOszh7PmvyydR_ys-IW4tMJWiTcM4SrApr20N3_SwU9ryY-LV6rSqLLAAAAmWcTVqo:APA91bEvawnofo6MoJW9zmsvJ9pV2kftwP12ukQv56zB5Dp1nG2sYQYNLuhl4Bnyz8CFrCqld0WLBxU96c4zctpq2dwyyI-z6vsWTej-0aXWtMcMHT_0wCv1dQ_ChvqsHO28zWPniI7g';

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
