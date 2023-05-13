import 'package:flutter/material.dart';
import 'package:flutter_univ/widgets/DialogWindowWidgets/FileWidgets/ContainerStyle.dart';

import '../../theme/AppThemeDefault.dart';

class ScrollText extends StatefulWidget {
  const ScrollText(
      {super.key,
      this.setMessageCallback,
      required this.editable,
      this.text = ""});

  final Function? setMessageCallback;
  final bool editable;
  final String text;

  @override
  State<ScrollText> createState() => _ScrollTextState();
}

class _ScrollTextState extends State<ScrollText> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  String message = "";
  late bool editable;
  Function? setMessageCallback;

  @override
  void initState() {
    super.initState();
    setMessageCallback = widget.setMessageCallback;
    editable = widget.editable;
    _textController.text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 100,
        child: Scrollbar(
          controller: _scrollController,
          child: TextField(
            controller: _textController,
            enabled: editable,
            scrollController: _scrollController,
            autofocus: true,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            autocorrect: true,
            onChanged: (s) {
              if (setMessageCallback != null) {
                setMessageCallback!(s);
              }
            },
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ));
  }
}

class ReportDialogWindows extends StatefulWidget {
  const ReportDialogWindows(
      {super.key,
      required this.fileName,
      required this.text,
      required this.read,
      required this.report});

  final String fileName;
  final String text;
  final bool read;
  final String report;

  @override
  State<ReportDialogWindows> createState() => _ReportDialogWindowsState();
}

class _ReportDialogWindowsState extends State<ReportDialogWindows> {
  late String fileName;
  late String text;
  late bool read;
  late String report;
  String message = "";

  @override
  void initState() {
    super.initState();
    fileName = widget.fileName;
    text = widget.text;
    read = widget.read;
    report = widget.report;
  }

  void setMessage(String value) {
    setState(() {
      message = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: SizedBox(
                width: 500,
                child: Container(
                  decoration: BoxDecoration(
                    color: appTheme(context).secondaryColor,
                    border: Border.all(
                      color: appTheme(context).tertiaryColor,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        ContainerStyle(
                          text: "Название файла",
                          child: Text(fileName),
                        ),
                        ContainerStyle(
                          text: "Анализированное сообщение",
                          child: Text(text),
                        ),
                        ContainerStyle(
                          text: "Сообщение",
                          child: ScrollText(
                            text: report,
                            editable: !read,
                            setMessageCallback: setMessage,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                !read
                    ? TextButton(
                        onPressed: () {
                          Navigator.pop(context, ["send", message]);
                        },
                        child: const Text("Отправить"),
                      )
                    : const SizedBox.shrink(),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, "cancel");
                  },
                  child: const Text("Закрыть"),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

Future<dynamic> showReportDialogWindow(
    BuildContext context, String fileName, String text, bool read,
    {String report = ""}) async {
  return await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return ReportDialogWindows(
        fileName: fileName,
        text: text,
        read: read,
        report: report,
      );
    },
  );
}
