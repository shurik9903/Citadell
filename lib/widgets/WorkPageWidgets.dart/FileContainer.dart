import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages/WorkPage.dart';
import '../../theme/AppThemeDefault.dart';

class FileContainer extends StatefulWidget {
  final String name;

  const FileContainer({required super.key, required this.name});

  @override
  State<FileContainer> createState() => _FileContainerState();
}

class _FileContainerState extends State<FileContainer> {
  late String name;
  late Key? selectKey;
  late Function callback;

  @override
  void initState() {
    super.initState();

    setState(() {
      name = widget.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () {
            context.read<OpenFiles>().selectFile(widget.key);
          },
          child: Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color:
                      context.watch<OpenFiles>().selectedFile?.selectFile.key ==
                              widget.key
                          ? appTheme(context).tertiaryColor
                          : appTheme(context).secondaryColor,
                  border: Border.all(color: appTheme(context).accentColor),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              child: Text(name)),
        ),
        Positioned(
          top: 5,
          right: 0,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              context.read<OpenFiles>().removeFile(widget.key);
            },
            child: Container(
              decoration: BoxDecoration(
                color: appTheme(context).tertiaryColor,
                shape: BoxShape.circle,
                border: Border.all(color: appTheme(context).accentColor),
              ),
              child: const Icon(Icons.close),
            ),
          ),
        ),
      ],
    );
  }
}
