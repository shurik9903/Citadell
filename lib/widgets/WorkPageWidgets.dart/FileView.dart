import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../pages/WorkPage.dart';
import '../../theme/AppThemeDefault.dart';
import '../DialogWindowWidgets/FileDialog.dart';

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
                              .map((e) => e.selectFile),
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
                        await showFileDialogWindow(context).then((value) {
                          if (value as String == "open") {}

                          if (value == "cancel") {
                            return;
                          }
                        });

                        // FilePickerResult? result =
                        //     await FilePicker.platform.pickFiles();

                        // try {
                        //   if (result != null) {
                        //     PlatformFile file = result.files.first;

                        //     print(file.name);

                        //     bool read = true;

                        //     await saveFileFetch(
                        //             file.name, file.bytes.toString())
                        //         .then((value) async {
                        //       print(value);

                        //       if (value == "true") {
                        //         await showReplaceDialogWindow(
                        //                 context, file.name)
                        //             .then((value) async {
                        //           if (value as String == null) {
                        //             return;
                        //           }

                        //           if (value as String == "rewrite") {
                        //             await rewriteFileFetch(file.name)
                        //                 .then((value) {})
                        //                 .catchError((error) {
                        //               read = false;
                        //               print(error);
                        //               return;
                        //             });
                        //           }

                        //           if (value == "cancel") {
                        //             read = false;
                        //             return;
                        //           }
                        //         }).catchError((error) {
                        //           read = false;
                        //           print(error);
                        //           return;
                        //         });
                        //       }

                        //       print("File Save OK");
                        //     }).catchError((error) {
                        //       read = false;
                        //       print(error.toString());
                        //       // setState(() {
                        //       // msg = error.toString();
                        //       // });
                        //       return;
                        //     });

                        //     print(read);
                        //     if (read) {
                        //       await context.read<OpenFiles>().addData(
                        //             file.name,
                        //             newFile: true,
                        //           );
                        //     }
                        //   } else {
                        //     throw Exception("Не удалось открыть файл");
                        //   }
                        // } catch (error) {
                        //   print(error.toString());
                        //   return;
                        // }
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
}
