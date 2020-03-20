import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:submission_letter/RTRW_Page/views/home_emp.dart';
import 'package:submission_letter/Util/util_auth.dart';

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
    _firebaseMessaging.onTokenRefresh.listen(tokennya);
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
      },
      onLaunch: (Map<String, dynamic> message) async {
        UtilAuth.movePage(context, HomeEmp());
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  // @override
  // Widget build(BuildContext context) => ListView(
  //       children: [
  //         TextFormField(
  //           controller: titleController,
  //           decoration: InputDecoration(labelText: 'Title'),
  //         ),
  //         TextFormField(
  //           controller: bodyController,
  //           decoration: InputDecoration(labelText: 'Body'),
  //         ),
  //         RaisedButton(
  //           onPressed: buildSendNotification(),
  //           child: Text('Send notification to Reza'),
  //         ),
  //       ]..addAll(messages.map(buildMessage).toList()),
  //     );

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text("Submission letter"),
      ),
    );
  }

  buildSendNotification() => sendNotification;

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
            'fAzGeKMQL1I:APA91bHU5UmXDkfPCKFgN6KAI3mSsfg581PUnxbFLvERG9Fn40EjSPVGzsWAbsnuxYthh5yKDM46zniGe6OBp0c-ZQ2DqpmRB7g-OBh-9_QkZlGfF9xkctkm_bCwLtAa2XBlkclGbTFS');
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

  void tokennya(String tokens) {
    setState(() {
      myToken = tokens;
    });

    print(myToken);
  }
}
