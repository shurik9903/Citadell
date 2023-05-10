import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:provider/provider.dart';

import '../../theme/AppThemeDefault.dart';

class LoadFile {
  late String _fullName;
  late String _name;
  late String _type;
  late Uint8List _bytes;
  late int _size;
  bool _title = true;
  bool _autoSize = true;
  Map<String, String> _sizeTable = {
    'colStart': '1',
    'colSize': '1',
    'rowStart': '1',
    'rowSize': '1'
  };

  Map<String, dynamic> toJson() => {
        'fullName': _fullName,
        'name': _name,
        'type': _type,
        'bytes': _bytes.toString(),
        'title': _title,
        'autoSize': _autoSize,
        'sizeTable': _sizeTable
      };

  LoadFile(
      {required String fullName,
      required String type,
      required Uint8List bytes,
      required int size}) {
    _fullName = fullName;
    _type = type;
    _bytes = bytes;
    _name = fullName.substring(0, fullName.lastIndexOf('.'));
    _size = size;
  }

  String get name => _name;

  set name(String name) {
    _name = name;
  }

  String get fullName => _fullName;

  String get type => _type;

  set type(String type) {
    _type = type;
  }

  bool get autoSize => _autoSize;

  set autoSize(bool autoSize) {
    _autoSize = autoSize;
  }

  bool get title => _title;

  set title(bool title) {
    _title = title;
  }

  Map<String, String> get sizeTable => _sizeTable;

  set sizeTable(Map<String, String> sizeTable) {
    _sizeTable = sizeTable;
  }

  String get size {
    final kb = _size / 1024;
    final mb = kb / 1024;

    return mb > 1
        ? '${mb.toStringAsFixed(2)} MB'
        : '${kb.toStringAsFixed(2)} KB';
  }
}

class FileWorking extends ChangeNotifier {
  LoadFile? _loadFile;
  Widget _openWindow = Container();
  String? _dropdownValue;
  List<String> _type = [
    '.txt',
    '.doc',
    '.xls',
  ];

  List<String> get type => _type;

  set type(List<String> type) {
    _type = type;
    notifyListeners();
  }

  LoadFile? get loadFile => _loadFile;

  set loadFile(LoadFile? loadFile) {
    _loadFile = loadFile;
    notifyListeners();
  }

  Widget get openWindow => _openWindow;

  set openWindow(Widget openWindow) {
    _openWindow = openWindow;
    notifyListeners();
  }

  String? get dropdownValue => _dropdownValue;

