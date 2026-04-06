import 'dart:io';
import '../shared/app_events.dart';
import '../shared/event_bus.dart';

abstract class IConnection {
  bool connect();
  void disconnect();
  void sendCommand(String command, dynamic value);
  bool get isConnected;
}

class MockConnection implements IConnection {
  @override
  bool connect() {
    return true;
  }

  @override
  void disconnect() {}

  @override
  void sendCommand(String command, dynamic value) {
    Future.delayed(const Duration(milliseconds: 100), () {
      eventBus.fire(CommandAcknowledgedEvent('OK $command $value'));
    });
  }

  @override
  bool get isConnected => true;
}

class EthernetConnection implements IConnection {
  Socket? _socket;
  final String host;
  final int port;

  EthernetConnection({required this.host, required this.port});

  @override
  bool connect() {
    try {
      Socket.connect(host, port).then((socket) {
        _socket = socket;
        _socket?.listen((data) {
          final response = String.fromCharCodes(data).trim();
          if (response.contains('OK')) {
            eventBus.fire(CommandAcknowledgedEvent(response));
          }
        });
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  void disconnect() {
    _socket?.close();
    _socket = null;
  }

  @override
  void sendCommand(String command, dynamic value) {
    if (_socket != null) {
      _socket!.write('MT-4 $command $value\0');
    }
  }

  @override
  bool get isConnected => _socket != null;
}