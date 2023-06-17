import 'dart:convert';
import 'dart:js';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_univ/data/UserData.dart';
import 'package:flutter_univ/modules/FileFetch.dart';
import 'package:flutter_univ/theme/AppThemeDefault.dart';
import 'package:flutter_univ/widgets/DialogWindowWidgets/CustomDialog.dart';
import 'package:flutter_univ/widgets/WorkPageWidgets.dart/FileContainer.dart';
import 'package:flutter_univ/widgets/WorkPageWidgets.dart/TableColumn.dart';
import 'package:flutter_univ/widgets/WorkPageWidgets.dart/TableView.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'data/FileData.dart';
import 'pages/RoutePage.dart';
import 'theme/ThemeFactory.dart';

class WebSocketService extends ChangeNotifier {
  WebSocketChannel? connection;

  final API_URL = "ws://localhost:8080/FSB/WSConnect";

  Future<void> close() async {
    connection?.sink.close(1000, 'Exit');
  }

  Future<bool> open() async {
    try {
      var userData = UserDataSingleton();

      // print(Uri.parse("$API_URL/${userData.login}"));

      // connection = WebSocketChannel.connect(Uri.parse(API_URL));

      connection =
          WebSocketChannel.connect(Uri.parse("$API_URL/${userData.login}"));

      return true;
    } catch (e) {
      print('WebSocket connection failed: ' + e.toString());
      return false;
    }
  }

  void sendMessage() {
    var userData = UserDataSingleton();

    var JSONMessage = jsonEncode(<String, String>{
      'login': userData.login,
      'token': userData.token,
      'message': 'Subscribe'
    });

    connection?.sink.add(JSONMessage);
  }
}

class WebSocketServiceFactory {
  static var _Socket;

  static _createInstance() {
    return WebSocketService();
  }

  static createInstance() {
    WebSocketServiceFactory._Socket ??=
        WebSocketServiceFactory._createInstance();
    return WebSocketServiceFactory._Socket;
  }
}

enum FileStatus { ready, processing, nothing }

class SelectFile {
  FileStatus _status = FileStatus.nothing;
  late String _name = "";
  late int _start = 1;
  late int _numberRows = 1;
  late FileContainer _fileContainer;

  SelectFile(
      {required String name, required int start, required int numberRows}) {
    _numberRows = numberRows;
    _name = name;
    _start = start;
    _fileContainer = FileContainer(
      key: () {
        var r = Random();
        return Key(String.fromCharCodes(
            List.generate(10, (index) => r.nextInt(33) + 89)));
      }(),
      name: name,
      status: status,
    );
  }

  FileStatus get status => _status;

  set status(FileStatus status) {
    fileContainer.setStatus(status);
    _status = status;
  }

  set name(String name) {
    _name = name;
  }

  String get name => _name;

  set numberRows(int numberRows) {
    _numberRows = numberRows;
  }

  int get numberRows => _numberRows;

  set start(int start) {
    if (start < 1)
      _start = 1;
    else
      _start = start;
  }

  int get start => _start;

  set fileContainer(FileContainer fileContainer) {
    _fileContainer = fileContainer;
  }

  FileContainer get fileContainer => _fileContainer;
}

class TableOption extends ChangeNotifier {
  static bool _fixHeader = false;
  static bool _fixStart = false;
  static bool _fixEnd = false;

  static int _lengthStart = 0;
  static int _lengthEnd = 0;

  int get lengthStart => _lengthStart;

  set lengthStart(int lengthStart) {
    _lengthStart = lengthStart;
    notifyListeners();
  }

  int get lengthEnd => _lengthEnd;

  set lengthEnd(int lengthEnd) {
    _lengthEnd = lengthEnd;
    notifyListeners();
  }

  bool get fixHeader => _fixHeader;

  set fixHeader(bool fixHeader) {
    _fixHeader = fixHeader;
    notifyListeners();
  }

  bool get fixStart => _fixStart;

  set fixStart(bool fixStart) {
    _fixStart = fixStart;
    notifyListeners();
  }

  bool get fixEnd => _fixEnd;

  set fixEnd(bool fixEnd) {
    _fixEnd = fixEnd;
    notifyListeners();
  }
}

