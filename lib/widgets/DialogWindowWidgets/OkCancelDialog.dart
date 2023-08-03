import 'package:flutter/material.dart';

class MessageDialog extends StatefulWidget {
  const MessageDialog({super.key, this.text});

  final String? text;

  @override
  State<MessageDialog> createState() => _MessageDialogState();
}

class _MessageDialogState extends State<MessageDialog> {
  String? text;

  @override
  void initState() {
    super.initState();

    text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: Text(text ?? ''),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text("Принять")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text("Отмена"))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<bool> showOkCancelDialogWindow(BuildContext context, String text) async {
  return await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return MessageDialog(
        text: text,
      );
    },
  );
}
