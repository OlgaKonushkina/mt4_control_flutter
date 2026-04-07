import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../shared/app_events.dart';
import '../shared/event_bus.dart';
import 'interfaces/connection.dart';

class BleConnection implements IConnection {
  BluetoothDevice? _device;
  BluetoothCharacteristic? _characteristic;
  bool _isConnected = false;
  bool _isConnecting = false;

  @override
  Future<bool> connect() async {
    if (_isConnecting) return false;
    _isConnecting = true;

    try {
      debugPrint('[BLE] Starting scan...');
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
      
      BluetoothDevice? foundDevice;
      final subscription = FlutterBluePlus.scanResults.listen((results) {
        for (final result in results) {
          debugPrint('[BLE] Found device: ${result.device.name}');
          if (result.device.name.contains('ESP32') || result.device.name.contains('MT4')) {
            foundDevice = result.device;
          }
        }
      });
      
      await Future.delayed(const Duration(seconds: 5));
      await subscription.cancel();
      await FlutterBluePlus.stopScan();
      
      if (foundDevice == null) {
        debugPrint('[BLE] No device found');
        _isConnecting = false;
        return false;
      }
      
      _device = foundDevice;
      debugPrint('[BLE] Connecting to ${_device!.name}...');
      await _device!.connect();
      _isConnected = true;
      await _discoverServices();
      
      _isConnecting = false;
      debugPrint('[BLE] Connected successfully');
      return true;
    } catch (e) {
      debugPrint('[BLE] Connection error: $e');
      _isConnecting = false;
      return false;
    }
  }

  Future<void> _discoverServices() async {
    final services = await _device!.discoverServices();
    for (final service in services) {
      for (final characteristic in service.characteristics) {
        if (characteristic.properties.write) {
          _characteristic = characteristic;
          await _characteristic!.setNotifyValue(true);
          _characteristic!.value.listen((data) {
            final response = String.fromCharCodes(data);
            debugPrint('[BLE] Received: $response');
            if (response.contains('OK')) {
              eventBus.fire(CommandAcknowledgedEvent(response));
            }
          });
          debugPrint('[BLE] Characteristic found');
          return;
        }
      }
    }
    debugPrint('[BLE] No writable characteristic found');
  }

  @override
  void disconnect() {
    _device?.disconnect();
    _device = null;
    _characteristic = null;
    _isConnected = false;
    _isConnecting = false;
    debugPrint('[BLE] Disconnected');
  }

  @override
  void sendCommand(String command, dynamic value) {
    if (_characteristic != null && _isConnected) {
      final cmd = 'MT-4 $command $value\0';
      debugPrint('[BLE] Sending: $cmd');
      _characteristic!.write(cmd.codeUnits);
    }
  }

  @override
  bool get isConnected => _isConnected;
}