import 'package:flutter/material.dart';
import 'package:flutter_univ/theme/AppThemeDefault.dart';
import 'package:flutter_univ/widgets/DialogWindowWidgets/FileWidgets/ContainerStyle.dart';
import 'package:flutter_univ/widgets/OptionPageWidgets/SystemWidgets/ServerAddressOption.dart';

class ServerWorking extends StatefulWidget {
  const ServerWorking({super.key});

  @override
  State<ServerWorking> createState() => _ServerWorkingState();
}

class _ServerWorkingState extends State<ServerWorking> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: appTheme(context).secondaryColor,
      width: double.infinity,
      child: const ContainerStyle(
        bottom: true,
        text: 'Настройки сервера',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ServerAddressOption(),
          ],
        ),
      ),
    );
  }
}
