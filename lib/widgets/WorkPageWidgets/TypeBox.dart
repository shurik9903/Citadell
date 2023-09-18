import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_univ/main.dart';
import 'package:flutter_univ/theme/AppThemeDefault.dart';
import 'package:flutter_univ/widgets/WorkPageWidgets/ContextMenu.dart';
import 'package:provider/provider.dart';

class MTypeBox extends StatefulWidget {
  const MTypeBox(
      {super.key, required this.value, required this.index, this.typeRow});

  final int value;
  final Map<int, TypeRow>? typeRow;
  final int index;

  @override
  State<MTypeBox> createState() => _MTypeBoxState();
}

class _MTypeBoxState extends State<MTypeBox> {
  late int index;
  late Map<int, TypeRow>? typeRow;

  @override
  void initState() {
    super.initState();
    index = widget.index;
    typeRow = widget.typeRow;
  }

  @override
  Widget build(BuildContext context) {
    return typeRow != null
        ? ContextMenu(
            contextMenuBuilder: (context, offset) {
              return AdaptiveTextSelectionToolbar(
                anchors: TextSelectionToolbarAnchors(
                  primaryAnchor: offset,
                ),
                children: typeRow?.entries
                    .whereNot((elementType) => elementType.key == widget.value)
                    .map(
                  (elementType) {
                    return CupertinoButton(
                      color: elementType.value.color,
                      pressedOpacity: 0.7,
                      borderRadius: null,
                      padding: const EdgeInsets.all(10.0),
                      onPressed: () {
                        ContextMenuController.removeAny();

                        int? typeIndex = context
                            .read<OpenFiles>()
                            .titleTypes
                            .entries
                            .firstWhereOrNull(
                                (element) => element.value == "type")
                            ?.key;

                        if (typeIndex != null) {
                          Map<int, List<dynamic>> fileRow =
                              context.read<OpenFiles>().fileRow;

                          fileRow[index]?[typeIndex] =
                              elementType.key.toString();

                          context.read<OpenFiles>().fileRow = fileRow;
                        }

                        context.read<OpenFiles>().saveRowData(jsonEncode({
                              'data': [
                                {
                                  'type': 'type',
                                  'index': index - 1,
                                  'classComment': elementType.key.toString(),
                                }
                              ]
                            }));
                      },
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(elementType.value.name),
                      ),
                    );
                  },
                ).toList()
                  ?..addAll([
                    CupertinoButton(
                      color: appTheme(context).secondaryColor,
                      pressedOpacity: 0.7,
                      borderRadius: null,
                      padding: const EdgeInsets.all(10.0),
                      onPressed: () {
                        ContextMenuController.removeAny();

                        int? typeIndex = context
                            .read<OpenFiles>()
                            .titleTypes
                            .entries
                            .firstWhereOrNull(
                                (element) => element.value == "type")
                            ?.key;

                        if (typeIndex != null) {
                          Map<int, List<dynamic>> fileRow =
                              context.read<OpenFiles>().fileRow;

                          fileRow[index]?[typeIndex] = "0";

                          context.read<OpenFiles>().fileRow = fileRow;
                        }

                        context.read<OpenFiles>().saveRowData(jsonEncode({
                              'data': [
                                {
                                  'type': 'type',
                                  'index': index - 1,
                                  'classComment': 0,
                                }
                              ]
                            }));
                      },
                      child: const SizedBox(
                        width: double.infinity,
                        child: Text('Пустой'),
                      ),
                    ),
                    CupertinoButton(
                      color: appTheme(context).secondaryColor,
                      pressedOpacity: 0.7,
                      borderRadius: null,
                      padding: const EdgeInsets.all(10.0),
                      onPressed: () {
                        ContextMenuController.removeAny();
                      },
                      child: const SizedBox(
                        width: double.infinity,
                        child: Text('Отмена'),
                      ),
                    ),
                  ]),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.only(right: 5),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      height: double.infinity,
                      decoration: BoxDecoration(
                          color: typeRow?[widget.value]?.color,
                          border: Border.all(
                            color: appTheme(context).primaryColor,
                            width: 5,
                          )),
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Text(typeRow?[widget.value]?.name ?? ""),
                ),
              ],
            ),
          )
        : Container();
  }
}
