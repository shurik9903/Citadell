import 'package:flutter/material.dart';
import 'package:flutter_univ/theme/AppThemeDefault.dart';
import 'package:provider/provider.dart';
import 'package:flutter_univ/widgets/DialogWindowWidgets/FileDialog.dart';

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key, required this.list});
  final List<String> list;

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  late List<String> list;
  @override
  void initState() {
    super.initState();
    list = widget.list;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: context.read<FileWorking>().dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      underline: Container(
        height: 2,
        color: appTheme(context).secondaryColor,
      ),
      onChanged: (String? value) {
        setState(() {
          context.read<FileWorking>().dropdownValue = value!;
        });
        context.read<FileWorking>().loadFile?.type = value!;
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
