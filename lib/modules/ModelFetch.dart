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

    return data;
  }
  if (response.statusCode == 401) {
    throw Exception(response.statusCode);
  }

  print(response.statusCode);
  throw Exception(response.statusCode);
}
