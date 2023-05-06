import 'package:flutter/material.dart';

class MSelectedText extends StatefulWidget {
  int selectId;
  int thisId;
  String text;
  Function? callback;

  MSelectedText(
      {super.key,
      required this.selectId,
      required this.text,
      required this.thisId,
      this.callback});

  @override
  State<MSelectedText> createState() => _MSelectedTextState();
}

class _MSelectedTextState extends State<MSelectedText> {
  int _selectId = -1;
  late int _thisId;
  late String _text;
  late Function _callback;

  @override
  void initState() {
    super.initState();
    _text = widget.text;
    _thisId = widget.thisId;
    _callback = widget.callback ?? () {};
  }

  @override
  Widget build(BuildContext context) {
    _selectId = widget.selectId;
    return GestureDetector(
      child: Text(
        style: TextStyle(
            color: _selectId == _thisId ? Colors.white : Colors.blue,
            decoration: TextDecoration.underline),
        _text,
      ),
      onTap: () => _callback(),
    );
  }
}
