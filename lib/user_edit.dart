import 'package:firestore_link/firestore_users_bloc.dart';
import 'package:firestore_link/value_objects/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserEdit extends StatelessWidget {
  final String title;

  UserEdit({this.title});

  User _getUserInfo(context) {
    var user = ModalRoute.of(context).settings.arguments;

    if (!(user is User)) {
      throw new Exception(
          'User以外のオブジェクトがUserDetailの画面遷移引数に渡されています。User型を渡してください。');
    }

    return user;
  }

  @override
  Widget build(BuildContext context) {
    User user = _getUserInfo(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            UserForm(),
            Text(user.documentId),
            Text(user.lastName),
            Text(user.name),
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
                      .newUser(User(
                          name: _nameController.text,
                          lastName: _lastNameController.text))
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
