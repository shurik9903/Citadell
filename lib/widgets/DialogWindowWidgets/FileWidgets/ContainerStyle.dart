import 'package:flutter/material.dart';
import 'package:flutter_univ/theme/AppThemeDefault.dart';

class ContainerStyle extends StatefulWidget {
  const ContainerStyle({super.key, this.child, this.text, this.bottom});

  final String? text;
  final Widget? child;
  final bool? bottom;

  @override
  State<ContainerStyle> createState() => _ContainerStyleState();
}

class _ContainerStyleState extends State<ContainerStyle> {
  late String? text;
  late bool bottom;

  @override
  void initState() {
    super.initState();
    text = widget.text;
    bottom = widget.bottom ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final border = bottom
        ? Border(
            top: BorderSide(color: appTheme(context).tertiaryColor, width: 1),
            bottom:
                BorderSide(color: appTheme(context).tertiaryColor, width: 1))
        : Border(
            top: BorderSide(color: appTheme(context).tertiaryColor, width: 1),
          );

    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.only(top: 15),
          decoration: BoxDecoration(
            border: border,
          ),
          child: widget.child,
        ),
        Positioned(
          left: 25,
          top: 2,
          child: text != null
              ? Container(
                  padding: const EdgeInsets.only(bottom: 1, left: 5, right: 5),
                  color: appTheme(context).secondaryColor,
                  child: Text(
                    text!,
                    style: const TextStyle(fontSize: 14),
                  ),
                )
              : const SizedBox(),
        ),
      ],
    );
  }
}
