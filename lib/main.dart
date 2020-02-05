import 'package:firestore_link/firestoreUsersLogic.dart';
import 'package:firestore_link/userDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLoC Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(
              title: 'Flutter BLoC Demo Home Page',
            ),
        '/userdetail': (context) => UserDetail(
              title: 'User Detail Page',
            ),
      },
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

  dynamic buildList(context, snapshot) {
    if (snapshot.hasError) {
      return Text('error');
    } else if (snapshot.connectionState == ConnectionState.active) {
      var documentSnapshots = snapshot.data?.documents ?? [];
      return SizedBox(
        height: 200.0,
        child: ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: documentSnapshots.length,
            itemBuilder: (context, index) => Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: ListTile(
                      leading: Icon(Icons.tag_faces),
                      title:
                          Text('ID : ' + documentSnapshots[index].documentID),
                      subtitle: Text(
                          documentSnapshots[index].data['last_name'] +
                              ' ' +
                              documentSnapshots[index].data['name']),
                      isThreeLine: true,
                      onTap: () {
                        Navigator.pushNamed(context, '/userdetail',
                            arguments: documentSnapshots[index]);
                      },
                    ),
                    actions: <Widget>[
                      IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                          _firestoreUsersLogic
                              .deleteUser(documentSnapshots[index].documentID);
                          _firestoreUsersLogic.getUsers();
                        },
                      ),
                    ])),
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
        return buildList(context, snapshot);
      },
    );
  }
}
