import 'package:flutter/material.dart';
import 'package:flutter_univ/main.dart';
import 'package:flutter_univ/widgets/WorkPageWidgets.dart/CustomTable.dart';
import 'package:flutter_univ/widgets/WorkPageWidgets.dart/TableLegend.dart';
import 'package:flutter_univ/widgets/WorkPageWidgets.dart/TableSettings.dart';
import 'package:provider/provider.dart';

import '../../theme/AppThemeDefault.dart';
import 'SelectedText.dart';

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<OpenFiles>().selectedFile != null) {
      setOption();
    }

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
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomRight,
        children: [
          // const Positioned(child: TableSettings()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 25,
                child: FractionallySizedBox(
                  widthFactor: 1,
                  heightFactor: 1,
                  child: context.watch<OpenFiles>().selectedFile != null
                      ? const CustomTable()
                      : Container(),
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
                              Container(
                                // height: 40,
                                alignment: Alignment.center,
                                child: Text(
                                    "Кол-во строк: ${context.watch<OpenFiles>().selectedFile?.numberRows ?? 0}",
                                    textAlign: TextAlign.center),
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
                          const Wrap(
                            children: [SizedBox()],
                          ),
                        ],
                      ),
                    ),
                  ))
            ],
          ),

          Container(
              margin: const EdgeInsets.only(right: 70, bottom: 5),
              child: const TableLegend()),
          Container(
              margin: const EdgeInsets.only(right: 10, bottom: 5),
              child: const TableSettings()),
        ],
      ),
    );
  }

  setOption() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TableOption>().setOption =
          context.read<OpenFiles>().selectedFile!.tableOption;
    });
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
