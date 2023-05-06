import '../data/Option.dart';
import '../data/UserData.dart';
import 'package:http/http.dart' as http;

Future<dynamic> dictionaryFetch(String word) async {
  var userData = UserDataSingleton();
  var option = OptionSingleton();

  var response =
      await http.get(Uri.parse('${option.url}dictionary/$word'), headers: {
    "Content-type": "application/json",
    "Accept": "application/json",
    "token": userData.token,
    "login": userData.login,
  });

  if (response.statusCode == 200) {
    var data = response.body;

    return '';
  }
  if (response.statusCode == 401) {
    userData.exit();
    return;
  }

  print(response.statusCode);
  throw Exception(response.statusCode);
}
