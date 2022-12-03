import 'dart:convert';

import 'package:http/http.dart' as http;

import '../data/UserData.dart';
import '../data/LoginData.dart';

Future<dynamic> loginFetch(String login, String password) async {
  var response = await http.get(
      Uri.parse('http://localhost:8080/FSB/api/login/$login/$password'),
      headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
      });

  if (response.statusCode == 200) {
    var data = response.body;

    final loginData = LoginData.fromJson(jsonDecode(data));

    if (loginData.msg != null) throw Exception(loginData.msg);

    var userData = UserData_Singleton();

    userData.id = loginData.userID ?? '';
    userData.login = loginData.userLogin ?? '';
    userData.token = loginData.token ?? '';

    // return "ok";
    return '';
  } else {
    print(response.statusCode);
    throw Exception(response.statusCode);
  }
}
