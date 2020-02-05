import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserDetail extends StatelessWidget {
  final String title;

  UserDetail({this.title});

  DocumentSnapshot _getValue(context) {
    var arguments = ModalRoute.of(context).settings.arguments;

    if (!(arguments is DocumentSnapshot)) {
      throw new Exception(
          'DocumentSnapshot以外のオブジェクトがUserDetailの画面遷移引数に渡されています。DocumentSnapshot型を渡してください。');
    }
    print(arguments);
    return arguments;
  }

  @override
  Widget build(BuildContext context) {
    DocumentSnapshot document = _getValue(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(document.documentID),
            Text(document.data['last_name']),
            Text(document.data['name']),
          ],
        ),
      ),
    );
  }
}
