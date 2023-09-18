import 'package:flutter/material.dart';
import 'package:flutter_univ/data/Option.dart';
import 'package:flutter_univ/modules/ConnectionFetch.dart';
import 'package:flutter_univ/theme/AppThemeDefault.dart';
import 'package:flutter_univ/widgets/WorkPageWidgets/LoadAnimation.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ServerAddressOption extends StatefulWidget {
  const ServerAddressOption({super.key});

  @override
  State<ServerAddressOption> createState() => _ServerAddressOptionState();
}

class _ServerAddressOptionState extends State<ServerAddressOption> {
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _apiController = TextEditingController();

  bool _isPing = false;

  bool _pingWait = false;

  Color? _pingButtonColor;

  textChange() {
    setState(() {
      _isPing = false;
      _pingButtonColor = null;
    });
  }

  @override
  void initState() {
    super.initState();

    OptionBase optionBase = OptionSingleton();

    _ipController.text = optionBase.serverIP;
    _portController.text = optionBase.serverPort;
    _nameController.text = optionBase.serverName;
    _apiController.text = optionBase.serverAPI;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: appTheme(context).primaryColor),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Адрес сервера"),
          Row(
            children: [
              Flexible(
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.3,
                  child: TextField(
                    controller: _ipController,
                    maxLines: 1,
                    decoration: const InputDecoration(hintText: 'IP'),
                    // onChanged: (value) => textChange(),
                    inputFormatters: [
                      MaskTextInputFormatter(
                          mask: '###.###.###.###',
                          filter: {'#': RegExp(r'[0-9]')},
                          type: MaskAutoCompletionType.lazy)
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: const Text(":"),
              ),
              Flexible(
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.1,
                  child: TextField(
                    controller: _portController,
                    maxLines: 1,
                    decoration: const InputDecoration(hintText: 'PORT'),
                    onChanged: (value) => textChange(),
                    inputFormatters: [
                      MaskTextInputFormatter(
                          mask: '####',
                          filter: {'#': RegExp(r'[0-9]')},
                          type: MaskAutoCompletionType.lazy)
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: const Text("/"),
              ),
              Flexible(
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.15,
                  child: TextField(
                    controller: _nameController,
                    maxLines: 1,
                    decoration: const InputDecoration(hintText: 'NAME'),
                    onChanged: (value) => textChange(),
                    inputFormatters: [
                      MaskTextInputFormatter(type: MaskAutoCompletionType.lazy)
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: const Text("/"),
              ),
              Flexible(
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.15,
                  child: TextField(
                    controller: _apiController,
                    maxLines: 1,
                    decoration: const InputDecoration(hintText: 'API'),
                    onChanged: (value) => textChange(),
                    inputFormatters: [
                      MaskTextInputFormatter(type: MaskAutoCompletionType.lazy)
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      _pingButtonColor = null;
                      _isPing = false;
                      _pingWait = true;
                    });

                    await connectionFetch(
                            address:
                                'http://${_ipController.text}:${_portController.text}/${_nameController.text}/${_apiController.text}/')
                        .then((value) {
                      setState(() {
                        _pingButtonColor = Colors.green;
                        _isPing = true;
                      });
                    }).catchError((error) {
                      setState(() {
                        _pingButtonColor = Colors.red;
                        _isPing = false;
                      });
                    });

                    setState(() {
                      _pingWait = false;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 50,
                    height: 25,
                    decoration: BoxDecoration(color: _pingButtonColor),
                    child: _pingWait
                        ? const LoadAnimation(
                            radiusToCenter: 10,
                            sizeDot: 4,
                          )
                        : Text(
                            "PING",
                            style: TextStyle(
                              color: _pingButtonColor == null
                                  ? null
                                  : Colors.black,
                            ),
                          ),
                  ),
                ),
                TextButton(
                  onPressed: _isPing
                      ? () {
                          setState(() {
                            _pingButtonColor = null;
                            _isPing = false;

                            var option = OptionSingleton();

                            option.serverIP = _ipController.text;
                            option.serverPort = _portController.text;
                            option.serverName = _nameController.text;
                            option.serverAPI = _apiController.text;
                          });
                        }
                      : null,
                  child: const Text("Сохранить"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
