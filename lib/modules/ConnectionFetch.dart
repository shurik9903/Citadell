import 'dart:convert';
import 'dart:js';

import 'package:flutter_univ/main.dart';
import 'package:flutter_univ/modules/AnalysisFetch.dart';

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
    throw Exception(response.statusCode);
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

Future<dynamic> subscribeDataConnection(
    Stream<dynamic>? connection, Function callback) async {
  connection?.listen((value) async {
    Map<String, dynamic> data = jsonDecode(value) as Map<String, dynamic>;

    String type = data['type'] as String? ?? ' ';
    String message = data['message'] as String? ?? ' ';

    switch (type) {
      case 'MSG':
        {
          print('Message: ${message}');
        }
        break;
      case 'FileResult':
        {
          var data = jsonDecode(message);

          String fileName = data["fileName"].toString();
          String uuid = data["uuid"].toString();

          await getAnalysisFetch(uuid);
          callback(fileName, FileStatus.ready);
        }
        break;
      default:
        break;
    }
  });
}
