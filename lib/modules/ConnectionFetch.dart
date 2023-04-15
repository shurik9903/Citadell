import '../data/UserData.dart';
import 'package:http/http.dart' as http;

Future<dynamic> connectionFetch() async {
  var userData = UserData_Singleton();

  var response = await http.get(Uri.parse('http://localhost:8080/FSB/api/ping'),
      headers: {
        "Content-type": "application/json",
        "Accept": "application/json"
      });

  if (response.statusCode == 200) {
    var data = response.body;

    return '';
  } else {
    print(response.statusCode);
    throw Exception(response.statusCode);
  }
}

Future<dynamic> callConnection(Function(bool connect) callback) async {
  connectionFetch().then((value) {
    callback(true);
  }).catchError((error) {
    callback(false);
  });

  while (true) {
    await Future.delayed(
      const Duration(seconds: 10),
      () {
        connectionFetch().then((value) {
          callback(true);
        }).catchError((error) {
          callback(false);
        });
      },
    );
  }
}
