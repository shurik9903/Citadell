import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_univ/modules/DictionaryFetch.dart';
import 'package:flutter_univ/theme/AppThemeDefault.dart';
import 'package:flutter_univ/widgets/DialogWindowWidgets/DictionaryWordDialog.dart';
import 'package:flutter_univ/widgets/DialogWindowWidgets/MessageDialog.dart';
import 'package:flutter_univ/widgets/DialogWindowWidgets/OkCancelDialog.dart';
import 'package:flutter_univ/widgets/OptionPageWidgets/ServiceWidgets/DictionaryWorking.dart';
import 'package:provider/provider.dart';

class DictionaryWordView extends StatefulWidget {
  const DictionaryWordView({super.key, this.sidebar = false});

  final bool sidebar;

  @override
  State<DictionaryWordView> createState() => _DictionaryWordViewState();
}

class _DictionaryWordViewState extends State<DictionaryWordView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _edit = false;
  BasicWord? _selectWord;

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

  @override
  Widget build(BuildContext context) {
    _selectWord =
        context.select((DictionaryOption select) => select.selectWord);

    if (_nameController.text != _selectWord?.word) _edit = false;

    _nameController.text = _selectWord?.word ?? '';

    _descriptionController.text = _selectWord?.description ?? '';

    if (_selectWord == null) _edit = false;

    for (var element in typesWord.entries) {
      element.value.active = false;

      if (element.key == _selectWord?.type) {
        element.value.active = true;
      }
    }

    return Container(
      height: double.infinity,
      padding: widget.sidebar
          ? const EdgeInsets.symmetric(horizontal: 20, vertical: 10)
          : const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      decoration: BoxDecoration(
          color: widget.sidebar
              ? appTheme(context).secondaryColor
              : appTheme(context).tertiaryColor),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: _selectWord != null
            ? Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 5,
                                color: widget.sidebar
                                    ? appTheme(context).primaryColor
                                    : appTheme(context).secondaryColor))),
                    child: Column(
                      children: widget.sidebar
                          ? [
                              Row(
                                children: _edit
                                    ? [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 5),
                                          decoration: BoxDecoration(
                                              color: appTheme(context)
                                                  .primaryColor,
                                              shape: BoxShape.circle),
                                          child: IconButton(
                                            icon: const Icon(Icons.save),
                                            onPressed: () {
                                              updatedWord();
                                            },
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          decoration: BoxDecoration(
                                              color: appTheme(context)
                                                  .primaryColor,
                                              shape: BoxShape.circle),
                                          child: IconButton(
                                            icon: const Icon(Icons.cancel),
                                            onPressed: () {
                                              setState(
                                                () {
                                                  _edit = false;
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ]
                                    : [
                                        Container(
                                            margin: const EdgeInsets.only(
                                                right: 10),
                                            decoration: BoxDecoration(
                                                color: appTheme(context)
                                                    .primaryColor,
                                                shape: BoxShape.circle),
                                            child: IconButton(
                                              icon: const Icon(Icons
                                                  .keyboard_backspace_rounded),
                                              onPressed: () {
                                                context
                                                    .read<DictionaryOption>()
                                                    .selectWord = null;
                                              },
                                            )),
                                        Container(
                                            margin: const EdgeInsets.only(
                                                right: 10),
                                            decoration: BoxDecoration(
                                                color: appTheme(context)
                                                    .primaryColor,
                                                shape: BoxShape.circle),
                                            child: IconButton(
                                              icon: const Icon(Icons.edit),
                                              onPressed: () {
                                                setState(() {
                                                  _edit = true;
                                                });
                                              },
                                            )),
                                        Container(
                                            decoration: BoxDecoration(
                                                color: appTheme(context)
                                                    .primaryColor,
                                                shape: BoxShape.circle),
                                            child: IconButton(
                                              icon: const Icon(Icons.delete),
                                              onPressed: () {
                                                deleteWord();
                                              },
                                            )),
                                      ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: _edit
                                    ? [
                                        Expanded(
                                          child: TextField(
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              labelText: 'Введите новое слово',
                                            ),
                                            style:
                                                const TextStyle(fontSize: 30),
                                            controller: _nameController,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ]
                                    : [
                                        Text(
                                          _nameController.text,
                                          style: TextStyle(
                                              fontSize: 30,
                                              color: Colors.amber[800],
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                  mainAxisAlignment: _edit
                                      ? MainAxisAlignment.center
                                      : MainAxisAlignment.start,
                                  children: _edit
                                      ? [
                                          if (_selectWord!.simple)
                                            Align(
                                              child: TypeWordSingleSelect(
                                                  typesWord: typesWord),
                                            )
                                        ]
                                      : [
                                          Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              color: _selectWord?.typeColor(),
                                            ),
                                            child: Text(
                                                typesWord[_selectWord?.type]
                                                        ?.text ??
                                                    '',
                                                style: const TextStyle(
                                                    fontSize: 25)),
                                          ),
                                        ]),
                              Row(
                                children: [
                                  if (!_selectWord!.simple)
                                    Container(
                                      margin: const EdgeInsets.only(top: 20),
                                      child: Row(
                                        children: [
                                          const Text(
                                            'Основное слово ',
                                            style: TextStyle(fontSize: 25),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              context
                                                  .read<DictionaryOption>()
                                                  .switchToSimpleWord();
                                            },
                                            child: Text(
                                              context
                                                  .read<DictionaryOption>()
                                                  .allWords
                                                  .firstWhere((element) =>
                                                      element.simpleID ==
                                                          _selectWord!
                                                              .simpleID &&
                                                      element.simple)
                                                  .word,
                                              // 'test',
                                              style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.amber[800],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                ],
                              )
                            ]
                          : [
                              Row(
                                // direction: Axis.horizontal,
                                children: _edit
                                    ? [
                                        Container(
                                            margin:
                                                const EdgeInsets.only(right: 5),
                                            decoration: BoxDecoration(
                                                color: appTheme(context)
                                                    .primaryColor,
                                                shape: BoxShape.circle),
                                            child: IconButton(
                                              icon: const Icon(Icons.save),
                                              onPressed: () {
                                                updatedWord();
                                              },
                                            )),
                                        Container(
                                            margin: const EdgeInsets.only(
                                                right: 10),
                                            decoration: BoxDecoration(
                                                color: appTheme(context)
                                                    .primaryColor,
                                                shape: BoxShape.circle),
                                            child: IconButton(
                                              icon: const Icon(Icons.cancel),
                                              onPressed: () {
                                                setState(() {
                                                  _edit = false;
                                                });
                                              },
                                            )),
                                        Expanded(
                                          child: TextField(
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              labelText: 'Введите новое слово',
                                            ),
                                            style:
                                                const TextStyle(fontSize: 30),
                                            controller: _nameController,
                                            maxLines: 1,
                                          ),
                                        ),
                                        if (_selectWord!.simple)
                                          TypeWordSingleSelect(
                                              typesWord: typesWord)
                                      ]
                                    : [
                                        Container(
                                            margin: const EdgeInsets.only(
                                                right: 10),
                                            decoration: BoxDecoration(
                                                color: appTheme(context)
                                                    .primaryColor,
                                                shape: BoxShape.circle),
                                            child: IconButton(
                                              icon: const Icon(Icons.edit),
                                              onPressed: () {
                                                setState(() {
                                                  _edit = true;
                                                });
                                              },
                                            )),
                                        Text(
                                          _nameController.text,
                                          style: TextStyle(
                                              fontSize: 30,
                                              color: Colors.amber[800],
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        Container(
                                          padding: const EdgeInsets.all(5),
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                            color: _selectWord?.typeColor(),
                                          ),
                                          child: Text(
                                              typesWord[_selectWord?.type]
                                                      ?.text ??
                                                  '',
                                              style: const TextStyle(
                                                  fontSize: 25)),
                                        ),
                                        Container(
                                            margin:
                                                const EdgeInsets.only(left: 10),
                                            decoration: BoxDecoration(
                                                color: appTheme(context)
                                                    .primaryColor,
                                                shape: BoxShape.circle),
                                            child: IconButton(
                                              icon: const Icon(Icons.delete),
                                              onPressed: () {
                                                deleteWord();
                                              },
                                            )),
                                      ],
                              ),
                              if (!_selectWord!.simple)
                                Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  child: Row(
                                    children: [
                                      const Text(
                                        'Основное слово ',
                                        style: TextStyle(fontSize: 25),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          context
                                              .read<DictionaryOption>()
                                              .switchToSimpleWord();
                                        },
                                        child: Text(
                                          context
                                              .read<DictionaryOption>()
                                              .allWords
                                              .firstWhere((element) =>
                                                  element.simpleID ==
                                                      _selectWord!.simpleID &&
                                                  element.simple)
                                              .word,
                                          // 'test',
                                          style: TextStyle(
                                            fontSize: 25,
                                            color: Colors.amber[800],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                            ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 410,
                    padding: const EdgeInsets.only(bottom: 20, top: 15),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 5,
                                color: widget.sidebar
                                    ? appTheme(context).primaryColor
                                    : appTheme(context).secondaryColor))),
                    child: Column(children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Описание слова',
                          style: TextStyle(fontSize: 40),
                        ),
                      ),
                      _edit
                          ? TextField(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                labelText: 'Введите новое описание слова',
                              ),
                              style: const TextStyle(fontSize: 30),
                              controller: _descriptionController,
                              maxLines: 8,
                            )
                          : Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    _descriptionController.text,
                                    style: const TextStyle(fontSize: 30),
                                  ),
                                ),
                              ),
                            ),
                    ]),
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Схожие слова',
                        style: TextStyle(fontSize: 40),
                      )),
                  // ConstrainedBox(
                  // constraints: const BoxConstraints(maxHeight: 1200),
                  Container(
                    alignment:
                        widget.sidebar ? Alignment.center : Alignment.topLeft,
                    padding: const EdgeInsets.only(bottom: 30),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 5,
                                color: widget.sidebar
                                    ? appTheme(context).primaryColor
                                    : appTheme(context).secondaryColor))),
                    // height: 1200,
                    width: double.infinity,
                    child: SingleChildScrollView(
                        child: Wrap(
                      direction:
                          widget.sidebar ? Axis.horizontal : Axis.horizontal,
                      spacing: 10,
                      runSpacing: 10,
                      children: context
                          .watch<DictionaryOption>()
                          .allWords
                          .where((element) =>
                              element.simpleID == _selectWord?.simpleID &&
                              element.word != _selectWord?.word)
                          .map(
                        (item) {
                          return GestureDetector(
                            onTap: () {
                              context
                                  .read<DictionaryOption>()
                                  .switchToWordID(item.id!);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              width: 400,
                              height: 400,
                              decoration: BoxDecoration(
                                  color: appTheme(context).primaryColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(right: 5),
                                        height: 30,
                                        width: 10,
                                        decoration: BoxDecoration(
                                            color: _selectWord?.typeColor(),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10))),
                                      ),
                                      Text(
                                        item.word,
                                        style: TextStyle(
                                            fontSize: 30,
                                            color: Colors.amber[800],
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: const Text('Описание слова',
                                        style: TextStyle(fontSize: 30)),
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(item.description,
                                        maxLines: 13,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 25)),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    )),
                  ),
                  // )
                ],
              )
            : Container(),
      ),
    );
  }

  updatedWord() {
    String? word =
        _nameController.text != _selectWord?.word ? _nameController.text : null;

    String? description =
        _descriptionController.text == _selectWord?.description
            ? null
            : _descriptionController.text;

    EnumTypesWord? activeType = typesWord.entries
        .firstWhereOrNull((element) => element.value.active == true)
        ?.key;

    if (_selectWord!.simple) {
      int? typeID = activeType != _selectWord?.type
          ? EnumTypesWord.values
                  .indexWhere((element) => element == activeType) +
              1
          : null;

      if (word != null || description != null || typeID != null) {
        updateSimpleWordFetch(
                id: _selectWord!.simpleID!,
                word: word,
                description: description,
                typeID: typeID)
            .then((value) {
          context.read<DictionaryOption>().updateFetchWords();
        }).catchError((e) {
          print(e.toString());
        });
      }
    } else {
      if (word != null || description != null) {
        updateSpellingWordFetch(
          id: _selectWord!.id!,
          word: word,
          description: description,
        ).then((value) {
          context.read<DictionaryOption>().updateFetchWords();
        }).catchError((e) {
          print(e.toString());
        });
      }
    }

    setState(() {
      _edit = false;
    });
  }

  deleteWord() {
    showOkCancelDialogWindow(
            context, 'Вы уверены, что хотите удалить данное слово?')
        .then((value) {
      if (value) {
        if (_selectWord!.simple) {
          deleteSimpleWordFetch(_selectWord!.simpleID!).then((value) {
            context.read<DictionaryOption>().selectWord = null;
            context.read<DictionaryOption>().updateFetchWords();
          }).catchError((e) {
            showMessageDialogWindow(
                context, "Не удалось удалить слово!\nОшибка: $e");
          });
        } else {
          deleteSpellingWordFetch(_selectWord!.id!).then((value) {
            context.read<DictionaryOption>().updateFetchWords();
            context.read<DictionaryOption>().selectWord = null;
          }).catchError((e) {
            showMessageDialogWindow(
                context, "Не удалось удалить слово!\nОшибка: $e");
          });
        }
      }
    });
  }
}
