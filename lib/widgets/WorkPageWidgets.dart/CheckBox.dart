import 'package:flutter/material.dart';

class MCheckBox extends StatefulWidget {
  const MCheckBox({super.key});

  @override
  State<MCheckBox> createState() => _MCheckBoxState();
}

class _MCheckBoxState extends State<MCheckBox> {
  bool select = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Checkbox(
        value: select,
        onChanged: (value) {
          setState(() {
            select = !select;
          });
        },
      ),
    );
  }
}
