import 'dart:convert';
import 'dart:js';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_univ/data/Option.dart';
import 'package:flutter_univ/data/UserData.dart';
import 'package:flutter_univ/modules/ConnectionFetch.dart';
import 'package:flutter_univ/modules/FileFetch.dart';
import 'package:flutter_univ/theme/AppThemeDefault.dart';
import 'package:flutter_univ/widgets/DialogWindowWidgets/CustomDialog.dart';
import 'package:flutter_univ/widgets/DialogWindowWidgets/MessageDialog.dart';
import 'package:flutter_univ/widgets/DialogWindowWidgets/OkCancelDialog.dart';
import 'package:flutter_univ/widgets/WorkPageWidgets/FileContainer.dart';

import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'data/FileData.dart';
import 'pages/RoutePage.dart';
import 'theme/ThemeFactory.dart';

class WebSocketService extends ChangeNotifier {
  WebSocketChannel? connection;

  Future<void> close() async {
    connection?.sink.close(1000, 'Exit');
  }

  Future<bool> open() async {
    OptionSingleton option = OptionSingleton();

    final webSocketUrl =
        "ws://${option.serverIP}:${option.serverPort}/${option.serverName}/WSConnect";

    try {
      var userData = UserDataSingleton();

      connection = WebSocketChannel.connect(
          Uri.parse("$webSocketUrl/${userData.login}"));

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
  late TableOption _tableOption;

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
    _tableOption = TableOption();
  }

  TableOption get tableOption => _tableOption;

  set tableOption(TableOption tableOption) {
    _tableOption = tableOption;
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

class TypeRow {
  late Color _color;
  late String _name;

  TypeRow(Color color, String name) {
    _color = color;
    _name = name;
  }

  Color get color => _color;

  set color(Color color) {
    _color = color;
  }

  String get name => _name;

  set name(String name) {
    _name = name;
  }
}

class TableOption extends ChangeNotifier {
  bool _fixHeader = true;
  bool _fixStart = false;
  bool _fixEnd = false;

  bool _enableColorStart = true;
  bool _enableColorEnd = true;

  Color _colorStart = Colors.blue;
  Color _colorEnd = Colors.orange;

  int _lengthStart = 0;
  int _lengthEnd = 0;

  Map<int, TypeRow> _typeRow = {
    1: TypeRow(const Color.fromARGB(39, 255, 247, 0), "Власть"),
    2: TypeRow(const Color.fromARGB(33, 131, 255, 43), "Церковь"),
    3: TypeRow(const Color.fromARGB(40, 255, 72, 72), "Врачи/Медицина"),
    4: TypeRow(const Color.fromARGB(40, 0, 255, 38), "Нерусские"),
    5: TypeRow(const Color.fromARGB(40, 255, 154, 31), "ЛГБТ"),
  };

  Map<int, TypeRow> get typeRow => _typeRow;

  set typeRow(Map<int, TypeRow> typeRow) {
    _typeRow = typeRow;

    notifyListeners();
  }

  Color get colorStart => _colorStart;

  set colorStart(Color colorStart) {
    _colorStart = colorStart;

    notifyListeners();
  }

  Color get colorEnd => _colorEnd;

  set colorEnd(Color colorEnd) {
    _colorEnd = colorEnd;

    notifyListeners();
  }

  bool get enableColorStart => _enableColorStart;

  set enableColorStart(bool enableColorStart) {
    _enableColorStart = enableColorStart;

    notifyListeners();
  }

  bool get enableColorEnd => _enableColorEnd;

  set enableColorEnd(bool enableColorEnd) {
    _enableColorEnd = enableColorEnd;

    notifyListeners();
  }

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

  set setOption(TableOption tableOption) {
    fixHeader = tableOption.fixHeader;
    fixStart = tableOption.fixStart;
    fixEnd = tableOption.fixEnd;

    enableColorStart = tableOption.enableColorStart;
    enableColorEnd = tableOption.enableColorEnd;

    colorStart = tableOption.colorStart;
    colorEnd = tableOption.colorEnd;

    lengthStart = tableOption.lengthStart;
    lengthEnd = tableOption.lengthEnd;

    typeRow = tableOption.typeRow;
  }
}

class OpenFiles extends ChangeNotifier {
  List<SelectFile> _openFiles = [];
  SelectFile? _selectedFile;
  // TableOption _tableOption = TableOption();
  Map<int, String> _title = {};
  Map<int, String> _titleTypes = {};
  Map<int, String> _fileTitle = {};
  Map<int, List<dynamic>> _fileRow = {};
  Map<int, int> _rowsType = {};
  Map<String, String> _analyzedText = {};
  Map<int, bool> _selectedRow = {};
  bool? _allSelect = false;

  int _numberRow = 25;

  Map<int, int> get rowsType => _rowsType;

  set rowsType(Map<int, int> rowsType) {
    _rowsType = rowsType;
    notifyListeners();
  }

  Map<int, bool> get selectedRow => _selectedRow;

  set selectedRow(Map<int, bool> selectedRow) {
    _selectedRow = selectedRow;
    notifyListeners();
  }

  bool? get allSelect => _allSelect;

  set allSelect(bool? allSelect) {
    _allSelect = allSelect;

    () async {
      if (allSelect != null && selectedFile != null) {
        await saveRowData(jsonEncode({'allSelect': allSelect.toString()}));
        refreshData();
      }
    }();

    notifyListeners();
  }

  set titleTypes(Map<int, String> titleTypes) {
    _titleTypes = titleTypes;
    notifyListeners();
  }

  Map<int, String> get titleTypes => _titleTypes;

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

  Future<void> saveRowData(String changeData) async {
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

  Future<bool> loadFile(String name) async {
    if (openFile.firstWhereOrNull((element) => element._name == name) != null) {
      return false;
    }

    await getFileFetch(name).then((value) {}).catchError((error) {
      print(error.toString());
      clearData();
    });

    return await addData(name, newFile: true);
  }

  Future<bool> addData(String name,
      {int start = 1, bool newFile = false}) async {
    await getDocFetch(name, start: start, diapason: numberRow).then((docData) {
      int maxRowLenght = -1;

      try {
        int titleLength = docData.title.length;

        if (titleLength < 5) {
          throw Exception(
              "File Error 4: Файл поврежден и не может быть прочитан. Отсутствуют дополнительные столбцы.");
        }

        docData.title
            .getRange(0, (titleLength - 4))
            .toList()
            .asMap()
            .forEach((key, value) {
          title[key] = value;
        });

        selectedRow = {};

        docData.rows.forEach((key, value) {
          if (value is List<dynamic>) {
            if (maxRowLenght < value.length) {
              maxRowLenght = value.length;
            }
          } else {
            throw Exception(
                "File Error 1: Файл поврежден и не может быть прочитан.");
          }
        });

        print(docData.title);

        if (docData.title.length != maxRowLenght) {
          throw Exception(
              "File Error 3: Файл поврежден и не может быть прочитан. Количество заголовков превышает количество столбцов.");
        }

        if (newFile) {
          SelectFile selectFile = SelectFile(
            name: name,
            start: 1,
            numberRows: docData.rowNumber,
          );

          addFile(selectFile);
        }

        fileTitle = docData.title.asMap();
        titleTypes = docData.titleTypes.asMap();

        Map<int, List<dynamic>> rows = {};

        docData.rows.forEach((key, value) {
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

    return true;
  }

  void clearData() {
    fileTitle = {};
    fileRow = {};
    title = {};
    rowsType = {};
    analyzedText = {};
    selectedRow = {};
    allSelect = false;
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
        // ChangeNotifierProvider(
        //   create: (context) => _openFile,
        // ),
        ChangeNotifierProvider(
          create: (context) => _tableOption,
        ),
        ChangeNotifierProxyProvider<TableOption, OpenFiles>(
            create: (context) => _openFile,
            update: (context, tableOtion, openFile) {
              openFile?.selectedFile?.tableOption.setOption = _tableOption;
              return openFile!;
            }),
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
          title: 'Citadell',
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

                                // height: max(600, constraints.maxHeight),
                                // width: max(800, constraints.maxWidth)),

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
            showCustomDialogWindow(
                context: context,
                child: const FilesContainer(),
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
              print(error);
              return;
            });
          },
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
          title: const Text("Закрыть"),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text("Проверка сетевого соединения"),
          onTap: () {
            connectionFetch().then((value) {
              showMessageDialogWindow(
                  context, 'Сетевое соединение присутствует');
            }).catchError((error) {
              showMessageDialogWindow(
                  context, 'Сетевое соединение отсутствует');
            });
          },
        ),
        ListTile(
          title: const Text("О программе"),
          onTap: () {
            showCustomDialogWindow(
                context: context,
                child: const InfoProgram(),
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
              print(error);
              return;
            });
          },
        ),
        ListTile(
          title: const Text("Выход"),
          onTap: () {
            Navigator.pushNamed(context, '/login');
          },
        ),
      ],
    );
  }
}

class InfoProgram extends StatelessWidget {
  const InfoProgram({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 250,
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        color: appTheme(context).primaryColor,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Web-приложение для классификации комментариев пользователей, а также выявление экстремистских высказываний посредством анализа сообщений машинным обучением",
            ),
            Text(
              "\n\n Автор:  \n Кривоносова София \n Сулима Роман \n Бовт Александр",
            ),
            Spacer(),
            Text(
              "Регистрационный номер: 2023665649",
            ),
          ],
        ),
      ),
    );
  }
}

