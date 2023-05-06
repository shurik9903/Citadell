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
            color: appTheme(context).tertiaryColor, shape: BoxShape.circle),
        child: Container(
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          height: double.infinity,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: context.watch<ConnectStatus>().status
                  ? Color.fromARGB(133, 3, 101, 0)
                  : Color.fromARGB(99, 129, 15, 0),
              shape: BoxShape.circle),
          child: FittedBox(
            child: Image.asset("lib/images/Coat_Russia.png"),
          ),
        ),
      ),
    );
  }
}