  set dropdownValue(String? dropdownValue) {
    _dropdownValue = dropdownValue;
    notifyListeners();
  }
}

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key, required this.list});
  final List<String> list;

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  late List<String> list;
  @override
  void initState() {
    super.initState();
    list = widget.list;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: context.read<FileWorking>().dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      underline: Container(
        height: 2,
        color: appTheme(context).secondaryColor,
      ),
      onChanged: (String? value) {
        setState(() {
          context.read<FileWorking>().dropdownValue = value!;
        });
        context.read<FileWorking>().loadFile?.type = value!;
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class DropFileContainer extends StatefulWidget {
  const DropFileContainer({super.key});

  @override
  State<DropFileContainer> createState() => _DropFileContainerState();
}

class _DropFileContainerState extends State<DropFileContainer> {
  late DropzoneViewController dropController;
  bool isDroping = false;
  bool fileError = false;

  @override
  Widget build(BuildContext context) {
    final dropColor = isDroping
        ? const Color.fromARGB(209, 0, 179, 255)
        : appTheme(context).primaryColor;

    return Center(
      child: Container(
        height: 200,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 100),
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: dropColor,
          border: Border.all(
            color: appTheme(context).tertiaryColor,
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            DropzoneView(
              onHover: () {
                setState(() {
                  isDroping = true;
                });
              },
              onLeave: () {
                setState(() {
                  isDroping = false;
                });
              },
              onCreated: ((controller) => dropController = controller),
              onDrop: (event) async {
                setState(() {
                  isDroping = false;
                });

                LoadFile loadFile = await loadingFile(event);

                if (isInvalidFile(loadFile.type)) {
                  showSelectFileWindow(loadFile);
                } else {
                  setState(() {
                    fileError = true;
                  });
                }
              },
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_upload),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("Перетащите файл в эту зону"),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(5),
                        shape: const RoundedRectangleBorder()),
                    icon: const Icon(
                      Icons.file_open,
                      size: 20,
                    ),
                    label: const Text("Выбрать файл"),
                    onPressed: () async {
                      final events = await dropController.pickFiles();

                      if (events.isEmpty) {
                        return;
                      }

                      LoadFile loadFile = await loadingFile(events.first);

                      if (isInvalidFile(loadFile.type)) {
                        showSelectFileWindow(loadFile);
                      } else {
                        setState(() {
                          fileError = true;
                        });
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  fileError
                      ? const Text(
                          "Неподдерживаемый тип файла. \nПоддерживаемые типы файлов:\n.txt, .doc(x), .xls(x).",
                          style: TextStyle(color: Colors.red))
                      : const SizedBox.shrink()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isInvalidFile(String type) {
    return context
        .read<FileWorking>()
        .type
        .firstWhere(
          (element) => RegExp(r'' + '^\\$element.?\$').hasMatch(type),
          orElse: () => "",
        )
        .isNotEmpty;
  }

  Future<LoadFile> loadingFile(dynamic event) async {
    final name = event.name;
    final mime = await dropController.getFileMIME(event);
    final bytes = await dropController.getFileData(event);
    final size = await dropController.getFileSize(event);
    final url = await dropController.createFileUrl(event);

    return LoadFile(
        fullName: name,
        type: name.substring(name.lastIndexOf('.')),
        bytes: bytes,
        size: size);
  }

  void showSelectFileWindow(LoadFile loadfile) {
    context.read<FileWorking>().loadFile = loadfile;

    String type = context.read<FileWorking>().type.firstWhere(
          (element) => RegExp(r'' + '^\\$element.?\$').hasMatch(loadfile.type),
          orElse: () => "",
        );

    context.read<FileWorking>().dropdownValue = type;
    context.read<FileWorking>().loadFile?.type = type;
    context.read<FileWorking>().openWindow = const FileWorkWindow();
  }
}

class DigitsTextField extends StatefulWidget {
  const DigitsTextField({super.key, this.callback});
  final Function? callback;
  @override
  State<DigitsTextField> createState() => _DigitsTextFieldState();
}

class _DigitsTextFieldState extends State<DigitsTextField> {
  late Function? callback;

  @override
  void initState() {
    super.initState();
    callback = widget.callback;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        if (callback != null) {
          callback!(value);
        }
      },
      decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 5),
          border: UnderlineInputBorder(),
          hintText: '1'),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
    );
  }
}

class ContainerStyle extends StatefulWidget {
  const ContainerStyle({super.key, required this.child, required this.text});

  final String text;
  final Widget child;

  @override
  State<ContainerStyle> createState() => _ContainerStyleState();
}

class _ContainerStyleState extends State<ContainerStyle> {
  late String text;
  late Widget child;

  @override
  void initState() {
    super.initState();

    text = widget.text;
    child = widget.child;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.only(top: 15),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: appTheme(context).tertiaryColor, width: 1),
            ),
          ),
          child: child,
        ),
        Positioned(
          left: 25,
          top: 2,
          child: Container(
            padding: const EdgeInsets.only(bottom: 1, left: 5, right: 5),
            color: appTheme(context).secondaryColor,
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}

class ColRowController extends StatefulWidget {
  const ColRowController({super.key});

  @override
  State<ColRowController> createState() => _ColRowControllerState();
}

class _ColRowControllerState extends State<ColRowController> {
  bool isAutoSizeTable = true;
  bool isColumnTitle = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CheckboxListTile(
          title: const Text(
              "Включить заголовки столбцов\n(Первая строка как заголовок)"),
          value: isColumnTitle,
          onChanged: (value) {
            setState(() {
              isColumnTitle = value!;
            });
            context.read<FileWorking>().loadFile?.title = isColumnTitle;
          },
          controlAffinity: ListTileControlAffinity.leading,
        ),
        CheckboxListTile(
          title: const Text("Автоматический размер"),
          value: isAutoSizeTable,
          onChanged: (value) {
            setState(() {
              isAutoSizeTable = value!;
            });

            context.read<FileWorking>().loadFile?.autoSize = isAutoSizeTable;
          },
          controlAffinity: ListTileControlAffinity.leading,
        ),
        sizeWindowView(),
      ],
    );
  }

  Widget sizeWindowView() {
    return !isAutoSizeTable
        ? Table(columnWidths: const {
            0: FlexColumnWidth(5),
            1: FlexColumnWidth(8),
          }, children: [
            TableRow(
              children: [
                const TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("Начало строки: "),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: DigitsTextField(
                      callback: (value) {
                        context
                            .read<FileWorking>()
                            .loadFile
                            ?.sizeTable['rowStart'] = value;
                      },
                    ),
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                const TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("Начало столбца: "),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: DigitsTextField(
                      callback: (value) {
                        context
                            .read<FileWorking>()
                            .loadFile
                            ?.sizeTable['colStart'] = value;
                      },
                    ),
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                const TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("Количество строк: "),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: DigitsTextField(
                      callback: (value) {
                        context
                            .read<FileWorking>()
                            .loadFile
                            ?.sizeTable['rowSize'] = value;
                      },
                    ),
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                const TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("Количество столбцов: "),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: DigitsTextField(
                      callback: (value) {
                        context
                            .read<FileWorking>()
                            .loadFile
                            ?.sizeTable['colSize'] = value;
                      },
                    ),
                  ),
                ),
              ],
            )
          ])
        : const SizedBox.shrink();
  }
}

