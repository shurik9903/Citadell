import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_univ/modules/ModelFetch.dart';
import 'package:flutter_univ/theme/AppThemeDefault.dart';
import 'package:flutter_univ/widgets/DialogWindowWidgets/FileWidgets/ContainerStyle.dart';
import 'package:provider/provider.dart';

class ModelData {
  late int id;
  late String name;

  ModelData(this.id, this.name);
}

class SelectWindow extends ChangeNotifier {
  //Класс провайдер для смены тем приложения
  Widget _openWindow = Container();

  Widget get openWindow => _openWindow;

  set openWindow(Widget openWindow) {
    _openWindow = openWindow;
    notifyListeners();
  }
}

class OptionPage extends StatefulWidget {
  const OptionPage({super.key});

  @override
  State<OptionPage> createState() => _OptionPageState();
}

class _OptionPageState extends State<OptionPage> {
  final SelectWindow _selectWindow = SelectWindow();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          //Добавление Provider темы в MultiProvider
          ChangeNotifierProvider(
            create: (context) => _selectWindow,
          ),
        ],
        builder: (context, child) {
          return const Center(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: OptionMenu(),
                ),
                Expanded(
                  flex: 9,
                  child: OptionWindow(),
                )
              ],
            ),
          );
        });
  }
}

class OptionMenu extends StatefulWidget {
  const OptionMenu({super.key});

  @override
  State<OptionMenu> createState() => _OptionMenuState();
}

class _OptionMenuState extends State<OptionMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: appTheme(context).tertiaryColor,
          border: Border.all(color: appTheme(context).accentColor, width: 2)),
      child: Column(
        children: [
          Container(
            height: 50,
            margin: const EdgeInsets.only(
              top: 10,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom:
                    BorderSide(color: appTheme(context).accentColor, width: 5),
              ),
            ),
            child: const Text("Меню"),
          ),
          MenuButton(
            text: "Настройки пользователя",
            onTap: () {
              context.read<SelectWindow>().openWindow = const UserSettings();
            },
          ),
          MenuButton(
            text: "Настройки системы",
            onTap: () {
              context.read<SelectWindow>().openWindow = const SystemSettings();
            },
          ),
          MenuButton(
            text: "Назад",
            onTap: () {
              Navigator.pushNamed(context, '/work');
            },
          ),
        ],
      ),
    );
  }
}

class MenuButton extends StatefulWidget {
  String? text;
  Function? onTap;
  MenuButton({super.key, this.text, this.onTap});

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  late String _text;
  late Function _onTap;

  @override
  void initState() {
    super.initState();

    _text = widget.text ?? "";
    _onTap = widget.onTap ?? () {};
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _onTap();
      },
      child: Container(
        height: 50,
        // margin: EdgeInsets.symmetric(
        //   vertical: 10,
        // ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: appTheme(context).secondaryColor,
          // border: Border(
          //   bottom:
          //       BorderSide(color: appTheme(context).accentColor),
          // ),
        ),
        child: Text(_text),
      ),
    );
  }
}

class OptionWindow extends StatefulWidget {
  const OptionWindow({super.key});

  @override
  State<OptionWindow> createState() => _OptionWindowState();
}

class _OptionWindowState extends State<OptionWindow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: appTheme(context).secondaryColor),
      child: context.watch<SelectWindow>().openWindow,
    );
  }
}

class UserSettings extends StatefulWidget {
  const UserSettings({super.key});

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: appTheme(context).tertiaryColor,
    );
  }
}

class SystemSettings extends StatefulWidget {
  const SystemSettings({super.key});

  @override
  State<SystemSettings> createState() => _SystemSettingsState();
}

class _SystemSettingsState extends State<SystemSettings> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: appTheme(context).tertiaryColor,
      child: const SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [ModelWorking()],
          )),
    );
  }
}

class ModelWorking extends StatefulWidget {
  const ModelWorking({super.key});

  @override
  State<ModelWorking> createState() => _ModelWorkingState();
}

