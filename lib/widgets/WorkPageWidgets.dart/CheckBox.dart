import 'package:flutter/material.dart';
import 'package:flutter_univ/pages/WorkPage.dart';
import 'package:provider/provider.dart';

class MCheckBox extends StatefulWidget {
  const MCheckBox({super.key, required this.value, required this.index});

  final bool value;
  final String index;

  @override
  State<MCheckBox> createState() => _MCheckBoxState();
}

class _MCheckBoxState extends State<MCheckBox> {
  late bool select;
  late String index;

  @override
  void initState() {
    super.initState();
    select = widget.value;
    index = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () async {
          setState(() {
            select = true;
          });

          context.read<OpenFiles>().changeData[index] ??= {};

          context.read<OpenFiles>().changeData[index]?["report"] =
              select.toString();
        },
        child: Icon(
          Icons.sim_card_alert_rounded,
          color: select
              ? const Color.fromARGB(255, 168, 0, 0)
              : const Color.fromARGB(255, 231, 231, 231),
        ),
      ),
    );
  }
}
