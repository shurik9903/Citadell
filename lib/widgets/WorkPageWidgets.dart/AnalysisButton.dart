import 'package:flutter/material.dart';
import 'package:flutter_univ/main.dart';
import 'package:flutter_univ/widgets/DialogWindowWidgets/AlalysisDialog.dart';
import 'package:flutter_univ/widgets/DialogWindowWidgets/FileDialog.dart';
import 'package:flutter_univ/widgets/WorkPageWidgets.dart/LoadAnimation.dart';
import 'package:provider/provider.dart';

import '../../modules/AnalysisFetch.dart';
import '../../pages/WorkPage.dart';
import '../../theme/AppThemeDefault.dart';

class MAnalysisButton extends StatefulWidget {
  const MAnalysisButton({super.key});

  @override
  State<MAnalysisButton> createState() => _MAnalysisButtonState();
}

class _MAnalysisButtonState extends State<MAnalysisButton> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.8,
      heightFactor: 0.95,
      child: GestureDetector(
        onTap: () async {
          String? fileName = context.read<OpenFiles>().selectedFile?.name;
          Map<int, String> columns = context.read<OpenFiles>().title;

          if (fileName == null) {
            return;
          }

          await showAnalysisDialogWindow(context, fileName, columns)
              .then((value) async {
            if (value[0] == "cancel") {
              return;
            }

            if (value[0] == "analysis") {
              await fileAnalysisFetch(fileName, value[1].toString())
                  .then((value) {
                context
                    .read<OpenFiles>()
                    .changeStatusFile(fileName, FileStatus.processing);
              }).catchError((error) {
                print(error.toString());
              });
            }
          });
        },
        child: Container(
          alignment: Alignment.center,
          decoration: context.watch<TypeViewMenu>().show
              ? BoxDecoration(
                  color: const Color.fromARGB(255, 18, 204, 18),
                  border: Border.all(
                    color: appTheme(context).accentColor,
                    width: 5,
                  ),
                  shape: BoxShape.circle)
              : BoxDecoration(
                  color: const Color.fromARGB(255, 18, 204, 18),
                  border: Border.all(
                    color: appTheme(context).accentColor,
                    width: 5,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
          child: context.watch<OpenFiles>().selectedFile?.status ==
                  FileStatus.processing
              ? const LoadAnimation()
              : Text(
                  context.watch<TypeViewMenu>().show ? ">>" : "Анализировать",
                  style: TextStyle(
                      fontSize: 30, color: appTheme(context).textColor2),
                ),
        ),
      ),
    );
  }
}
