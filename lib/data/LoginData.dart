//Класс для хранения данных авторизации
class LoginData {
  LoginData({this.msg, this.login, this.token});

  final String? msg;
  final String? login;
  final String? token;

  factory LoginData.fromJson(Map<String, dynamic> data) {
    final msg = data['msg'] as String?;
    final login = data['login'] as String?;
    final token = data['token'] as String?;
    return LoginData(msg: msg, login: login, token: token);
  }
}
