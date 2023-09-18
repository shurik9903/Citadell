import 'package:flutter/material.dart';
import 'package:flutter_univ/theme/AppThemeDefault.dart';

class ContainerStyle extends StatefulWidget {
  const ContainerStyle(
      {super.key,
      this.child,
      this.text = '',
      this.bottom = false,
      this.borderColor,
      this.color});

  final String? text;
  final Widget? child;
  final bool bottom;
  final Color? borderColor;
  final Color? color;

  @override
  State<ContainerStyle> createState() => _ContainerStyleState();
}

class _ContainerStyleState extends State<ContainerStyle> {
  late Color borderColor;
  late Color color;

  @override
  Widget build(BuildContext context) {
    borderColor = widget.borderColor ?? appTheme(context).tertiaryColor;
    color = widget.color ?? appTheme(context).secondaryColor;

    final border = widget.bottom
        ? Border(
            top: BorderSide(color: borderColor, width: 1),
            bottom: BorderSide(color: borderColor, width: 1))
        : Border(
            top: BorderSide(color: borderColor, width: 1),
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
          child: widget.text != null
              ? Container(
                  padding: const EdgeInsets.only(bottom: 1, left: 5, right: 5),
                  color: color,
                  child: Text(
                    widget.text!,
                    style: const TextStyle(fontSize: 14),
                  ),
                )
              : const SizedBox(),
        ),
      ],
    );
  }
}
