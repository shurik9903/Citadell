import 'dart:convert';

import 'package:flutter_univ/data/UserData.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

const API_URL = "ws://localhost:8080/FSB/WSConnect";

class WebSocketService {
  WebSocketChannel? connection;

  close() async {
    connection?.sink.close(1000, 'Exit');
  }

  open() async {
    try {
      connection = WebSocketChannel.connect(Uri.parse("$API_URL"));
      return true;
    } catch (e) {
      print('WebSocket connection failed: ' + e.toString());
      return false;
    }
  }

  sendMessage() {
    var userData = UserDataSingleton();

    var JSONMessage = jsonEncode(<String, String>{
      'login': userData.login,
      'token': userData.token,
      'message': 'test'
    });

    connection?.sink.add(JSONMessage);
  }
}

class WebSocketServiceFactory {
  static var _Socket;

  static _createInstance() {
    return WebSocketService();
  }

  static createInstance() {
    WebSocketServiceFactory._Socket ??=
        WebSocketServiceFactory._createInstance();
    return WebSocketServiceFactory._Socket;
  }
}
