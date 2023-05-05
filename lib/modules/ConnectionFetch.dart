import 'dart:convert';

import '../data/Option.dart';
import '../data/UserData.dart';
import 'package:http/http.dart' as http;

Future<dynamic> connectionFetch() async {
  var userData = UserDataSingleton();
  var option = OptionSingleton();

  var response = await http.get(Uri.parse('${option.url}ping'), headers: {
    "Content-type": "application/json",
    "Accept": "application/json"
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

Future<dynamic> callConnection(Function(bool connect) callback) async {
  connectionFetch().then((value) {
    callback(true);
  }).catchError((error) {
    callback(false);
  });

  while (true) {
    await Future.delayed(
      const Duration(seconds: 5),
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

Future<dynamic> subscribeDataConnection(Stream<dynamic>? connection) async {
  connection?.listen((data) {
    data = jsonDecode(data) as Map<String, dynamic>;

    String type = data['type'] as String? ?? ' ';
    String message = data['message'] as String? ?? ' ';

    switch (type) {
      case 'MSG':
        {
          print('Message: ${message}');
        }
        break;
      case 'FILE':
        {
          print('File: ${message}');
        }
        break;
      default:
        break;
    }
  });
}
