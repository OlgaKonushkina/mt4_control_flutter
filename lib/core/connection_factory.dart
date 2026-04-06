import 'interfaces/connection.dart';

enum ConnectionType { mock, ethernet, ble }

class ConnectionFactory {
  static IConnection create(ConnectionType type, {
    String host = '127.0.0.1',
    int port = 10001,
  }) {
    switch (type) {
      case ConnectionType.mock:
        return MockConnection();
      case ConnectionType.ethernet:
        return EthernetConnection(host: host, port: port);
      case ConnectionType.ble:
        // TODO: реализовать BleConnection
        return MockConnection();
    }
  }
}