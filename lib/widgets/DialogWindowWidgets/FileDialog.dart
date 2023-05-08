import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:provider/provider.dart';

import '../../theme/AppThemeDefault.dart';

class LoadFile {
  String fullName;
  String type;
  final int bytes;

  LoadFile({required this.fullName, required this.type, required this.bytes});

  String get name {
    return fullName.substring(0, fullName.lastIndexOf('.'));
  }

  String get size {
    final kb = bytes / 1024;
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
    final bytes = await dropController.getFileSize(event);
    final url = await dropController.createFileUrl(event);

    return LoadFile(
        fullName: name,
        type: name.substring(name.lastIndexOf('.')),
        bytes: bytes);
  }

  void showSelectFileWindow(LoadFile loadfile) {
    context.read<FileWorking>().loadFile = loadfile;
    context.read<FileWorking>().dropdownValue =
        context.read<FileWorking>().type.firstWhere(
              (element) =>
                  RegExp(r'' + '^\\$element.?\$').hasMatch(loadfile.type),
              orElse: () => "",
            );
    context.read<FileWorking>().openWindow = const FileWorkWindow();
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
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.only(top: 15),
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
            padding: EdgeInsets.only(bottom: 1, left: 5, right: 5),
            color: appTheme(context).secondaryColor,
            child: Text(
              text,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
      ],
    );
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
          padding: EdgeInsets.all(20),
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
              context.watch<FileWorking>().dropdownValue == ".xls"
                  ? ContainerStyle(
                      text: "Размер таблицы",
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: isAutoSizeTable,
                            onChanged: (value) {
                              setState(() {
                                isAutoSizeTable = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          )),
    );
  }
}

class FileDialogWindow extends StatefulWidget {
  const FileDialogWindow({super.key});

  @override
  State<FileDialogWindow> createState() => _FileDialogWindowState();
}

class _FileDialogWindowState extends State<FileDialogWindow> {
  FileWorking _fileWorking = FileWorking();

  @override
  void initState() {
    super.initState();
    _fileWorking.openWindow = DropFileContainer();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          //Добавление Provider темы в MultiProvider
          ChangeNotifierProvider(
            create: (context) => _fileWorking,
          ),
        ],
        builder: (context, child) {
          return Dialog(
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
                    context.watch<FileWorking>().openWindow.toString() ==
                            const FileWorkWindow().toString()
                        ? TextButton(
                            onPressed: () {
                              Navigator.pop(context, "open");
                            },
                            child: const Text("Открыть"),
                          )
                        : const SizedBox.shrink(),
                    context.watch<FileWorking>().openWindow.toString() ==
                            const FileWorkWindow().toString()
                        ? TextButton(
                            onPressed: () {
                              context.read<FileWorking>().loadFile = null;
                              context.read<FileWorking>().openWindow =
                                  const DropFileContainer();
                            },
                            child: const Text("Сменить файл"),
                          )
                        : const SizedBox.shrink(),
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
          );
        });
  }
}

Future<void> showFileDialogWindow(BuildContext context) async {
  return await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return const FileDialogWindow();
    },
  );
}
