import 'package:firestore_link/hoge.dart';
import 'package:firestore_link/huga.dart';
import 'package:firestore_link/user_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBottomNavigation extends StatefulWidget {
  @override
  _AppBottomNavigationState createState() => _AppBottomNavigationState();
}

class _AppBottomNavigationState extends State<AppBottomNavigation> {
  int _selectedIndex = 0;
  
  final List<Widget> _children = [
    UserListPage(),
    HogePage(),
    HugaPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
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
      ),
    );
  }
}
