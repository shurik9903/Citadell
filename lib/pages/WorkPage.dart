import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_univ/modules/ConnectionFetch.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../theme/AppThemeDefault.dart';
import '../widgets/WorkPageWidgets.dart/FileView.dart';
import '../widgets/WorkPageWidgets.dart/Sidebar.dart';
import '../widgets/WorkPageWidgets.dart/TableView.dart';

class DictioneryText extends ChangeNotifier {
  List<TextSpan> _dictText = [];

  set dictText(List<TextSpan> dictText) {
    _dictText = dictText;
    notifyListeners();
  }

  List<TextSpan> get dictText => _dictText;
}

class TypeViewMenu extends ChangeNotifier {
  bool _show = true;

  set show(bool show) {
    _show = show;
    notifyListeners();
  }

  bool get show => _show;
}

class WorkPage extends StatefulWidget {
  const WorkPage({super.key});

  @override
  State<WorkPage> createState() => _WorkPageState();
}

class _WorkPageState extends State<WorkPage> {
  final DictioneryText _dictioneryText = DictioneryText();
  final TypeViewMenu _typeViewMenu = TypeViewMenu();

  @override
  void initState() {
    super.initState();

    try {
      callConnection((connect) {
        context.read<ConnectStatus>().status = connect;
      });

      context.read<WebSocketService>().open();

      // socket.sendMessage();

      subscribeDataConnection(
          context.read<WebSocketService>().connection?.stream,
          context.read<OpenFiles>().changeStatusFile);
    } catch (e) {
      print("Error WebSocket: " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //Добавление Provider темы в MultiProvider
        ChangeNotifierProvider(
          create: (context) => _dictioneryText,
        ),
        ChangeNotifierProvider(
          create: (context) => _typeViewMenu,
        ),
      ],
      builder: (context, child) {
        return Center(
          child: Container(
            color: appTheme(context).tertiaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: context.watch<TypeViewMenu>().show ? 1500 : 900,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: const [
                      Expanded(
                        flex: 75,
                        child: MFileView(),
                      ),
                      Spacer(
                        flex: 3,
                      ),
                      Expanded(
                        flex: 900,
                        child: MTableView(),
                      ),
                    ],
                  ),
                ),
                const Spacer(
                  flex: 3,
                ),
                Expanded(
                  flex: context.watch<TypeViewMenu>().show ? 80 : 200,
                  child: Stack(
                    fit: StackFit.expand,
                    clipBehavior: Clip.none,
                    children: [
                      const MSidebar(),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            heightFactor: 0.2,
                            widthFactor:
                                context.watch<TypeViewMenu>().show ? 0.3 : 0.1,
                            child: Container(
                              margin: const EdgeInsets.only(right: 5),
                              child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    appTheme(context).secondaryColor,
                                  ),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: context
                                              .watch<TypeViewMenu>()
                                              .show
                                          ? const BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              bottomLeft: Radius.circular(30))
                                          : const BorderRadius.only(
                                              topRight: Radius.circular(30),
                                              bottomRight: Radius.circular(30)),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  context.read<TypeViewMenu>().show =
                                      !context.read<TypeViewMenu>().show;
                                },
                                child: context.watch<TypeViewMenu>().show
                                    ? const Text('<')
                                    : const Text('>'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
