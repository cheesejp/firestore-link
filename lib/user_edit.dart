import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_link/firestore_users_logic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserEdit extends StatelessWidget {
  final String title;

  UserEdit({this.title});

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
            UserForm(FirestoreUsersLogic()),
            Text(document.documentID),
            Text(document.data['last_name']),
            Text(document.data['name']),
          ],
        ),
      ),
    );
  }
}

class UserForm extends StatelessWidget {
  final _formkey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final FirestoreUsersLogic _firestoreUsersLogic;

  UserForm(this._firestoreUsersLogic);

  String requireValidation(value) {
    if (value.isEmpty) {
      return '必須です。';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                hintText: '苗字を入力してください。',
                labelText: '苗字',
              ),
              validator: requireValidation,
            ),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                hintText: '名前を入力してください。',
                labelText: '名前',
              ),
              validator: requireValidation,
            ),
            RaisedButton(
              child: const Text('send'),
              onPressed: () {
                if (_formkey.currentState.validate()) {
                  _firestoreUsersLogic
                      .newUser(_lastNameController.text, _nameController.text)
                      .then((onValue) {
                    print('success!');
                  }).catchError((onError) {
                    print('error!');
                  }).whenComplete(() {
                    _firestoreUsersLogic.getUsers();
                    print('done.');
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
  }
}
