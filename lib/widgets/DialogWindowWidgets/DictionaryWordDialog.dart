import 'package:flutter/material.dart';
import 'package:flutter_univ/data/SimpleWordData.dart';
import 'package:flutter_univ/modules/DictionaryFetch.dart';
import 'package:flutter_univ/theme/AppThemeDefault.dart';
import 'package:flutter_univ/widgets/DialogWindowWidgets/FileWidgets/ContainerStyle.dart';
import 'package:flutter_univ/widgets/OptionPageWidgets/ServiceWidgets/DictionaryWorking.dart';

class DictionaryWord extends StatefulWidget {
  const DictionaryWord({super.key});

  @override
  State<DictionaryWord> createState() => _DictionaryWordState();
}

class _DictionaryWordState extends State<DictionaryWord> {
  String _find = '';

  BasicWord? _selectWord;
  bool _isSelectWord = false;

  Map<EnumTypesWord, TypeWord> typesWord = {
    EnumTypesWord.action: TypeWord(
        text: 'Действие',
        active: true,
        color: {true: Colors.red[600], false: Colors.red[200]}),
    EnumTypesWord.object: TypeWord(
        text: 'Объект',
        active: false,
        color: {true: Colors.blue[600], false: Colors.blue[200]}),
    EnumTypesWord.character: TypeWord(
        text: 'Характеристика',
        active: false,
        color: {true: Colors.orange[600], false: Colors.orange[200]}),
  };

  Map<EnumTypesDictionary, TypeWord> typesDictionary = {
    EnumTypesDictionary.basic: TypeWord(
        text: 'Основные',
        active: true,
        color: {true: Colors.white, false: Colors.grey[800]}),
    EnumTypesDictionary.additional: TypeWord(
        text: 'Схожие',
        active: false,
        color: {true: Colors.white, false: Colors.grey[800]}),
  };

  bool _validate = false;
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _findcontroller = TextEditingController();

