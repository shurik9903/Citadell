import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../theme/AppThemeDefault.dart';

class MMenuButton extends StatefulWidget {
  const MMenuButton({super.key});

  @override
  State<MMenuButton> createState() => _MMenuButtonState();
}

class _MMenuButtonState extends State<MMenuButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Scaffold.of(context).openEndDrawer();
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: context.watch<ConnectStatus>().status
                ? const Color.fromARGB(133, 9, 255, 0)
                : const Color.fromARGB(162, 255, 30, 0),
            shape: BoxShape.circle),
        child: Container(
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          height: double.infinity,
          margin: const EdgeInsets.all(7.5),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Colors.blue,
                Colors.red,
              ],
            ),
          ),
          child: FittedBox(
            child: Image.asset("lib/images/Coat_Russia.png"),
          ),
        ),
      ),
    );
  }
}
