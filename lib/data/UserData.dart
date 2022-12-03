//абстрактный класс для хранения данных пользователя
abstract class UserDataBase {
  String _id = '';
  String _login = '';
  String _token = '';

  set id(String id) => _id = id;

  String get id => _id;

  set login(String login) => _login = login;

  String get login => _login;

  set token(String token) => _token = token;

  String get token => _token;
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
