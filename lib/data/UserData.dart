//абстрактный класс для хранения данных пользователя

import 'package:localstorage/localstorage.dart';

abstract class UserDataBase {
  final storage = new LocalStorage('userData.json');

  set login(String login) => storage.setItem('login', login);

  String get login => storage.getItem('login') ?? '';

  set token(String token) => storage.setItem('token', token);

  String get token => storage.getItem('token') ?? '';

  void clear() {
    storage.deleteItem('login');
    storage.deleteItem('token');
  }
}

//Singleton конструктор
class UserData_Singleton extends UserDataBase {
  static final UserData_Singleton _singleton =
      UserData_Singleton._constructor();

  factory UserData_Singleton() {
    return _singleton;
  }

  UserData_Singleton._constructor();
}
