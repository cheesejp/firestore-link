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
  const DestinationView({Key key, this.destination, this.onNavigation})
      : super(key: key);
  final Destination destination;
  final VoidCallback onNavigation;

  @override
  State<StatefulWidget> createState() => _DestinationViewState();
}

class _DestinationViewState extends State<DestinationView> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      observers: <NavigatorObserver>[
        DestinationViewNavigatorObserver(widget.onNavigation),
      ],
      onGenerateRoute: widget.destination.generateRoute,
    );
  }
}

/// Navigationで画面を遷移する際に実行するコールバックを設定するクラス。
/// まだ未使用。
class DestinationViewNavigatorObserver extends NavigatorObserver {
  DestinationViewNavigatorObserver(this.onNavigation);
  VoidCallback onNavigation;

  @override
  void didPop(Route route, Route previousRoute) {
    super.didPop(route, previousRoute);
    onNavigation();
  }

  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);
    onNavigation();
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  List<AnimationController> _viewOpacities;

  @override
  void initState() {
    super.initState();
    _viewOpacities = destinations
        .map<AnimationController>((dest) => AnimationController(
            vsync: this, duration: Duration(milliseconds: 200)))
        .toList();
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

  Stack _destinationViewStack() {
    // print('build.');
    // print('selected index : ${_selectedIndex}');
    return Stack(
      children: destinations.map((Destination dest) {
        final Widget view = FadeTransition(
          opacity: _viewOpacities[dest.index],
          child: DestinationView(
            destination: dest,
            onNavigation: () {},
          ),
        );
        if (dest.index == _selectedIndex) {
          _viewOpacities[dest.index].forward();
          return view;
        }
        _viewOpacities[dest.index].reverse();
        return Offstage(child: view);
      }).toList(),
    );
  }

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
