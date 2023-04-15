import 'package:flutter_univ/data/AnalysisTextData.dart';

import '../data/UserData.dart';
import 'package:http/http.dart' as http;

Future<dynamic> fileFetch(String docid) async {
  var userData = UserData_Singleton();

  var response = await http.get(
      Uri.parse('http://localhost:8080/FSB/api/analysis/$docid'),
      headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "token": userData.token,
        "login": userData.login,
      });

  if (response.statusCode == 200) {
    var data = response.body;

    return '';
  } else {
    print(response.statusCode);
    throw Exception(response.statusCode);
  }
}

List<AnalysisTextData> testAnulysisText1 = [
  AnalysisTextData(text: "Яркая ", type: TextType.characteristic),
  AnalysisTextData(text: "пышная ", type: TextType.characteristic),
  AnalysisTextData(text: "роза ", type: TextType.object),
  AnalysisTextData(text: "из бисера. "),
  AnalysisTextData(text: "#"),
  AnalysisTextData(text: "цветы", type: TextType.object),
  AnalysisTextData(text: "@magiya_bisera"),
];

List<AnalysisTextData> testAnulysisText2 = [
  AnalysisTextData(text: "Нашли ещё лазейку как к "),
  AnalysisTextData(text: "людям ", type: TextType.object),
  AnalysisTextData(text: "в карман "),
  AnalysisTextData(text: "залезть ", type: TextType.action),
  AnalysisTextData(text: ", а как "),
  AnalysisTextData(text: "кружки ", type: TextType.object),
  AnalysisTextData(text: "бесплатные ", type: TextType.characteristic),
  AnalysisTextData(text: "создать ", type: TextType.action),
  AnalysisTextData(text: "ума не хватает. Когда уже "),
  AnalysisTextData(text: "уроды ", type: TextType.object),
  AnalysisTextData(text: "нахапаются ", type: TextType.action),
  AnalysisTextData(text: ", "),
  AnalysisTextData(text: "обдирают ", type: TextType.action),
  AnalysisTextData(text: "народ ", type: TextType.object),
  AnalysisTextData(text: "до нитки."),
];
