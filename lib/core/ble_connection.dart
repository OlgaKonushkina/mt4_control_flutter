import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../shared/app_events.dart';
import '../../shared/event_bus.dart';
import 'interfaces/connection.dart';

const String serviceUuid = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
const String characteristicUuid = "beb5483e-36e1-4688-b7f5-ea07361b26a8";

int _getCharacteristicPropertiesValue(CharacteristicProperties properties) {
  int value = 0;
  if (properties.read) value |= 0x02;
  if (properties.write) value |= 0x08;
  if (properties.notify) value |= 0x10;
  if (properties.indicate) value |= 0x20;
  if (properties.writeWithoutResponse) value |= 0x04;
  return value;
}

class BleConnection implements IConnection {
  BluetoothDevice? _device;
  BluetoothCharacteristic? _characteristic;
  bool _isConnected = false;
  bool _isConnecting = false;
  
  String? connectedServiceUuid;
  String? connectedCharacteristicUuid;
  List<String>? connectedCharacteristicProperties;
  int? connectedCharacteristicPropertiesValue;

  @override
  Future<bool> connect() async {
    if (_isConnecting) return false;
    _isConnecting = true;

    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
      
      BluetoothDevice? foundDevice;
      final subscription = FlutterBluePlus.scanResults.listen((results) {
        for (final result in results) {
          final name = result.device.platformName;
          if (name.contains('ESP32') || name.contains('MT4')) {
            foundDevice = result.device;
            debugPrint('[BLE] Found device: $name (${result.device.remoteId.str})');
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
      debugPrint('[BLE] Connecting to ${_device!.platformName}...');
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
        if (characteristic.uuid.toString() == characteristicUuid) {
          _characteristic = characteristic;
          connectedServiceUuid = service.uuid.toString();
          connectedCharacteristicUuid = characteristic.uuid.toString();
          
          final properties = <String>[];
          if (characteristic.properties.read) properties.add('READ');
          if (characteristic.properties.write) properties.add('WRITE');
          if (characteristic.properties.notify) properties.add('NOTIFY');
          if (characteristic.properties.indicate) properties.add('INDICATE');
          if (characteristic.properties.writeWithoutResponse) properties.add('WRITE_WO_RESP');
          connectedCharacteristicProperties = properties;
          connectedCharacteristicPropertiesValue = _getCharacteristicPropertiesValue(characteristic.properties);
          
          debugPrint('[BLE] Characteristic properties: $properties');
          debugPrint('[BLE] Characteristic properties value: $connectedCharacteristicPropertiesValue (0x${connectedCharacteristicPropertiesValue!.toRadixString(16)})');
          
          if (characteristic.properties.notify) {
            await characteristic.setNotifyValue(true);
            final valueStream = characteristic.lastValueStream;
            valueStream.listen((data) {
              final response = String.fromCharCodes(data);
              debugPrint('[BLE] Received: $response');
              if (response.contains('OK')) {
                eventBus.fire(CommandAcknowledgedEvent(response));
              }
            });
          }
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
    connectedCharacteristicProperties = null;
    connectedCharacteristicPropertiesValue = null;
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