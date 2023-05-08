import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_univ/data/FileData.dart';
import 'package:flutter_univ/modules/ConnectionFetch.dart';
import 'package:flutter_univ/modules/WebSocketService.dart';
import 'package:flutter_univ/widgets/WorkPageWidgets.dart/TableColumn.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../modules/FileFetch.dart';
import '../theme/AppThemeDefault.dart';
import '../widgets/WorkPageWidgets.dart/FileContainer.dart';
import '../widgets/WorkPageWidgets.dart/FileView.dart';
import '../widgets/WorkPageWidgets.dart/Sidebar.dart';
import '../widgets/WorkPageWidgets.dart/TableView.dart';

class SelectFile {
  late String _name = "";
  late int _start = 1;
  late int _numberRows = 1;
  late FileContainer _selectFile;

  SelectFile(
      {required String name,
      required int start,
      required int numberRows,
      required FileContainer selectFile}) {
    _numberRows = numberRows;
    _name = name;
    _start = start;
    _selectFile = selectFile;
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

  set selectFile(FileContainer fileContainer) {
    _selectFile = fileContainer;
  }

  FileContainer get selectFile => _selectFile;
}

class OpenFiles extends ChangeNotifier {
  List<SelectFile> _openFile = [];
  SelectFile? _selectFile;
  List<DataColumn> _fileTitle = [];
  List<DataRow> _fileRow = [];
  int _numberRow = 25;

  set fileTitle(List<DataColumn> fileTitle) {
    _fileTitle = fileTitle;
    notifyListeners();
  }

  List<DataColumn> get fileTitle => _fileTitle;

  set fileRow(List<DataRow> fileRow) {
    _fileRow = fileRow;
    notifyListeners();
  }

  List<DataRow> get fileRow => _fileRow;

  set numberRow(int numberRow) {
    _numberRow = numberRow;
    refreshData();
    notifyListeners();
  }

  int get numberRow => _numberRow;

  set openFile(List<SelectFile> openFile) {
    _openFile = openFile;
    notifyListeners();
  }

  List<SelectFile> get openFile => _openFile;

  set selectedFile(SelectFile? fileContainer) {
    _selectFile = fileContainer;
    notifyListeners();
  }

  SelectFile? get selectedFile => _selectFile;

  void addFile(SelectFile openFile) {
    _openFile.add(openFile);
    _selectFile = openFile;
    notifyListeners();
  }

  Future<void> removeFile(Key? keyFile) async {
    if (keyFile != null) {
      List<SelectFile> copeFile = _openFile
          .where((element) => element.selectFile.key != keyFile)
          .toList();

      if (copeFile.isEmpty) {
        selectedFile = null;
      } else {
        selectedFile = copeFile.last;
      }

      await refreshData();

      _openFile.removeWhere(
        (element) => element.selectFile.key == keyFile,
      );

      notifyListeners();
    }
  }

  Future<void> addData(String name,
      {int start = 1, bool newFile = false}) async {
    return await getDocFetch(name, start: start, diapason: numberRow)
        .then((docData) {
      print("File OK");

      List<DataColumn> dataTitle = [];
      List<DataRow> dataRow = [];
      int maxRowLenght = -1;

      try {
        if (docData is DocData) {
          docData.title?.addAll([
            "Анализированное сообщение",
            "Вероятность",
            "Обновить",
            "Выделение",
          ]);

          docData.title?.asMap().forEach((key, value) {
            dataTitle.add(DataColumn(
              label: TableColumn(
                index: key,
                text: value,
                length: docData.title?.length ?? 0,
              ),
            ));
          });

          docData.rows?.forEach((key, value) {
            if (value is List<dynamic>) {
              if (maxRowLenght < value.length) {
                maxRowLenght = value.length + 4;
              }

              if (value.isNotEmpty) {
                dataRow.add(buildTableRow(rowsText: [...value]));
              }
            } else {
              throw Exception(
                  "File Error 1: Файл поврежден и не может быть прочитан.");
            }
          });
        } else {
          throw Exception(
              "File Error 2: Файл поврежден и не может быть прочитан.");
        }

        if (dataTitle.length != maxRowLenght) {
          throw Exception(
              "File Error 3: Файл поврежден и не может быть прочитан. Количество строк превышает количество столбцов.");
        }

        if (newFile) {
          FileContainer fileContainer = FileContainer(
            key: () {
              var r = Random();

              return Key(String.fromCharCodes(
                  List.generate(10, (index) => r.nextInt(33) + 89)));
            }(),
            name: name,
          );

          SelectFile selectFile = SelectFile(
              name: name,
              start: 1,
              numberRows: docData.rowNumber ?? 0,
              selectFile: fileContainer);

          addFile(selectFile);
        }

        fileTitle = dataTitle;
        fileRow = dataRow;
      } catch (e) {
        throw Exception("Error: ${e.toString()}");
      }
    }).catchError((error) {
      print(error.toString());
      fileTitle = [];
      fileRow = [];
    });
  }

