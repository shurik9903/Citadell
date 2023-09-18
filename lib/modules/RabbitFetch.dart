import 'package:http/http.dart' as http;

import '../data/Option.dart';

Future<void> rabbitFetch() async {
  var option = OptionSingleton();

  var response = await http.get(Uri.parse('${option.url}test'), headers: {
    "Content-type": "application/json",
    "Accept": "application/json",
  });

  if (response.statusCode == 200) {
    return;
  }
  throw Exception(response.body);
}
