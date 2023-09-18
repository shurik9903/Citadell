import 'package:flutter/material.dart';
import 'package:flutter_univ/theme/AppThemeDefault.dart';
import 'package:flutter_univ/widgets/OptionPageWidgets/ServiceWidgets/ServerWorking.dart';

class SystemSettings extends StatefulWidget {
  const SystemSettings({super.key});

  @override
  State<SystemSettings> createState() => _SystemSettingsState();
}

class _SystemSettingsState extends State<SystemSettings> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: appTheme(context).tertiaryColor,
      child: const SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              ServerWorking(),
            ],
          )),
    );
  }
}
