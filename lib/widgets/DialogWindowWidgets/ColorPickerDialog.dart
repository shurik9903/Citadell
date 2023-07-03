import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerDialogWindow extends StatefulWidget {
  const ColorPickerDialogWindow({super.key, this.color});

  final Color? color;

  @override
  State<ColorPickerDialogWindow> createState() =>
      _ColorPickerDialogWindowState();
}

class _ColorPickerDialogWindowState extends State<ColorPickerDialogWindow> {
  late Color color;
  late Color _setColor;

  @override
  void initState() {
    super.initState();
    color = widget.color ?? Colors.white;
    _setColor = widget.color ?? Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 550,
        width: 300,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: const Text('Выберите цвет'),
              ),
              ColorPicker(
                portraitOnly: true,
                pickerColor: color,
                onColorChanged: (Color color) {
                  _setColor = color;
                },
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, _setColor);
                  },
                  child: const Text("Принять"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, null);
                  },
                  child: const Text("Отмена"),
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }
}

Future<Color?> showColorPickerDialogWindow(
    {required BuildContext context, Color? color}) async {
  return await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return ColorPickerDialogWindow(
        color: color,
      );
    },
  );
}
