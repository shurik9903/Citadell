import '../data/UserData.dart';
import 'package:http/http.dart' as http;

Future<dynamic> fileFetch(String docid) async {
  var userData = UserData_Singleton();

  var response = await http.get(
      Uri.parse('http://localhost:8080/FSB/api/analysis/$docid'),
      headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Token": userData.token,
      });

  if (response.statusCode == 200) {
    var data = response.body;

    return '';
  } else {
    print(response.statusCode);
    throw Exception(response.statusCode);
  }
}
