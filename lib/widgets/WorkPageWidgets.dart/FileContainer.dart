import 'package:flutter/material.dart';
import 'package:flutter_univ/main.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import '../../theme/AppThemeDefault.dart';

class FileContainer extends StatefulWidget {
  final String name;
  final FileStatus status;
  late Function(FileStatus) setStatus;

  FileContainer({required super.key, required this.name, required this.status});

  @override
  State<FileContainer> createState() => _FileContainerState();
}

class _FileContainerState extends State<FileContainer> {
  late String name;
  late FileStatus status;
  late Widget _textScrolls;
  late Map<FileStatus, LinearGradient> colorStatus;

  void textMove() {
    setState(() {
      _textScrolls = Marquee(
        text: name,
        blankSpace: 30,
      );
    });
  }

  void setStatus(FileStatus newStatus) {
    setState(() {
      status = newStatus;
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
    status = widget.status;
    widget.setStatus = setStatus;
    textStop();

    // colorStatus = {
    //   FileStatus.nothing: const LinearGradient(
    //     begin: Alignment.topLeft,
    //     end: Alignment.bottomRight,
    //     colors: [
    //       Color.fromARGB(255, 0, 225, 255),
    //       Color.fromARGB(255, 0, 255, 217)
    //     ],
    //   ),
    //   FileStatus.processing: const LinearGradient(
    //     begin: Alignment.topLeft,
    //     end: Alignment.bottomRight,
    //     colors: [
    //       Color.fromARGB(255, 255, 217, 0),
    //       Color.fromARGB(255, 255, 174, 0)
    //     ],
    //   ),
    //   FileStatus.ready: const LinearGradient(
    //     begin: Alignment.topLeft,
    //     end: Alignment.bottomRight,
    //     colors: [
    //       Color.fromARGB(255, 81, 255, 0),
    //       Color.fromARGB(255, 166, 255, 0)
    //     ],
    //   ),
    // };

    colorStatus = {
      FileStatus.processing: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.fromARGB(255, 255, 217, 0),
          Color.fromARGB(255, 255, 174, 0)
        ],
      ),
      FileStatus.ready: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.fromARGB(255, 81, 255, 0),
          Color.fromARGB(255, 166, 255, 0)
        ],
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    colorStatus[FileStatus.nothing] = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        appTheme(context).tertiaryColor,
        appTheme(context).secondaryColor,
      ],
    );

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
                  gradient: colorStatus[status],
                  border: Border.all(
                      color: context
                                  .watch<OpenFiles>()
                                  .selectedFile
                                  ?.fileContainer
                                  .key ==
                              widget.key
                          ? appTheme(context).tertiaryColor
                          : appTheme(context).secondaryColor),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              child: _textScrolls,
            ),
          ),
        ),
        Positioned(
          top: 9,
          right: 0,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              context.read<OpenFiles>().removeFile(widget.key);
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(220, 155, 0, 0),
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
