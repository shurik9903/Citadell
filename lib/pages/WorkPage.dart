import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/UserData.dart';
import '../modules/FileFetch.dart';
import '../theme/AppThemeDefault.dart';

class OpenFiles extends ChangeNotifier {
  List<FileContainer> _openFile = [];

  set openFile(List<FileContainer> openFile) {
    _openFile = openFile;
    notifyListeners();
  }

  void addFile(FileContainer openFile) {
    _openFile.add(openFile);
    notifyListeners();
  }

  void removeFile(Key? keyFile) {
    if (keyFile != null) {
      _openFile.removeWhere(
        (element) => element.key == keyFile,
      );
      notifyListeners();
    }
  }

  List<FileContainer> get openFile => _openFile;
}

class FileRow extends ChangeNotifier {
  //Класс провайдер для смены тем приложения
  List<DataRow> _fileRow = [];

  set fileRow(List<DataRow> fileRow) {
    _fileRow = fileRow;
    notifyListeners();
  }

  List<DataRow> get fileRow => _fileRow;
}

class WorkPage extends StatefulWidget {
  const WorkPage({super.key});

  @override
  State<WorkPage> createState() => _WorkPageState();
}

class _WorkPageState extends State<WorkPage> {
  final FileRow _fileRow = FileRow();
  final OpenFiles _openFile = OpenFiles();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //Добавление Provider темы в MultiProvider
        ChangeNotifierProvider(
          create: (context) => _fileRow,
        ),
        ChangeNotifierProvider(
          create: (context) => _openFile,
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
                  flex: 900,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: const [
                        Expanded(
                          flex: 100,
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
                ),
                Spacer(
                  flex: 3,
                ),
                const Expanded(
                  flex: 200,
                  child: MSidebar(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MFileView extends StatefulWidget {
  const MFileView({super.key});

  @override
  State<MFileView> createState() => _MFileViewState();
}

class _MFileViewState extends State<MFileView> {
  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: appTheme(context).secondaryColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        width: double.infinity,
        height: 200,
        child: FractionallySizedBox(
          widthFactor: 0.98,
          heightFactor: 0.85,
          child: Container(
              decoration: BoxDecoration(
                color: appTheme(context).primaryColor,
                border: Border.all(
                  color: appTheme(context).accentColor,
                  width: 5,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 14,
                    child: Scrollbar(
                      controller: controller,
                      interactive: true,
                      trackVisibility: true,
                      thumbVisibility: true,
                      child: ListView(
                        controller: controller,
                        scrollDirection: Axis.horizontal,
                        children: [
                          ...context.watch<OpenFiles>().openFile,
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles();

                        if (result != null) {
                          PlatformFile file = result.files.first;

                          print(file.name);
                          // print(file.bytes);
                          // print(file.size);
                          // print(file.extension);
                          // print(file.path);

                          fileFetch(file.name).then((value) {
                            print("File OK");
                            context.read<FileRow>().fileRow = testData
                                .map((data) => buildTableRow(
                                    number: data.number ?? "",
                                    type: data.type ?? "",
                                    source: data.source ?? "",
                                    contentText: data.contentText ?? "",
                                    originalText: data.originalText ?? "",
                                    date: data.date ?? "",
                                    analyzedText: data.analyzedText ?? "",
                                    probability: data.probability ?? ""))
                                .toList();

                            context.read<OpenFiles>().addFile(FileContainer(
                                key: () {
                                  var r = Random();

                                  return Key(String.fromCharCodes(List.generate(
                                      10, (index) => r.nextInt(33) + 89)));
                                }(),
                                name: file.name));
                          }).catchError((error) {
                            setState(() {
                              print(error.toString());
                              // msg = error.toString();
                            });
                          });
                        } else {
                          print("Не удалось открыть файл");
                          // User canceled the picker
                        }
                      },
                      child: const SizedBox(
                          height: double.infinity,
                          child: FittedBox(
                              alignment: Alignment.center,
                              child: Icon(Icons.add))),
                    ),
                  )
                ],
              )),
        ));
  }
}

class MTableView extends StatefulWidget {
  const MTableView({super.key});

  @override
  State<MTableView> createState() => _MTableViewState();
}

class _MTableViewState extends State<MTableView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: appTheme(context).primaryColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 1,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            horizontalMargin: 0,
            columnSpacing: 0,
            columns: [
              ...buildTableColumns([
                "№",
                "Тип",
                "Источник",
                "Содержание сообщения",
                "Оригинал сообщения",
                "Дата",
                "Анализированное сообщение",
                "Вероятность",
                "Обновить",
                "Выделение"
              ], context)
            ],
            rows: [...context.watch<FileRow>().fileRow],
          ),
        ),
      ),
    );
  }
}

