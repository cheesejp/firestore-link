import 'package:firestore_link/src/blocs/firestore_users_bloc.dart';
import 'package:firestore_link/src/resources/models/user.dart';
import 'package:firestore_link/src/resources/repositories/firestore_users_repository.dart';
import 'package:firestore_link/src/ui/screens/user_edit.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// class UserParent extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Navigator(
//         initialRoute: '/',
//         onGenerateRoute: (RouteSettings settings) {
//           WidgetBuilder builder;
//           // Manage your route names here
//           switch (settings.name) {
//             case '/':
//               builder = (BuildContext context) => HomePage();
//               break;
//             case '/edit':
//               builder = (BuildContext context) => Page1();
//               break;
//             default:
//               throw Exception('Invalid route: ${settings.name}');
//           }
//           // You can also return a PageRouteBuilder and
//           // define custom transitions between pages
//           return MaterialPageRoute(
//             builder: builder,
//             settings: settings,
//           );
//         },
//       ),
//     );
//   }
// }

class UserListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => FirestoreUsersBloc(FirestoreUsersRepository()),
      dispose: (_, bloc) => bloc.dispose(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('User List Page'),
        ),
        body: _FirestoreUsersStreamList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserEditPage.newUser()));
            // Navigator.pushNamed(context, '/useredit');
          },
          tooltip: 'Add User',
          child: Icon(Icons.add),
        ),
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    UserEditPage(userList[index])));
                        // Navigator.pushNamed(context, '/useredit',
                        //     arguments: userList[index]);
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
