import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_univ/widgets/DialogWindowWidgets/FileWidgets/DropFileContainer.dart';
import 'package:flutter_univ/widgets/DialogWindowWidgets/FileWidgets/FileWorkWindow.dart';
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