DataRow buildTableRow(
    {String number = "0",
    String type = "",
    String source = "",
    String contentText = "",
    String originalText = "",
    String date = "",
    String analyzedText = "",
    String probability = ""}) {
  bool t = false;

  return DataRow(cells: [
    DataCell(Container(
      alignment: Alignment.center,
      child: Text(number),
    )),
    DataCell(Container(
      child: Text(type),
    )),
    DataCell(Container(
      child: Text(source),
    )),
    DataCell(Container(
      child: Text(contentText),
    )),
    DataCell(Container(
      child: Text(originalText),
    )),
    DataCell(Container(
      alignment: Alignment.center,
      child: Text(date),
    )),
    DataCell(Container(
      child: Text(analyzedText),
    )),
    DataCell(Container(
      alignment: Alignment.center,
      child: Text(
        probability,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: int.tryParse(probability) != null
              ? int.parse(probability) <= 30
                  ? Color.fromARGB(255, 255, 0, 0)
                  : int.parse(probability) <= 60
                      ? Color.fromARGB(255, 255, 217, 0)
                      : Color.fromARGB(255, 30, 255, 0)
              : Color.fromARGB(255, 255, 255, 255),
        ),
      ),
    )),
    DataCell(Container(
      alignment: Alignment.center,
      child: Text(""),
    )),
    DataCell(MCheckBox()),
  ]);
}

class MCheckBox extends StatefulWidget {
  const MCheckBox({super.key});

  @override
  State<MCheckBox> createState() => _MCheckBoxState();
}

class _MCheckBoxState extends State<MCheckBox> {
  bool select = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Checkbox(
        value: select,
        onChanged: (value) {
          setState(() {
            select = !select;
          });
        },
      ),
    );
  }
}

List<DataColumn> buildTableColumns(List<String> labels, BuildContext context) =>
    labels.asMap().entries.map((element) {
      return DataColumn(
        label: Expanded(
          child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                  color: appTheme(context).secondaryColor,
                  border: Border.all(
                    color: appTheme(context).tertiaryColor,
                    width: 1,
                  ),
                  borderRadius: element.key == 0
                      ? const BorderRadius.only(topLeft: Radius.circular(10))
                      : element.key == (labels.length - 1)
                          ? const BorderRadius.only(
                              topRight: Radius.circular(10))
                          : null),
              alignment: Alignment.center,
              child: Text(element.value)),
        ),
      );
    }).toList();

class MSidebar extends StatefulWidget {
  const MSidebar({super.key});

  @override
  State<MSidebar> createState() => _MSidebarState();
}

class _MSidebarState extends State<MSidebar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: appTheme(context).primaryColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Column(
        children: const [
          Expanded(
            flex: 20,
            child: MUserPanel(),
          ),
          Expanded(
            flex: 110,
            child: MDictionary(),
          ),
          Expanded(
            flex: 10,
            child: MAnalysisButton(),
          ),
          Spacer(
            flex: 3,
          )
        ],
      ),
    );
  }
}

