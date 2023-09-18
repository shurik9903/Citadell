import 'dart:convert';

import 'package:flutter_univ/data/SimpleWordData.dart';
import 'package:flutter_univ/data/SpellingWordData.dart';

import '../data/Option.dart';
import '../data/UserData.dart';
import 'package:http/http.dart' as http;

Future<List<SimpleWordData>> getAllSimpleWordFetch() async {
  var userData = UserDataSingleton();
  var option = OptionSingleton();

  var response =
      await http.get(Uri.parse('${option.url}dictionary/simple'), headers: {
    "Content-type": "application/json",
    "Accept": "application/json",
    "token": userData.token,
    "login": userData.login,
  });

  if (response.statusCode == 200) {
    var data = response.body;

    List<SimpleWordData>? words = jsonDecode(jsonDecode(data)["words"]) != null
        ? (jsonDecode(jsonDecode(data)["words"]) as List<dynamic>).map((e) {
            return SimpleWordData.fromJson(e);
          }).toList()
        : [];

    return words;
  }
  if (response.statusCode == 401) {
    throw Exception(response.statusCode);
  }

  print(response.statusCode);
  throw Exception(response.statusCode);
}

Future<List<SpellingWordData>> getAllSpellingWordFetch() async {
  var userData = UserDataSingleton();
  var option = OptionSingleton();

  var response =
      await http.get(Uri.parse('${option.url}dictionary/spelling'), headers: {
    "Content-type": "application/json",
    "Accept": "application/json",
    "token": userData.token,
    "login": userData.login,
  });

  if (response.statusCode == 200) {
    var data = response.body;

    List<SpellingWordData> words = jsonDecode(jsonDecode(data)["words"]) != null
        ? (jsonDecode(jsonDecode(data)["words"]) as List<dynamic>).map((e) {
            return SpellingWordData.fromJson(e);
          }).toList()
        : [];

    return words;
  }
  throw Exception(response.body);
}

Future<void> addSimpleWordFetch(
    {required String word, String? description, required int typeID}) async {
  var userData = UserDataSingleton();
  var option = OptionSingleton();

  var response = await http.post(Uri.parse('${option.url}dictionary/simple'),
      headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "token": userData.token,
        "login": userData.login,
      },
      body: jsonEncode(
          {"word": word, "typeID": typeID, 'description': description}));

  if (response.statusCode == 200) {
    return;
  }
  if (response.statusCode == 401) {
    throw Exception(response.body);
  }

  print(response.statusCode);
  throw Exception(response.body);
}

Future<void> addSpellingWordFetch(
    {required String word, String? description, required int simpleID}) async {
  var userData = UserDataSingleton();
  var option = OptionSingleton();

  var response = await http.post(Uri.parse('${option.url}dictionary/spelling'),
      headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "token": userData.token,
        "login": userData.login,
      },
      body: jsonEncode(
          {"word": word, "simpleID": simpleID, 'description': description}));

  if (response.statusCode == 200) {
    return;
  }
  if (response.statusCode == 401) {
    throw Exception(response.body);
  }

  print(response.statusCode);
  throw Exception(response.body);
}

Future<void> deleteSimpleWordFetch(int id) async {
  var userData = UserDataSingleton();
  var option = OptionSingleton();

  var response = await http.delete(
    Uri.parse('${option.url}dictionary/simple/$id'),
    headers: {
      "Content-type": "application/json",
      "Accept": "application/json",
      "token": userData.token,
      "login": userData.login,
    },
  );

  if (response.statusCode == 200) {
    return;
  }
  if (response.statusCode == 401) {
    throw Exception(response.body);
  }

  print(response.statusCode);
  throw Exception(response.body);
}

Future<void> deleteSpellingWordFetch(int id) async {
  var userData = UserDataSingleton();
  var option = OptionSingleton();

  var response = await http.delete(
    Uri.parse('${option.url}dictionary/spelling/$id'),
    headers: {
      "Content-type": "application/json",
      "Accept": "application/json",
      "token": userData.token,
      "login": userData.login,
    },
  );

  if (response.statusCode == 200) {
    return;
  }
  if (response.statusCode == 401) {
    throw Exception(response.body);
  }

  print(response.statusCode);
  throw Exception(response.body);
}

Future<void> updateSimpleWordFetch(
    {required int id, String? word, String? description, int? typeID}) async {
  var userData = UserDataSingleton();
  var option = OptionSingleton();

  var response = await http.put(Uri.parse('${option.url}dictionary/simple/'),
      headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "token": userData.token,
        "login": userData.login,
      },
      body: jsonEncode(<String, dynamic>{
        'id': id,
        'word': word,
        'description': description,
        'typeID': typeID
      }));

  if (response.statusCode == 200) {
    return;
  }
  if (response.statusCode == 401) {
    throw Exception(response.body);
  }

  print(response.statusCode);
  throw Exception(response.body);
}

Future<void> updateSpellingWordFetch(
    {required int id, String? word, String? description}) async {
  var userData = UserDataSingleton();
  var option = OptionSingleton();

  var response = await http.put(Uri.parse('${option.url}dictionary/spelling/'),
      headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "token": userData.token,
        "login": userData.login,
      },
      body: jsonEncode(<String, dynamic>{
        'id': id,
        'word': word,
        'description': description,
      }));

  if (response.statusCode == 200) {
    return;
  }
  if (response.statusCode == 401) {
    throw Exception(response.body);
  }

  print(response.statusCode);
  throw Exception(response.body);
}
