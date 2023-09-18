import 'package:flutter/material.dart';
import 'package:flutter_univ/main.dart';
import 'package:flutter_univ/theme/AppThemeDefault.dart';
import 'package:flutter_univ/widgets/DialogWindowWidgets/ColorPickerDialog.dart';
import 'package:flutter_univ/widgets/WorkPageWidgets/CustomNumberInput.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../DialogWindowWidgets/FileWidgets/ContainerStyle.dart';

class TableSettings extends StatefulWidget {
  const TableSettings({super.key});

  @override
  State<TableSettings> createState() => _TableSettingsState();
}

class _TableSettingsState extends State<TableSettings> {
  bool _fixHeader = false;
  bool _fixStart = false;
  bool _fixEnd = false;

  bool _enableColorStart = true;
  bool _enableColorEnd = true;

  Color _colorStart = Colors.blue;
  Color _colorEnd = Colors.orange;

  bool _show = false;

  @override
  Widget build(BuildContext context) {
    fixHeader = context.watch<TableOption>().fixHeader;
    fixStart = context.watch<TableOption>().fixStart;
    fixEnd = context.watch<TableOption>().fixEnd;
    enableColorStart = context.watch<TableOption>().enableColorStart;
    enableColorEnd = context.watch<TableOption>().enableColorEnd;
    colorStart = context.watch<TableOption>().colorStart;
    colorEnd = context.watch<TableOption>().colorEnd;

    Widget buttonSettings = Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: appTheme(context).secondaryColor,
          border: Border.all(color: appTheme(context).accentColor)),
      child: IconButton(
          onPressed: () {
            setState(() {
              _show = !_show;
            });
          },
          icon: const Icon(Icons.settings)),
    );

    return _show
        ? ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: 100,
                maxHeight: MediaQuery.of(context).size.height * 0.5),
            child: FractionallySizedBox(
              widthFactor: 0.15,
              // heightFactor: 0.5,
              child: Container(
                decoration: BoxDecoration(
                    color: appTheme(context).secondaryColor,
                    border: Border.all(color: appTheme(context).accentColor)),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          ContainerStyle(
                            text: 'Закрепление таблицы',
                            child: Column(children: [
                              CheckboxListTile(
                                title: const Text("Закрепить заголовок"),
                                value: _fixHeader,
                                onChanged: (value) {
                                  setState(() {
                                    context.read<TableOption>().fixHeader =
                                        value!;
                                  });
                                },
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),
                              ...buildFixedSettings(
                                  onChangedColor: (Color value) {
                                    context.read<TableOption>().colorStart =
                                        value;
                                  },
                                  title: "Закрепить начальные столбцы",
                                  checkboxTitle: _fixStart,
                                  titleOnChanged: (value) {
                                    setState(() {
                                      context.read<TableOption>().fixStart =
                                          value!;
                                    });
                                  },
                                  maxValue: context.watch<TableOption>().fixEnd
                                      ? context
                                              .watch<OpenFiles>()
                                              .fileTitle
                                              .length -
                                          context.watch<TableOption>().lengthEnd
                                      : context
                                          .watch<OpenFiles>()
                                          .fileTitle
                                          .length,
                                  startValue:
                                      context.read<TableOption>().lengthStart,
                                  callbackValue: (int value) {
                                    context.read<TableOption>().lengthStart =
                                        value;
                                  },
                                  checkboxColor: _enableColorStart,
                                  onChangedColorEnable: (value) {
                                    setState(() {
                                      context
                                          .read<TableOption>()
                                          .enableColorStart = value!;
                                    });
                                  },
                                  color:
                                      context.watch<TableOption>().colorStart),
                              ...buildFixedSettings(
                                  onChangedColor: (Color value) {
                                    context.read<TableOption>().colorEnd =
                                        value;
                                  },
                                  title: "Закрепить конечные столбцы",
                                  checkboxTitle: _fixEnd,
                                  titleOnChanged: (value) {
                                    setState(() {
                                      context.read<TableOption>().fixEnd =
                                          value!;
                                    });
                                  },
                                  maxValue:
                                      context.watch<TableOption>().fixStart
                                          ? context
                                                  .watch<OpenFiles>()
                                                  .fileTitle
                                                  .length -
                                              context
                                                  .watch<TableOption>()
                                                  .lengthStart
                                          : context
                                              .watch<OpenFiles>()
                                              .fileTitle
                                              .length,
                                  startValue:
                                      context.read<TableOption>().lengthEnd,
                                  callbackValue: (int value) {
                                    context.read<TableOption>().lengthEnd =
                                        value;
                                  },
                                  checkboxColor: _enableColorEnd,
                                  onChangedColorEnable: (value) {
                                    setState(() {
                                      context
                                          .read<TableOption>()
                                          .enableColorEnd = value!;
                                    });
                                  },
                                  color: context.watch<TableOption>().colorEnd),
                            ]),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [buttonSettings],
                    ),
                  ],
                ),
              ),
            ),
          )
        : buttonSettings;
  }

  buildFixedSettings(
      {required String title,
      required bool checkboxTitle,
      required void Function(bool?)? titleOnChanged,
      required int maxValue,
      required int startValue,
      required void Function(int)? callbackValue,
      required bool checkboxColor,
      required void Function(bool?)? onChangedColorEnable,
      required Color color,
      required void Function(Color) onChangedColor}) {
    return [
      CheckboxListTile(
        title: Text(title),
        value: checkboxTitle,
        onChanged: titleOnChanged,
        controlAffinity: ListTileControlAffinity.leading,
      ),
      checkboxTitle
          ? ContainerStyle(
              bottom: true,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          title: const Text("Цветовое выделение столбца"),
                          value: checkboxColor,
                          onChanged: onChangedColorEnable,
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            showColorPickerDialogWindow(
                                    context: context, color: color)
                                .then((value) {
                              if (value != null) {
                                onChangedColor(value);
                              }
                            });
                          },
                          icon: Icon(
                            Icons.color_lens,
                            color: color,
                          ))
                    ],
                  ),
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(10),
                      1: FlexColumnWidth(3),
                    },
                    children: [
                      TableRow(
                        children: [
                          const TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 10, right: 5, bottom: 10),
                              child: Text("Количество закрепленных столбцов: "),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 10, bottom: 10),
                              child: CustomNumberInput(
                                minValue: 1,
                                maxValue: maxValue,
                                startValue: startValue,
                                callbackValue: callbackValue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          : const SizedBox()
    ];
  }

  bool get fixHeader => _fixHeader;

  set fixHeader(bool fix) {
    setState(() {
      _fixHeader = fix;
    });
  }

  bool get fixStart => _fixStart;

  set fixStart(bool fix) {
    setState(() {
      _fixStart = fix;
    });
  }

  bool get fixEnd => _fixEnd;

  set fixEnd(bool fix) {
    setState(() {
      _fixEnd = fix;
    });
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
