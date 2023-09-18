import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_univ/data/ModelData.dart';
import 'package:flutter_univ/modules/ModelFetch.dart';
import 'package:flutter_univ/theme/AppThemeDefault.dart';
import 'package:flutter_univ/widgets/DialogWindowWidgets/InputTextDialog.dart';
import 'package:flutter_univ/widgets/OptionPageWidgets/ServiceWidgets/DropDownItem.dart';

class ModelEdit extends StatefulWidget {
  const ModelEdit({super.key, this.menu = true, this.getActiveModel});

  final bool menu;
  final void Function(ModelData?)? getActiveModel;

  @override
  State<ModelEdit> createState() => _ModelEditState();
}

class _ModelEditState extends State<ModelEdit> {
  List<ModelData> _modelData = [];
  ModelData? _activeModel;
  bool _isSelectedModel = false;

  updateModelList() async {
    getModelsFetch().then((value) {
      setState(() {
        setActiveModel = value['model'];
        _modelData = value['models'];
        if (_activeModel != null) {
          _isSelectedModel = true;
          _modelData.removeWhere(
            (element) => element.id == _activeModel!.id,
          );
        }
      });
    }).catchError((e) {
      print(e.toString());
    });
  }

  set setActiveModel(ModelData? modelData) {
    setState(() {
      _activeModel = modelData;
      if (widget.getActiveModel != null) {
        widget.getActiveModel!(_activeModel);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    updateModelList();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> menu = [];

    if (!_isSelectedModel) {
      menu.add(
        TextButton(
          onPressed: () {},
          child: const Text("Активировать"),
        ),
      );
    }

    if (_activeModel != null && _isSelectedModel != true) {
      menu.add(
        TextButton(
          onPressed: () {},
          child: const Text("Удалить"),
        ),
      );
    }

    menu.add(
      TextButton(
        onPressed: () {
          if (_activeModel == null) return;

          showInputTextDialogWindow(context, text: _activeModel!.name)
              .then((value) {
            if (value['select'] == true) {
              updateModelsFetch(value['data'], _activeModel!.id).then((value) {
                updateModelList();
              }).catchError((e) {
                print(e);
              });
            }
          }).catchError((e) {
            print(e);
          });
        },
        child: const Text("Переименовать"),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownSearch<ModelData>(
          popupProps: PopupProps.menu(
            showSearchBox: true,
            showSelectedItems: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                filled: true,
                fillColor: appTheme(context).primaryColor,
              ),
            ),
            itemBuilder: (context, item, isSelected) {
              return DropDownItem(
                item: item,
                isSelect: isSelected,
              );
            },
          ),
          filterFn: (item, filter) {
            return item.name.contains(filter) ||
                item.id.toString().contains(filter) ||
                '${item.id.toString()} ${item.name}'.contains(filter) ||
                filter.isEmpty;
          },
          compareFn: (item1, item2) =>
              item1.name == item2.name && item1.id == item2.id,
          items: _modelData,
          itemAsString: (item) => '${item.id} ${item.name}',
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
                labelText:
                    _isSelectedModel ? 'Активная модель' : 'Неактивная модель'),
          ),
          dropdownBuilder: (context, selectedItem) {
            return DropDownItem(
              item: selectedItem,
            );
          },
          onChanged: (value) {
            setState(() {
              _isSelectedModel = value?.active ?? false;
              setActiveModel = value;
            });
          },
          selectedItem: _activeModel,
        ),
        if (widget.menu)
          Row(
            children: menu,
          )
      ],
    );
  }
}
