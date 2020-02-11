import 'package:firestore_link/blocs/firestore_users_repository.dart';
import 'package:firestore_link/common/bottom_navigation_bar.dart';
import 'package:firestore_link/blocs/firestore_users_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => FirestoreUsersBloc(FirestoreUsersRepository()),
      dispose: (_, bloc) => bloc.dispose(),
      child: MaterialApp(
        title: 'BLoC Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AppBottomNavigation(),
      ),
    );
  }
}
