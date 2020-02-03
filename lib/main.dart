import 'package:firestore_link/firestoreUsersLogic.dart';
import 'package:firestore_link/firestoreUsersService.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
            UserForm(),
            // _FirestoreUserName(),
            // _FirestoreUsersList(),
            _FirestoreUsersStreamList(),
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

  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
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
                  // FirestoreUsersService()
                  //     .newUser(_lastNameController.text, _nameController.text)

                  FirestoreUsersLogic()
                      .newUser(_lastNameController.text, _nameController.text)
                      .then((onValue) {
                    print('success!');
                  }).catchError((onError) {
                    print('error!');
                  }).whenComplete(() {
                    FirestoreUsersLogic().getUsers();
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
}

class _FirestoreUserName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirestoreUsersService().getUser('taro', delayTime: 0),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('error');
        } else if (snapshot.hasData) {
          return Text('${snapshot.data['last_name']} ${snapshot.data['name']}');
        } else {
          return Text('loading...');
        }
      },
    );
  }
}

class _FirestoreUsersList extends StatelessWidget {
  dynamic rebuildList(context, snapshot) {
    if (snapshot.hasError) {
      return Text('error');
    } else if (snapshot.hasData) {
      final items = snapshot.data?.documents ?? [];
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
    return FutureBuilder(
      future: FirestoreUsersService().getUsers(delayTime: 0),
      builder: (context, snapshot) {
        return rebuildList(context, snapshot);
      },
    );
  }
}

class _FirestoreUsersStreamList extends StatelessWidget {
  dynamic rebuildList(context, snapshot) {
    if (snapshot.hasError) {
      return Text('error');
    } else if (snapshot.hasData) {
      final items = snapshot.data?.documents ?? [];
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
      stream: FirestoreUsersLogic().list,
      builder: (context, snapshot) {
        return rebuildList(context, snapshot);
      },
    );
  }
}
