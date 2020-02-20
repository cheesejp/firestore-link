import 'package:firestore_link/src/blocs/firestore_users_bloc.dart';
import 'package:firestore_link/src/resources/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormComponents {
  FormComponents(this.labelText, this.hintText, this.vallidator,
      this.textEditingController);
  final String hintText;
  final String labelText;
  final Function(String) vallidator;
  final TextEditingController textEditingController;
}

class UserEditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  User _user;
  final _formkey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();

  void didChangeDependencies() {
    super.didChangeDependencies();

    User user = ModalRoute.of(context).settings.arguments;
    if (user == null) {
      user = User();
    }
    if (!(user is User)) {
      throw Exception('User以外のオブジェクトが/usereditの画面遷移引数に渡されています。User型を渡してください。');
    }
    this._user = user;
    _nameController.text = this._user.name;
    _lastNameController.text = this._user.lastName;
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _lastNameController.dispose();
  }

  static String _requireValidation(String value) {
    if (value.isEmpty) {
      return '必須です。';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Edit Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _userForm(),
        ),
      ),
    );
  }

  List<Widget> _userForm() {
    FirestoreUsersBloc bloc =
        Provider.of<FirestoreUsersBloc>(context, listen: false);
    List<FormComponents> _formComponents = [
      FormComponents(
          '苗字', '苗字を入力してください。', _requireValidation, _lastNameController),
      FormComponents('名前', '名前を入力してください。', _requireValidation, _nameController),
    ];

    List<TextFormField> forms = _formComponents.map((FormComponents form) {
      return TextFormField(
        controller: form.textEditingController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          filled: true,
          hintText: form.hintText,
          labelText: form.labelText,
        ),
        validator: form.vallidator,
      );
    }).toList();

    return <Widget>[
      Text('ID : ${this._user.documentId}'),
      Form(
        key: _formkey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              ...forms,
              RaisedButton(
                child: const Text('send'),
                onPressed: () {
                  if (_formkey.currentState.validate()) {
                    this._user.name = _nameController.text;
                    this._user.lastName = _lastNameController.text;
                    bloc.editUser(this._user).then((onValue) {
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
    ];
  }
}