  Future<void> refreshData() async {
    if (selectedFile == null) {
      fileRow = [];
      return;
    }

    addData(selectedFile?.name ?? "", start: selectedFile?.start ?? 1);
  }

  Future<void> selectFile(Key? keyFile) async {
    if (keyFile != null) {
      List<SelectFile> selectFiles = _openFile
          .where((element) => element.selectFile.key == keyFile)
          .toList();

      if (selectFiles.isEmpty) return;

      selectedFile = selectFiles.first;

      refreshData();
    }
  }
}

class DictioneryText extends ChangeNotifier {
  List<TextSpan> _dictText = [];

  set dictText(List<TextSpan> dictText) {
    _dictText = dictText;
    notifyListeners();
  }

  List<TextSpan> get dictText => _dictText;
}

class TypeViewMenu extends ChangeNotifier {
  bool _show = true;

  set show(bool show) {
    _show = show;
    notifyListeners();
  }

  bool get show => _show;
}

class WorkPage extends StatefulWidget {
  const WorkPage({super.key});

  @override
  State<WorkPage> createState() => _WorkPageState();
}

class _WorkPageState extends State<WorkPage> {
  final DictioneryText _dictioneryText = DictioneryText();
  final TypeViewMenu _typeViewMenu = TypeViewMenu();

  WebSocketService socket = WebSocketServiceFactory.createInstance();

  @override
  void initState() {
    super.initState();

    callConnection((connect) {
      context.read<ConnectStatus>().status = connect;
    });

    socket.open();

    socket.sendMessage();

    subscribeDataConnection(socket.connection?.stream);
  }

  @override
  void dispose() {
    socket.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //Добавление Provider темы в MultiProvider
        ChangeNotifierProvider(
          create: (context) => _dictioneryText,
        ),
        ChangeNotifierProvider(
          create: (context) => _typeViewMenu,
        ),
      ],
      builder: (context, child) {
        return Center(
          child: Container(
            color: appTheme(context).tertiaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: context.watch<TypeViewMenu>().show ? 1500 : 900,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: const [
                      Expanded(
                        flex: 75,
                        child: MFileView(),
                      ),
                      Spacer(
                        flex: 3,
                      ),
                      Expanded(
                        flex: 900,
                        child: MTableView(),
                      ),
                    ],
                  ),
                ),
                const Spacer(
                  flex: 3,
                ),
                Expanded(
                  flex: context.watch<TypeViewMenu>().show ? 80 : 200,
                  child: Stack(
                    fit: StackFit.expand,
                    clipBehavior: Clip.none,
                    children: [
                      const MSidebar(),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            heightFactor: 0.2,
                            widthFactor:
                                context.watch<TypeViewMenu>().show ? 0.3 : 0.1,
                            child: Container(
                              margin: const EdgeInsets.only(right: 5),
                              child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    appTheme(context).secondaryColor,
                                  ),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: context
                                              .watch<TypeViewMenu>()
                                              .show
                                          ? const BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              bottomLeft: Radius.circular(30))
                                          : const BorderRadius.only(
                                              topRight: Radius.circular(30),
                                              bottomRight: Radius.circular(30)),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  context.read<TypeViewMenu>().show =
                                      !context.read<TypeViewMenu>().show;
                                },
                                child: context.watch<TypeViewMenu>().show
                                    ? const Text('<')
                                    : const Text('>'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
