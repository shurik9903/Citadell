import 'dart:convert';
import 'package:flutter_univ/data/FileData.dart';
import 'package:http/http.dart' as http;
import '../data/Option.dart';
import '../data/UserData.dart';

Future<void> getFileFetch(String fileName) async {
  var userData = UserDataSingleton();
  var option = OptionSingleton();
  var response =
      await http.get(Uri.parse('${option.url}file?name=$fileName'), headers: {
    "Content-type": "application/json",
    "Accept": "application/json",
    "token": userData.token,
    "login": userData.login,
  });

  if (response.statusCode == 200) {
    return;
  }

  throw Exception(response.body);
}

Future<dynamic> saveFileFetch(String fileData) async {
  var userData = UserDataSingleton();
  var option = OptionSingleton();
  var response = await http.post(
    Uri.parse('${option.url}file'),
    headers: {
      "Content-type": "application/json",
      "Accept": "application/json",
      "token": userData.token,
      "login": userData.login,
    },
    body: fileData,
  );

  if (response.statusCode == 200) {
    var data = response.body;
    var replace = jsonDecode(data)["Replace"];
    return replace;
  }
  throw Exception(response.body);
}

Future<List<FileData>?> getAllUserFileFetch() async {
  var userData = UserDataSingleton();
  var option = OptionSingleton();

  var response = await http.get(Uri.parse('${option.url}doc'), headers: {
    "Content-type": "application/json",
    "Accept": "application/json",
    "token": userData.token,
    "login": userData.login,
  });

  if (response.statusCode == 200) {
    var data = response.body;
    final docData = jsonDecode(data)["Files"];

    List<FileData>? files = jsonDecode(docData)
        .map<FileData>((value) => FileData.fromJson(value))
        .toList();

    return files;
  }
  throw Exception(response.body);
}

Future<DocData> getDocFetch(String name,
    {int start = 1, int diapason = 25}) async {
  var userData = UserDataSingleton();
  var option = OptionSingleton();

  var response = await http.get(
      Uri.parse('${option.url}doc?name=$name&start=$start&diapason=$diapason'),
      headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "token": userData.token,
        "login": userData.login,
      });

  if (response.statusCode == 200) {
    var data = response.body;
    final docData = DocData.fromJson(jsonDecode(data));

    return docData;
  }

  throw Exception(response.body);
}

Future<void> rewriteFileFetch(String docName) async {
  var userData = UserDataSingleton();
  var option = OptionSingleton();

  var response =
      await http.put(Uri.parse('${option.url}file?name=$docName'), headers: {
    "Content-type": "application/json",
    "Accept": "application/json",
    "token": userData.token,
    "login": userData.login,
  });

  if (response.statusCode == 200) {
    return;
  }

  throw Exception(response.body);
}

Future<void> updateDocFetch(String docName, String docData) async {
  var userData = UserDataSingleton();
  var option = OptionSingleton();

  var response = await http.put(Uri.parse('${option.url}doc?name=$docName'),
      headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "token": userData.token,
        "login": userData.login,
      },
      body: docData);

  if (response.statusCode == 200) {
    return;
  }

  throw Exception(response.body);
}

Future<void> deleteFileFetch(String fileName) async {
  var userData = UserDataSingleton();
  var option = OptionSingleton();
  var response = await http
      .delete(Uri.parse('${option.url}file?name=$fileName'), headers: {
    "Content-type": "application/json",
    "Accept": "application/json",
    "token": userData.token,
    "login": userData.login,
  });

  if (response.statusCode == 200) {
    return;
  }

  throw Exception(response.body);
}
