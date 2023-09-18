import 'package:flutter/material.dart';
import 'package:flutter_univ/data/ModelData.dart';
import 'package:flutter_univ/theme/AppThemeDefault.dart';
import 'package:flutter_univ/widgets/WorkPageWidgets/FileContainer.dart';

class DropDownItem extends StatefulWidget {
  const DropDownItem({super.key, this.item, this.isSelect = false});

  final ModelData? item;
  final bool isSelect;

  @override
  State<DropDownItem> createState() => _DropDownItemState();
}

class _DropDownItemState extends State<DropDownItem> {
  bool _isMove = false;

  void textMove(bool move) {
    setState(() {
      _isMove = move;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.item == null
        ? Container()
        : Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
                color: widget.isSelect
                    ? Colors.blue[600]
                    : appTheme(context).primaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(25))),
            child: Row(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(6),
                    height: double.infinity,
                    decoration: BoxDecoration(
                        color: scoreColor(widget.item?.score),
                        shape: BoxShape.circle),
                    child: Stack(
                      children: [
                        FittedBox(
                          fit: BoxFit.fill,
                          child: Text(
                            widget.item?.score.toString() ?? " ",
                            style: TextStyle(
                                letterSpacing: 3,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 8
                                  ..color = Colors.black,
                                fontSize: 30),
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.fill,
                          child: Text(
                            widget.item?.score.toString() ?? " ",
                            style:
                                const TextStyle(letterSpacing: 3, fontSize: 30),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: MouseRegion(
                    onEnter: (event) {
                      textMove(true);
                    },
                    onExit: (event) {
                      textMove(false);
                    },
                    child: Container(
                        alignment: Alignment.center,
                        height: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextScroll(
                          isMove: _isMove,
                          text: widget.item?.name ?? "",
                        )),
                  ),
                ),
              ],
            ),
          );
  }

  Color scoreColor(double? score) {
    return score != null
        ? score <= 30
            ? const Color.fromARGB(255, 255, 0, 0)
            : score <= 60
                ? const Color.fromARGB(255, 255, 217, 0)
                : const Color.fromARGB(255, 30, 255, 0)
        : const Color.fromARGB(255, 255, 255, 255);
  }
}
