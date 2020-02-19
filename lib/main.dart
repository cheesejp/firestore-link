import 'package:firestore_link/src/blocs/firestore_users_bloc.dart';
import 'package:firestore_link/src/resources/repositories/firestore_users_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firestore_link/src/ui/routes/router.dart' as router;

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
        home: HomePage(),
      ),
    );
  }
}

class Destination {
  const Destination(this.index, this.title, this.icon, this.iconText,
      this.color, this.generateRoute);
  final int index;
  final String title;
  final IconData icon;
  final String iconText;
  final MaterialColor color;
  final Function(RouteSettings) generateRoute;
}

List<Destination> destinations = <Destination>[
  Destination(0, 'User list', Icons.person, 'User list', Colors.blue,
      router.generateRouteUserList),
  Destination(1, 'Hoge Page', Icons.pets, 'Hoge page', Colors.green,
      router.generateRouteHoge),
  Destination(2, 'Piyo Page', Icons.settings, 'Piyo page', Colors.red,
      router.generateRoutePiyo),
];

class DestinationView extends StatefulWidget {
  const DestinationView({Key key, this.destination}) : super(key: key);
  final Destination destination;

  @override
  State<StatefulWidget> createState() => _DestinationViewState();
}

class _DestinationViewState extends State<DestinationView> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: widget.destination.generateRoute,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: _destinationViewStack(),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  Stack _destinationViewStack() => Stack(
        children: destinations.map((Destination dest) {
          DestinationView view = DestinationView(destination: dest);
          if (dest.index == _selectedIndex) {
            return view;
          }
          return Offstage(child: view);
        }).toList(),
      );

  BottomNavigationBar _bottomNavigationBar() => BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
        items: destinations.map((Destination dest) {
          return BottomNavigationBarItem(
            icon: Icon(dest.icon),
            backgroundColor: dest.color,
            title: Text(dest.iconText),
          );
        }).toList(),
      );

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
