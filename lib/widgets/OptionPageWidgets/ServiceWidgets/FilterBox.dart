import 'package:flutter/material.dart';
import 'package:flutter_univ/theme/AppThemeDefault.dart';
import 'package:flutter_univ/widgets/DialogWindowWidgets/FileWidgets/ContainerStyle.dart';
import 'package:flutter_univ/widgets/OptionPageWidgets/ServiceWidgets/DictionaryWorking.dart';
import 'package:flutter_univ/widgets/OptionPageWidgets/ServiceWidgets/WordColumn.dart';
import 'package:provider/provider.dart';

class FilterBox extends StatefulWidget {
  const FilterBox({super.key});

  @override
  State<FilterBox> createState() => _FilterBoxState();
}

class _FilterBoxState extends State<FilterBox> {
  Map<EnumTypesWord, TypeWord> typesWord = {
    EnumTypesWord.action: TypeWord(
        text: 'Действие',
        active: true,
        color: {true: Colors.red[600], false: Colors.red[200]}),
    EnumTypesWord.object: TypeWord(
        text: 'Объект',
        active: true,
        color: {true: Colors.blue[600], false: Colors.blue[200]}),
    EnumTypesWord.character: TypeWord(
        text: 'Характеристика',
        active: true,
        color: {true: Colors.orange[600], false: Colors.orange[200]}),
  };

  Map<EnumTypesDictionary, TypeWord> typesDictionary = {
    EnumTypesDictionary.all: TypeWord(
      text: 'Все',
      active: true,
    ),
    EnumTypesDictionary.basic: TypeWord(
      text: 'Основные',
      active: false,
    ),
    EnumTypesDictionary.additional: TypeWord(
      text: 'Схожие',
      active: false,
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: appTheme(context).tertiaryColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: Column(
        children: [
          ContainerStyle(
            borderColor: appTheme(context).accentColor,
            color: appTheme(context).tertiaryColor,
            text: 'Тип слова',
            child: Align(
              alignment: Alignment.center,
              child: ScrollConfiguration(
                behavior: MyCustomScrollBehavior(),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: SizedBox(
                      height: 35,
                      child: ToggleButtons(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        isSelected: typesWord.entries.map((e) {
                          return e.value.active;
                        }).toList(),
                        onPressed: (index) {
                          setState(() {
                            typesWord.values.toList()[index].active =
                                !typesWord.values.toList()[index].active;
                          });

                          Map<EnumFilterWord, bool> activeFilter =
                              context.read<DictionaryOption>().activeFilter;

                          activeFilter[EnumFilterWord.action] =
                              typesWord[EnumTypesWord.action]!.active;

                          activeFilter[EnumFilterWord.object] =
                              typesWord[EnumTypesWord.object]!.active;

                          activeFilter[EnumFilterWord.character] =
                              typesWord[EnumTypesWord.character]!.active;

                          // context.read<DictionaryOption>().typesWord = typesWord.map(
                          //   (key, value) {
                          //     return MapEntry(key, value.active);
                          //   },
                          // );
                          context.read<DictionaryOption>().activeFilter =
                              activeFilter;
                        },
                        children: [
                          ...typesWord.entries.map((e) {
                            return Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              // width: 110,
                              alignment: Alignment.center,
                              height: double.infinity,
                              color: e.value.color?[e.value.active],
                              child: Text(e.value.text,
                                  style: TextStyle(
                                      color: (e.value.active)
                                          ? Colors.white
                                          : Colors.black)),
                            );
                          }).toList()
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          ContainerStyle(
            bottom: true,
            text: 'Тип словаря',
            borderColor: appTheme(context).accentColor,
            color: appTheme(context).tertiaryColor,
            child: Align(
              alignment: Alignment.center,
              child: ScrollConfiguration(
                behavior: MyCustomScrollBehavior(),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: SizedBox(
                      height: 35,
                      child: ToggleButtons(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        isSelected: typesDictionary.entries.map((e) {
                          return e.value.active;
                        }).toList(),
                        onPressed: (index) {
                          setState(() {
                            for (var element in typesDictionary.values) {
                              element.active = false;
                            }
                            typesDictionary.values.toList()[index].active =
                                true;
                          });
                          context.read<DictionaryOption>().typesDictionary =
                              typesDictionary.keys.toList()[index];
                        },
                        children: [
                          ...typesDictionary.entries.map((e) {
                            return Container(
                              // width: 110,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              alignment: Alignment.center,
                              height: double.infinity,
                              // color: e.value.color[e.value.active],
                              color: e.value.active
                                  ? Colors.white
                                  : Colors.grey[800],
                              child: Text(e.value.text,
                                  style: TextStyle(
                                      color: e.value.active
                                          ? Colors.black
                                          : Colors.white70)),
                            );
                          }).toList()
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
