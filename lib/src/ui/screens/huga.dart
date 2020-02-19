import 'package:flutter/material.dart';

class HugaPage extends StatelessWidget {
  final String title;
  HugaPage({this.title = ''});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Huga Page'),
      ),
      body: Text('This is Huga Page.'),
    );
  }
}
