import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../modules/FileFetch.dart';
import '../../pages/WorkPage.dart';
import '../../theme/AppThemeDefault.dart';
import '../DialogWindowWidgets/FileDialog.dart';
import '../DialogWindowWidgets/ReplaceDialog.dart';

class MFileView extends StatefulWidget {
  const MFileView({super.key});

  @override
  State<MFileView> createState() => _MFileViewState();
}

class _MFileViewState extends State<MFileView> {
  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: appTheme(context).secondaryColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        width: double.infinity,
        child: FractionallySizedBox(
          widthFactor: 0.98,
          heightFactor: 0.85,
          child: Container(
              decoration: BoxDecoration(
                color: appTheme(context).primaryColor,
                border: Border.all(
                  color: appTheme(context).accentColor,
                  width: 5,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 150,
                    child: Scrollbar(
                      controller: controller,
                      interactive: true,
                      trackVisibility: true,
                      thumbVisibility: true,
                      child: ListView(
                        controller: controller,
                        scrollDirection: Axis.horizontal,
                        children: [
                          ...context
                              .watch<OpenFiles>()
                              .openFile
                              .map((e) => e.fileContainer),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(
                    flex: 1,
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () async {
                        await showFileDialogWindow(context).then((value) async {
                          try {
                            await saveFile(value);
                          } catch (e) {
                            print(e.toString());
                            return;
                          }
                        });
                      },
                      child: const SizedBox(
                          height: double.infinity,
                          child: FittedBox(
                              alignment: Alignment.center,
                              child: Icon(Icons.add))),
                    ),
                  )
                ],
              )),
        ));
  }

  Future<void> saveFile(dynamic value) async {
    if (value is LoadFile) {
      bool read = true;

      await saveFileFetch(value).then((result) async {
        if (result == "true") {
          await showReplaceDialogWindow(context, value.name)
              .then((select) async {
            read = await replaceFile(select, value.fullName);
          }).catchError((error) {
            read = false;
            print(error);
            return;
          });
        }

        print("File Save OK");
      }).catchError((error) {
        read = false;
        print(error.toString());

        return;
      });

      if (read) {
        addData(value.fullName);
      }
      return;
    }

    if (value == "cancel") {
      return;
    }

    throw Exception("Не удалось открыть файл");
  }

  Future<bool> replaceFile(String select, String fullName) async {
    if (select.isEmpty) {
      return false;
    }

    if (select == "rewrite") {
      return await rewriteFileFetch(fullName).then((value) {
        return true;
      }).catchError((error) {
        print(error);
        return false;
      });
    }

    if (select == "cancel") {
      return false;
    }

    if (select == "open") {
      return await getFileFetch(fullName).then((value) {
        return true;
      }).catchError((error) {
        print(error);
        return false;
      });
    }

    return false;
  }

  void addData(String fullName) {
    context.read<OpenFiles>().addData(
          fullName,
          newFile: true,
        );
  }
}