class MUserPanel extends StatefulWidget {
  const MUserPanel({super.key});

  @override
  State<MUserPanel> createState() => _MUserPanelState();
}

class _MUserPanelState extends State<MUserPanel> {
  @override
  Widget build(BuildContext context) {
    var userData = UserData_Singleton();

    return FractionallySizedBox(
      widthFactor: 0.95,
      heightFactor: 0.95,
      child: Container(
        decoration: BoxDecoration(
          color: appTheme(context).secondaryColor,
          border: Border.all(
            color: appTheme(context).accentColor,
            width: 5,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 7,
              child: Container(
                margin: const EdgeInsets.only(left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      userData.login,
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(
                      userData.id,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: () {
                  Scaffold.of(context).openEndDrawer();
                },
                child: Container(
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: appTheme(context).tertiaryColor,
                      shape: BoxShape.circle),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    height: double.infinity,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: appTheme(context).accentColor,
                        shape: BoxShape.circle),
                    child: FittedBox(
                      child: Icon(Icons.menu,
                          color: appTheme(context).additionalColor1),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MDictionary extends StatefulWidget {
  const MDictionary({super.key});

  @override
  State<MDictionary> createState() => _MDictionaryState();
}

class _MDictionaryState extends State<MDictionary> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.95,
      heightFactor: 0.98,
      child: Container(
        decoration: BoxDecoration(
          color: appTheme(context).secondaryColor,
          border: Border.all(
            color: appTheme(context).accentColor,
            width: 5,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: FractionallySizedBox(
          heightFactor: 0.96,
          widthFactor: 0.91,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: appTheme(context).primaryColor, width: 10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: appTheme(context).primaryColor, width: 5),
                      ),
                    ),
                    child: const Text(
                      "Словарь",
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: RichText(
                      text: const TextSpan(
                        children: [],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MAnalysisButton extends StatefulWidget {
  const MAnalysisButton({super.key});

  @override
  State<MAnalysisButton> createState() => _MAnalysisButtonState();
}

class _MAnalysisButtonState extends State<MAnalysisButton> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.8,
      heightFactor: 0.95,
      child: GestureDetector(
        onTap: () {
          fileFetch("testid").then((value) {
            print("Analysis OK");
            context.read<FileRow>().fileRow = [];

            context.read<FileRow>().fileRow = testDataAnalysis
                .map((data) => buildTableRow(
                    number: data.number ?? "",
                    type: data.type ?? "",
                    source: data.source ?? "",
                    contentText: data.contentText ?? "",
                    originalText: data.originalText ?? "",
                    date: data.date ?? "",
                    analyzedText: data.analyzedText ?? "",
                    probability: data.probability ?? ""))
                .toList();
          }).catchError((error) {
            setState(() {
              print(error.toString());
            });
          });
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 18, 204, 18),
            border: Border.all(
              color: appTheme(context).accentColor,
              width: 5,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Text(
            "Анализировать",
            style: TextStyle(fontSize: 30, color: appTheme(context).textColor2),
          ),
        ),
      ),
    );
  }
}

class FileContainer extends StatefulWidget {
  String name;
  FileContainer({required super.key, required this.name});

  @override
  State<FileContainer> createState() => _FileContainerState();
}

class _FileContainerState extends State<FileContainer> {
  late String name;
  @override
  void initState() {
    super.initState();
    setState(() {
      name = widget.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: appTheme(context).secondaryColor,
                border: Border.all(color: appTheme(context).accentColor),
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            child: Text(name)),
        Positioned(
          top: 5,
          right: 0,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              context.read<OpenFiles>().removeFile(widget.key);
            },
            child: Container(
              decoration: BoxDecoration(
                color: appTheme(context).tertiaryColor,
                shape: BoxShape.circle,
                border: Border.all(color: appTheme(context).accentColor),
              ),
              child: Icon(Icons.close),
            ),
          ),
        ),
      ],
    );
  }
}
