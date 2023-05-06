import 'package:flutter/material.dart';

import '../../theme/AppThemeDefault.dart';

class TableColumn extends StatefulWidget {
  TableColumn({
    super.key,
    required this.index,
    required this.length,
    this.text,
  });

  int index;
  int length;
  String? text;

  @override
  State<TableColumn> createState() => _TableColumnState();
}

class _TableColumnState extends State<TableColumn> {
  late int index;
  late int length;
  late String text;

  @override
  void initState() {
    super.initState();

    index = widget.index;
    length = widget.length;
    text = widget.text ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              color: appTheme(context).secondaryColor,
              border: Border.all(
                color: appTheme(context).tertiaryColor,
                width: 1,
              ),
              borderRadius: index == 0
                  ? const BorderRadius.only(topLeft: Radius.circular(10))
                  : index == (length - 1)
                      ? const BorderRadius.only(topRight: Radius.circular(10))
                      : null),
          alignment: Alignment.center,
          child: Text(text)),
    );
  }
}
