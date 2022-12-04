import 'package:flutter/material.dart';
import 'package:flutter_univ/theme/AppThemeDefault.dart';
import 'package:provider/provider.dart';

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
  SelectWindow _selectWindow = SelectWindow();

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
          return Center(
            child: Row(
              children: const [
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
            margin: EdgeInsets.only(
              top: 10,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom:
                    BorderSide(color: appTheme(context).accentColor, width: 5),
              ),
            ),
            child: Text("Меню"),
          ),
          MenuButton(
            text: "Меню 1",
            onTap: () {
              context.read<SelectWindow>().openWindow = TestWindow();
            },
          ),
          MenuButton(
            text: "Меню 2",
            onTap: () {
              context.read<SelectWindow>().openWindow = TestWindow2();
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

class TestWindow extends StatefulWidget {
  const TestWindow({super.key});

  @override
  State<TestWindow> createState() => _TestWindowState();
}

class _TestWindowState extends State<TestWindow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: appTheme(context).tertiaryColor,
    );
  }
}

class TestWindow2 extends StatefulWidget {
  const TestWindow2({super.key});

  @override
  State<TestWindow2> createState() => _TestWindow2State();
}

class _TestWindow2State extends State<TestWindow2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: appTheme(context).primaryColor,
    );
  }
}