class FilesContainer extends StatefulWidget {
  const FilesContainer({super.key});

  @override
  State<FilesContainer> createState() => _FilesContainerState();
}

class _FilesContainerState extends State<FilesContainer> {
  List<FileData> files = [];

  @override
  void initState() {
    super.initState();
    update();
  }

  void update() {
    getAllUserFileFetch().then((value) {
      setState(() {
        files = value ?? [];
      });
    }).catchError((error) {
      files = [];
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: Column(
        children: [
          ...(files).map<Widget>((value) {
            return SelectFileContainer(
              key: Key(value.id.toString()),
              name: value.name,
              fileID: value.id,
              deleteFile: update,
            );
          }).toList(),
        ],
      ),
    );
  }
}

class SelectFileContainer extends StatefulWidget {
  const SelectFileContainer({
    super.key,
    required this.name,
    required this.fileID,
    required this.deleteFile,
  });

  final String name;
  final int fileID;
  final Function deleteFile;

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
      onTap: () async {
        context.read<OpenFiles>().loadFile(name).then((value) {
          if (!value) {
            showMessageDialogWindow(context, "Файл с именем $name уже открыт!");
          }
        });
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
            const Spacer(),
            IconButton(
                onPressed: () {
                  showOkCancelDialogWindow(context,
                          'Вы уверены, что хотите удалить данный файл?')
                      .then((value) {
                    if (value) {
                      deleteFileFetch(name).then((value) {
                        widget.deleteFile();
                        showMessageDialogWindow(
                            context, "Файл успешно удален!");
                      }).catchError((e) {
                        showMessageDialogWindow(
                            context, "Не удалось удалить файл!\nОшибка: $e");
                      });
                    }
                  });
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ))
          ],
        ),
      ),
    );
  }
}
