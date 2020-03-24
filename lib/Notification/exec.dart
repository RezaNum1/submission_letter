import 'package:flutter/material.dart';
import 'package:submission_letter/Notification/widget_function/messaging_widget.dart';

class Exec extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notif"),
      ),
      body: MessagingWidget(),
    );
  }
}