class OpenFiles extends ChangeNotifier {
  List<SelectFile> _openFiles = [];
  SelectFile? _selectedFile;
  Map<int, String> _title = {};
  // List<DataColumn> _fileTitle = [];
  // List<DataRow> _fileRow = [];
  Map<int, String> _fileTitle = {};
  Map<int, List<dynamic>> _fileRow = {};
  Map<String, String> _analyzedText = {};
  Map<int, bool> _selectedRow = {};
  bool? _allSelect = false;

  int _numberRow = 25;

  Map<int, bool> get selectedRow => _selectedRow;

  set selectedRow(Map<int, bool> selectedRow) {
    _selectedRow = selectedRow;
    notifyListeners();
  }

  bool? get allSelect => _allSelect;

  set allSelect(bool? allSelect) {
    _allSelect = allSelect;

    () async {
      if (allSelect != null) {
        await saveReportData(jsonEncode({'allSelect': allSelect.toString()}));
        refreshData();
      }
    }();

    notifyListeners();
  }

  set title(Map<int, String> title) {
    _title = title;
    notifyListeners();
  }

  Map<int, String> get title => _title;

  set analyzedText(Map<String, String> analyzedText) {
    _analyzedText = analyzedText;
    notifyListeners();
  }

  Map<String, String> get analyzedText => _analyzedText;

  set fileTitle(Map<int, String> fileTitle) {
    _fileTitle = fileTitle;
    notifyListeners();
  }

  Map<int, String> get fileTitle => _fileTitle;

  set fileRow(Map<int, List<dynamic>> fileRow) {
    _fileRow = fileRow;
    notifyListeners();
  }

  Map<int, List<dynamic>> get fileRow => _fileRow;

  // set fileTitle(List<DataColumn> fileTitle) {
  //   _fileTitle = fileTitle;
  //   notifyListeners();
  // }

  // List<DataColumn> get fileTitle => _fileTitle;

  // set fileRow(List<DataRow> fileRow) {
  //   _fileRow = fileRow;
  //   notifyListeners();
  // }

  // List<DataRow> get fileRow => _fileRow;

  set numberRow(int numberRow) {
    _numberRow = numberRow;
    refreshData();
    notifyListeners();
  }

  int get numberRow => _numberRow;

  set openFile(List<SelectFile> openFile) {
    _openFiles = openFile;
    notifyListeners();
  }

  List<SelectFile> get openFile => _openFiles;

  set selectedFile(SelectFile? fileContainer) {
    _selectedFile = fileContainer;
    notifyListeners();
  }

  SelectFile? get selectedFile => _selectedFile;

  Future<void> changeStatusFile(String fileName, FileStatus status) async {
    for (var element in _openFiles) {
      if (element.name == fileName) {
        element.status = status;
        break;
      }
    }

    if (status == FileStatus.ready && selectedFile?.name == fileName) {
      await refreshData();
      selectedFile?.status = FileStatus.nothing;
    }

    notifyListeners();
  }

  void addFile(SelectFile openFile) {
    _openFiles.add(openFile);
    _selectedFile = openFile;
    notifyListeners();
  }

  Future<void> saveReportData(String changeData) async {
    if (selectedFile != null && selectedFile!.name.isNotEmpty) {
      await updateDocFetch(selectedFile!.name, changeData);
    }
  }

  Future<void> removeFile(Key? keyFile) async {
    if (keyFile != null) {
      List<SelectFile> copeFile = _openFiles
          .where((element) => element.fileContainer.key != keyFile)
          .toList();

      if (copeFile.isEmpty) {
        selectedFile = null;
      } else {
        selectedFile = copeFile.last;
      }

      await refreshData();

      _openFiles.removeWhere(
        (element) => element.fileContainer.key == keyFile,
      );

      notifyListeners();
    }
  }

  Future<void> loadFile(String name) async {
    await getFileFetch(name).then((value) {}).catchError((error) {
      print(error.toString());
      clearData();
    });
    await addData(name, newFile: true);
  }

