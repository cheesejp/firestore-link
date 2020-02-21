import 'package:firestore_link/src/ui/screens/hoge.dart';
import 'package:firestore_link/src/ui/screens/piyo.dart';
import 'package:firestore_link/src/ui/screens/user_edit.dart';
import 'package:firestore_link/src/ui/screens/user_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const String USER_LIST_ROOT_PAGE = '/';
const String USER_EDIT_PAGE = '/useredit';
const String HOGE_ROOT_PAGE = '/';
const String PIYO_ROOT_PAGE = '/';

Route<dynamic> generateRouteUserList(RouteSettings settings) {
  // RouteSettingsをMaterialPageRouteのコンストラクタに渡さないと、画面間の引数の受け渡しができない。
  switch (settings.name) {
    case USER_LIST_ROOT_PAGE:
      return MaterialPageRoute(
          builder: (context) => UserListPage(), settings: settings);
    case USER_EDIT_PAGE:
      return MaterialPageRoute(
          builder: (context) => UserEditPage(), settings: settings);
    default:
      throw Exception('無効なNamed Routeが指定されました。: ${settings.name}');
  }
}

Route<dynamic> generateRouteHoge(RouteSettings settings) {
  switch (settings.name) {
    case HOGE_ROOT_PAGE:
      return MaterialPageRoute(
          builder: (context) => HogePage(), settings: settings);
    default:
      throw Exception('無効なNamed Routeが指定されました。: ${settings.name}');
  }
}

Route<dynamic> generateRoutePiyo(RouteSettings settings) {
  switch (settings.name) {
    case PIYO_ROOT_PAGE:
      return MaterialPageRoute(
          builder: (context) => PiyoPage(), settings: settings);
    default:
      throw Exception('無効なNamed Routeが指定されました。: ${settings.name}');
  }
}
