import 'package:flutter/material.dart';
import 'package:flutter_univ/theme/AppThemeDefault.dart';
import 'package:flutter_univ/widgets/OptionPageWidgets/ServiceWidgets/DictionarySidebar.dart';
import 'package:flutter_univ/widgets/OptionPageWidgets/ServiceWidgets/DictionaryWorking.dart';
import 'package:flutter_univ/widgets/OptionPageWidgets/ServiceWidgets/FilterBox.dart';
import 'package:provider/provider.dart';

class FindField extends StatefulWidget {
  const FindField({super.key});

  @override
  State<FindField> createState() => _FindFieldState();
}

class _FindFieldState extends State<FindField> {
  final TextEditingController _findController = TextEditingController();

  bool _filterView = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: appTheme(context).tertiaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(5))),
          child: Row(
            children: [
              Expanded(
                  child: Container(
                padding: const EdgeInsets.only(left: 5, right: 10),
                child: TextField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(bottom: 10),
                    labelText: 'Введите слово для поиска в словаре',
                  ),
                  style: const TextStyle(fontSize: 15),
                  controller: _findController,
                  maxLines: 1,
                ),
              )),
              Container(
                decoration: BoxDecoration(
                    color: appTheme(context).primaryColor,
                    shape: BoxShape.circle),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _filterView = !_filterView;
                    });
                  },
                  icon: const Icon(Icons.filter_alt_outlined),
                ),
              ),
              const SizedBox(width: 5),
              Container(
                decoration: BoxDecoration(
                    color: appTheme(context).primaryColor,
                    shape: BoxShape.circle),
                child: IconButton(
                  onPressed: () {
                    context.read<DictionaryOption>().findFilter =
                        _findController.text;
                  },
                  icon: const Icon(Icons.search),
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        if (_filterView) const FilterBox()
      ],
    );
  }
}
