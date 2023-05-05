//абстрактный класс для хранения данных пользователя

import 'package:localstorage/localstorage.dart';

abstract class UserDataBase {
  final storage = LocalStorage('userData.json');
  Function? _exitCallback;

  Function? get exitCallback => _exitCallback;

  set exitCallback(Function? exitCallback) {
    _exitCallback = exitCallback;
  }

  set login(String login) => storage.setItem('login', login);

  String get login => storage.getItem('login') ?? '';

  set token(String token) => storage.setItem('token', token);

  String get token => storage.getItem('token') ?? '';

  void clear() {
    storage.deleteItem('login');
    storage.deleteItem('token');
  }

  void exit() {
    clear();
    if (exitCallback != null) {
      exitCallback!();
    }
  }
}

//Singleton конструктор
class UserDataSingleton extends UserDataBase {
  static final UserDataSingleton _singleton = UserDataSingleton._constructor();

  factory UserDataSingleton() {
    return _singleton;
  }

  UserDataSingleton._constructor();
}
