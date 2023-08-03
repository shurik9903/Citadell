//Класс для хранения данных авторизации
class LoginData {
  LoginData({this.login, this.token});

  final String? login;
  final String? token;

  factory LoginData.fromJson(Map<String, dynamic> data) {
    final login = data['login'] as String?;
    final token = data['token'] as String?;
    return LoginData(login: login, token: token);
  }
}
