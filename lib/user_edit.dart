import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_link/firestore_users_bloc.dart';
import 'package:firestore_link/value_objects/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserEdit extends StatelessWidget {
  final String title;

  UserEdit({this.title});

  User _getUserInfo(context) {
    var snapshot = ModalRoute.of(context).settings.arguments;

    if (!(snapshot is DocumentSnapshot)) {
      throw new Exception(
          'DocumentSnapshot以外のオブジェクトがUserDetailの画面遷移引数に渡されています。DocumentSnapshot型を渡してください。');
    }
    User userInfo = User.fromDocumentSnapshot(snapshot);
    return userInfo;
  }

  @override
  Widget build(BuildContext context) {
    User userInfo = _getUserInfo(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            UserForm(),
            Text(userInfo.documentId),
            Text(userInfo.lastName),
            Text(userInfo.name),
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

  String requireValidation(value) {
    if (value.isEmpty) {
      return '必須です。';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    FirestoreUsersBloc bloc =
        Provider.of<FirestoreUsersBloc>(context, listen: false);

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
                  bloc
                      .newUser(_lastNameController.text, _nameController.text)
                      .then((onValue) {
                    print('success!');
                  }).catchError((onError) {
                    print('error!');
                  }).whenComplete(() {
                    bloc.getUsers();
                    Navigator.pop(context);
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
