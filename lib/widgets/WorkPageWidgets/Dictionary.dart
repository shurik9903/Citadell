import 'package:flutter/material.dart';
import 'package:flutter_univ/widgets/OptionPageWidgets/ServiceWidgets/DictionarySidebar.dart';
import 'package:flutter_univ/widgets/OptionPageWidgets/ServiceWidgets/DictionaryWordView.dart';
import 'package:flutter_univ/widgets/OptionPageWidgets/ServiceWidgets/DictionaryWorking.dart';
import 'package:provider/provider.dart';
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
          heightFactor: 0.98,
          widthFactor: 0.97,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: appTheme(context).primaryColor, width: 5)),
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
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                Expanded(
                  flex: 12,
                  child: Container(
                      padding: const EdgeInsets.only(bottom: 10),
                      height: double.infinity,
                      width: double.infinity,
                      child:
                          context.watch<DictionaryOption>().selectWord != null
                              ? const DictionaryWordView(
                                  sidebar: true,
                                )
                              : const DictionarySidebar()),
                  // ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
