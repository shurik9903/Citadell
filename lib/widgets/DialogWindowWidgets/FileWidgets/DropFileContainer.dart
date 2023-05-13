import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter_univ/theme/AppThemeDefault.dart';
import 'package:flutter_univ/widgets/DialogWindowWidgets/FileDialog.dart';
import 'package:flutter_univ/widgets/DialogWindowWidgets/FileWidgets/FileWorkWindow.dart';
import 'package:provider/provider.dart';

class DropFileContainer extends StatefulWidget {
  const DropFileContainer({super.key});

  @override
  State<DropFileContainer> createState() => _DropFileContainerState();
}

class _DropFileContainerState extends State<DropFileContainer> {
  late DropzoneViewController dropController;
  bool isDroping = false;
  bool fileError = false;

  @override
  Widget build(BuildContext context) {
    final dropColor = isDroping
        ? const Color.fromARGB(209, 0, 179, 255)
        : appTheme(context).primaryColor;

    return Center(
      child: Container(
        height: 200,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 100),
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: dropColor,
          border: Border.all(
            color: appTheme(context).tertiaryColor,
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            DropzoneView(
              onHover: () {
                setState(() {
                  isDroping = true;
                });
              },
              onLeave: () {
                setState(() {
                  isDroping = false;
                });
              },
              onCreated: ((controller) => dropController = controller),
              onDrop: (event) async {
                setState(() {
                  isDroping = false;
                });

                LoadFile loadFile = await loadingFile(event);

                if (isInvalidFile(loadFile.type)) {
                  showSelectFileWindow(loadFile);
                } else {
                  setState(() {
                    fileError = true;
                  });
                }
              },
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_upload),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("Перетащите файл в эту зону"),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(5),
                        shape: const RoundedRectangleBorder()),
                    icon: const Icon(
                      Icons.file_open,
                      size: 20,
                    ),
                    label: const Text("Выбрать файл"),
                    onPressed: () async {
                      final events = await dropController.pickFiles();

                      if (events.isEmpty) {
                        return;
                      }

                      LoadFile loadFile = await loadingFile(events.first);

                      if (isInvalidFile(loadFile.type)) {
                        showSelectFileWindow(loadFile);
                      } else {
                        setState(() {
                          fileError = true;
                        });
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  fileError
                      ? const Text(
                          "Неподдерживаемый тип файла. \nПоддерживаемые типы файлов:\n.txt, .doc(x), .xls(x).",
                          style: TextStyle(color: Colors.red))
                      : const SizedBox.shrink()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isInvalidFile(String type) {
    return context
        .read<FileWorking>()
        .type
        .firstWhere(
          (element) => RegExp(r'' + '^\\$element.?\$').hasMatch(type),
          orElse: () => "",
        )
        .isNotEmpty;
  }

  Future<LoadFile> loadingFile(dynamic event) async {
    final name = event.name;
    final mime = await dropController.getFileMIME(event);
    final bytes = await dropController.getFileData(event);
    final size = await dropController.getFileSize(event);
    final url = await dropController.createFileUrl(event);

    return LoadFile(
        fullName: name,
        type: name.substring(name.lastIndexOf('.')),
        bytes: bytes,
        size: size);
  }

  void showSelectFileWindow(LoadFile loadfile) {
    context.read<FileWorking>().loadFile = loadfile;

    String type = context.read<FileWorking>().type.firstWhere(
          (element) => RegExp(r'' + '^\\$element.?\$').hasMatch(loadfile.type),
          orElse: () => "",
        );

    context.read<FileWorking>().dropdownValue = type;
    context.read<FileWorking>().loadFile?.type = type;
    context.read<FileWorking>().openWindow = const FileWorkWindow();
  }
}
