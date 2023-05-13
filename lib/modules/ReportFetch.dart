import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_univ/data/Option.dart';
import 'package:flutter_univ/data/UserData.dart';

Future<dynamic> getReportFetch(String name, String row) async {
  var userData = UserDataSingleton();
  var option = OptionSingleton();

  var response = await http
      .get(Uri.parse('${option.url}report?name=$name&row=$row'), headers: {
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

    final report = jsonDecode(data)["report"];
    return report;
  }

  if (response.statusCode == 401) {
    throw Exception(response.statusCode);
  }

  print(response.statusCode);
  throw Exception(response.statusCode);
}
