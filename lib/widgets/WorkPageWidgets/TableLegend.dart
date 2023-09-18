import 'package:flutter/material.dart';
import 'package:flutter_univ/main.dart';
import 'package:provider/provider.dart';

import '../../theme/AppThemeDefault.dart';

class TableLegend extends StatefulWidget {
  const TableLegend({super.key});

  @override
  State<TableLegend> createState() => _TableLegendState();
}

class _TableLegendState extends State<TableLegend> {
  bool _show = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> legend = context.watch<TableOption>().typeRow.entries.map((e) {
      return Container(
        decoration: BoxDecoration(
            color: appTheme(context).tertiaryColor,
            border: Border.all(color: appTheme(context).accentColor, width: 3)),
        margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
        padding: const EdgeInsets.all(5),
        width: double.infinity,
        height: 50,
        child: Row(
          children: [
            Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                  color: e.value.color,
                  border: Border.all(
                      color: appTheme(context).accentColor, width: 2)),
              margin: const EdgeInsets.only(right: 10),
            ),
            Text(e.value.name)
          ],
        ),
      );
    }).toList();

    Widget buttonLegend = Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: appTheme(context).secondaryColor,
          border: Border.all(color: appTheme(context).accentColor)),
      child: IconButton(
          onPressed: () {
            setState(() {
              _show = !_show;
            });
          },
          icon: const Icon(Icons.question_mark)),
    );

    return _show
        ? ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: 100,
                maxHeight: MediaQuery.of(context).size.height * 0.5),
            child: FractionallySizedBox(
              widthFactor: 0.15,
              // heightFactor: 0.5,
              child: Container(
                decoration: BoxDecoration(
                    color: appTheme(context).secondaryColor,
                    border: Border.all(color: appTheme(context).accentColor)),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(children: [
                          ...legend,
                        ])),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [buttonLegend],
                    ),
                  ],
                ),
              ),
            ),
          )
        : buttonLegend;
  }
}
