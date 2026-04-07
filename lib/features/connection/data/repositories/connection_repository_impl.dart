import 'package:get_it/get_it.dart';
import '../../../../core/ble_connection.dart';
import '../../../../core/interfaces/connection.dart';
import '../../domain/entities/connection_config.dart';
import '../../domain/repositories/i_connection_repository.dart';
import '../../presentation/bloc/connection_state.dart';

final getIt = GetIt.instance;

class ConnectionRepositoryImpl implements IConnectionRepository {
  IConnection? _currentConnection;
  bool _isConnected = false;

  @override
  Stream<IConnection?> get connectionStream => throw UnimplementedError();

  @override
  IConnection? get currentConnection => _currentConnection;

  @override
  bool get isConnected => _isConnected;

  @override
  Future<ConnState> connect(ConnectionConfig config) async {
    await disconnect();

    IConnection? connection;

    switch (config.type) {
      case ConnectionType.emulator:
        connection = MockDeviceConnection();
        break;
      case ConnectionType.wifi:
        if (config.host == null || config.port == null) {
          return const ConnError('Wi-Fi: host or port missing');
        }
        connection = EthernetConnection(
          host: config.host!,
          port: config.port!,
        );
        break;
      case ConnectionType.bluetooth:
        connection = BleConnection();
        break;
      case ConnectionType.serial:
        return const ConnError('Serial not implemented');
    }

    final success = await connection.connect();
    if (success) {
      _currentConnection = connection;
      _isConnected = true;
      
      if (connection is BleConnection) {
        return ConnConnected(
          config,
          serviceUuid: connection.connectedServiceUuid,
          characteristicUuid: connection.connectedCharacteristicUuid,
        );
      }
      return ConnConnected(config);
    }
    return const ConnError('Failed to connect');
  }

  @override
  Future<void> disconnect() async {
    _currentConnection?.disconnect();
    _currentConnection = null;
    _isConnected = false;
  }
}