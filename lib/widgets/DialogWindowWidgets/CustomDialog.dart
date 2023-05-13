import 'package:flutter/material.dart';

class CustomDialogWindow extends StatefulWidget {
  const CustomDialogWindow(
      {super.key, required this.child, required this.button});

  final Widget child;
  final List<Widget> button;

  @override
  State<CustomDialogWindow> createState() => _CustomDialogWindowState();
}

class _CustomDialogWindowState extends State<CustomDialogWindow> {
  late Widget child;
  late List<Widget> button;

  @override
  void initState() {
    super.initState();

    child = widget.child;
    button = widget.button;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: child,
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [...button],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> showCustomDialogWindow(
    {required BuildContext context,
    required Widget child,
    required List<Widget> button}) async {
  return await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return CustomDialogWindow(
        button: button,
        child: child,
      );
    },
  );
}
