import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

const API_URL = "ws://localhost:8080/FSB/subs";

class WebSocketService {
  WebSocketChannel? connection;

  close() async {
    connection?.sink.close();
  }

  open() async {
    try {
      connection = WebSocketChannel.connect(Uri.parse("$API_URL"));
    } catch (e) {
      print(e);
      return 'WebSocket connection failed';
    }
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
