import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_univ/theme/AppThemeDefault.dart';
import 'package:flutter_univ/widgets/OptionPageWidgets/ServiceWidgets/DictionaryWorking.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class WordColumn extends StatefulWidget {
  const WordColumn({super.key});

  @override
  State<WordColumn> createState() => _WordColumnState();
}

class _WordColumnState extends State<WordColumn> with TickerProviderStateMixin {
  // List<BasicWord> allWords = [];

  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  // String _find = '';

  late AnimationController _topAnimationController;
  late AnimationController _bottomAnimationController;
  late Animation<double> _topOpacityAnimation;
  late Animation<double> _bottomOpacityAnimation;

  // List<BasicWord> _viewWords = [];

  @override
  void initState() {
    super.initState();
    // updateDictionary();

    context.read<DictionaryOption>().updateFetchWords();

    _topAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _bottomAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _topOpacityAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 40.0, end: 120.0), weight: 1),
    ]).animate(_topAnimationController);

    _bottomOpacityAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 40.0, end: 120.0), weight: 1),
    ]).animate(_bottomAnimationController);

    _itemPositionsListener.itemPositions.addListener(() {
      ItemPosition? first =
          _itemPositionsListener.itemPositions.value.firstOrNull;
      ItemPosition? last =
          _itemPositionsListener.itemPositions.value.lastOrNull;

      if (first != null && last != null) {
        if (first.index <= 1) {
          _topAnimationController.reverse();
        } else {
          _topAnimationController.forward();
        }

        if (last.index >=
            context.read<DictionaryOption>().viewWords.length - 1) {
          _bottomAnimationController.reverse();
        } else {
          _bottomAnimationController.forward();
        }
      } else {
        _topAnimationController.reverse();
        _bottomAnimationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // _viewWords = context.select((DictionaryOption select) => select.viewWords);

    // updateDictionary(context.watch<DictionaryOption>().simpleWords,
    //     context.watch<DictionaryOption>().spellingWords);

    // scrollToChar(context.watch<DictionaryOption>().charMove);

    // actionActiveFilter(
    //     context.watch<DictionaryOption>().typesWord[EnumTypesWord.action]!);

    // objectActiveFilter(
    //     context.watch<DictionaryOption>().typesWord[EnumTypesWord.object]!);

    // characterActiveFilter(
    //     context.watch<DictionaryOption>().typesWord[EnumTypesWord.character]!);

    // dictionaryActiveFilter(context.watch<DictionaryOption>().typesDictionary);

    // findFilter(context.watch<DictionaryOption>().findFilter);

    // updateDictionary(
    //     context.select((DictionaryOption select) => select.simpleWords),
    //     context.select((DictionaryOption select) => select.spellingWords));

    // scrollToChar(context.select((DictionaryOption select) => select.charMove));

    // actionActiveFilter(context.select(
    //     (DictionaryOption select) => select.typesWord[EnumTypesWord.action]!));

    // objectActiveFilter(context.select(
    //     (DictionaryOption select) => select.typesWord[EnumTypesWord.object]!));

    // characterActiveFilter(context.select((DictionaryOption select) =>
    //     select.typesWord[EnumTypesWord.character]!));

    // dictionaryActiveFilter(
    //     context.select((DictionaryOption select) => select.typesDictionary));

    // findFilter(context.select((DictionaryOption select) => select.findFilter));

    // List<BasicWord> viewWords =
    //     context.select((DictionaryOption option) => option.viewWords);

    // List<BasicWord> viewWords =
    //     context.select((DictionaryOption option) => option.viewWords);

    List<BasicWord> viewWords = context.watch<DictionaryOption>().viewWords;

    scrollToChar(context.select((DictionaryOption option) => option.charMove),
        context.select((DictionaryOption option) => option.viewWords));

    return Stack(
      children: [
        StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
              margin: const EdgeInsets.only(left: 5),
              child: ScrollConfiguration(
                behavior: MyCustomScrollBehavior(),
                child: ScrollablePositionedList.builder(
                  // addAutomaticKeepAlives: true,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: viewWords.length,
                  itemScrollController: _itemScrollController,
                  itemPositionsListener: _itemPositionsListener,
                  itemBuilder: (context, index) {
                    BasicWord word = viewWords[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      padding: const EdgeInsets.all(2),
                      height: 50,
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: word.typeColor(),
                              borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(5),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                context
                                    .read<DictionaryOption>()
                                    .switchToWordID(word.id!);
                                // bool active = word.active;

                                // setState(() {
                                //   for (var element in viewWords) {
                                //     element.active = false;
                                //   }

                                //   word.active = !active;

                                //   if (word.active) {
                                //     context
                                //         .read<DictionaryOption>()
                                //         .selectWord = word;
                                //   } else {
                                //     context
                                //         .read<DictionaryOption>()
                                //         .selectWord = null;
                                //   }
                                // });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: word.active
                                        ? Colors.amber[800]
                                        : appTheme(context).tertiaryColor,
                                    borderRadius: const BorderRadius.horizontal(
                                        right: Radius.circular(10))),
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Text(
                                      word.word,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    const Spacer(),
                                    if (word.simple) const Icon(Icons.star)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
        Align(
          alignment: Alignment.topCenter,
          child: AnimatedBuilder(
            animation: _topAnimationController,
            builder: (context, child) {
              return Container(
                height: _topOpacityAnimation.value,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      appTheme(context).secondaryColor,
                      appTheme(context).secondaryColor,
                      appTheme(context).secondaryColor.withOpacity(0.8),
                      appTheme(context).secondaryColor.withOpacity(0)
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedBuilder(
            animation: _bottomAnimationController,
            builder: (context, child) {
              return Container(
                height: _bottomOpacityAnimation.value,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      appTheme(context).secondaryColor,
                      appTheme(context).secondaryColor,
                      appTheme(context).secondaryColor.withOpacity(0.8),
                      appTheme(context).secondaryColor.withOpacity(0)
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  scrollToChar(String char, List<BasicWord> viewWords) {
    int index = viewWords.indexWhere(
        (element) => element.word.toUpperCase().startsWith(char.toUpperCase()));

    if (index >= 0 && char.isNotEmpty) {
      _itemScrollController.scrollTo(
          index: index,
          duration: const Duration(seconds: 1),
          alignment: 0.1,
          curve: Curves.easeOut);
    }
  }
}

// class ScrollWordItems extends StatefulWidget {
//   const ScrollWordItems(
//       {super.key,
//       required this.viewWords,
//       required this.scrollController,
//       required this.positionsListener});

//   final List<BasicWord> viewWords;
//   final ItemScrollController scrollController;
//   final ItemPositionsListener positionsListener;

//   @override
//   State<ScrollWordItems> createState() => _ScrollWordItemsState();
// }

// class _ScrollWordItemsState extends State<ScrollWordItems> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
//       margin: const EdgeInsets.only(left: 5),
//       child: ScrollConfiguration(
//         behavior: MyCustomScrollBehavior(),
//         child: ScrollablePositionedList.builder(
//           // addAutomaticKeepAlives: true,
//           physics: const BouncingScrollPhysics(),
//           scrollDirection: Axis.vertical,
//           shrinkWrap: true,
//           itemCount: widget.viewWords.length,
//           itemScrollController: widget.scrollController,
//           itemPositionsListener: widget.positionsListener,
//           itemBuilder: (context, index) {
//             BasicWord word = widget.viewWords[index];
//             return Container(
//               margin: const EdgeInsets.symmetric(vertical: 2),
//               padding: const EdgeInsets.all(2),
//               height: 50,
//               child: Row(
//                 children: [
//                   Container(
//                     width: 8,
//                     height: double.infinity,
//                     decoration: BoxDecoration(
//                       color: word.typeColor(),
//                       borderRadius: const BorderRadius.all(
//                         Radius.circular(5),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () {},
//                       child: Container(
//                         decoration: BoxDecoration(
//                             color: word.active
//                                 ? Colors.amber[800]
//                                 : appTheme(context).tertiaryColor,
//                             borderRadius: const BorderRadius.horizontal(
//                                 right: Radius.circular(10))),
//                         alignment: Alignment.center,
//                         padding: const EdgeInsets.all(10),
//                         child: Row(
//                           children: [
//                             Text(
//                               word.word,
//                               style: const TextStyle(fontSize: 20),
//                             ),
//                             const Spacer(),
//                             if (word.simple) const Icon(Icons.star)
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
