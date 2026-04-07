import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../shared/app_events.dart';
import '../../shared/event_bus.dart';

abstract class IConnection {
  Future<bool> connect();
  void disconnect();
  void sendCommand(String command, dynamic value);
  bool get isConnected;
}

class MockDeviceConnection implements IConnection {
  bool _isConnected = false;

  @override
  Future<bool> connect() async {
    _isConnected = true;
    debugPrint('[MockDevice] Connected');
    return true;
  }

  @override
  void disconnect() {
    _isConnected = false;
    debugPrint('[MockDevice] Disconnected');
  }

  @override
  void sendCommand(String command, dynamic value) {
    debugPrint('[MockDevice] Received: MT-4 $command $value');
    
    Future.delayed(const Duration(milliseconds: 100), () {
      String response;
      
      if (command == 'GTR_F' || command == 'PS_F') {
        final freq = double.tryParse(value.toString());
        if (freq != null && freq >= 100.0 && freq <= 999.9999) {
          response = 'OK $command $value';
        } else {
          response = '?$command $value';
        }
      } else {
        response = 'OK $command $value';
      }
      
      debugPrint('[MockDevice] Response: $response');
      eventBus.fire(CommandAcknowledgedEvent(response));
    });
  }

  @override
  bool get isConnected => _isConnected;
}

class EthernetConnection implements IConnection {
  Socket? _socket;
  final String host;
  final int port;
  bool _isConnecting = false;

  EthernetConnection({required this.host, required this.port});

  @override
  Future<bool> connect() async {
    if (_isConnecting) return false;
    _isConnecting = true;
    
    try {
      _socket = await Socket.connect(host, port).timeout(const Duration(seconds: 5));
      _socket?.listen((data) {
        final response = String.fromCharCodes(data).trim();
        if (response.contains('OK')) {
          eventBus.fire(CommandAcknowledgedEvent(response));
        }
      });
      _isConnecting = false;
      debugPrint('[Ethernet] Connected to $host:$port');
      return true;
    } catch (e) {
      _isConnecting = false;
      _socket = null;
      debugPrint('[Ethernet] Connection failed: $e');
      return false;
    }
  }

  @override
  void disconnect() {
    _socket?.close();
    _socket = null;
    _isConnecting = false;
    debugPrint('[Ethernet] Disconnected');
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

class MockConnection implements IConnection {
  @override
  Future<bool> connect() async => true;

  @override
  void disconnect() {}

  @override
  void sendCommand(String command, dynamic value) {}

  @override
  bool get isConnected => true;
}