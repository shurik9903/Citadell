//Класс для хранения данных авторизации
class LoginData {
  LoginData({required this.login, required this.token});

  final String login;
  final String token;

  factory LoginData.fromJson(Map<String, dynamic> data) {
    final login = data['login'];
    final token = data['token'];
    return LoginData(login: login, token: token);
  }
}
