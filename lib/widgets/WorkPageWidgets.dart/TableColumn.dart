import 'package:flutter/material.dart';
import 'package:flutter_univ/main.dart';
import 'package:provider/provider.dart';

import '../../theme/AppThemeDefault.dart';

class AllSelect extends StatefulWidget {
  const AllSelect({super.key, this.value});

  final bool? value;

  @override
  State<AllSelect> createState() => _AllSelectState();
}

class _AllSelectState extends State<AllSelect> {
  late bool? select;

  @override
  void initState() {
    super.initState();
    select = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    select = context.watch<OpenFiles>().allSelect;

    return Checkbox(
      tristate: true,
      value: select,
      activeColor: select == true
          ? const Color.fromARGB(255, 0, 255, 0)
          : select == null
              ? const Color.fromARGB(255, 255, 0, 0)
              : null,
      onChanged: (value) {
        value ??= false;
        setState(() {
          context.read<OpenFiles>().allSelect = value;
        });
      },
    );
  }
}

class TableColumn extends StatefulWidget {
  TableColumn({
    super.key,
    required this.index,
    required this.length,
    required this.child,
  });

  int index;
  int length;
  Widget child;

  @override
  State<TableColumn> createState() => _TableColumnState();
}

class _TableColumnState extends State<TableColumn> {
  late int index;
  late int length;
  late Widget child;

  @override
  void initState() {
    super.initState();

    index = widget.index;
    length = widget.length;
    child = widget.child;
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
          child: child),
    );
  }
}
