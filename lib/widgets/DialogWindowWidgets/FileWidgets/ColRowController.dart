import 'package:flutter/material.dart';
import 'package:flutter_univ/widgets/DialogWindowWidgets/FileDialog.dart';
import 'package:flutter_univ/widgets/DialogWindowWidgets/FileWidgets/DigitsTextField.dart';
import 'package:provider/provider.dart';

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
