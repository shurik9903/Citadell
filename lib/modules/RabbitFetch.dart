import 'dart:convert';

import 'package:http/http.dart' as http;

Future<dynamic> rabbitFetch() async {
  var response =
      await http.get(Uri.parse('http://localhost:8080/FSB/api/test'), headers: {
    "Content-type": "application/json",
    "Accept": "application/json",
  });

  if (response.statusCode == 200) {
    var data = response.body;

    print(data);

    // return "ok";
    return '';
  } else {
    print(response.statusCode);
    throw Exception(response.statusCode);
  }
}
