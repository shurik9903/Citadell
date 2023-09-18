import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_univ/data/SimpleWordData.dart';
import 'package:flutter_univ/data/SpellingWordData.dart';
import 'package:flutter_univ/modules/DictionaryFetch.dart';
import 'package:flutter_univ/theme/AppThemeDefault.dart';
import 'package:flutter_univ/widgets/DialogWindowWidgets/FileWidgets/ContainerStyle.dart';
import 'package:flutter_univ/widgets/OptionPageWidgets/ServiceWidgets/DictionarySidebar.dart';
import 'package:flutter_univ/widgets/OptionPageWidgets/ServiceWidgets/DictionaryWordView.dart';
import 'package:provider/provider.dart';

class TypeWord {
  String text;
  bool active;
  Map<bool, Color?>? color;

  TypeWord({required this.text, required this.active, this.color});
}

class BasicWord {
  int? id;
  int? simpleID;
  EnumTypesWord type;
  String word;
  bool simple;
  String description;
  bool active;

  BasicWord({
    this.id,
    this.simpleID,
    required this.type,
    required this.word,
    this.simple = false,
    this.description = '',
    this.active = false,
  });

  Color? typeColor() {
    if (type == EnumTypesWord.action) {
      return Colors.red[600];
    }

    if (type == EnumTypesWord.object) {
      return Colors.blue[600];
    }

    if (type == EnumTypesWord.character) {
      return Colors.orange[600];
    }

    return null;
  }
}

enum EnumFilterWord {
  action,
  object,
  character,
  basic,
  additional,
  find,
}

class DictionaryOption extends ChangeNotifier {
  EnumTypesDictionary _typesDictionary = EnumTypesDictionary.all;

  // Map<EnumTypesWord, bool> _typesWord = {
  //   EnumTypesWord.object: true,
  //   EnumTypesWord.action: true,
  //   EnumTypesWord.character: true
  // };

  List<SimpleWordData> _simpleWords = [];
  List<SpellingWordData> _spellingWords = [];

  List<BasicWord> _viewWords = [];
  List<BasicWord> _allWords = [];

  BasicWord? _selectWord;

  String _charMove = '';

  String _findFilter = '';

  Map<EnumFilterWord, bool> _activeFilter = {
    EnumFilterWord.action: true,
    EnumFilterWord.object: true,
    EnumFilterWord.character: true,
    EnumFilterWord.basic: true,
    EnumFilterWord.additional: true,
  };

  updateFetchWords() async {
    List<SimpleWordData> simpleWords = await getAllSimpleWordFetch();
    List<SpellingWordData> spellingWords = await getAllSpellingWordFetch();

    this.simpleWords = simpleWords;
    this.spellingWords = spellingWords;

    updateDictionary(simpleWords, spellingWords);
  }

  set activeFilter(Map<EnumFilterWord, bool> activeFilter) {
    _activeFilter = activeFilter;
    updateWords();
    notifyListeners();
  }

  Map<EnumFilterWord, bool> get activeFilter => _activeFilter;

  set allWords(List<BasicWord> allWords) {
    _allWords = allWords;
    notifyListeners();
  }

  List<BasicWord> get allWords => _allWords;

  set viewWords(List<BasicWord> viewWords) {
    _viewWords = viewWords;
    notifyListeners();
  }

  List<BasicWord> get viewWords => _viewWords;

  set selectWord(BasicWord? selectWord) {
    _selectWord = selectWord;
    notifyListeners();
  }

  BasicWord? get selectWord => _selectWord;

  set spellingWords(List<SpellingWordData> spellingWords) {
    _spellingWords = spellingWords;
    notifyListeners();
  }

  List<SpellingWordData> get spellingWords => _spellingWords;

  set simpleWords(List<SimpleWordData> simpleWords) {
    _simpleWords = simpleWords;
    notifyListeners();
  }

  List<SimpleWordData> get simpleWords => _simpleWords;

  set charMove(String char) {
    _charMove = char;
    notifyListeners();
  }

  String get charMove => _charMove;

  set findFilter(String find) {
    _findFilter = find;
    updateWords();
    notifyListeners();
  }

  String get findFilter => _findFilter;

  set typesDictionary(EnumTypesDictionary active) {
    _typesDictionary = active;
    dictionaryActiveFilter(_typesDictionary);
    notifyListeners();
  }

  EnumTypesDictionary get typesDictionary => _typesDictionary;

  // set typesWord(Map<EnumTypesWord, bool> typesWord) {
  //   _typesWord = typesWord;

  //   activeFilter[EnumFilterWord.action] = action;
  //   activeFilter[EnumFilterWord.object] = object;
  //   activeFilter[EnumFilterWord.character] = character;

  //   notifyListeners();
  // }

