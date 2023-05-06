import 'package:flutter/material.dart';

import '../../data/UserData.dart';
import '../../pages/WorkPage.dart';
import '../../theme/AppThemeDefault.dart';
import 'MenuButton.dart';

class MUserPanel extends StatefulWidget {
  const MUserPanel({super.key});

  @override
  State<MUserPanel> createState() => _MUserPanelState();
}

class _MUserPanelState extends State<MUserPanel> {
  @override
  Widget build(BuildContext context) {
    var userData = UserDataSingleton();

    return FractionallySizedBox(
      widthFactor: 0.95,
      heightFactor: 0.95,
      child: Container(
        decoration: BoxDecoration(
          color: appTheme(context).secondaryColor,
          border: Border.all(
            color: appTheme(context).accentColor,
            width: 5,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 7,
              child: Container(
                margin: const EdgeInsets.only(left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      userData.login,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
            const Expanded(
              flex: 3,
              child: MMenuButton(),
            ),
          ],
        ),
      ),
    );
  }
}
