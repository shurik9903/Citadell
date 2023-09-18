import 'dart:convert';

import 'package:flutter_univ/data/Option.dart';

import '../data/UserData.dart';
import 'package:http/http.dart' as http;

Future<void> fileAnalysisFetch(String fileName, int column, int select) async {
  var userData = UserDataSingleton();
  var option = OptionSingleton();

  var response = await http.post(
    Uri.parse('${option.url}analysis'),
    headers: {
      "Content-type": "application/json",
      "Accept": "application/json",
      "token": userData.token,
      "login": userData.login,
    },
    body: jsonEncode(
      <String, String>{
        'name': fileName,
        'column': column.toString(),
        'select': select.toString()
      },
    ),
  );

  if (response.statusCode == 200) {
    return;
  }

  throw Exception(response.body);
}

Future<void> getAnalysisFetch(String uuid) async {
  var userData = UserDataSingleton();
  var option = OptionSingleton();

  print(uuid);

  var response =
      await http.get(Uri.parse('${option.url}analysis/result/$uuid'), headers: {
    "Content-type": "application/json",
    "Accept": "application/json",
    "token": userData.token,
    "login": userData.login,
  });

  if (response.statusCode == 200) {
    return;
  }

  throw Exception(response.body);
}