  // Map<EnumTypesWord, bool> get typesWord => _typesWord;

  switchToSimpleWord() {
    if (selectWord == null || selectWord?.simpleID == null) return;

    BasicWord simple =
        allWords.firstWhere((element) => element.id == selectWord!.simpleID);

    simple.active = true;

    allWords.firstWhere((element) => element.id == selectWord!.id).active =
        false;

    selectWord = simple;

    notifyListeners();
  }

  switchToWordID(int wordID) {
    BasicWord word = allWords.firstWhere((element) => element.id == wordID);

    word.active = true;

    if (selectWord != null) {
      allWords.firstWhere((element) => element.id == selectWord!.id).active =
          false;
    }

    selectWord = word;

    notifyListeners();
  }

  updateDictionary(
      List<SimpleWordData> simple, List<SpellingWordData> spelling) {
    List<SimpleWordData> simpleWords = simple; //await getAllSimpleWordFetch();
    List<SpellingWordData> spellingWords =
        spelling; //await getAllSpellingWordFetch();

    allWords = spellingWords.map((e) {
      SimpleWordData simpleWord =
          simpleWords.firstWhere((element) => element.id == e.simpleID);

      return BasicWord(
        simpleID: e.simpleID,
        id: e.id,
        type: EnumTypesWord.values[simpleWord.typeID - 1],
        word: e.word,
        simple: simpleWord.word == e.word,
        description: e.description,
      );
    }).toList();

    BasicWord? activeWord =
        allWords.firstWhereOrNull((element) => element.id == _selectWord?.id);

    activeWord?.active = true;

    if (_selectWord != null) {
      _selectWord = activeWord;
    }

    updateWords();
  }

  // actionActiveFilter(bool action) {
  //   activeFilter[EnumFilterWord.action] = action;
  //   updateWords();
  // }

  // objectActiveFilter(bool object) {
  //   activeFilter[EnumFilterWord.object] = object;
  //   updateWords();
  // }

  // characterActiveFilter(bool character) {
  //   setState(() {
  //     activeFilter[EnumFilterWord.character] = character;
  //   });
  //   updateWords();
  // }

  dictionaryActiveFilter(EnumTypesDictionary type) {
    if (type == EnumTypesDictionary.all) {
      activeFilter[EnumFilterWord.basic] = true;
      activeFilter[EnumFilterWord.additional] = true;
    }

    if (type == EnumTypesDictionary.basic) {
      activeFilter[EnumFilterWord.basic] = true;
      activeFilter[EnumFilterWord.additional] = false;
    }

    if (type == EnumTypesDictionary.additional) {
      activeFilter[EnumFilterWord.basic] = false;
      activeFilter[EnumFilterWord.additional] = true;
    }

    updateWords();
  }

  updateWords() {
    _viewWords = List<BasicWord>.from(allWords);

    if (!activeFilter[EnumFilterWord.action]!) {
      _viewWords.removeWhere((element) => element.type == EnumTypesWord.action);
    }

    if (!activeFilter[EnumFilterWord.object]!) {
      _viewWords.removeWhere((element) => element.type == EnumTypesWord.object);
    }

    if (!activeFilter[EnumFilterWord.character]!) {
      _viewWords
          .removeWhere((element) => element.type == EnumTypesWord.character);
    }

    if (!activeFilter[EnumFilterWord.basic]!) {
      _viewWords.removeWhere((element) => element.simple == true);
    }

    if (!activeFilter[EnumFilterWord.additional]!) {
      _viewWords.removeWhere((element) => element.simple == false);
    }

    if (_findFilter.isNotEmpty) {
      _viewWords.removeWhere(
        (element) =>
            !element.word.toUpperCase().contains(_findFilter.toUpperCase()),
      );
    }

    _viewWords.sortBy((element) => element.word);

    viewWords = _viewWords;
  }
}

enum EnumTypesWord { action, object, character }

enum EnumTypesDictionary { all, basic, additional }

class DictionaryWorking extends StatefulWidget {
  const DictionaryWorking({super.key});

  @override
  State<DictionaryWorking> createState() => _DictionaryWorkingState();
}

class _DictionaryWorkingState extends State<DictionaryWorking> {
  final DictionaryOption _dictionaryOption = DictionaryOption();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => _dictionaryOption,
        ),
      ],
      child: Container(
        height: 1300,
        color: appTheme(context).secondaryColor,
        width: double.infinity,
        child: ContainerStyle(
          bottom: true,
          text: 'Словарь',
          child: Container(
            decoration: BoxDecoration(color: appTheme(context).primaryColor),
            padding: const EdgeInsets.all(10),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 1, child: DictionarySidebar()),
                Expanded(flex: 3, child: DictionaryWordView()),
              ],
            ),
          ),
        ),
        // ),
      ),
    );
  }
}
