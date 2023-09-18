import 'dart:convert';
import 'package:flutter_univ/main.dart';
import 'package:flutter_univ/modules/AnalysisFetch.dart';
import 'package:flutter_univ/modules/TeachingFetch.dart';
import '../data/Option.dart';
import 'package:http/http.dart' as http;

Future<void> connectionFetch({String? address}) async {
  if (address == null) {
    var option = OptionSingleton();
    address = option.url;
  }

  var response = await http.get(Uri.parse('${address}ping'), headers: {
    "Content-type": "application/json",
    "Accept": "application/json"
  }).timeout(const Duration(seconds: 10));

  if (response.statusCode == 200) {
    return;
  }

  throw Exception(response.body);
}

Future<void> callConnection(Function(bool connect) callback) async {
  do {
    connectionFetch().then((value) {
      callback(true);
    }).catchError((error) {
      callback(false);
    });

    await Future.delayed(
      const Duration(seconds: 60),
    );
  } while (true);
}

Future<void> subscribeDataConnection(
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
      case 'FilePredictResult':
        {
          var data = jsonDecode(message);

          String fileName = data["fileName"].toString();
          String uuid = data["uuid"].toString();

          await getAnalysisFetch(uuid);
          callback(fileName, FileStatus.ready);
        }
        break;
      case 'FileTeachResult':
        {
          var data = jsonDecode(message);

          String fileName = data["fileName"].toString();
          String uuid = data["uuid"].toString();

          await getTeachingFetch(uuid);
          callback(fileName, FileStatus.ready);
        }
        break;
      default:
        break;
    }
  });
}