class FileWorkWindow extends StatefulWidget {
  const FileWorkWindow({super.key});

  @override
  State<FileWorkWindow> createState() => _FileWorkWindowState();
}

class _FileWorkWindowState extends State<FileWorkWindow> {
  bool isAutoSizeTable = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          padding: const EdgeInsets.all(20),
          alignment: Alignment.topLeft,
          decoration: BoxDecoration(
            color: appTheme(context).secondaryColor,
            border: Border.all(
              color: appTheme(context).tertiaryColor,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ContainerStyle(
                text: "Имя файла",
                child: TextField(
                  onChanged: (value) {},
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                      border: const UnderlineInputBorder(),
                      hintText:
                          '${context.read<FileWorking>().loadFile?.name}'),
                ),
              ),
              ContainerStyle(
                text: "Тип файла",
                child: DropdownButtonExample(
                  list: context.read<FileWorking>().type,
                ),
              ),
              ContainerStyle(
                text: "Размер файла",
                child: Text("${context.read<FileWorking>().loadFile?.size}"),
              ),
              tableSizeWindow(),
            ],
          )),
    );
  }

  Widget tableSizeWindow() {
    return context.watch<FileWorking>().dropdownValue == ".xls"
        ? ContainerStyle(
            text: "Размер таблицы",
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [ColRowController()],
            ),
          )
        : const SizedBox.shrink();
  }
}

class FileDialogWindow extends StatefulWidget {
  const FileDialogWindow({super.key});

  @override
  State<FileDialogWindow> createState() => _FileDialogWindowState();
}

class _FileDialogWindowState extends State<FileDialogWindow> {
  final FileWorking _fileWorking = FileWorking();

  @override
  void initState() {
    super.initState();
    _fileWorking.openWindow = const DropFileContainer();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => _fileWorking,
          ),
        ],
        builder: (context, child) {
          Widget loadFile() {
            return context.watch<FileWorking>().openWindow.toString() ==
                    const FileWorkWindow().toString()
                ? TextButton(
                    onPressed: () {
                      Navigator.pop(
                          context, context.read<FileWorking>().loadFile);
                    },
                    child: const Text("Открыть"),
                  )
                : const SizedBox.shrink();
          }

          Widget changeFile() {
            return context.watch<FileWorking>().openWindow.toString() ==
                    const FileWorkWindow().toString()
                ? TextButton(
                    onPressed: () {
                      context.read<FileWorking>().loadFile = null;
                      context.read<FileWorking>().openWindow =
                          const DropFileContainer();
                    },
                    child: const Text("Сменить файл"),
                  )
                : const SizedBox.shrink();
          }

          return Dialog(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: 500,
                      child: Container(
                        decoration: BoxDecoration(
                          color: appTheme(context).secondaryColor,
                          border: Border.all(
                            color: appTheme(context).tertiaryColor,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Column(
                            children: [context.watch<FileWorking>().openWindow],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      loadFile(),
                      changeFile(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, "cancel");
                        },
                        child: const Text("Закрыть"),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

Future<dynamic> showFileDialogWindow(BuildContext context) async {
  return await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return const FileDialogWindow();
    },
  );
}
