import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_univ/modules/FileFetch.dart';
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
          Expanded(
            flex: 25,
            child: FractionallySizedBox(
              widthFactor: 1,
              heightFactor: 1,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: context.watch<OpenFiles>().fileTitle.isNotEmpty
                    ? DataTable(
                        horizontalMargin: 0,
                        columnSpacing: 0,
                        columns: [...context.watch<OpenFiles>().fileTitle],
                        rows: [...context.watch<OpenFiles>().fileRow],
                      )
                    : Container(),
              ),
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
}

DataRow buildTableRow(
    {required List<String> rowsText,
    required String rowIndex,
    required String analyzedText,
    required String probability,
    required bool update,
    required bool incorrect}) {
  return DataRow(cells: [
    ...rowsText.map((value) => DataCell(Container(
          alignment: Alignment.center,
          child: Text(value),
        ))),
    DataCell(MAnalysisText(
      parseText: [],
    )),
    DataCell(Container(
      alignment: Alignment.center,
      child: Text(
        probability,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: int.tryParse(probability) != null
              ? int.parse(probability) <= 30
                  ? Color.fromARGB(255, 255, 0, 0)
                  : int.parse(probability) <= 60
                      ? Color.fromARGB(255, 255, 217, 0)
                      : Color.fromARGB(255, 30, 255, 0)
              : Color.fromARGB(255, 255, 255, 255),
        ),
      ),
    )),
    DataCell(
      MUpdateBox(
        value: update,
        index: rowIndex,
        key: Key(rowIndex),
      ),
    ),
    DataCell(
      MReportBox(
        value: incorrect,
        index: rowIndex,
        key: Key(rowIndex),
      ),
    ),
  ]);
}
