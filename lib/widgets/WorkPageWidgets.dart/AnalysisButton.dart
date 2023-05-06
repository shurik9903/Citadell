import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../modules/AnalysisFetch.dart';
import '../../pages/WorkPage.dart';
import '../../theme/AppThemeDefault.dart';

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
          fileAnalysisFetch('0').then((value) {}).catchError((error) {});

          // rabbitFetch().then((value) {
          //   print(value);
          // }).catchError((error) {
          //   print(error.toString());
          // });

          // getFileFetch("testid").then((value) {
          //   print("Analysis OK");

          //   context.read<FileRow>().fileRow = testDataAnalysis
          //       .map((data) => buildTableRow(
          //           number: data.number ?? "",
          //           type: data.type ?? "",
          //           source: data.source ?? "",
          //           contentText: data.contentText ?? "",
          //           originalText: data.originalText ?? "",
          //           date: data.date ?? "",
          //           analyzedText: [
          //             ...?data.analyzedText
          //                 ?.map(
          //                   (element) => TextSpan(
          //                     recognizer: element.type != null
          //                         ? (TapGestureRecognizer()
          //                           ..onTap = () {
          //                             dictionaryFetch(element.text ?? "")
          //                                 .then((value) {
          //                               print("Dictionary OK");
          //                               print(element.text);

          //                               context.read<TypeViewMenu>().show =
          //                                   false;

          //                               context
          //                                   .read<DictioneryText>()
          //                                   .dictText = [
          //                                 TextSpan(
          //                                   text: "${element.text} - ",
          //                                   style: TextStyle(
          //                                     color: element.type == null
          //                                         ? appTheme(context).textColor1
          //                                         : element.type?.typeColor,
          //                                   ),
          //                                 ),
          //                                 TextSpan(
          //                                   text: testWord[element.text
          //                                           ?.toLowerCase()
          //                                           .replaceAll(' ', '')] ??
          //                                       "",
          //                                   style: TextStyle(
          //                                     color: element.type == null
          //                                         ? appTheme(context).textColor1
          //                                         : element.type?.typeColor,
          //                                   ),
          //                                 )
          //                               ];
          //                             }).catchError((error) {
          //                               setState(() {
          //                                 print(error.toString());
          //                               });
          //                             });
          //                           })
          //                         : null,
          //                     text: element.text,
          //                     style: TextStyle(
          //                       color: element.type == null
          //                           ? appTheme(context).textColor1
          //                           : element.type?.typeColor,
          //                     ),
          //                   ),
          //                 )
          //                 .toList()
          //           ],
          //           probability: data.probability ?? ""))
          //       .toList();
          // }).catchError((error) {
          //   setState(() {
          //     print(error.toString());
          //   });
          // });
        },
        child: Container(
          alignment: Alignment.center,
          decoration: context.watch<TypeViewMenu>().show
              ? BoxDecoration(
                  color: const Color.fromARGB(255, 18, 204, 18),
                  border: Border.all(
                    color: appTheme(context).accentColor,
                    width: 5,
                  ),
                  shape: BoxShape.circle)
              : BoxDecoration(
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
            context.watch<TypeViewMenu>().show ? ">>" : "Анализировать",
            style: TextStyle(fontSize: 30, color: appTheme(context).textColor2),
          ),
        ),
      ),
    );
  }
}
