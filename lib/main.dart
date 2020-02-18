import 'package:firestore_link/src/ui/routes/route_constants.dart';
import 'package:firestore_link/src/ui/screens/hoge.dart';
import 'package:firestore_link/src/ui/screens/huga.dart';
import 'package:firestore_link/src/ui/screens/user_list.dart';
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
    UserListPageRoute,
    HogePageRoute,
    HugaPageRoute,
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      body: _navigator(),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  Navigator _navigator() => Navigator(
        key: _navigatorKey,
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          switch (settings.name) {
            case UserListPageRoute:
              builder = (BuildContext context) => UserParent();
              break;
            case HogePageRoute:
              builder = (BuildContext context) => HogePage();
              break;
            case HugaPageRoute:
              builder = (BuildContext context) => HugaPage();
              break;
            default:
              throw Exception('Invalid route: ${settings.name}');
          }
          return MaterialPageRoute(
            builder: builder,
            settings: settings,
          );
        },
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
}