  Future<void> addData(String name,
      {int start = 1, bool newFile = false}) async {
    return await getDocFetch(name, start: start, diapason: numberRow)
        .then((docData) {
      // List<DataColumn> dataTitle = [];
      // List<DataRow> dataRow = [];
      int maxRowLenght = -1;

      try {
        if (docData is DocData) {
          int titleLength = docData.title?.length ?? 0;

          if (titleLength < 5) {
            throw Exception(
                "File Error 4: Файл поврежден и не может быть прочитан. Отсутствуют столбцы.");
          }

          docData.title
              ?.getRange(0, (titleLength - 4))
              .toList()
              .asMap()
              .forEach((key, value) {
            title[key] = value;
          });

          // docData.title?.asMap().forEach((key, value) {
          //   // if (value == "Обновить") {
          //   //   dataTitle.add(DataColumn(
          //   //     label: TableColumn(
          //   //       index: key,
          //   //       length: docData.title?.length ?? 0,
          //   //       child: const AllSelect(value: false),
          //   //     ),
          //   //   ));
          //   // } else {
          //   //   dataTitle.add(DataColumn(
          //   //     label: TableColumn(
          //   //       index: key,
          //   //       length: docData.title?.length ?? 0,
          //   //       child: Text(value),
          //   //     ),
          //   //   ));
          //   // }
          // });

          selectedRow = {};
          // docData.rows?.cast<String, List<dynamic>>();

          docData.rows?.forEach((key, value) {
            if (value is List<dynamic>) {
              if (maxRowLenght < value.length) {
                maxRowLenght = value.length;
              }

              // if (value.isNotEmpty) {
              //   analyzedText[key] = value[maxRowLenght - 4];

              //   selectedRow[(int.tryParse(key)! - 1)] =
              //       (value[maxRowLenght - 2] == "true");
              //   dataRow.add(buildTableRow(
              //     rowIndex: (int.tryParse(key)! - 1),
              //     rowsText: [...value.getRange(0, maxRowLenght - 4)],
              //     analyzedText: value[maxRowLenght - 4],
              //     probability: value[maxRowLenght - 3],
              //     incorrect: value[maxRowLenght - 1] == "true",
              //     type: docData.type?[key] ?? 0,
              //   ));
              // }
            } else {
              throw Exception(
                  "File Error 1: Файл поврежден и не может быть прочитан.");
            }
          });
        } else {
          throw Exception(
              "File Error 2: Файл поврежден и не может быть прочитан.");
        }

        // print(dataTitle.length)

        if (docData.title?.length != maxRowLenght) {
          throw Exception(
              "File Error 3: Файл поврежден и не может быть прочитан. Количество строк превышает количество столбцов.");
        }

        if (newFile) {
          SelectFile selectFile = SelectFile(
            name: name,
            start: 1,
            numberRows: docData.rowNumber ?? 0,
          );

          addFile(selectFile);
        }

        fileTitle = docData.title?.asMap() ?? {};

        Map<int, List<dynamic>> rows = {};

        docData.rows?.forEach((key, value) {
          rows[int.parse(key)] = value as List<dynamic>;
        });

        fileRow = rows;
      } catch (e) {
        throw Exception("Error: ${e.toString()}");
      }
    }).catchError((error) {
      print(error.toString());
      clearData();
    });
  }

  void clearData() {
    fileTitle = {};
    fileRow = {};
    title = {};
    allSelect = false;
    selectedRow = {};
  }

  Future<void> refreshData() async {
    if (selectedFile == null) {
      clearData();
      return;
    }

    addData(selectedFile?.name ?? "", start: selectedFile?.start ?? 1);
  }

  Future<void> selectFile(Key? keyFile) async {
    if (keyFile != null) {
      List<SelectFile> selectFiles = _openFiles
          .where((element) => element.fileContainer.key == keyFile)
          .toList();

      if (selectFiles.isEmpty) return;

      selectedFile = selectFiles.first;

      if (selectedFile?.status == FileStatus.ready) {
        selectedFile?.status = FileStatus.nothing;
      }

      refreshData();
    }
  }
}

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
  final WebSocketService _socket = WebSocketServiceFactory.createInstance();
  final TableOption _tableOption = TableOption();
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
          create: (context) => _socket,
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
        ChangeNotifierProvider(
          create: (context) => _tableOption,
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
                  _socket.close();
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
        context.read<OpenFiles>().loadFile(name);
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
