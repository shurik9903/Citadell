import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_univ/data/ModelData.dart';
import 'package:flutter_univ/widgets/DialogWindowWidgets/FileWidgets/ContainerStyle.dart';
import 'package:flutter_univ/widgets/OptionPageWidgets/ServiceWidgets/ModelEdit.dart';
import 'package:flutter_univ/widgets/OptionPageWidgets/ServiceWidgets/ModelWorking.dart';

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
  TextEditingController _modelName = TextEditingController();

  late String _fileName;
  late Map<int, String> _columns;
  late int _analysisIndex;
  late int _selectedRow;

  ModelData? _selectModel;

  bool _validate = false;
  bool _typesSwitch = true;
  bool _newModelSwitch = false;

  @override
  void initState() {
    super.initState();
    _fileName = widget.fileName;
    _columns = widget.columns;
    _analysisIndex = _columns.entries.first.key;
    _selectedRow = 1;
  }

  void setAnalysisColumn(int value) {
    setState(() {
      _analysisIndex = value;
    });
  }

  void setSelectedRow(int value) {
    setState(() {
      _selectedRow = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 600,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: ToggleButtons(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  isSelected: [_typesSwitch, !_typesSwitch],
                  onPressed: (index) {
                    setState(() {
                      _typesSwitch = !_typesSwitch;
                    });
                  },
                  children: [
                    ...[_typesSwitch, !_typesSwitch]
                        .mapIndexed((index, element) {
                      return Container(
                        width: 280,
                        alignment: Alignment.center,
                        height: double.infinity,
                        color: element ? Colors.white : Colors.grey[800],
                        child: Text(index == 0 ? 'Анализ' : 'Обучение',
                            style: TextStyle(
                                color:
                                    element ? Colors.black : Colors.white70)),
                      );
                    }).toList()
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: SizedBox(
                  width: 600,
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
                          _typesSwitch
                              ? ContainerStyle(
                                  text: "Название файла",
                                  child: Text(_fileName),
                                )
                              : Column(
                                  children: [
                                    // Container(
                                    //   margin: const EdgeInsets.only(top: 10),
                                    //   child: ToggleButtons(
                                    //     borderRadius: const BorderRadius.all(
                                    //         Radius.circular(10)),
                                    //     isSelected: [
                                    //       _newModelSwitch,
                                    //       !_newModelSwitch
                                    //     ],
                                    //     onPressed: (index) {
                                    //       setState(() {
                                    //         _newModelSwitch = !_newModelSwitch;
                                    //       });
                                    //     },
                                    //     children: [
                                    //       ...[_newModelSwitch, !_newModelSwitch]
                                    //           .mapIndexed((index, element) {
                                    //         return Container(
                                    //           width: 280,
                                    //           alignment: Alignment.center,
                                    //           height: double.infinity,
                                    //           color: element
                                    //               ? Colors.white
                                    //               : Colors.grey[800],
                                    //           child: Text(
                                    //               index == 0
                                    //                   ? 'Создать новую модель'
                                    //                   : 'Использовать существующую модель',
                                    //               style: TextStyle(
                                    //                   color: element
                                    //                       ? Colors.black
                                    //                       : Colors.white70)),
                                    //         );
                                    //       }).toList()
                                    //     ],
                                    //   ),
                                    // ),
                                    _newModelSwitch
                                        ? Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 20),
                                            child: TextField(
                                              onTap: () {
                                                setState(() {
                                                  _validate = false;
                                                });
                                              },
                                              maxLines: 1,
                                              controller: _modelName,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: appTheme(context)
                                                    .primaryColor,
                                                labelText:
                                                    'Введите название новой модели',
                                                errorText: _validate
                                                    ? 'Значение не может быть пустым'
                                                    : null,
                                              ),
                                            ),
                                          )
                                        : Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            child: ModelEdit(
                                              menu: false,
                                              getActiveModel: (model) {
                                                setState(() {
                                                  _selectModel = model;
                                                });
                                              },
                                            ),
                                          ),
                                  ],
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
                                list: _columns, callback: setAnalysisColumn),
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
                      // if (_modelName.text.isEmpty &&
                      //     !_typesSwitch &&
                      //     _newModelSwitch) {
                      //   setState(() {
                      //     _validate = true;
                      //   });
                      //   return;
                      // }

                      Map<String, dynamic> result = {};

                      result['type'] = _typesSwitch ? 'analysis' : 'teaching';
                      result['index'] = _analysisIndex;
                      result['row'] = _selectedRow;

                      // if (_newModelSwitch) {
                      //   result['modelName'] = _modelName.text;
                      // }

                      if (!_typesSwitch) {
                        if (_selectModel != null) {
                          result['modelID'] = _selectModel!.id;
                        } else {
                          return;
                        }
                      }

                      print('test');

                      Navigator.pop(context, [result]);
                    },
                    child: const Text("Запустить"),
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
