import 'package:flutter/material.dart';
import 'package:flutter_univ/theme/AppThemeDefault.dart';
import 'package:flutter_univ/widgets/DialogWindowWidgets/FileWidgets/ContainerStyle.dart';
import 'package:flutter_univ/widgets/OptionPageWidgets/ServiceWidgets/ModelEdit.dart';

class ModelWorking extends StatefulWidget {
  const ModelWorking({super.key});

  @override
  State<ModelWorking> createState() => _ModelWorkingState();
}

class _ModelWorkingState extends State<ModelWorking> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: appTheme(context).secondaryColor,
      width: double.infinity,
      child: ContainerStyle(
        bottom: true,
        text: 'Модель',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              decoration:
                  BoxDecoration(color: appTheme(context).secondaryColor),
              padding: const EdgeInsets.all(10),
              child: const FractionallySizedBox(
                widthFactor: 0.25,
                child: ModelEdit(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
