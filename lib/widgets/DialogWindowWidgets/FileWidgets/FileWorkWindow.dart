import 'package:flutter/material.dart';
import 'package:flutter_univ/theme/AppThemeDefault.dart';
import 'package:flutter_univ/widgets/DialogWindowWidgets/FileDialog.dart';
import 'package:flutter_univ/widgets/DialogWindowWidgets/FileWidgets/ColRowController.dart';
import 'package:flutter_univ/widgets/DialogWindowWidgets/FileWidgets/ContainerStyle.dart';
import 'package:flutter_univ/widgets/DialogWindowWidgets/FileWidgets/DropdownButton.dart';
import 'package:provider/provider.dart';

class FileWorkWindow extends StatefulWidget {
  const FileWorkWindow({super.key});

  @override
  State<FileWorkWindow> createState() => _FileWorkWindowState();
}

class _FileWorkWindowState extends State<FileWorkWindow> {
  bool isAutoSizeTable = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          padding: const EdgeInsets.all(20),
          alignment: Alignment.topLeft,
          decoration: BoxDecoration(
            color: appTheme(context).secondaryColor,
            border: Border.all(
              color: appTheme(context).tertiaryColor,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ContainerStyle(
                text: "Имя файла",
                child: TextField(
                  onChanged: (value) {},
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                      border: const UnderlineInputBorder(),
                      hintText:
                          '${context.read<FileWorking>().loadFile?.name}'),
                ),
              ),
              ContainerStyle(
                text: "Тип файла",
                child: DropdownButtonExample(
                  list: context.read<FileWorking>().type,
                ),
              ),
              ContainerStyle(
                text: "Размер файла",
                child: Text("${context.read<FileWorking>().loadFile?.size}"),
              ),
              tableSizeWindow(),
            ],
          )),
    );
  }

  Widget tableSizeWindow() {
    return context.watch<FileWorking>().dropdownValue == ".xls"
        ? ContainerStyle(
            text: "Размер таблицы",
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [ColRowController()],
            ),
          )
        : const SizedBox.shrink();
  }
}
