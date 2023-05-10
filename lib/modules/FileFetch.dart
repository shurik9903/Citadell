import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_univ/data/AnalysisTextData.dart';
import 'package:flutter_univ/data/FileData.dart';
import 'package:flutter_univ/data/RowTableData.dart';
import 'package:flutter_univ/modules/AnalysisFetch.dart';
import 'package:flutter_univ/widgets/DialogWindowWidgets/FileDialog.dart';
import 'package:http/http.dart' as http;

import '../data/Option.dart';
import '../data/UserData.dart';

Future<dynamic> saveFileFetch(LoadFile fileData) async {
  var userData = UserDataSingleton();
  var response = await http.post(
    Uri.parse('http://localhost:8080/FSB/api/doc'),
    headers: {
      "Content-type": "application/json",
      "Accept": "application/json",
      "token": userData.token,
      "login": userData.login,
    },
    body: jsonEncode(fileData),
  );

  if (response.statusCode == 200) {
    var data = response.body;
    var msg = jsonDecode(data)["Msg"];
    var replace = jsonDecode(data)["Replace"];

    if (msg != '') {
      print(msg);
      throw Exception(msg);
    }

    return replace;
  }
  if (response.statusCode == 401) {
    throw Exception(response.statusCode);
  }

  print(response.statusCode);
  throw Exception(response.statusCode);
}

Future<dynamic> getAllUserFileFetch() async {
  var userData = UserDataSingleton();

  var response =
      await http.get(Uri.parse('http://localhost:8080/FSB/api/doc'), headers: {
    "Content-type": "application/json",
    "Accept": "application/json",
    "token": userData.token,
    "login": userData.login,
  });

  if (response.statusCode == 200) {
    var data = response.body;
    var msg = jsonDecode(data)["Msg"];

    if (msg != null && msg != '') {
      print(msg);
      throw Exception(msg);
    }

    final docData = jsonDecode(data)["Files"];

    List<FileData>? files = jsonDecode(docData)
        .map<FileData>((value) => FileData.fromJson(value))
        .toList();

    return files;
  }
  if (response.statusCode == 401) {
    throw Exception(response.statusCode);
  }

  print(response.statusCode);
  throw Exception(response.statusCode);
}

Future<dynamic> getDocFetch(String name, {int start = 1, diapason = 25}) async {
  var userData = UserDataSingleton();
  var option = OptionSingleton();

  var response = await http.get(
      Uri.parse('${option.url}doc?name=$name&start=$start&diapason=$diapason'),
      headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "token": userData.token,
        "login": userData.login,
      });

  if (response.statusCode == 200) {
    var data = response.body;
    var msg = jsonDecode(data)["Msg"];

    if (msg != '') {
      print(msg);
      throw Exception(msg);
    }

    final docData = DocData.fromJson(jsonDecode(data));

    return docData;
  }

  if (response.statusCode == 401) {
    throw Exception(response.statusCode);
  }

  print(response.statusCode);
  throw Exception(response.statusCode);
}

Future<dynamic> rewriteFileFetch(String docName) async {
  var userData = UserDataSingleton();
  var option = OptionSingleton();

  var response =
      await http.put(Uri.parse('${option.url}doc?name=$docName'), headers: {
    "Content-type": "application/json",
    "Accept": "application/json",
    "token": userData.token,
    "login": userData.login,
  });

  if (response.statusCode == 200) {
    var data = response.body;
    var msg = jsonDecode(data)["Msg"];

    if (msg != '') {
      print(msg);
      throw Exception(msg);
    }

    return "";
  }
  if (response.statusCode == 401) {
    throw Exception(response.statusCode);
  }

  print(response.statusCode);
  throw Exception(response.statusCode);
}

