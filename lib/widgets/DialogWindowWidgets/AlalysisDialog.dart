import 'package:flutter/material.dart';
import 'package:flutter_univ/widgets/DialogWindowWidgets/FileWidgets/ContainerStyle.dart';
import 'package:flutter_univ/widgets/DialogWindowWidgets/FileWidgets/DropdownButton.dart';

import '../../theme/AppThemeDefault.dart';

class DropdownColumnsExample extends StatefulWidget {
  const DropdownColumnsExample(
      {super.key, required this.list, required this.callback});
  final Map<int, String> list;
  final Function callback;

  @override
  State<DropdownColumnsExample> createState() => _DropdownColumnsExampleState();
}

class _DropdownColumnsExampleState extends State<DropdownColumnsExample> {
  late Map<int, String> list;
  late Function callback;
  late int index;

  @override
  void initState() {
    super.initState();
    list = widget.list;
    callback = widget.callback;
    index = list.entries.first.key;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: index,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      underline: Container(
        height: 2,
        color: appTheme(context).secondaryColor,
      ),
      onChanged: (int? value) {
        setState(() {
          index = value!;
        });
        callback(value);
      },
      items: list
          .map((key, value) {
            return MapEntry(
                value,
                DropdownMenuItem<int>(
                  value: key,
                  child: Text(value),
                ));
          })
          .values
          .toList(),
    );
  }
}

class AnalysisDialogWindows extends StatefulWidget {
  const AnalysisDialogWindows({
    super.key,
    required this.fileName,
    required this.columns,
  });

  final String fileName;
  final Map<int, String> columns;

  @override
  State<AnalysisDialogWindows> createState() => _AnalysisDialogWindowsState();
}

class _AnalysisDialogWindowsState extends State<AnalysisDialogWindows> {
  late String fileName;
  late Map<int, String> columns;
  late int analysisIndex;
  late int selectedRow;

  @override
  void initState() {
    super.initState();
    fileName = widget.fileName;
    columns = widget.columns;
    analysisIndex = columns.entries.first.key;
    selectedRow = 1;
  }

  void setAnalysisColumn(int value) {
    setState(() {
      analysisIndex = value;
    });
  }

  void setSelectedRow(int value) {
    setState(() {
      print(value);
      selectedRow = value;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      children: [
                        ContainerStyle(
                          text: "Название файла",
                          child: Text(fileName),
                        ),
                        ContainerStyle(
                          text: 'Выделенные строки',
                          child: DropdownColumnsExample(list: const {
                            1: 'Все',
                            2: 'Выделенные',
                            3: 'Невыделенные'
                          }, callback: setSelectedRow),
                        ),
                        ContainerStyle(
                          text: "Выберите анализируемый столбец",
                          child: DropdownColumnsExample(
                              list: columns, callback: setAnalysisColumn),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, [
                      "analysis",
                      {
                        'analysisIndex': analysisIndex,
                        'selectedRow': selectedRow
                      }
                    ]);
                  },
                  child: const Text("Анализировать"),
                ),
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
  }
}

Future<dynamic> showAnalysisDialogWindow(
    BuildContext context, String fileName, Map<int, String> columns) async {
  return await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AnalysisDialogWindows(fileName: fileName, columns: columns);
    },
  );
}
