import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBottomNavigation extends StatefulWidget {
  @override
  _AppBottomNavigationState createState() => _AppBottomNavigationState();
}

class _AppBottomNavigationState extends State<AppBottomNavigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
  }
}