  List<BasicWord> simpleWords = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      () async {
        List<SimpleWordData> allWords = await getAllSimpleWordFetch();
        simpleWords = allWords
            .map((e) => BasicWord(
                word: e.word,
                id: e.id,
                type: EnumTypesWord.values[e.typeID - 1]))
            .toList();
      }();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                color: appTheme(context).primaryColor,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        onTap: () {
                          setState(() {
                            _validate = false;
                          });
                        },
                        maxLines: 1,
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Введите слово для добавления в словарь',
                          errorText: _validate
                              ? 'Значение не может быть пустым'
                              : null,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        minLines: 4,
                        maxLines: 4,
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Введите описание слова',
                        ),
                      ),
                    ),
                    ContainerStyle(
                      bottom: false,
                      text: 'Тип словаря',
                      borderColor: appTheme(context).accentColor,
                      color: appTheme(context).primaryColor,
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
                            },
                            children: [
                              ...typesDictionary.entries.map((e) {
                                return Container(
                                  width: 110,
                                  alignment: Alignment.center,
                                  height: double.infinity,
                                  // color: e.value.color?[e.value.active],
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
                    if (!typesDictionary[EnumTypesDictionary.additional]!
                        .active)
                      ContainerStyle(
                        borderColor: appTheme(context).accentColor,
                        color: appTheme(context).primaryColor,
                        text: 'Тип слова',
                        child: TypeWordSingleSelect(typesWord: typesWord),
                      ),
                    if (typesDictionary[EnumTypesDictionary.additional]!.active)
                      ContainerStyle(
                        bottom: false,
                        text: 'Основное слово',
                        borderColor: appTheme(context).accentColor,
                        color: appTheme(context).primaryColor,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    maxLines: 1,
                                    controller: _findcontroller,
                                    decoration: const InputDecoration(
                                      labelText: 'Введите слово для поиска',
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: appTheme(context).primaryColor,
                                      shape: BoxShape.circle),
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _find = _findcontroller.text;
                                      });
                                    },
                                    icon: const Icon(Icons.search),
                                  ),
                                )
                              ],
                            ),
                            if (_isSelectWord)
                              Text(
                                'Выберите основное слово',
                                style: TextStyle(color: Colors.red[700]),
                              ),
                            const SizedBox(
                              height: 10,
                            ),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxHeight: 300),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: simpleWords
                                      .where((element) =>
                                          element.word
                                              .toUpperCase()
                                              .contains(_find.toUpperCase()) ||
                                          _find.isEmpty)
                                      .map(
                                    (e) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            for (var element in simpleWords) {
                                              element.active = false;
                                            }
                                            e.active = true;
                                            _selectWord = e;
                                            _isSelectWord = false;
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 8,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  color: e.typeColor(),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(5))),
                                            ),
                                            Expanded(
                                              child: Container(
                                                alignment: Alignment.center,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5),
                                                padding:
                                                    const EdgeInsets.all(5),
                                                height: 40,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius
                                                                .horizontal(
                                                            right:
                                                                Radius.circular(
                                                                    10)),
                                                    color: e.active
                                                        ? appTheme(context)
                                                            .tertiaryColor
                                                        : appTheme(context)
                                                            .secondaryColor),
                                                child: Text(
                                                  e.word,
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: appTheme(context)
                                                          .textColor1),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: appTheme(context).tertiaryColor,
                        foregroundColor: appTheme(context).textColor1,
                      ),
                      onPressed: () {
                        if (_nameController.text.isEmpty) {
                          setState(() {
                            _validate = true;
                          });
                          return;
                        }

                        if (_selectWord == null &&
                            typesDictionary.entries
                                    .firstWhere(
                                        (element) => element.value.active)
                                    .key ==
                                EnumTypesDictionary.additional) {
                          setState(() {
                            _isSelectWord = true;
                          });
                          return;
                        }

                        Map<String, dynamic> data = {};

                        data['word'] = _nameController.text;

                        data['description'] = _descriptionController.text;

                        data['dictionary'] = typesDictionary.entries
                            .firstWhere((element) => element.value.active)
                            .key;

                        if (typesDictionary.entries
                                .firstWhere((element) => element.value.active)
                                .key ==
                            EnumTypesDictionary.basic) {
                          data['typeID'] = typesWord.entries
                                  .firstWhere((element) => element.value.active)
                                  .key
                                  .index +
                              1;
                        } else {
                          data['simpleID'] = _selectWord?.id;
                        }

                        Navigator.pop(
                          context,
                          {
                            'select': true,
                            'data': data,
                          },
                        );
                      },
                      child: const Text("Принять"),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: appTheme(context).tertiaryColor,
                          foregroundColor: appTheme(context).textColor1,
                        ),
                        onPressed: () {
                          Navigator.pop(context, {'select': false});
                        },
                        child: const Text("Отмена"))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<dynamic> showDictionaryWordDialogWindow(BuildContext context) async {
  return await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return const DictionaryWord();
    },
  );
}

class TypeWordSingleSelect extends StatefulWidget {
  const TypeWordSingleSelect({super.key, required this.typesWord});

  final Map<EnumTypesWord, TypeWord> typesWord;

  @override
  State<TypeWordSingleSelect> createState() => _TypeWordSingleSelectState();
}

class _TypeWordSingleSelectState extends State<TypeWordSingleSelect> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 35,
        child: ToggleButtons(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          isSelected: widget.typesWord.entries.map((e) {
            return e.value.active;
          }).toList(),
          onPressed: (index) {
            setState(() {
              for (var element in widget.typesWord.values) {
                element.active = false;
              }

              widget.typesWord.values.toList()[index].active =
                  !widget.typesWord.values.toList()[index].active;
            });
          },
          children: [
            ...widget.typesWord.entries.map((e) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),

                // width: 110,
                alignment: Alignment.center,
                height: double.infinity,
                color: e.value.color?[e.value.active],
                child: Text(e.value.text,
                    style: TextStyle(
                        color: (e.value.active) ? Colors.white : Colors.black)),
              );
            }).toList()
          ],
        ),
      ),
    );
  }
}
