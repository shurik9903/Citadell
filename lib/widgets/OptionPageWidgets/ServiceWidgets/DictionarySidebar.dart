import 'package:flutter/material.dart';
import 'package:flutter_univ/theme/AppThemeDefault.dart';
import 'package:flutter_univ/widgets/OptionPageWidgets/ServiceWidgets/AlphabetColumn.dart';
import 'package:flutter_univ/widgets/OptionPageWidgets/ServiceWidgets/FindField.dart';
import 'package:flutter_univ/widgets/OptionPageWidgets/ServiceWidgets/WordColumn.dart';

class DictionarySidebar extends StatefulWidget {
  const DictionarySidebar({super.key});

  @override
  State<DictionarySidebar> createState() => _DictionarySidebarState();
}

class _DictionarySidebarState extends State<DictionarySidebar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: appTheme(context).secondaryColor),
      child: Column(
        children: [
          Container(
              padding: const EdgeInsets.only(
                  top: 25, left: 15, right: 15, bottom: 5),
              child: const FindField()),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    height: 980,
                    width: double.infinity,
                    padding:
                        const EdgeInsets.only(bottom: 20, right: 15, top: 10),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 40, child: AlphabetColumn()),
                        Expanded(child: WordColumn()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
