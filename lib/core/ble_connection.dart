import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../shared/app_events.dart';
import '../shared/event_bus.dart';
import 'connection.dart';

class BleConnection implements IConnection {
  BluetoothDevice? _device;
  BluetoothCharacteristic? _characteristic;
  bool _isConnected = false;

  @override
  bool connect() {
    _scanAndConnect();
    return true;
  }

  Future<void> _scanAndConnect() async {
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
    
    FlutterBluePlus.scanResults.listen((results) async {
      for (ScanResult result in results) {
        if (result.device.name.contains("ESP32")) {
          await FlutterBluePlus.stopScan();
          _device = result.device;
          await _device!.connect();
          _isConnected = true;
          await _discoverServices();
          return;
        }
      }
    });
  }

  Future<void> _discoverServices() async {
    List<BluetoothService> services = await _device!.discoverServices();
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.properties.write) {
          _characteristic = characteristic;
          await _characteristic!.setNotifyValue(true);
          _characteristic!.value.listen((data) {
            String response = String.fromCharCodes(data);
            if (response.contains('OK')) {
              eventBus.fire(CommandAcknowledgedEvent(response));
            }
          });
          return;
        }
      }
    }
  }

  @override
  void disconnect() {
    _device?.disconnect();
    _isConnected = false;
  }

  @override
  void sendCommand(String command, dynamic value) {
    if (_characteristic != null && _isConnected) {
      String cmd = 'MT-4 $command $value\0';
      _characteristic!.write(cmd.codeUnits);
    }
  }

  @override
  bool get isConnected => _isConnected;
}