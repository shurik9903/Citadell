//Класс для хранения данных авторизации
class LoginData {
  LoginData({this.msg, this.userID, this.userLogin, this.token});

  final String? msg;
  final String? userID;
  final String? userLogin;
  final String? token;

  factory LoginData.fromJson(Map<String, dynamic> data) {
    final msg = data['Msg'] as String?;
    final userID = data['UserID'] as String?;
    final userLogin = data['UserLogin'] as String?;
    final token = data['Token'] as String?;
    return LoginData(
        msg: msg, userID: userID, userLogin: userLogin, token: token);
  }
}