class _ModelWorkingState extends State<ModelWorking> {
  List<ModelData> _modelData = [];
  ModelData? _activeModel;

  @override
  void initState() {
    super.initState();
    // getModelsFetch().then((value) {
    //   print(value);
    //   setState(() {});
    // });

    _modelData = [
      ModelData(1, "первый"),
      ModelData(2, "второй"),
      ModelData(3, "третий"),
      ModelData(4, "четвертый"),
      ModelData(5, "пятый"),
      ModelData(1, "первый"),
      ModelData(2, "второй"),
      ModelData(3, "третий"),
      ModelData(4, "четвертый"),
      ModelData(5, "пятый")
    ];

    _activeModel = ModelData(0, "Активный");

    if (_activeModel != null) {
      _modelData.add(_activeModel!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: appTheme(context).secondaryColor,
      width: double.infinity,
      child: ContainerStyle(
        bottom: true,
        text: 'Модель',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FractionallySizedBox(
              widthFactor: 0.2,
              child: DropdownSearch<ModelData>(
                popupProps: const PopupProps.menu(
                  showSearchBox: true,
                  showSelectedItems: true,
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
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Активная модель",
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _activeModel = value;
                  });
                },
                selectedItem: _activeModel,
              ),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text("Выбрать"),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("Переименовать"),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("Удалить"),
                ),
              ],
            )
          ],
        ),
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     const Text("Активная модель"),
        //     FractionallySizedBox(
        //       widthFactor: 0.2,
        //       child: Container(
        //         color: appTheme(context).primaryColor,
        //         margin: const EdgeInsets.symmetric(vertical: 20),
        //         padding:
        //             const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        //         child: ModelTile(
        //           data: ModelData(1, "первый"),
        //         ),
        //       ),
        //     ),
        //     const Text("Доступные модели"),
        //     ModelList(
        //       data: _modelData,
        //     ),
        //   ],
        // ),
      ),
    );
  }
}

// class ModelList extends StatefulWidget {
//   const ModelList({super.key, required this.data});

//   final List<ModelData> data;

//   @override
//   State<ModelList> createState() => _ModelListState();
// }

// enum ModelSelect { none, select, rename, delete }

// class _ModelListState extends State<ModelList> {
//   @override
//   Widget build(BuildContext context) {
//     return FractionallySizedBox(
//       widthFactor: 0.2,
//       child: Container(
//         color: appTheme(context).primaryColor,
//         margin: const EdgeInsets.symmetric(vertical: 20),
//         padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
//         height: 300,
//         child: ListView.builder(
//           itemCount: widget.data.length,
//           itemBuilder: (context, index) {
//             return ModelTile(
//               data: widget.data[index],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class ModelTile extends StatefulWidget {
//   const ModelTile({super.key, required this.data});
//   final ModelData data;

//   @override
//   State<ModelTile> createState() => _ModelTileState();
// }

// class _ModelTileState extends State<ModelTile> {
//   ModelSelect _modelSelect = ModelSelect.none;

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: CircleAvatar(
//         backgroundColor: appTheme(context).accentColor,
//         child: Text(widget.data.id.toString()),
//       ),
//       title: Text(widget.data.name),
//       trailing: PopupMenuButton<ModelSelect>(
//         onSelected: (ModelSelect value) {
//           setState(() {
//             _modelSelect = value;
//           });
//           print(value);
//         },
//         itemBuilder: (BuildContext context) => <PopupMenuEntry<ModelSelect>>[
//           const PopupMenuItem<ModelSelect>(
//             value: ModelSelect.select,
//             child: Text('Выбрать'),
//           ),
//           const PopupMenuItem<ModelSelect>(
//             value: ModelSelect.rename,
//             child: Text('Переименовать'),
//           ),
//           const PopupMenuItem<ModelSelect>(
//             value: ModelSelect.delete,
//             child: Text('Удалить'),
//           ),
//         ],
//       ),
//     );
//   }
// }
