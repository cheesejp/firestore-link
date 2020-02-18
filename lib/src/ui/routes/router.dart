import 'package:firestore_link/src/ui/screens/hoge.dart';
import 'package:firestore_link/src/ui/screens/huga.dart';
import 'package:firestore_link/src/ui/screens/user_edit.dart';
import 'package:firestore_link/src/ui/screens/user_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const String USER_LIST_PAGE_ROUTE = '/';
const String USER_EDIT_PAGE_ROUTE = '/useredit';
const String HOGE_PAGE_ROUTE = '/hoge';
const String HUGA_PAGE_ROUTE = '/huga';

Route<dynamic> generateRoute(RouteSettings settings) {
  // settingsを渡さないと引数の受け渡しができない。
  switch (settings.name) {
    case USER_LIST_PAGE_ROUTE:
      return MaterialPageRoute(
          builder: (context) => UserListPage(), settings: settings);
    case USER_EDIT_PAGE_ROUTE:
      return MaterialPageRoute(
          builder: (context) => UserEditPage(), settings: settings);
    case HOGE_PAGE_ROUTE:
      return MaterialPageRoute(
          builder: (context) => HogePage(), settings: settings);
    case HUGA_PAGE_ROUTE:
      return MaterialPageRoute(
          builder: (context) => HugaPage(), settings: settings);
    default:
      throw Exception('無効なRouteが指定されました。: ${settings.name}');
  }
}
