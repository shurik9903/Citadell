import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_univ/theme/AppThemeDefault.dart';

class CustomNumberInput extends StatefulWidget {
  const CustomNumberInput(
      {super.key,
      this.maxValue,
      this.minValue,
      this.startValue,
      this.callbackValue});

  final int? maxValue;
  final int? minValue;
  final int? startValue;
  final void Function(int)? callbackValue;

  @override
  State<CustomNumberInput> createState() => _CustomNumberInputState();
}

class _CustomNumberInputState extends State<CustomNumberInput> {
  final TextEditingController _controller = TextEditingController();

  late int _min;
  late int _max;
  late void Function(int)? callbackValue;

  int ramp(int value) {
    return max(_min, min(value, _max));
  }

  void setValue(int value) {
    setState(() {
      int rampValue = ramp(value);
      _controller.text = rampValue.toString();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (callbackValue != null) {
          callbackValue!(int.parse(_controller.text));
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _min = widget.minValue ?? 0;
    _max = widget.maxValue ?? 9999999;
    _controller.text = ramp(widget.startValue ?? 0).toString();
    callbackValue = widget.callbackValue;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (callbackValue != null) {
        callbackValue!(int.parse(_controller.text));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _min = widget.minValue ?? 0;
    _max = widget.maxValue ?? 9999999;

    if (_controller.text != ramp(int.parse(_controller.text)).toString()) {
      print('test');
      setValue(int.parse(_controller.text));
    }

    return Container(
      width: 60,
      foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: appTheme(context).accentColor, width: 2)),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TextFormField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              controller: _controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: false,
                signed: true,
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ),
          SizedBox(
            height: 38,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 0.5),
                    ),
                  ),
                  child: InkWell(
                      child: const Icon(
                        Icons.arrow_drop_up,
                        size: 18,
                      ),
                      onTap: () {
                        int currentValue = int.parse(_controller.text);
                        setValue(++currentValue);
                      }),
                ),
                InkWell(
                  child: const Icon(
                    Icons.arrow_drop_down,
                    size: 18,
                  ),
                  onTap: () {
                    int currentValue = int.parse(_controller.text);
                    setValue(--currentValue);
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
