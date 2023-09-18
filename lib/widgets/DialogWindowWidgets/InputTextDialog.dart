import 'package:flutter/material.dart';

class InputText extends StatefulWidget {
  const InputText({super.key, this.text});

  final String? text;

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  bool _validate = false;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    widget.text != null ? controller.text = widget.text! : null;

    return Dialog(
      child: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                maxLines: 1,
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Введите текст',
                  errorText: _validate ? 'Значение не может быть пустым' : null,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                      onPressed: () {
                        if (controller.text.isEmpty) {
                          setState(() {
                            _validate = true;
                          });
                          return;
                        }

                        Navigator.pop(
                            context, {'select': true, 'data': controller.text});
                      },
                      child: const Text("Принять")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, {'select': false});
                      },
                      child: const Text("Отмена"))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<dynamic> showInputTextDialogWindow(BuildContext context,
    {String text = ""}) async {
  return await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return InputText(text: text);
    },
  );
}
