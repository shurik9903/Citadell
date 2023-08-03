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
    return '';
  }
  if (response.statusCode == 401) {
    throw Exception(response.statusCode);
  }

  print(response.statusCode);
  throw Exception(response.statusCode);
}
