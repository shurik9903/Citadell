import 'package:flutter/material.dart';
import 'package:flutter_univ/theme/AppThemeDefault.dart';
import 'package:flutter_univ/widgets/OptionPageWidgets/ServiceWidgets/DictionaryWorking.dart';
import 'package:flutter_univ/widgets/OptionPageWidgets/ServiceWidgets/ModelWorking.dart';

class ServiceSettings extends StatefulWidget {
  const ServiceSettings({super.key});

  @override
  State<ServiceSettings> createState() => _ServiceSettingsState();
}

class _ServiceSettingsState extends State<ServiceSettings> {
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
              ModelWorking(),
              DictionaryWorking(),
            ],
          )),
    );
  }
}
