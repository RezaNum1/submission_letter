import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../model/message.dart';
import '../api/messaging.dart';

class MessagingWidget extends StatefulWidget {
  _MessagingWidgetState createState() => _MessagingWidgetState();
}

class _MessagingWidgetState extends State<MessagingWidget> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final List<Message> messages = [];
  final TextEditingController titleController =
      TextEditingController(text: 'Title');
  final TextEditingController bodyController =
      TextEditingController(text: 'Body123');

  String myToken;

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.onTokenRefresh.listen(sendTokenToServer);
    _firebaseMessaging.getToken();
    _firebaseMessaging.subscribeToTopic('all');

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");

        final notification = message['notification'];
        setState(() {
          messages.add(Message(
              title: notification['title'], body: notification['body']));
        });
        // Navigator.of(context).pushReplacement(
        //     new MaterialPageRoute(builder: (BuildContext context) => Homes()));
      },
      onLaunch: (Map<String, dynamic> message) {
        // print("onLaunch: $message");

        // setState(() {
        //   messages.add(Message(
        //     title: '$message',
        //     body: 'OnLaunch:',
        //   ));
        // });
        // final notification = message['data'];
        // setState(() {
        //   messages.add(
        //     Message(
        //         title: "OnLaunch: ${notification['title']}",
        //         body: "OnLaunch: ${notification['body']}"),
        //   );
        // });
        // Navigator.of(context).pushReplacement(
        //     new MaterialPageRoute(builder: (BuildContext context) => Homes()));
      },
      onResume: (Map<String, dynamic> message) async {
        // Navigator.of(context).pushReplacement(
        //     new MaterialPageRoute(builder: (BuildContext context) => Homes()));
        // print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  @override
  Widget build(BuildContext context) => ListView(
        children: [
          TextFormField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextFormField(
            controller: bodyController,
            decoration: InputDecoration(labelText: 'Body'),
          ),
          RaisedButton(
            onPressed: buildSendNotification(),
            child: Text('Send notification to Reza'),
          ),
          RaisedButton(
            onPressed: buildSendNotification1(),
            child: Text('Send notification to Mesa'),
          ),
        ]..addAll(messages.map(buildMessage).toList()),
      );

  buildSendNotification() => sendNotification;
  buildSendNotification1() => sendNotification1;

  Widget buildMessage(Message message) => ListTile(
        title: Text(message.title),
        subtitle: Text(message.body),
      );

  void sendNotification() async {
    // final response = await Messaging.sendToAll(
    //     title: titleController.text, body: bodyController.text);

    final response = await Messaging.sendTo(
        title: titleController.text,
        body: bodyController.text,
        fcmToken:
            'e2B5t5KxULI:APA91bHSB_1cKDE6iOlDRAaGHAovQ_6MLq8CEGT_E5nJJ_ePq469sNRVigcRxSBofmNYO5BuwT-OAcA1HV48G13PxlSZnhegdCxKykBZ4VmiwA-LfhKjDhcNK6ftc8KpeaXr5O0Jmnt8');
    if (response.statusCode != 200) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content:
            Text('[${response.statusCode}] Error Message: ${response.body}'),
      ));
    }
  }

  void sendNotification1() async {
    // final response = await Messaging.sendToAll(
    //     title: titleController.text, body: bodyController.text);

    final response = await Messaging.sendTo(
        title: titleController.text,
        body: bodyController.text,
        fcmToken:
            'cS9uSChEhJQ:APA91bGkLurIAGDEaXI0bkTzCKDqHN9b3_DsUr7d3a98hJIWsE0l75BHIzh9LWKoV65IHUYtjQpAErYQDcpsbJDjtr3ZTkI01QvpJVaomHuUYlQtDYguDzDlmhXm6UI7Sdpd9JIiSPfM');
    if (response.statusCode != 200) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content:
            Text('[${response.statusCode}] Error Message: ${response.body}'),
      ));
    }
  }

  void sendTokenToServer(String fcmToken) {
    print('TokenNya: $fcmToken');
  }
}
