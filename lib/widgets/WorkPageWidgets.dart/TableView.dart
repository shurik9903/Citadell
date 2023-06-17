import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_univ/data/FileData.dart';
import 'package:flutter_univ/main.dart';
import 'package:flutter_univ/modules/FileFetch.dart';
import 'package:flutter_univ/widgets/WorkPageWidgets.dart/TableColumn.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:provider/provider.dart';

import '../../pages/WorkPage.dart';
import '../../theme/AppThemeDefault.dart';
import 'AnalysisText.dart';
import 'ReportBox.dart';
import 'SelectedText.dart';
import 'UpdateBox.dart';

class MTableView extends StatefulWidget {
  const MTableView({super.key});

  @override
  State<MTableView> createState() => _MTableViewState();
}

class _MTableViewState extends State<MTableView> {
  int _selectId = 1;
  int _lastPage = 0;

  // ScrollController _verticalScrollController = ScrollController();
  // ScrollController _horizontalScrollController = ScrollController();

  // List<Widget> _titleWidget = [];
  // List<Row> _rows = [];

  TextEditingController page = TextEditingController();

  setSelectedID(int selectId) {
    setState(() {
      _selectId = selectId;
    });
  }

  setLastPage(int lastPage) {
    setState(() {
      _lastPage = lastPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    // _updataTitle(context.watch<OpenFiles>().fileTitle);

    // _updateRows(context.watch<OpenFiles>().fileRow);

    page.text = (((context.watch<OpenFiles>().selectedFile?.start ?? -1) + 1) /
            context.watch<OpenFiles>().numberRow)
        .ceil()
        .toString();

    setLastPage(((context.watch<OpenFiles>().selectedFile?.numberRows ?? 0) /
            context.watch<OpenFiles>().numberRow)
        .ceil());

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: appTheme(context).primaryColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          // Expanded(
          //   flex: 2,
          //   child: FractionallySizedBox(
          //     widthFactor: 1,
          //     heightFactor: 1,
          //     child: context.watch<OpenFiles>().fileTitle.isNotEmpty
          //         ? DataTable(
          //             horizontalMargin: 0,
          //             columnSpacing: 0,
          //             columns: [...context.watch<OpenFiles>().fileTitle],
          //             rows: [],
          //           )
          //         : Container(),
          //   ),
          // ),
          Expanded(
            flex: 25,
            child: FractionallySizedBox(
              widthFactor: 1,
              heightFactor: 1,
              child: context.watch<OpenFiles>().fileTitle.isNotEmpty
                  ? const CustomTable()
                  : Container(),
              // child: context.watch<OpenFiles>().fileTitle.isNotEmpty
              //     ? HorizontalDataTable(
              //         onScrollControllerReady: (vertical, horizontal) {
              //           _verticalScrollController = vertical;
              //           _horizontalScrollController = horizontal;
              //         },
              //         leftHandSideColumnWidth: 100,
              //         rightHandSideColumnWidth: 1000,
              //         isFixedHeader: true,
              //         isFixedFooter: false,
              //         headerWidgets: [..._titleWidget],
              //         itemCount: _rows.length,
              //         leftSideChildren: [..._rows],
              //         rightSideChildren: [..._rows],
              //         // leftSideChildren: [],
              //         // rightSideChildren: [..._rows],
              //       )
              //     : Container(),
              // child: SingleChildScrollView(
              //   scrollDirection: Axis.vertical,
              //   child:
              //       // context.watch<OpenFiles>().fileTitle.isNotEmpty
              //       //     ? DataTable(
              //       //         horizontalMargin: 0,
              //       //         columnSpacing: 0,
              //       //         columns: [...context.watch<OpenFiles>().fileTitle],
              //       //         rows: [...context.watch<OpenFiles>().fileRow],
              //       //       )
              //       //     :
              //       Container(),
              // ),
            ),
          ),
          Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.only(
                    left: 20, bottom: 10, top: 10, right: 20),
                height: double.infinity,
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Wrap(
                        direction: Axis.horizontal,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        spacing: 10,
                        children: [
                          MSelectedText(
                            thisId: 1,
                            selectId: _selectId,
                            text: "25",
                            callback: () {
                              setSelectedID(1);
                              context.read<OpenFiles>().numberRow = 25;
                            },
                          ),
                          MSelectedText(
                              thisId: 2,
                              selectId: _selectId,
                              text: "50",
                              callback: () {
                                setSelectedID(2);
                                context.read<OpenFiles>().numberRow = 50;
                              }),
                          MSelectedText(
                            thisId: 3,
                            selectId: _selectId,
                            text: "100",
                            callback: () {
                              setSelectedID(3);
                              context.read<OpenFiles>().numberRow = 100;
                            },
                          ),
                        ],
                      ),
                      Wrap(
                        spacing: 5,
                        direction: Axis.horizontal,
                        children: [
                          TextButton(
                            onPressed: () {
                              refreshDataLeft();
                            },
                            child: const Text("<"),
                          ),
                          SizedBox(
                            width: 25,
                            child: TextField(
                              onSubmitted: (value) {
                                refreshDataInput(value);
                              },
                              controller: page,
                              textAlign: TextAlign.right,
                              style: const TextStyle(fontSize: 14),
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(top: 4),
                                isDense: true,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Text("/ $_lastPage"),
                          TextButton(
                            onPressed: () {
                              refreshDataRight();
                            },
                            child: const Text(">"),
                          ),
                        ],
                      ),
                      Text(
                          "Кол-во строк: ${context.watch<OpenFiles>().selectedFile?.numberRows ?? 0}"),
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }

  void refreshDataLeft() {
    int start = context.read<OpenFiles>().selectedFile?.start ?? 1;

    if (start == 1) return;

    int startDifference = start - context.read<OpenFiles>().numberRow;

    if (startDifference < 1) {
      context.read<OpenFiles>().selectedFile?.start = 1;
      context.read<OpenFiles>().refreshData();
      return;
    }

    context.read<OpenFiles>().selectedFile?.start = startDifference;
    context.read<OpenFiles>().refreshData();
  }

  void refreshDataInput(String value) {
    int actualPage = ((context.read<OpenFiles>().selectedFile?.start ?? 0) /
            context.read<OpenFiles>().numberRow)
        .ceil();

    if (int.tryParse(value) != null) {
      int setPage = int.parse(value);
      if (0 > setPage || setPage > _lastPage) {
        page.text = actualPage.toString();
        return;
      }

      context.read<OpenFiles>().selectedFile?.start =
          ((setPage - 1) * context.read<OpenFiles>().numberRow) + 1;

      context.read<OpenFiles>().refreshData();
      return;
    }
    page.text = actualPage.toString();
  }

  void refreshDataRight() {
    int start = context.read<OpenFiles>().selectedFile?.start ?? 1;

    if (start == context.read<OpenFiles>().selectedFile?.numberRows) return;

    int startDifference = start + context.read<OpenFiles>().numberRow;

    if (startDifference >
        (context.read<OpenFiles>().selectedFile?.numberRows ?? 0)) {
      return;
    }

    context.read<OpenFiles>().selectedFile?.start = startDifference;
    context.read<OpenFiles>().refreshData();
  }

  // void _updataTitle(Map<int, String> title) {
  //   setState(() {
  //     _titleWidget = _getTitleWidget(title);
  //   });
  // }

  // List<Widget> _getTitleWidget(Map<int, String> title) {
  //   return title.entries.map((e) {
  //     if (e.value == 'Обновить') {
  //       return _getTitleItemWidget(
  //           const AllSelect(value: false), Key(e.key.toString()));
  //     } else {
  //       return _getTitleItemWidget(Text(e.value), Key(e.key.toString()));
  //     }
  //   }).toList();
  // }

  // Widget _getTitleItemWidget(Widget child, Key key) {
  //   return Container(
  //     key: key,
  //     width: 50,
  //     height: 50,
  //     padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
  //     alignment: Alignment.centerLeft,
  //     child: child,
  //   );
  // }

  // void _updateRows(Map<int, List<dynamic>> rows) {
  //   setState(() {
  //     _rows = _getRowsWidget(rows);
  //   });
  // }

  // List<Row> _getRowsWidget(Map<int, List<dynamic>> rows) {
  //   return rows.entries.map((e) {
  //     return _getRowItemWidget(
  //         e.value.map((text) {
  //           return Container(width: 50, height: 50, child: Text(text));
  //         }).toList(),
  //         Key(e.key.toString()));
  //   }).toList();
  // }

  // Row _getRowItemWidget(List<Widget> children, Key key) {
  //   return Row(
  //     key: key,
  //     children: children,
  //   );
  // }
}

// DataRow buildTableRow({
//   required List<String> rowsText,
//   required int rowIndex,
//   required String analyzedText,
//   required String probability,
//   // required bool update,
//   required bool incorrect,
//   required String type,
// }) {
//   Map<String, Color> typeColor = {
//     '1': Color.fromARGB(39, 255, 81, 0),
//     '2': Color.fromARGB(36, 43, 128, 255),
//     '3': Color.fromARGB(40, 136, 255, 72),
//     '4': Color.fromARGB(40, 255, 19, 19),
//     '5': Color.fromARGB(40, 184, 31, 255),
//   };

//   return DataRow(
//       color: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
//         if (typeColor[type] != null) {
//           return typeColor[type];
//         }
//         return null; // Use the default value.
//       }),
//       cells: [
//         ...rowsText.map((value) => DataCell(Container(
//               alignment: Alignment.center,
//               child: Text(value),
//             ))),
//         DataCell(MAnalysisText(
//           parseText: [],
//         )),
//         DataCell(Container(
//           alignment: Alignment.center,
//           child: Text(
//             probability,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: int.tryParse(probability) != null
//                   ? int.parse(probability) <= 30
//                       ? Color.fromARGB(255, 255, 0, 0)
//                       : int.parse(probability) <= 60
//                           ? Color.fromARGB(255, 255, 217, 0)
//                           : Color.fromARGB(255, 30, 255, 0)
//                   : Color.fromARGB(255, 255, 255, 255),
//             ),
//           ),
//         )),
//         DataCell(
//           MUpdateBox(
//             value: false,
//             index: rowIndex,
//             key: Key(rowIndex.toString()),
//           ),
//         ),
//         DataCell(
//           MReportBox(
//             value: incorrect,
//             index: rowIndex.toString(),
//             key: Key(rowIndex.toString()),
//           ),
//         ),
//       ]);
// }

class TableColumns {
  String? title;
  double? width;

  TableColumns({this.width, this.title});
}

// class TableDataHelper {
//   static List<TableColumns> sTableColumnsList = [
//     // TableColumns(title: 'first', width: 50),
//     // TableColumns(title: '1', width: 50),
//     // TableColumns(title: '2', width: 50),
//     // TableColumns(title: '3', width: 50),
//     // TableColumns(title: '4', width: 50),
//     // TableColumns(title: '5', width: 50),
//     // TableColumns(title: '6', width: 50),
//     // TableColumns(title: '7', width: 50),
//     // TableColumns(title: 'last', width: 50),
//   ];
// }

class CustomTable extends StatefulWidget {
  const CustomTable({super.key});

  @override
  State<CustomTable> createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable> {
  LinkedScrollControllerGroup _controllerGroup = LinkedScrollControllerGroup();

  List<TableColumns> _helperTableColumnsList = [];

  ScrollController? _headerScrollController;
  ScrollController? _dataScrollController;

  Map<int, String> _titleData = {};
  Map<int, List<dynamic>> _rowsData = {};

  List<DataColumn> _columnsMid = [];
  List<DataColumn> _columnsStart = [];
  List<DataColumn> _columnsEnd = [];

  List<DataRow> _rowsMid = [];
  List<DataRow> _rowsStart = [];
  List<DataRow> _rowsEnd = [];

  // List<Widget> _header = [];
  // List<Widget> _content = [];

  bool _fixHeader = false;
  bool _fixStart = false;
  bool _fixEnd = false;

  int _lengthHeader = 0;
  int _lengthStart = 0;
  int _lengthEnd = 0;

  @override
  void initState() {
    super.initState();
    _headerScrollController = _controllerGroup.addAndGet();
    _dataScrollController = _controllerGroup.addAndGet();
  }

  @override
  Widget build(BuildContext context) {
    print("test2");

    setFixStart(context.watch<TableOption>().fixStart);
    setFixHeader(context.watch<TableOption>().fixHeader);
    setFixEnd(context.watch<TableOption>().fixEnd);

    setLengthEnd(context.watch<TableOption>().lengthEnd);
    setLengthStart(context.watch<TableOption>().lengthStart);

    setTitleData(context.watch<OpenFiles>().fileTitle);
    setRowsData(context.watch<OpenFiles>().fileRow);

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

  // Widget tableContent() {
  // List<Widget> children = [];

  // if (_fixStart && _columnsStart.isNotEmpty) {
  //   children.add(Container(
  //       color: Colors.blue,
  //       child: DataTable(
  //         columns: _columnsStart,
  //         rows: _rowsStart,
  //       )));
  // }

  // if (_columnsMid.isNotEmpty) {
  //   children.add(Expanded(
  //     child: SingleChildScrollView(
  //       scrollDirection: Axis.horizontal,
  //       controller: _dataScrollController,
  //       child: DataTable(
  //         columns: _columnsMid,
  //         rows: _rowsMid,
  //       ),
  //     ),
  //   ));
  // }

  // if (_fixEnd && _columnsEnd.isNotEmpty) {
  //   children.add(DataTable(columns: _columnsEnd, rows: _rowsEnd));
  // }

  // return;
  // return SingleChildScrollView(
  //   child: Row(
  //     children: [
  //       Container(
  //           color: Colors.blue,
  //           child: DataTable(
  //             columns: TableDataHelper.sTableColumnsList
  //                 .getRange(0, 1)
  //                 .map((e) => DataColumn(
  //                     label: SizedBox(
  //                         width: e.width ?? 0,
  //                         child: Text(
  //                           e.title ?? '',
  //                         ))))
  //                 .toList(),
  //             rows: List.generate(
  //                 100,
  //                 (index) => DataRow(cells: [
  //                       DataCell(SizedBox(
  //                           width: TableDataHelper.sTableColumnsList[0].width,
  //                           child: Text('$index')))
  //                     ])),
  //           )), // start
  //       Expanded(
  //         child: SingleChildScrollView(
  //           controller: _dataScrollController,
  //           scrollDirection: Axis.horizontal,
  //           child: DataTable(
  //             columns: TableDataHelper.sTableColumnsList
  //                 .getRange(1, TableDataHelper.sTableColumnsList.length - 1)
  //                 .map((e) => DataColumn(
  //                     label: SizedBox(
  //                         width: e.width ?? 0,
  //                         child: Text(
  //                           e.title ?? '',
  //                         ))))
  //                 .toList(),
  //             rows: List.generate(
  //                 100,
  //                 (index) => DataRow(cells: [
  //                       DataCell(SizedBox(
  //                           width: TableDataHelper.sTableColumnsList[1].width,
  //                           child: Text('1 $index'))),
  //                       DataCell(SizedBox(
  //                           width: TableDataHelper.sTableColumnsList[2].width,
  //                           child: Text('2 $index'))),
  //                       DataCell(SizedBox(
  //                           width: TableDataHelper.sTableColumnsList[3].width,
  //                           child: Text('3 $index'))),
  //                       DataCell(SizedBox(
  //                           width: TableDataHelper.sTableColumnsList[4].width,
  //                           child: Text('4 $index'))),
  //                       DataCell(SizedBox(
  //                           width: TableDataHelper.sTableColumnsList[5].width,
  //                           child: Text('5 $index'))),
  //                       DataCell(SizedBox(
  //                           width: TableDataHelper.sTableColumnsList[6].width,
  //                           child: Text('6 $index'))),
  //                       DataCell(SizedBox(
  //                           width: TableDataHelper.sTableColumnsList[7].width,
  //                           child: Text('7 $index'))),
  //                     ])),
  //           ),
  //         ),
  //       ), // mid
  //       DataTable(
  //           columns: TableDataHelper.sTableColumnsList
  //               .getRange(TableDataHelper.sTableColumnsList.length - 1,
  //                   TableDataHelper.sTableColumnsList.length)
  //               .map((e) => DataColumn(
  //                   label: SizedBox(
  //                       width: e.width ?? 0,
  //                       child: Text(
  //                         e.title ?? '',
  //                       ))))
  //               .toList(),
  //           rows: List.generate(
  //               100,
  //               (index) => DataRow(cells: [
  //                     DataCell(SizedBox(
  //                         width: TableDataHelper.sTableColumnsList[8].width,
  //                         child: Text('$index'))),
  //                   ]))), // end
  //     ],
  //   ),
  // );
  // }

  // Widget tableHeader() {
  // List<Widget> children = [];

  // if (_fixStart && _columnsStart.isNotEmpty) {
  //   children.add(Container(
  //       color: Colors.blue,
  //       child: DataTable(
  //         columns: _columnsStart,
  //         rows: [],
  //       )));
  // }

  // if (_columnsMid.isNotEmpty) {
  //   children.add(Expanded(
  //     child: SingleChildScrollView(
  //       scrollDirection: Axis.horizontal,
  //       controller: _headerScrollController,
  //       child: DataTable(
  //         columns: _columnsMid,
  //         rows: [],
  //       ),
  //     ),
  //   ));
  // }

  // if (_fixEnd && _columnsEnd.isNotEmpty) {
  //   children.add(DataTable(columns: _columnsEnd, rows: []));
  // }

  // return;
  // }

  List<Widget> buildTableValue({bool header = false}) {
    List<Widget> children = [];

    print(_titleData);
    print(_columnsStart);
    print(_columnsEnd);
    print(_columnsMid);

    if (_fixStart && _columnsStart.isNotEmpty) {
      children.add(Container(
          color: Colors.blue,
          child: DataTable(
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
            columns: _columnsMid,
            rows: !header ? _rowsMid : [],
          ),
        ),
      ));
    }

    if (_fixEnd && _columnsEnd.isNotEmpty) {
      children
          .add(DataTable(columns: _columnsEnd, rows: !header ? _rowsEnd : []));
    }

    return children;
  }

  void setTitleData(Map<int, String> title) {
    setState(() {
      _titleData = title;
    });
    setLengthHeader(title.length);
    fullBuild();
  }

  void setRowsData(Map<int, List<dynamic>> rows) {
    setState(() {
      _rowsData = rows;
    });
    fullBuild();
  }

  void fullBuild() {
    buildTableColumns();
    buildTableRows();
  }

  void buildTableColumns() {
    setState(() {
      int rowsLength = maxRowsLength();

      print("build");
      print('title length: ${_titleData.length}');
      print('rows length: $rowsLength');
      print('header length: $_lengthHeader');

      if (_titleData.length >= _lengthHeader && rowsLength >= _lengthHeader) {
        _titleData.forEach((key, value) {
          _helperTableColumnsList.add(TableColumns(title: value, width: 50));
        });

        List<DataColumn> columns = _helperTableColumnsList.map((e) {
          return DataColumn(
              label: SizedBox(
                  width: e.width ?? 0,
                  child: Text(
                    e.title ?? '',
                  )));
        }).toList();

        print('start length: $_lengthStart');

        if (_fixStart && _lengthStart != 0 && columns.length >= _lengthStart) {
          _columnsStart = columns.getRange(0, _lengthStart).toList();
        }

        if (_fixEnd &&
            _lengthEnd != 0 &&
            columns.length - (_lengthHeader - _lengthStart) >= _lengthEnd) {
          _columnsEnd = columns
              .getRange(_lengthHeader - _lengthStart - 1, _lengthEnd)
              .toList();
        }

        print(columns
            .getRange(_lengthStart, _lengthHeader - _lengthEnd)
            .toList());

        if (_lengthHeader != 0 &&
            columns.length - (_lengthStart + _lengthEnd) >= _lengthHeader) {
          _columnsMid = columns
              .getRange(_lengthStart, _lengthHeader - _lengthEnd)
              .toList();
        }
        print('test');
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
      int rowsLength = maxRowsLength();

      if (_titleData.length >= _lengthHeader &&
          rowsLength >= _lengthHeader &&
          rowsLength <= _titleData.length &&
          _helperTableColumnsList.length >= rowsLength) {
        List<DataRow> rows = _rowsData.entries.map((data) {
          return DataRow(
              cells: data.value.map((row) {
            return DataCell(SizedBox(
                width: _helperTableColumnsList[data.key].width,
                child: Text(row.toString())));
          }).toList());
        }).toList();

        if (_fixStart && _lengthStart != 0 && rows.length >= _lengthStart) {
          _rowsStart = rows.getRange(0, _lengthStart).toList();
        }

        if (_fixEnd &&
            _lengthEnd != 0 &&
            rows.length - (_lengthHeader - _lengthStart) >= _lengthEnd) {
          _rowsEnd = rows
              .getRange(_lengthHeader - _lengthStart - 1, _lengthEnd)
              .toList();
        }

        if (_lengthHeader != 0 &&
            rows.length - (_lengthHeader - (_lengthStart + _lengthEnd)) >=
                _lengthHeader) {
          _rowsMid = rows.getRange(_lengthStart - 1, _lengthEnd).toList();
        }
      }
    });
  }

  void setFixHeader(bool fixHeader) {
    setState(() {
      _fixHeader = fixHeader;
    });
    fullBuild();
  }

  void setFixStart(bool fixStart) {
    if (fixStart) {
      if (_lengthStart >= _lengthHeader - _lengthEnd) {
        setState(() {
          _fixStart = fixStart;
        });
      }
      fullBuild();
    }
    setState(() {
      _fixStart = fixStart;
    });
    fullBuild();
  }

  void setFixEnd(bool fixEnd) {
    if (fixEnd) {
      if (_lengthEnd >= _lengthHeader - _lengthStart) {
        setState(() {
          _fixEnd = fixEnd;
        });
      }
    }
    setState(() {
      _fixEnd = fixEnd;
    });
    fullBuild();
  }

  void setLengthHeader(int lengthHeader) {
    setState(() {
      _lengthHeader = lengthHeader >= 0 ? lengthHeader : 0;
    });
    fullBuild();
  }

  void setLengthStart(int lengthStart) {
    setState(() {
      _lengthStart = lengthStart >= 0 ? lengthStart : 0;
    });
    fullBuild();
  }

  void setLengthEnd(int lengthEnd) {
    setState(() {
      _lengthEnd = lengthEnd >= 0 ? lengthEnd : 0;
    });
    fullBuild();
  }
}
