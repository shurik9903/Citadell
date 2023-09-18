import 'package:flutter/material.dart';
import 'package:flutter_univ/modules/DictionaryFetch.dart';
import 'package:flutter_univ/theme/AppThemeDefault.dart';
import 'package:flutter_univ/widgets/DialogWindowWidgets/DictionaryWordDialog.dart';
import 'package:flutter_univ/widgets/OptionPageWidgets/ServiceWidgets/DictionarySidebar.dart';
import 'package:flutter_univ/widgets/OptionPageWidgets/ServiceWidgets/DictionaryWorking.dart';
import 'package:provider/provider.dart';

class AlphabetData {
  bool active;
  Map<bool, Color?> color = {true: Colors.orange, false: null};

  AlphabetData({this.active = false});
}

class AlphabetColumn extends StatefulWidget {
  const AlphabetColumn({super.key});

  @override
  State<AlphabetColumn> createState() => _AlphabetColumnState();
}

class _AlphabetColumnState extends State<AlphabetColumn> {
  bool _languageSwitch = true;

  Map<String, AlphabetData> rusAlphabet = {
    'А': AlphabetData(),
    'Б': AlphabetData(),
    'В': AlphabetData(),
    'Г': AlphabetData(),
    'Д': AlphabetData(),
    'Е': AlphabetData(),
    'Ё': AlphabetData(),
    'Ж': AlphabetData(),
    'З': AlphabetData(),
    'И': AlphabetData(),
    'Й': AlphabetData(),
    'К': AlphabetData(),
    'Л': AlphabetData(),
    'М': AlphabetData(),
    'Н': AlphabetData(),
    'О': AlphabetData(),
    'П': AlphabetData(),
    'Р': AlphabetData(),
    'С': AlphabetData(),
    'Т': AlphabetData(),
    'У': AlphabetData(),
    'Ф': AlphabetData(),
    'Х': AlphabetData(),
    'Ц': AlphabetData(),
    'Ч': AlphabetData(),
    'Ш': AlphabetData(),
    'Щ': AlphabetData(),
    'Ъ': AlphabetData(),
    'Ы': AlphabetData(),
    'Ь': AlphabetData(),
    'Э': AlphabetData(),
    'Ю': AlphabetData(),
    'Я': AlphabetData(),
  };

  Map<String, AlphabetData> engAlphaber = {
    'A': AlphabetData(),
    'B': AlphabetData(),
    'C': AlphabetData(),
    'D': AlphabetData(),
    'E': AlphabetData(),
    'F': AlphabetData(),
    'G': AlphabetData(),
    'H': AlphabetData(),
    'I': AlphabetData(),
    'J': AlphabetData(),
    'K': AlphabetData(),
    'L': AlphabetData(),
    'M': AlphabetData(),
    'N': AlphabetData(),
    'O': AlphabetData(),
    'P': AlphabetData(),
    'Q': AlphabetData(),
    'R': AlphabetData(),
    'S': AlphabetData(),
    'T': AlphabetData(),
    'U': AlphabetData(),
    'V': AlphabetData(),
    'W': AlphabetData(),
    'X': AlphabetData(),
    'Y': AlphabetData(),
    'Z': AlphabetData(),
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
              color: appTheme(context).tertiaryColor,
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(10),
              )),
          child: IconButton(
            onPressed: () {
              showDictionaryWordDialogWindow(context).then((value) async {
                if (value['select']) {
                  value = value['data'];

                  if (value['dictionary'] == EnumTypesDictionary.basic) {
                    addSimpleWordFetch(
                            word: value['word'],
                            typeID: value['typeID'],
                            description: value['description'])
                        .then((value) {
                      context.read<DictionaryOption>().updateFetchWords();
                    }).catchError((e) {
                      print(e.toString());
                    });
                  }

                  if (value['dictionary'] == EnumTypesDictionary.additional) {
                    addSpellingWordFetch(
                            word: value['word'],
                            simpleID: value['simpleID'],
                            description: value['description'])
                        .then((value) {
                      context.read<DictionaryOption>().updateFetchWords();
                    }).catchError((e) {
                      print(e.toString());
                    });
                  }
                }
              });
            },
            icon: const Icon(Icons.add),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
              color: appTheme(context).tertiaryColor,
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(10),
              )),
          child: IconButton(
            onPressed: () {
              setState(() {
                for (var element
                    in (_languageSwitch ? rusAlphabet : engAlphaber).entries) {
                  element.value.active = false;
                }
                _languageSwitch = !_languageSwitch;
              });
            },
            icon: const Icon(Icons.language),
          ),
        ),
        const SizedBox(height: 5),
        ...(_languageSwitch ? rusAlphabet : engAlphaber).entries.map((element) {
          return GestureDetector(
            onTap: () {
              setState(() {
                bool active = !element.value.active;

                for (var element
                    in (_languageSwitch ? rusAlphabet : engAlphaber).entries) {
                  element.value.active = false;
                }

                element.value.active = active;
                if (active) {
                  context.read<DictionaryOption>().charMove = element.key;
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: element.value.color[element.value.active],
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(10))),
              alignment: Alignment.centerRight,
              child: Text(element.key),
            ),
          );
        }).toList()
      ],
    );
  }
}
