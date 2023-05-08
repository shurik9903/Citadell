import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
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
  late Widget _textScrolls;

  void textMove() {
    setState(() {
      _textScrolls = Marquee(
        text: name,
        blankSpace: 30,
      );
    });
  }

  void textStop() {
    setState(() {
      _textScrolls = Text(
        name,
        overflow: TextOverflow.fade,
        maxLines: 1,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    name = widget.name;
    textStop();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        MouseRegion(
          onEnter: (event) {
            textMove();
          },
          onExit: (event) {
            textStop();
          },
          child: GestureDetector(
            onTap: () {
              context.read<OpenFiles>().selectFile(widget.key);
            },
            child: Container(
              padding: const EdgeInsets.only(left: 2.5, right: 20),
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              alignment: Alignment.center,
              constraints: const BoxConstraints(maxWidth: 250),
              decoration: BoxDecoration(
                  color:
                      context.watch<OpenFiles>().selectedFile?.selectFile.key ==
                              widget.key
                          ? appTheme(context).tertiaryColor
                          : appTheme(context).secondaryColor,
                  border: Border.all(color: appTheme(context).accentColor),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              child: _textScrolls,
            ),
          ),
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
                color: Color.fromARGB(220, 155, 0, 0),
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
