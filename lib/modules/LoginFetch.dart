import 'dart:convert';

import 'package:http/http.dart' as http;

import '../data/Option.dart';
import '../data/UserData.dart';
import '../data/LoginData.dart';

Future<dynamic> loginFetch(String login, String password) async {
  var option = OptionSingleton();

  var response = await http.post(Uri.parse('${option.url}login'),
      headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(<String, String>{'password': password, 'login': login}));

  if (response.statusCode == 200) {
    var data = response.body;

    final loginData = LoginData.fromJson(jsonDecode(data));

    if (loginData.msg != null) throw Exception(loginData.msg);

    var userData = UserDataSingleton();

    userData.login = loginData.login ?? '';
    userData.token = loginData.token ?? '';

    print(loginData.msg);

    return '';
  }
  if (response.statusCode == 401) {
    throw Exception(response.statusCode);
  }

  print(response.statusCode);
  throw Exception(response.statusCode);
}
