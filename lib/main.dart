import 'package:firestore_link/firestore_users_bloc.dart';
import 'package:firestore_link/user_edit.dart';
import 'package:firestore_link/value_objects/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => FirestoreUsersBloc(),
      dispose: (_, bloc) => bloc.dispose(),
      child: MaterialApp(
        title: 'BLoC Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => MyHomePage(
                title: 'BLoC Demo',
              ),
          '/userdetail': (context) => UserEdit(
                title: 'User Detail Page',
              ),
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  MyHomePage({this.title = ''});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _FirestoreUsersStreamList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/userdetail');
        },
        tooltip: 'Add User',
        child: Icon(Icons.add),
      ),
    );
  }
}

class _FirestoreUsersStreamList extends StatelessWidget {
  dynamic buildList(context, snapshot, FirestoreUsersBloc bloc) {
    if (snapshot.hasError) {
      return Text('error');
    } else if (snapshot.connectionState == ConnectionState.active) {
      List<User> userList = snapshot.data ?? [];
      return SizedBox(
        height: 500.0,
        child: ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: userList.length,
            itemBuilder: (context, index) => Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: ListTile(
                      leading: Icon(Icons.tag_faces),
                      title: Text('ID : ${userList[index].documentId}'),
                      subtitle: Text(
                          '${userList[index].lastName} ${userList[index].name}'),
                      isThreeLine: true,
                      onTap: () {
                        Navigator.pushNamed(context, '/userdetail',
                            arguments: userList[index]);
                      },
                    ),
                    actions: <Widget>[
                      IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                          bloc.deleteUser(userList[index].documentId);
                          bloc.getUsers();
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
    FirestoreUsersBloc firestoreUsersBloc =
        Provider.of<FirestoreUsersBloc>(context, listen: false);

    return StreamBuilder(
      stream: firestoreUsersBloc.listStream,
      builder: (context, snapshot) {
        return buildList(context, snapshot, firestoreUsersBloc);
      },
    );
  }
}
