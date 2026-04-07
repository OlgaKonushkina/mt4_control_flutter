enum ConnectionType { emulator, wifi, bluetooth, serial }

class ConnectionConfig {
  final ConnectionType type;
  final String? host;
  final int? port;
  final String? deviceName;

  ConnectionConfig({
    required this.type,
    this.host,
    this.port,
    this.deviceName,
  });
}