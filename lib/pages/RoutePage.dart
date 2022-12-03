import 'package:flutter/material.dart';
import 'package:flutter_univ/pages/OptionPage.dart';
import 'LoginPage.dart';
import 'WorkPage.dart';

enum EnumPage { none, work, login, option }

class RoutePageFactory {
  Widget pageCreator(EnumPage enumPage) {
    Widget page = Container();

    switch (enumPage) {
      case EnumPage.work:
        page = const WorkPage();
        break;
      case EnumPage.login:
        page = const LoginPage();
        break;
      case EnumPage.option:
        page = const OptionPage();
        break;
      case EnumPage.none:
        page = Container();
        break;
      default:
        page = Container();
        break;
    }

    return page;
  }
}
