import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_univ/data/FileData.dart';
import 'package:flutter_univ/main.dart';
import 'package:flutter_univ/pages/WorkPage.dart';
import 'package:flutter_univ/theme/AppThemeDefault.dart';
import 'package:flutter_univ/widgets/OptionPageWidgets/ServiceWidgets/DictionaryWorking.dart';
import 'package:flutter_univ/widgets/WorkPageWidgets/ReportBox.dart';
import 'package:flutter_univ/widgets/WorkPageWidgets/TableColumn.dart';
import 'package:flutter_univ/widgets/WorkPageWidgets/TypeBox.dart';
import 'package:flutter_univ/widgets/WorkPageWidgets/UpdateBox.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:provider/provider.dart';

class TableColumns {
  String? title;
  String? type;
  double? width;

  TableColumns({this.width, this.title, this.type});
}

class CustomTable extends StatefulWidget {
  const CustomTable({super.key});

  @override
  State<CustomTable> createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable> {
  final LinkedScrollControllerGroup _controllerGroup =
      LinkedScrollControllerGroup();

  List<TableColumns> _helperTableColumnsList = [];

  ScrollController? _headerScrollController;
  ScrollController? _dataScrollController;

  Map<int, Map<String, String>> _titleData = {};
  Map<int, List<dynamic>> _rowsData = {};

  List<DataColumn> _columnsMid = [];
  List<DataColumn> _columnsStart = [];
  List<DataColumn> _columnsEnd = [];

  List<DataRow> _rowsMid = [];
  List<DataRow> _rowsStart = [];
  List<DataRow> _rowsEnd = [];

  bool _fixHeader = false;
  bool _fixStart = false;
  bool _fixEnd = false;

  int _lengthHeader = 0;
  int _lengthStart = 0;
  int _lengthEnd = 0;

  bool _enableColorStart = true;
  bool _enableColorEnd = true;

  Color _colorStart = Colors.blue;
  Color _colorEnd = Colors.orange;

  @override
  void initState() {
    super.initState();
    _headerScrollController = _controllerGroup.addAndGet();
    _dataScrollController = _controllerGroup.addAndGet();
  }

  @override
  Widget build(BuildContext context) {
    print('update');

    fixStart = context.watch<TableOption>().fixStart;
    fixHeader = context.watch<TableOption>().fixHeader;
    fixEnd = context.watch<TableOption>().fixEnd;

    lengthEnd = context.watch<TableOption>().lengthEnd;
    lengthStart = context.watch<TableOption>().lengthStart;

    setTitleData(context.watch<OpenFiles>().fileTitle,
        context.watch<OpenFiles>().titleTypes);

    rowsData = context.watch<OpenFiles>().fileRow;

    enableColorStart = context.watch<TableOption>().enableColorStart;
    enableColorEnd = context.watch<TableOption>().enableColorEnd;

    colorStart = context.watch<TableOption>().colorStart;
    colorEnd = context.watch<TableOption>().colorEnd;

    fullBuild();

    List<Widget> children = [];
    children.add(SingleChildScrollView(
      child: Row(
        children: buildTableValue(),
      ),
    ));

    if (_fixHeader) {
      children.add(Row(children: buildTableValue(header: true)));
    }

    return Stack(children: children);
  }

  List<Widget> buildTableValue({bool header = false}) {
    List<Widget> children = [];

    if (_fixStart && _columnsStart.isNotEmpty) {
      children.add(Container(
          color: _enableColorStart ? colorStart : null,
          child: DataTable(
            horizontalMargin: 0,
            columnSpacing: 0,
            columns: _columnsStart,
            rows: !header ? _rowsStart : [],
          )));
    }

    if (_columnsMid.isNotEmpty) {
      children.add(Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: header ? _headerScrollController : _dataScrollController,
          child: DataTable(
            horizontalMargin: 0,
            columnSpacing: 0,
            columns: _columnsMid,
            rows: !header ? _rowsMid : [],
          ),
        ),
      ));
    } else {
      children.add(Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: header ? _headerScrollController : _dataScrollController,
        ),
      ));
    }

    if (_fixEnd && _columnsEnd.isNotEmpty) {
      children.add(Container(
        color: _enableColorEnd ? colorEnd : null,
        child: DataTable(
            horizontalMargin: 0,
            columnSpacing: 0,
            columns: _columnsEnd,
            rows: !header ? _rowsEnd : []),
      ));
    }

    return children;
  }

  void buildTableColumns() {
    setState(() {
      if (_titleData.length >= _lengthHeader &&
          _lengthHeader >= _lengthHeader) {
        _helperTableColumnsList = _titleData.entries
            .map((e) => TableColumns(
                title: e.value['title'], width: 200, type: e.value['type']))
            .toList();

        List<DataColumn> columns =
            _helperTableColumnsList.asMap().entries.map((e) {
          Widget child;
          if (e.value.type == 'update') {
            child = const AllSelect(value: false);
          } else {
            child = Text(
              e.value.title ?? '',
            );
          }

          return DataColumn(
              label: Container(
                  key: Key(e.key.toString()),
                  alignment: Alignment.center,
                  height: double.infinity,
                  color: appTheme(context).secondaryColor,
                  width: e.value.width ?? 0,
                  child: child));
        }).toList();

        if (_fixStart &&
            _lengthStart != 0 &&
            _lengthHeader - _lengthEnd >= _lengthStart) {
          _columnsStart = columns.getRange(0, _lengthStart).toList();
        }

        if (_fixEnd &&
            _lengthEnd != 0 &&
            _lengthHeader - _lengthStart >= _lengthEnd) {
          _columnsEnd = columns
              .getRange(_lengthHeader - _lengthEnd, _lengthHeader)
              .toList();
        }

        if (_lengthHeader != 0 &&
            _lengthHeader - (_lengthStart + _lengthEnd) >= 0) {
          _columnsMid = columns
              .getRange(_lengthStart, _lengthHeader - _lengthEnd)
              .toList();
        }
      }
    });
  }

  int maxRowsLength() {
    int maxRowLenght = -1;
    _rowsData.forEach((key, value) {
      if (maxRowLenght < value.length) {
        maxRowLenght = value.length;
      }
    });
    return maxRowLenght;
  }

  void buildTableRows() {
    setState(() {
      int maxRows = maxRowsLength();

      Color colorPercent(int? percent) {
        return percent != null
            ? percent <= 30
                ? const Color.fromARGB(255, 255, 0, 0)
                : percent <= 60
                    ? const Color.fromARGB(255, 255, 217, 0)
                    : const Color.fromARGB(255, 30, 255, 0)
            : const Color.fromARGB(255, 255, 255, 255);
      }

      if (_titleData.length >= _lengthHeader &&
          maxRows >= _lengthHeader &&
          maxRows <= _titleData.length &&
          _helperTableColumnsList.length >= maxRows) {
        createCell(int columnIndex, int rowIndex, String value) {
          Widget? child;
          TableColumns title = _helperTableColumnsList[columnIndex];

          child = () {
            if (title.type == "type") {
              return MTypeBox(
                value: int.tryParse(value) ?? 0,
                index: rowIndex,
                typeRow: context.read<TableOption>().typeRow,
                key: Key(rowIndex.toString()),
              );
            }

            if (title.type == "update") {
              return MUpdateBox(
                value: value == "true",
                index: rowIndex,
                key: Key(rowIndex.toString()),
              );
            }

            if (title.type == "report") {
              return MReportBox(
                value: value == "true",
                index: rowIndex,
                key: Key(rowIndex.toString()),
              );
            }

            if (title.type == "probability") {
              return Container(
                alignment: Alignment.center,
                child: Text(
                  value,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colorPercent(int.tryParse(value)),
                  ),
                ),
              );
            }

            if (title.type == "analysis" && value.isNotEmpty) {
              List<AnalysisWord> words = jsonDecode(value)
                  .map<AnalysisWord>((value) => AnalysisWord.fromJson(value))
                  .toList();

              List<String> text = [];
              List<InlineSpan> spanText = [];

              for (var element in words) {
                if (element.isWord == true && element.id != null) {
                  if (text.isNotEmpty) {
                    spanText.add(TextSpan(text: text.join()));
                    text = [];
                  }

                  BasicWord? basicWord = context
                      .watch<DictionaryOption>()
                      .allWords
                      .firstWhereOrNull((dictionaryElement) {
                    return dictionaryElement.id == element.id;
                  });

                  if (basicWord != null) {
                    spanText.add(
                      WidgetSpan(
                        child: Tooltip(
                          showDuration: const Duration(milliseconds: 200),
                          waitDuration: const Duration(milliseconds: 500),
                          richMessage: basicWord.description.isNotEmpty
                              ? WidgetSpan(
                                  alignment: PlaceholderAlignment.baseline,
                                  baseline: TextBaseline.alphabetic,
                                  child: Container(
                                    color: appTheme(context).primaryColor,
                                    padding: const EdgeInsets.all(5),
                                    constraints: const BoxConstraints(
                                      maxWidth: 250,
                                    ),
                                    child: Text(
                                      maxLines: 5,
                                      basicWord.description,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                              : const TextSpan(),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              child: Text(
                                element.word,
                                style: TextStyle(color: basicWord.typeColor()),
                              ),
                              onTap: () {
                                context.read<TypeViewMenu>().show = true;
                                context.read<DictionaryOption>().selectWord =
                                    basicWord;
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    text.add(element.word);
                  }
                } else {
                  text.add(element.word);
                }
              }

              if (text.isNotEmpty) {
                spanText.add(TextSpan(text: text.join()));
              }

              return SingleChildScrollView(
                child: Text.rich(
                  TextSpan(children: spanText),
                ),
              );
            }

            return SingleChildScrollView(
              child: Text(value),
            );
          }();

          return DataCell(Container(
              alignment: Alignment.center,
              height: double.infinity,
              width: _helperTableColumnsList[columnIndex].width,
              child: child));
        }

        setColorRow(int rowIndex) {
          return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
            return context
                .read<TableOption>()
                .typeRow[int.tryParse(_rowsData[rowIndex]?[
                        _helperTableColumnsList.indexWhere(
                            (element) => element.type == "type")]) ??
                    0]
                ?.color;
          });
        }

        if (_fixStart && _lengthStart != 0 && _lengthHeader >= _lengthStart) {
          _rowsStart = _rowsData.entries.map((data) {
            int columnIndex = 0;
            return DataRow(
                color: setColorRow(data.key),
                cells: data.value.getRange(0, _lengthStart).map((row) {
                  return createCell(columnIndex++, data.key, row);
                }).toList());
          }).toList();
        }

        if (_fixEnd &&
            _lengthEnd != 0 &&
            _lengthHeader - _lengthStart >= _lengthEnd) {
          _rowsEnd = _rowsData.entries.map((data) {
            int columnIndex = _lengthHeader - _lengthEnd;
            return DataRow(
                color: setColorRow(data.key),
                cells: data.value
                    .getRange(_lengthHeader - _lengthEnd, _lengthHeader)
                    .map((row) {
                  return createCell(columnIndex++, data.key, row);
                }).toList());
          }).toList();
        }

        if (_lengthHeader != 0 &&
            _lengthHeader - (_lengthStart + _lengthEnd) >= 0) {
          _rowsMid = _rowsData.entries.map((data) {
            int columnIndex = _lengthStart;
            return DataRow(
                color: setColorRow(data.key),
                cells: data.value
                    .getRange(_lengthStart, _lengthHeader - _lengthEnd)
                    .map((row) {
                  return createCell(columnIndex++, data.key, row);
                }).toList());
          }).toList();
        }
      }
    });
  }

  Map<int, Map<String, String>> get titleData => _titleData;

  set titleData(Map<int, Map<String, String>> titleData) {
    setState(() {
      _titleData = titleData;
    });

    // fullBuild();
  }

  void setTitleData(Map<int, String> title, Map<int, String> titleTypes) {
    if (title.length != titleTypes.length) {
      throw Exception(
          'Ошибка при формировании таблица количество заголовков и их типов не совподают');
    }

    setState(() {
      for (int index = 0; index < title.length; index++) {
        _titleData[index] = {
          'title': title[index] ?? "",
          'type': titleTypes[index] ?? ""
        };
      }
    });
    lengthHeader = title.length;
    // fullBuild();
  }

  Map<int, List<dynamic>> get rowsData => _rowsData;

  set rowsData(Map<int, List<dynamic>> rows) {
    setState(() {
      _rowsData = rows;
    });
    // fullBuild();
  }

  void fullBuild() {
    buildTableColumns();
    buildTableRows();
  }

  bool get fixHeader => _fixHeader;

  set fixHeader(bool fix) {
    setState(() {
      _fixHeader = fix;
    });
  }

  bool get fixStart => _fixStart;

  set fixStart(bool fix) {
    if (fixStart && (_lengthStart >= _lengthHeader - _lengthEnd)) {
      // fullBuild();
    }

    setState(() {
      _fixStart = fix;
    });
  }

  bool get fixEnd => _fixEnd;

  set fixEnd(bool fix) {
    if (fixEnd & (_lengthEnd >= _lengthHeader - _lengthStart)) {
      // fullBuild();
    }

    setState(() {
      _fixEnd = fix;
    });
  }

  int get lengthHeader => _lengthHeader;

  set lengthHeader(int lengthHeader) {
    setState(() {
      _lengthHeader = lengthHeader >= 0 ? lengthHeader : 0;
    });
    // fullBuild();
  }

  int get lengthStart => _lengthStart;

  set lengthStart(int lengthStart) {
    setState(() {
      if (_fixStart) {
        _lengthStart = lengthStart >= 0 ? lengthStart : 0;
      } else {
        _lengthStart = 0;
      }
    });
    // fullBuild();
  }

  int get lengthEnd => _lengthEnd;

  set lengthEnd(int lengthEnd) {
    setState(() {
      if (_fixEnd) {
        _lengthEnd = lengthEnd >= 0 ? lengthEnd : 0;
      } else {
        _lengthEnd = 0;
      }
    });
    // fullBuild();
  }

  bool get enableColorStart => _enableColorStart;

  set enableColorStart(bool enable) {
    setState(() {
      _enableColorStart = enable;
    });
  }

  bool get enableColorEnd => _enableColorEnd;

  set enableColorEnd(bool enable) {
    setState(() {
      _enableColorEnd = enable;
    });
  }

  Color get colorStart => _colorStart;

  set colorStart(Color color) {
    setState(() {
      _colorStart = color;
    });
  }

  Color get colorEnd => _colorEnd;

  set colorEnd(Color color) {
    setState(() {
      _colorEnd = color;
    });
  }
}
