import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_univ/main.dart';
import 'package:flutter_univ/modules/ReportFetch.dart';
import 'package:flutter_univ/widgets/DialogWindowWidgets/ReportDialog.dart';
import 'package:provider/provider.dart';

class MReportBox extends StatefulWidget {
  const MReportBox({super.key, required this.value, required this.index});

  final bool value;
  final int index;

  @override
  State<MReportBox> createState() => _MReportBoxState();
}

class _MReportBoxState extends State<MReportBox> {
  late bool select;
  late int index;

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
          String fileName = context.read<OpenFiles>().selectedFile?.name ?? "";
          String text = context.read<OpenFiles>().analyzedText[index] ?? "";

          if (!select) {
            await showReportDialogWindow(
              context,
              fileName,
              text,
              false,
            ).then((value) {
              if (value[0] == "send") {
                addReport(value[1]);
              }
              return;
            });
          } else {
            await getReportFetch(fileName, (index - 1).toString())
                .then((value) async {
              await showReportDialogWindow(context, fileName, text, true,
                      report: value)
                  .then((value) {});
            }).catchError((error) {
              print(error);
              return;
            });
          }
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

  void addReport(String message) {
    setState(() {
      select = true;
    });

    context.read<OpenFiles>().saveRowData(jsonEncode({
          'data': [
            {
              'type': 'report',
              'index': index - 1,
              'select': select.toString(),
              'message': message
            }
          ]
        }));
  }
}
