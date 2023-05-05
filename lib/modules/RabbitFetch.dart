import 'dart:convert';

import 'package:http/http.dart' as http;

import '../data/Option.dart';
import '../data/UserData.dart';

Future<dynamic> rabbitFetch() async {
  var option = OptionSingleton();

  var response = await http.get(Uri.parse('${option.url}test'), headers: {
    "Content-type": "application/json",
    "Accept": "application/json",
  });

  if (response.statusCode == 200) {
    var data = response.body;

    print(data);

    // return "ok";
    return '';
  }
  if (response.statusCode == 401) {
    UserDataSingleton().exit();
    return;
  }

  print(response.statusCode);
  throw Exception(response.statusCode);
}
