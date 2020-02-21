import 'package:flutter/material.dart';

class PiyoPage extends StatelessWidget {
  final String title;
  PiyoPage({this.title = ''});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Piyo Page'),
      ),
      body: Text('This is Piyo Page.'),
    );
  }
}
