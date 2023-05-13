import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DigitsTextField extends StatefulWidget {
  const DigitsTextField({super.key, this.callback});
  final Function? callback;
  @override
  State<DigitsTextField> createState() => _DigitsTextFieldState();
}

class _DigitsTextFieldState extends State<DigitsTextField> {
  late Function? callback;

  @override
  void initState() {
    super.initState();
    callback = widget.callback;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        if (callback != null) {
          callback!(value);
        }
      },
      decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 5),
          border: UnderlineInputBorder(),
          hintText: '1'),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
    );
  }
}
