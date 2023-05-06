import 'package:flutter/material.dart';

class MUpdateBox extends StatefulWidget {
  const MUpdateBox({super.key});

  @override
  State<MUpdateBox> createState() => _MUpdateBoxState();
}

class _MUpdateBoxState extends State<MUpdateBox> {
  bool? select = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Checkbox(
        tristate: true,
        value: select,
        activeColor: select == true
            ? const Color.fromARGB(255, 0, 255, 0)
            : select == null
                ? const Color.fromARGB(255, 255, 0, 0)
                : null,
        onChanged: (value) {
          setState(() {
            select = value;
          });
        },
      ),
    );
  }
}
