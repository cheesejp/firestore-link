import 'package:firestore_link/src/blocs/firestore_users_bloc.dart';
import 'package:firestore_link/src/resources/repositories/firestore_users_repository.dart';
import 'package:firestore_link/src/ui/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firestore_link/src/ui/routes/router.dart' as router;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLoC Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AppNavigation(),
    );
  }
}

class AppNavigation extends StatefulWidget {
  @override
  _AppNavigationState createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int _selectedIndex = 0;
  final _navigatorKey = GlobalKey<NavigatorState>();

  final List<String> _pageRoutes = [
    USER_LIST_PAGE_ROUTE,
    HOGE_PAGE_ROUTE,
    HUGA_PAGE_ROUTE,
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Title'),
      ),
      body: Provider(
        create: (context) => FirestoreUsersBloc(FirestoreUsersRepository()),
        dispose: (_, bloc) => bloc.dispose(),
        child: _navigator(),
      ),
      bottomNavigationBar: _bottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigatorKey.currentState.pushNamed(router.USER_EDIT_PAGE_ROUTE);
        },
        tooltip: 'Add User',
        child: Icon(Icons.add),
      ),
    );
  }

  Navigator _navigator() => Navigator(
        key: _navigatorKey,
        initialRoute: USER_LIST_PAGE_ROUTE,
        onGenerateRoute: (settings) => router.generateRoute(settings),
      );

  BottomNavigationBar _bottomNavigationBar() => BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('User List'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            title: Text('Hoge'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Huga'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      );

  void _onItemTapped(int index) {
    setState(() {
      _navigatorKey.currentState.pushReplacementNamed(_pageRoutes[index]);
      _selectedIndex = index;
    });
  }

// TabController(vsync: tickerProvider, length: tabCount)..addListener(() {
//   if (!tabController.indexIsChanging) {
//     setState(() {
//       // Rebuild the enclosing scaffold with a new AppBar title
//       appBarTitle = 'Tab ${tabController.index}';
//     });
//   }
// })
}
