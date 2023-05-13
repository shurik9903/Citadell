import 'package:flutter/material.dart';
import 'package:flutter_univ/theme/AppThemeDefault.dart';

class ContainerStyle extends StatefulWidget {
  const ContainerStyle({super.key, required this.child, required this.text});

  final String text;
  final Widget child;

  @override
  State<ContainerStyle> createState() => _ContainerStyleState();
}

class _ContainerStyleState extends State<ContainerStyle> {
  late String text;
  late Widget child;

  @override
  void initState() {
    super.initState();

    text = widget.text;
    child = widget.child;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.only(top: 15),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: appTheme(context).tertiaryColor, width: 1),
            ),
          ),
          child: child,
        ),
        Positioned(
          left: 25,
          top: 2,
          child: Container(
            padding: const EdgeInsets.only(bottom: 1, left: 5, right: 5),
            color: appTheme(context).secondaryColor,
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}