// List<RowTableData> testData = [
//   RowTableData(
//     number: "1",
//     type: "Репост",
//     source: "Пользователь",
//     contentText: "Яркая пышная роза из бисера \nцветы@magiya_bisera",
//     originalText: "Ссылка...",
//     date: "18.01.2019 19:19:21",
//     // analyzedText: "Яркая пышная роза из бисера...",
//     // probability: "1",
//   ),
//   RowTableData(
//     number: "2",
//     type: "Коментарий к посту/репосту",
//     source: "Группа",
//     contentText:
//         "Нашли еще лазейку как к людям в карман залезть, а как кружки бесплатные создать ума не хватает. Когда уже уроды нахапаются, обдирают народ до нитки.",
//     originalText: "Ссылка...",
//     date: "04.01.2019 16:44:15",
//     // analyzedText:
//     //     "Нашли еще лазейку как к людям в карман залезть, а как кружки бесплатные создать ума не хватает. Когда уже уроды нахапаются, обдирают народ до нитки.",
//     // probability: "86",
//   ),
//   RowTableData(
//     number: "3",
//     type: "Репост",
//     source: "Пользователь",
//     contentText: "Яркая пышная роза из бисера \nцветы@magiya_bisera",
//     originalText: "Ссылка...",
//     date: "18.01.2019 19:19:21",
//     // analyzedText: "Яркая пышная роза из бисера...",
//     // probability: "50",
//   ),
//   ...List.generate(
//       20,
//       (index) => RowTableData(
//             number: "4",
//             type: "Репост",
//             source: "Пользователь",
//             contentText: "Яркая пышная роза из бисера \nцветы@magiya_bisera",
//             originalText: "Ссылка...",
//             date: "18.01.2019 19:19:21",
//             // analyzedText: "Яркая пышная роза из бисера...",
//             // probability: "1",
//           ))
// ];

// // List<RowTableData> testDataAnalysis = [
// //   RowTableData(
// //     number: "1",
// //     type: "Репост",
// //     source: "Пользователь",
// //     contentText: "Яркая пышная роза из бисера \nцветы@magiya_bisera",
// //     originalText: "Ссылка...",
// //     date: "18.01.2019 19:19:21",
// //     analyzedText: [
// //       ...testAnulysisText1
// //           .map(
// //             (e) => TextSpan(
// //               text: e.text,
// //               style: TextStyle(
// //                   color: e.type == null
// //                       ? Color.fromARGB(255, 255, 255, 255)
// //                       : e.type?.typeColor),
// //             ),
// //           )
// //           .toList()
// //     ],
// //     probability: "1",
// //   ),
// //   RowTableData(
// //     number: "2",
// //     type: "Коментарий к посту/репосту",
// //     source: "Группа",
// //     contentText:
// //         "Нашли еще лазейку как к людям в карман залезть, а как кружки бесплатные создать ума не хватает. Когда уже уроды нахапаются, обдирают народ до нитки.",
// //     originalText: "Ссылка...",
// //     date: "04.01.2019 16:44:15",
// //     analyzedText: [
// //       ...testAnulysisText2
// //           .map(
// //             (e) => TextSpan(
// //               text: e.text,
// //               style: TextStyle(
// //                   color: e.type == null
// //                       ? Color.fromARGB(255, 255, 255, 255)
// //                       : e.type?.typeColor),
// //             ),
// //           )
// //           .toList()
// //     ],
// //     probability: "86",
// //   ),
// //   RowTableData(
// //     number: "3",
// //     type: "Репост",
// //     source: "Пользователь",
// //     contentText: "Яркая пышная роза из бисера \nцветы@magiya_bisera",
// //     originalText: "Ссылка...",
// //     date: "18.01.2019 19:19:21",
// //     analyzedText: [
// //       TextSpan(
// //         text: "Яркая пышная роза из бисера...",
// //         style: TextStyle(
// //           color: Color.fromARGB(255, 255, 255, 255),
// //         ),
// //       ),
// //     ],
// //     probability: "50",
// //   ),
// //   ...List.generate(
// //       20,
// //       (index) => RowTableData(
// //             number: "4",
// //             type: "Репост",
// //             source: "Пользователь",
// //             contentText: "Яркая пышная роза из бисера \nцветы@magiya_bisera",
// //             originalText: "Ссылка...",
// //             date: "18.01.2019 19:19:21",
// //             analyzedText: [
// //               TextSpan(
// //                 text: "Яркая пышная роза из бисера...",
// //                 style: TextStyle(
// //                   color: Color.fromARGB(255, 255, 255, 255),
// //                 ),
// //               ),
// //             ],
// //             probability: "1",
// //           ))
// // ];

