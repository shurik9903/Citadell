import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_univ/main.dart';
import 'package:provider/provider.dart';

import '../../pages/WorkPage.dart';

class MUpdateBox extends StatefulWidget {
  const MUpdateBox({super.key, required this.value, required this.index});

  final bool value;
  final int index;

  @override
  State<MUpdateBox> createState() => _MUpdateBoxState();
}

class _MUpdateBoxState extends State<MUpdateBox> {
  late bool select;
  late int index;

  @override
  void initState() {
    super.initState();
    select = widget.value;
    index = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    select = context.watch<OpenFiles>().selectedRow[index] ?? widget.value;
    return Checkbox(
      value: select,
      activeColor: const Color.fromARGB(255, 0, 170, 255),
      onChanged: (value) {
        setState(() {
          context.read<OpenFiles>().selectedRow[index] = value!;
        });

        context.read<OpenFiles>().saveReportData(jsonEncode({
              'data': [
                {
                  'type': 'update',
                  'index': index - 1,
                  'select': value.toString(),
                }
              ]
            }));
      },
    );
  }
}
