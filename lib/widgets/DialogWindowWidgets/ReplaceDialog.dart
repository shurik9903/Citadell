import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

import '../../theme/AppThemeDefault.dart';

class ReplaceDialogWindows extends StatefulWidget {
  const ReplaceDialogWindows({super.key, this.fileName});

  final String? fileName;

  @override
  State<ReplaceDialogWindows> createState() => _ReplaceDialogWindowsState();
}

class _ReplaceDialogWindowsState extends State<ReplaceDialogWindows> {
  String fileName = "";

  @override
  void initState() {
    super.initState();
    fileName = widget.fileName ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Stack(
      children: [
        SizedBox(
          width: 400,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("$fileName уже существует."),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, "rewrite");
                      },
                      child: const Text("Заменить"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, "open");
                      },
                      child: const Text("Открыть уже существующий"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, "cancel");
                      },
                      child: const Text("Отмена"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}

Future<void> showReplaceDialogWindow(
    BuildContext context, String fileName) async {
  return await showDialog(
    context: context,
    builder: (context) {
      return ReplaceDialogWindows(fileName: fileName);
    },
  );
}