// List<RowTableData> testDataAnalysis = [
//   RowTableData(
//     number: "1",
//     type: "Репост",
//     source: "Пользователь",
//     contentText: "Яркая пышная роза из бисера \nцветы@magiya_bisera",
//     originalText: "Ссылка...",
//     date: "18.01.2019 19:19:21",
//     analyzedText: testAnulysisText1,
//     probability: "1",
//   ),
//   RowTableData(
//     number: "2",
//     type: "Коментарий к посту/репосту",
//     source: "Группа",
//     contentText:
//         "Нашли еще лазейку как к людям в карман залезть, а как кружки бесплатные создать ума не хватает. Когда уже уроды нахапаются, обдирают народ до нитки.",
//     originalText: "Ссылка...",
//     date: "04.01.2019 16:44:15",
//     analyzedText: testAnulysisText2,
//     probability: "86",
//   ),
//   RowTableData(
//     number: "3",
//     type: "Репост",
//     source: "Пользователь",
//     contentText: "Яркая пышная роза из бисера \nцветы@magiya_bisera",
//     originalText: "Ссылка...",
//     date: "18.01.2019 19:19:21",
//     analyzedText: [
//       AnalysisTextData(
//           text: "Яркая пышная роза из бисера \nцветы@magiya_bisera")
//     ],
//     probability: "50",
//   ),
//   ...List.generate(
//       20,
//       (index) => RowTableData(
//             number: "4",
//             type: "Репост",
//             source: "Пользователь",
//             contentText: "Яркая пышная роза из бисера \nцветы@magiya_bisera",
//             originalText: "Ссылка...",
//             date: "18.01.2019 19:19:21",
//             analyzedText: [
//               AnalysisTextData(
//                   text: "Яркая пышная роза из бисера \nцветы@magiya_bisera")
//             ],
//             probability: "1",
//           ))
// ];

// Map<String, String> testWord = {
//   "яркая":
//       "Очень сильный, сияющий, ослепительный, излучающий сильный свет. Яркий свет. Яркая лампа. Яркое солнце.",
//   "пышная":
//       "Мягкий, пухлый, рыхлый и легкий. Играли на полях певучие вьюги ---, щедро кутая городок в пышные сугробы снега.",
//   "роза":
//       "Декоративный кустарник с крупными махровыми, обычно ароматными, цветками разнообразной окраски и со стеблями, покрытыми шипами, а также цветки этого растения.",
//   "цветы":
//       "Часть растения, обычно имеющая вид венчика из лепестков, окружающих пестик с тычинками.",
//   "людям":
//       "Живое существо, обладающее мышлением, речью, способностью создавать орудия и пользоваться ими в процессе общественного труда.",
//   "залезть":
//       "1. на что. Карабкаясь, цепляясь, взобраться на верх чего-л.; влезть. Залезть на крышу. \n2. Прилагая усилия, протиснуться, проникнуть, забраться куда-л., во что-л.",
//   "кружки": "Сосуд в форме стакана с ручкой.",
//   "бесплатные": "Без оплаты.",
//   "создать":
//       "Путем творческих усилий и труда дать существование чему-л., вызвать к жизни что-л.",
//   "уроды":
//       "1. Человек с физическим недостатком. \n2. Человек с некрасивой, безобразной внешностью. \n3. Разг. Употребляется как бранное слово.",
//   "нахапаются":
//       "С жадность набрать чего-либо в каком-либо (обычно большом) количестве.",
//   "обдирают":
//       "1. (несов. также драть). Содрать со всех сторон, со всей поверхности чего-л. верхний слой, покров и т. п. \n2. Разг. Ноской, употреблением привести в негодный вид; \n3. перен. Прост. Ограбить, обобрать. ",
//   "народ":
//       "1. Население, жители той или иной страны, государства. \n2. Нация, национальность, народность. \n3. только ед. ч. Основная трудовая масса населения страны (в эксплуататорских государствах — угнетаемая господствующими классами).",
// };
