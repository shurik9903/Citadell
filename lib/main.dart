import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_univ/data/UserData.dart';
import 'package:flutter_univ/modules/FileFetch.dart';
import 'package:flutter_univ/pages/WorkPage.dart';
import 'package:flutter_univ/theme/AppThemeDefault.dart';
import 'package:flutter_univ/widgets/DialogWindowWidgets/CustomDialog.dart';
import 'package:provider/provider.dart';

import 'data/FileData.dart';
import 'pages/RoutePage.dart';
import 'theme/ThemeFactory.dart';

class ConnectStatus extends ChangeNotifier {
  bool _status = false;

  set status(bool status) {
    _status = status;
    notifyListeners();
  }

  bool get status => _status;
}

class TokenStatus extends ChangeNotifier {
  bool _tokenStatus = false;

  set tokenStatus(bool tokenStatus) {
    _tokenStatus = tokenStatus;
    notifyListeners();
  }

  bool get tokenStatus => _tokenStatus;
}

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
  UserDataSingleton();
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
  final ConnectStatus _connectStatus = ConnectStatus();
  final OpenFiles _openFile = OpenFiles();
  final TokenStatus _tokenStatus = TokenStatus();
  EnumPage _enumPage = EnumPage.none;

  @override
  void initState() {
    super.initState();
  }

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
        ChangeNotifierProvider(
          create: (context) => _connectStatus,
        ),
        ChangeNotifierProvider(
          create: (context) => _openFile,
        ),
        ChangeNotifierProvider(
          create: (context) => _tokenStatus,
        ),
      ],
      builder: (context, child) {
        if (context.watch<TokenStatus>().tokenStatus == true) {
          Navigator.pushNamed(context, '/login');
        }

        return MaterialApp(
          initialRoute: '/login',
          title: 'FSB',
          theme: themeFactory.themeCreator(context.watch<SelectTheme>().theme),
          onGenerateRoute: (settings) {
            var userData = UserDataSingleton();

            if (userData.token.isEmpty) {
              _enumPage = EnumPage.login;
            } else {
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
            }
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
                                    height: max(840, constraints.maxHeight),
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
          title: const Text("Сохранить данные"),
          onTap: () async {
            SelectFile? selectFile = context.read<OpenFiles>().selectedFile;
            if (selectFile != null) await rewriteFileFetch(selectFile.name);
          },
        ),
        ListTile(
          title: const Text("Загрузить данные"),
          onTap: () async {
            await getAllUserFileFetch().then((value) {
              showCustomDialogWindow(
                  context: context,
                  child: SizedBox(
                    width: 500,
                    child: Column(
                      children: [
                        ...(value as List<FileData>).map<Widget>((value) {
                          return SelectFileContainer(
                              name: value.name ?? ' ', fileID: value.id ?? -1);
                        }).toList(),
                      ],
                    ),
                  ),
                  button: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, "cancel");
                      },
                      child: const Text("Закрыть"),
                    ),
                  ]).then((value) async {
                if (value as String == "cancel") {
                  return;
                }
              }).catchError((error) {
                return;
              });
            }).catchError((error) {
              print(error);
            });
          },
        ),
        ListTile(
          title: const Text("Доп. Информация"),
          onTap: () {},
        ),
        ListTile(
          title: const Text("Настройки"),
          onTap: () {
            Navigator.pushNamed(context, '/option');
          },
        ),
        ListTile(
          title: const Text("Закрыть файл"),
          onTap: () {
            context.read<OpenFiles>().removeFile(
                context.read<OpenFiles>().selectedFile?.fileContainer.key);
          },
        ),
        ListTile(
          title: const Text("Выход"),
          onTap: () {
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

class SelectFileContainer extends StatefulWidget {
  const SelectFileContainer(
      {super.key, required this.name, required this.fileID});

  final String name;
  final int fileID;

  @override
  State<SelectFileContainer> createState() => _SelectFileContainerState();
}

class _SelectFileContainerState extends State<SelectFileContainer> {
  late String name;
  late int fileID;

  @override
  void initState() {
    super.initState();
    name = widget.name;
    fileID = widget.fileID;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('${name} ${fileID}');
        context.read<OpenFiles>().addData(name, newFile: true);
        Navigator.pop(context, "cancel");
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        width: double.infinity,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: appTheme(context).secondaryColor,
            border: Border.all(color: appTheme(context).accentColor),
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        child: Row(
          children: [
            Text(name),
          ],
        ),
      ),
    );
  }
}
