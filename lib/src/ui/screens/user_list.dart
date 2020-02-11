import 'package:firestore_link/src/blocs/firestore_users_bloc.dart';
import 'package:firestore_link/src/resources/models/user.dart';
import 'package:firestore_link/src/resources/repositories/firestore_users_repository.dart';
import 'package:firestore_link/src/ui/screens/user_edit.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firestore_link/src/ui/routes/route_constants.dart'
    as route_constants;

class UserParent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => FirestoreUsersBloc(FirestoreUsersRepository()),
      dispose: (_, bloc) => bloc.dispose(),
      child: Navigator(
        onGenerateRoute: (RouteSettings settings) {
          // TODO onGenerateRoute()が2回呼ばれる。1回目はsettings.name = '/'で呼ばれ、2回目はinitialRouteで設定された文字列がsettings.nameに代入されて呼び出される。詳細は不明なので調査すること。
          WidgetBuilder builder;
          switch (settings.name) {
            case route_constants.UserEditPageRoute:
              builder = (BuildContext context) => UserEditPage();
              break;
            default:
              builder = (BuildContext context) => UserListPage();
          }
          return MaterialPageRoute(
            builder: builder,
            settings: settings,
          );
        },
      ),
    );
  }
}

class UserListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List Page'),
      ),
      body: _FirestoreUsersStreamList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, route_constants.UserEditPageRoute);
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
                        Navigator.pushNamed(
                            context, route_constants.UserEditPageRoute,
                            arguments: userList[index]);
                      },
                    ),
                    actions: <Widget>[
                      IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                          bloc.deleteUser(userList[index]);
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
