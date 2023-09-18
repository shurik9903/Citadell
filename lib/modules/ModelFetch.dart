import 'dart:convert';

import 'package:flutter_univ/data/ModelData.dart';
import 'package:flutter_univ/data/Option.dart';
import 'package:flutter_univ/data/UserData.dart';
import 'package:http/http.dart' as http;

Future<dynamic> getModelsFetch() async {
  var userData = UserDataSingleton();
  var option = OptionSingleton();

  var response = await http.get(Uri.parse('${option.url}models'), headers: {
    "Content-type": "application/json",
    "Accept": "application/json",
    "token": userData.token,
    "login": userData.login,
  });

  if (response.statusCode == 200) {
    var data = response.body;

    ModelData model = ModelData.fromJson(jsonDecode(data));
    List<ModelData> models =
        (jsonDecode(data)["Models"] as List<dynamic>).map((e) {
      return ModelData.fromJson(e);
    }).toList();

    return {'model': model, 'models': models};
  }
  throw Exception(response.body);
}

Future<void> updateModelsFetch(String newName, int id) async {
  var userData = UserDataSingleton();
  var option = OptionSingleton();

  var response = await http.put(
    Uri.parse('${option.url}models/$id'),
    headers: {
      "Content-type": "application/json",
      "Accept": "application/json",
      "token": userData.token,
      "login": userData.login,
    },
    body: jsonEncode(
      <String, String>{
        'NameModel': newName,
      },
    ),
  );

  if (response.statusCode == 200) {
    return;
  }
  throw Exception(response.body);
}
