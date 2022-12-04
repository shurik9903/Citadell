import 'package:flutter_univ/data/RowTableData.dart';
import 'package:http/http.dart' as http;

import '../data/UserData.dart';

Future<dynamic> fileFetch(String name) async {
  var userData = UserData_Singleton();

  var response = await http
      .get(Uri.parse('http://localhost:8080/FSB/api/doc/$name'), headers: {
    "Content-type": "application/json",
    "Accept": "application/json",
    "Token": userData.token,
  });

  if (response.statusCode == 200) {
    var data = response.body;

    return '';
  } else {
    print(response.statusCode);
    throw Exception(response.statusCode);
  }
}

List<RowTableData> testData = [
  RowTableData(
    number: "1",
    type: "Репост",
    source: "Пользователь",
    contentText: "Яркая пышная роза из бисера \nцветы@magiya_bisera",
    originalText: "Ссылка...",
    date: "18.01.2019 19:19:21",
    // analyzedText: "Яркая пышная роза из бисера...",
    // probability: "1",
  ),
  RowTableData(
    number: "2",
    type: "Коментарий к посту/репосту",
    source: "Группа",
    contentText:
        "Нашли еще лазейку как к людям в карман залезть, а как кружки бесплатные создать ума не хватает. Когда уже уроды нахапаются, обдирают народ до нитки.",
    originalText: "Ссылка...",
    date: "04.01.2019 16:44:15",
    // analyzedText:
    //     "Нашли еще лазейку как к людям в карман залезть, а как кружки бесплатные создать ума не хватает. Когда уже уроды нахапаются, обдирают народ до нитки.",
    // probability: "86",
  ),
  RowTableData(
    number: "3",
    type: "Репост",
    source: "Пользователь",
    contentText: "Яркая пышная роза из бисера \nцветы@magiya_bisera",
    originalText: "Ссылка...",
    date: "18.01.2019 19:19:21",
    // analyzedText: "Яркая пышная роза из бисера...",
    // probability: "50",
  ),
  ...List.generate(
      20,
      (index) => RowTableData(
            number: "4",
            type: "Репост",
            source: "Пользователь",
            contentText: "Яркая пышная роза из бисера \nцветы@magiya_bisera",
            originalText: "Ссылка...",
            date: "18.01.2019 19:19:21",
            // analyzedText: "Яркая пышная роза из бисера...",
            // probability: "1",
          ))
];

List<RowTableData> testDataAnalysis = [
  RowTableData(
    number: "1",
    type: "Репост",
    source: "Пользователь",
    contentText: "Яркая пышная роза из бисера \nцветы@magiya_bisera",
    originalText: "Ссылка...",
    date: "18.01.2019 19:19:21",
    analyzedText: "Яркая пышная роза из бисера...",
    probability: "1",
  ),
  RowTableData(
    number: "2",
    type: "Коментарий к посту/репосту",
    source: "Группа",
    contentText:
        "Нашли еще лазейку как к людям в карман залезть, а как кружки бесплатные создать ума не хватает. Когда уже уроды нахапаются, обдирают народ до нитки.",
    originalText: "Ссылка...",
    date: "04.01.2019 16:44:15",
    analyzedText:
        "Нашли еще лазейку как к людям в карман залезть, а как кружки бесплатные создать ума не хватает. Когда уже уроды нахапаются, обдирают народ до нитки.",
    probability: "86",
  ),
  RowTableData(
    number: "3",
    type: "Репост",
    source: "Пользователь",
    contentText: "Яркая пышная роза из бисера \nцветы@magiya_bisera",
    originalText: "Ссылка...",
    date: "18.01.2019 19:19:21",
    analyzedText: "Яркая пышная роза из бисера...",
    probability: "50",
  ),
  ...List.generate(
      20,
      (index) => RowTableData(
            number: "4",
            type: "Репост",
            source: "Пользователь",
            contentText: "Яркая пышная роза из бисера \nцветы@magiya_bisera",
            originalText: "Ссылка...",
            date: "18.01.2019 19:19:21",
            analyzedText: "Яркая пышная роза из бисера...",
            probability: "1",
          ))
];
