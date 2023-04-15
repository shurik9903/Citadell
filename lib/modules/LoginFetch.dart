import 'dart:convert';

import 'package:http/http.dart' as http;

import '../data/UserData.dart';
import '../data/LoginData.dart';

Future<dynamic> loginFetch(String login, String password) async {
  var response = await http.post(
      Uri.parse('http://localhost:8080/FSB/api/login'),
      headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(<String, String>{'password': password, 'login': login}));

  if (response.statusCode == 200) {
    var data = response.body;

    final loginData = LoginData.fromJson(jsonDecode(data));

    if (loginData.msg != null) throw Exception(loginData.msg);

    var userData = UserData_Singleton();

    userData.login = loginData.login ?? '';
    userData.token = loginData.token ?? '';

    // return "ok";
    return '';
  } else {
    print(response.statusCode);
    throw Exception(response.statusCode);
  }
}
