import 'dart:convert';

import 'package:flutter_univ/data/Option.dart';

import '../data/UserData.dart';
import 'package:http/http.dart' as http;

Future<void> fileTeachingFetch(
    String fileName, int column, int select, int modelID) async {
  var userData = UserDataSingleton();
  var option = OptionSingleton();

  var response = await http.post(
    Uri.parse('${option.url}teaching'),
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
        'select': select.toString(),
        'modelID': modelID.toString(),
      },
    ),
  );

  if (response.statusCode == 200) {
    return;
  }

  throw Exception(response.body);
}

Future<void> getTeachingFetch(String uuid) async {
  var userData = UserDataSingleton();
  var option = OptionSingleton();

  print(uuid);

  var response =
      await http.get(Uri.parse('${option.url}teaching/result/$uuid'), headers: {
    "Content-type": "application/json",
    "Accept": "application/json",
    "token": userData.token,
    "login": userData.login,
  });

  if (response.statusCode == 200) {
    print('teaching result ${response.body}');
    return;
  }

  throw Exception(response.body);
}
