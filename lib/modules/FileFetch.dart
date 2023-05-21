import 'dart:convert';
import 'package:flutter_univ/data/FileData.dart';
import 'package:flutter_univ/widgets/DialogWindowWidgets/FileDialog.dart';
import 'package:http/http.dart' as http;
import '../data/Option.dart';
import '../data/UserData.dart';

Future<dynamic> getFileFetch(String fileName) async {
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
    var data = response.body;
    var msg = jsonDecode(data)["Msg"];

    if (msg != '') {
      print("msg $msg");
      throw Exception(msg);
    }

    return '';
  }

  if (response.statusCode == 401) {
    throw Exception(response.statusCode);
  }

  print(response.statusCode);
  throw Exception(response.statusCode);
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
    var msg = jsonDecode(data)["Msg"];
    var replace = jsonDecode(data)["Replace"];

    if (msg != '') {
      print(msg);
      throw Exception(msg);
    }

    return replace;
  }
  if (response.statusCode == 401) {
    throw Exception(response.statusCode);
  }

  print(response.statusCode);
  throw Exception(response.statusCode);
}

Future<dynamic> getAllUserFileFetch() async {
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
    var msg = jsonDecode(data)["Msg"];

    if (msg != null && msg != '') {
      print(msg);
      throw Exception(msg);
    }

    final docData = jsonDecode(data)["Files"];

    List<FileData>? files = jsonDecode(docData)
        .map<FileData>((value) => FileData.fromJson(value))
        .toList();

    return files;
  }
  if (response.statusCode == 401) {
    throw Exception(response.statusCode);
  }

  print(response.statusCode);
  throw Exception(response.statusCode);
}

Future<dynamic> getDocFetch(String name,
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
    var msg = jsonDecode(data)["Msg"];

    if (msg != '') {
      print(msg);
      throw Exception(msg);
    }

    final docData = DocData.fromJson(jsonDecode(data));
    return docData;
  }

  if (response.statusCode == 401) {
    throw Exception(response.statusCode);
  }

  print(response.statusCode);
  throw Exception(response.statusCode);
}

Future<dynamic> rewriteFileFetch(String docName) async {
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
    var data = response.body;
    var msg = jsonDecode(data)["Msg"];

    if (msg != '') {
      print(msg);
      throw Exception(msg);
    }

    return "";
  }
  if (response.statusCode == 401) {
    throw Exception(response.statusCode);
  }

  print(response.statusCode);
  throw Exception(response.statusCode);
}

Future<dynamic> updateDocFetch(String docName, String docData) async {
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
    var data = response.body;
    var msg = jsonDecode(data)["Msg"];

    if (msg != '') {
      print(msg);
      throw Exception(msg);
    }

    return "";
  }
  if (response.statusCode == 401) {
    throw Exception(response.statusCode);
  }

  print(response.statusCode);
  throw Exception(response.statusCode);
}
