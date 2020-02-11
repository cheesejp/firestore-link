import 'package:firestore_link/src/blocs/firestore_users_bloc.dart';
import 'package:firestore_link/src/resources/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserEditPage extends StatelessWidget {
  final String title;

  UserEditPage({this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _UserForm(),
          ],
        ),
      ),
    );
  }
}

class _UserForm extends StatelessWidget {
  final _formkey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FirestoreUsersBloc bloc =
        Provider.of<FirestoreUsersBloc>(context, listen: false);
    User _user = _getUserInfo(context);
    _nameController.text = _user.name;
    _lastNameController.text = _user.lastName;

    return Column(
      children: <Widget>[
        Text('ID : ${_user.documentId}'),
        Form(
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
                  validator: _requireValidation,
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    hintText: '名前を入力してください。',
                    labelText: '名前',
                  ),
                  validator: _requireValidation,
                ),
                RaisedButton(
                  child: const Text('send'),
                  onPressed: () {
                    if (_formkey.currentState.validate()) {
                      _user.name = _nameController.text;
                      _user.lastName = _lastNameController.text;
                      bloc.editUser(_user).then((onValue) {
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
        ),
      ],
    );
  }

  User _getUserInfo(context) {
    User user = ModalRoute.of(context).settings.arguments;

    if (user == null) {
      user = User();
    }

    if (!(user is User)) {
      throw Exception('User以外のオブジェクトが/usereditの画面遷移引数に渡されています。User型を渡してください。');
    }

    return user;
  }

  String _requireValidation(value) {
    if (value.isEmpty) {
      return '必須です。';
    }
    return null;
  }

  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
  }
}
