import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../shared/app_events.dart';
import '../../shared/event_bus.dart';
import 'interfaces/connection.dart';

const String SERVICE_UUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
const String CHARACTERISTIC_UUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8";

class BleConnection implements IConnection {
  BluetoothDevice? _device;
  BluetoothCharacteristic? _characteristic;
  bool _isConnected = false;
  bool _isConnecting = false;
  
  String? connectedServiceUuid;
  String? connectedCharacteristicUuid;

  @override
  Future<bool> connect() async {
    if (_isConnecting) return false;
    _isConnecting = true;

    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
      
      BluetoothDevice? foundDevice;
      final subscription = FlutterBluePlus.scanResults.listen((results) {
        for (final result in results) {
          final name = result.device.name;
          if (name.contains('ESP32') || name.contains('MT4')) {
            foundDevice = result.device;
            debugPrint('[BLE] Found device: $name (${result.device.id.id})');
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
      debugPrint('[BLE] Service: ${service.uuid}');
      for (final characteristic in service.characteristics) {
        debugPrint('[BLE]   Characteristic: ${characteristic.uuid}');
        
        if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
          debugPrint('[BLE] Found target characteristic!');
          _characteristic = characteristic;
          connectedServiceUuid = service.uuid.toString();
          connectedCharacteristicUuid = characteristic.uuid.toString();
          await _characteristic!.setNotifyValue(true);
          _characteristic!.value.listen((data) {
            final response = String.fromCharCodes(data);
            debugPrint('[BLE] Received: $response');
            if (response.contains('OK')) {
              eventBus.fire(CommandAcknowledgedEvent(response));
            }
          });
          return;
        }
      }
    }
    
    if (_characteristic == null) {
      debugPrint('[BLE] Warning: Target characteristic not found!');
    }
  }

  @override
  void disconnect() {
    _device?.disconnect();
    _device = null;
    _characteristic = null;
    _isConnected = false;
    _isConnecting = false;
    connectedServiceUuid = null;
    connectedCharacteristicUuid = null;
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