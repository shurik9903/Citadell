import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages/WorkPage.dart';
import '../../theme/AppThemeDefault.dart';

class MDictionary extends StatefulWidget {
  const MDictionary({super.key});

  @override
  State<MDictionary> createState() => _MDictionaryState();
}

class _MDictionaryState extends State<MDictionary> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.95,
      heightFactor: 0.98,
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
        child: FractionallySizedBox(
          heightFactor: 0.96,
          widthFactor: 0.91,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: appTheme(context).primaryColor, width: 10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: appTheme(context).primaryColor, width: 5),
                      ),
                    ),
                    child: const Text(
                      "Словарь",
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    height: double.infinity,
                    width: double.infinity,
                    alignment: Alignment.topLeft,
                    child: RichText(
                      text: TextSpan(
                        children: context.watch<DictioneryText>().dictText,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
