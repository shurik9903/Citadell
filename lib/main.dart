import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_univ/data/UserData.dart';
import 'package:flutter_univ/theme/AppThemeDefault.dart';
import 'package:provider/provider.dart';

import 'pages/RoutePage.dart';
import 'theme/ThemeFactory.dart';

class SelectTheme extends ChangeNotifier {
  //Класс провайдер для смены тем приложения
  EnumTheme _enumTheme = EnumTheme.dark;

  set theme(EnumTheme theme) {
    _enumTheme = theme;
    notifyListeners();
  }

  EnumTheme get theme => _enumTheme;

  void change() {
    //Переключение тем
    if (_enumTheme == EnumTheme.dark) {
      _enumTheme = EnumTheme.light;
    } else {
      _enumTheme = EnumTheme.dark;
    }
    notifyListeners();
  }
}

void main() {
  runApp(const MyApp());
}

//Основное окно
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //Provider для возможности глобально изменить цвет
  final SelectTheme _selectTheme = SelectTheme();
  EnumPage _enumPage = EnumPage.none;

  @override
  Widget build(BuildContext context) {
    //Фабрикатор страниц
    RoutePageFactory pageFactory = RoutePageFactory();
    //Фабрикатор темы
    ThemeFactory themeFactory = ThemeFactory();

    return MultiProvider(
      providers: [
        //Добавление Provider темы в MultiProvider
        ChangeNotifierProvider(
          create: (context) => _selectTheme,
        ),
      ],
      builder: (context, child) {
        return MaterialApp(
          initialRoute: '/login',
          title: 'FSB',
          theme: themeFactory.themeCreator(context.watch<SelectTheme>().theme),
          onGenerateRoute: (settings) {
            var user_data = UserData_Singleton();

            // if (user_data.token.isEmpty) {
            //   _enumPage = EnumPage.login;
            // } else {
            var path = settings.name?.split('/');
            switch (path?[1]) {
              case "login":
                _enumPage = EnumPage.login;
                break;
              case "work":
                _enumPage = EnumPage.work;
                break;
              case "option":
                _enumPage = EnumPage.option;
                break;
              default:
                _enumPage = EnumPage.none;
                break;
            }
            // }
            return MaterialPageRoute(
                builder: (context) => Scaffold(
                      endDrawer: const Drawer(
                        child: DrawerMenu(),
                      ),
                      body: LayoutBuilder(
                        builder: (context, constraints) =>
                            SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                                padding: const EdgeInsets.all(5),
                                color: appTheme(context).primaryColor,
                                constraints: BoxConstraints.tightFor(
                                    height: max(1080, constraints.maxHeight),
                                    width: max(1920, constraints.maxWidth)),
                                child: pageFactory.pageCreator(_enumPage)),
                          ),
                        ),
                      ),
                    ),
                settings: settings);
          },
        );
      },
    );
  }
}

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({super.key});

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DrawerHeader(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: Container(
              color: appTheme(context).secondaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.read<SelectTheme>().change();
                    },
                    child: Container(
                      child: Icon(Icons.palette,
                          color: appTheme(context).additionalColor3),
                    ),
                  )
                ],
              ),
            )),
        ListTile(
          title: Text("Сохранить данные"),
          onTap: () {},
        ),
        ListTile(
          title: Text("Загрузить данные"),
          onTap: () {},
        ),
        ListTile(
          title: Text("Доп. Информация"),
          onTap: () {},
        ),
        ListTile(
          title: Text("Настройки"),
          onTap: () {
            Navigator.pushNamed(context, '/option');
          },
        ),
        ListTile(
          title: Text("Закрыть файл"),
          onTap: () {},
        ),
        ListTile(
          title: Text("Выход"),
          onTap: () {
            UserData_Singleton().clear();
            Navigator.pushNamed(context, '/login');
          },
        ),
        ListTile(
          title: Text("Закрыть"),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
