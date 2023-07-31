//абстрактный класс для хранения данных пользователя

import 'package:localstorage/localstorage.dart';

abstract class OptionBase {
  final storage = LocalStorage('option.json');

  String get url => 'http://$serverIP:$serverPort/$serverName/$serverAPI/';

  set serverIP(String serverIP) => storage.setItem('serverIP', serverIP);

  String get serverIP => storage.getItem('serverIP') ?? 'localhost';

  set serverAPI(String serverAPI) => storage.setItem('serverAPI', serverAPI);

  String get serverAPI => storage.getItem('serverAPI') ?? 'api';

  set serverName(String serverName) =>
      storage.setItem('serverName', serverName);

  String get serverName => storage.getItem('serverName') ?? 'Citadel';

  set serverPort(String serverPort) =>
      storage.setItem('serverPort', serverPort);

  String get serverPort => storage.getItem('serverPort') ?? '8080';

  void clear() {
    storage.deleteItem('serverIP');
    storage.deleteItem('serverAPI');
    storage.deleteItem('serverName');
    storage.deleteItem('serverPort');
  }
}

//Singleton конструктор
class OptionSingleton extends OptionBase {
  static final OptionSingleton _singleton = OptionSingleton._constructor();

  factory OptionSingleton() {
    return _singleton;
  }

  OptionSingleton._constructor();
}
