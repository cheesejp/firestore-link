import 'package:firestore_link/firestoreUsersLogic.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLoC Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter BLoC Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirestoreUsersLogic _firestoreUsersLogic;

  _MyHomePageState() {
    this._firestoreUsersLogic = FirestoreUsersLogic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            UserForm(_firestoreUsersLogic),
            _FirestoreUsersStreamList(_firestoreUsersLogic),
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

class _FirestoreUsersStreamList extends StatelessWidget {
  final FirestoreUsersLogic _firestoreUsersLogic;

  _FirestoreUsersStreamList(this._firestoreUsersLogic);

  dynamic rebuildList(context, snapshot) {
    if (snapshot.hasError) {
      return Text('error');
    } else if (snapshot.connectionState == ConnectionState.active) {
      var items = snapshot.data?.documents ?? [];
      return SizedBox(
        height: 200.0,
        child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) => ListTile(
                  title: Text('User'),
                  subtitle: Text(items[index].data['last_name'] +
                      ' ' +
                      items[index].data['name']),
                  isThreeLine: true,
                )),
      );
    } else {
      return Text('loading...');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestoreUsersLogic.list,
      builder: (context, snapshot) {
        return rebuildList(context, snapshot);
      },
    );
  }
}
