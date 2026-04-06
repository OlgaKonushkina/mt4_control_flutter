import 'connection.dart';

enum ConnectionType { mock }

class ConnectionFactory {
  static IConnection create(ConnectionType type, {
    String portName = 'COM3',
    int baudRate = 115200,
    String host = '127.0.0.1',
    int port = 10001,
  }) {
    switch (type) {
      case ConnectionType.mock:
        return MockConnection();
    }
  }
}