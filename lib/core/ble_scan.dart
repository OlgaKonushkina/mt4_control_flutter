import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BleScanResult {
  final BluetoothDevice device;
  final String name;
  final String id;

  BleScanResult(this.device, this.name, this.id);
}

Future<List<BleScanResult>> scanForDevices() async {
  final List<BleScanResult> devices = [];
  final Completer<List<BleScanResult>> completer = Completer();

  // Запрашиваем разрешения
  final permissions = await [
    Permission.bluetooth,
    Permission.bluetoothScan,
    Permission.bluetoothConnect,
    Permission.location,
  ].request();

  if (permissions[Permission.bluetooth] != PermissionStatus.granted ||
      permissions[Permission.bluetoothScan] != PermissionStatus.granted ||
      permissions[Permission.bluetoothConnect] != PermissionStatus.granted ||
      permissions[Permission.location] != PermissionStatus.granted) {
    debugPrint('[BLE] Permissions denied');
    return [];
  }

  try {
    debugPrint('[BLE] Starting scan...');
    
    // Подписываемся на результаты
    final subscription = FlutterBluePlus.scanResults.listen((results) {
      for (final result in results) {
        final name = result.device.name;
        final id = result.device.id.id;
        debugPrint('[BLE] Found: "$name", ID: $id');
        
        // Добавляем устройство, если его ещё нет
        if (!devices.any((d) => d.id == id)) {
          devices.add(BleScanResult(
            result.device,
            name.isEmpty ? 'Unknown' : name,
            id,
          ));
        }
      }
    });
    
    // Запускаем сканирование на 5 секунд
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
    
    // Ждём завершения сканирования
    await Future.delayed(const Duration(seconds: 5));
    
    // Останавливаем
    await subscription.cancel();
    await FlutterBluePlus.stopScan();
    
    debugPrint('[BLE] Scan finished, found ${devices.length} devices');
  } catch (e) {
    debugPrint('[BLE] Scan error: $e');
  }
  
  return devices;
}