import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages/WorkPage.dart';
import '../../theme/AppThemeDefault.dart';
import 'AnalysisButton.dart';
import 'Dictionary.dart';
import 'MenuButton.dart';
import 'UserPanel.dart';

class MSidebar extends StatefulWidget {
  const MSidebar({super.key});

  @override
  State<MSidebar> createState() => _MSidebarState();
}

class _MSidebarState extends State<MSidebar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: appTheme(context).primaryColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 10,
            child: context.watch<TypeViewMenu>().show
                ? const MUserPanel()
                : const MMenuButton(),
          ),
          Expanded(
            flex: 110,
            child: context.watch<TypeViewMenu>().show
                ? const MDictionary()
                : const SizedBox(),
          ),
          const Expanded(
            flex: 10,
            child: MAnalysisButton(),
          ),
          const Spacer(
            flex: 3,
          )
        ],
      ),
    );
  }
}
