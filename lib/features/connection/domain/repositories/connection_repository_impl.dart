import 'package:get_it/get_it.dart';
import '../../../../core/interfaces/connection.dart';
import '../../domain/entities/connection_config.dart';
import '../../domain/repositories/i_connection_repository.dart';

final getIt = GetIt.instance;

class ConnectionRepositoryImpl implements IConnectionRepository {
  IConnection? _currentConnection;
  ConnectionConfig? _currentConfig;
  bool _isConnected = false;

  @override
  Stream<IConnection?> get connectionStream => throw UnimplementedError();

  @override
  IConnection? get currentConnection => _currentConnection;

  @override
  bool get isConnected => _isConnected;

  @override
  Future<bool> connect(ConnectionConfig config) async {
    await disconnect();

    IConnection? connection;

    switch (config.type) {
      case ConnectionType.emulator:
        connection = MockDeviceConnection();
        break;
      case ConnectionType.wifi:
        if (config.host == null || config.port == null) {
          return false;
        }
        connection = EthernetConnection(
          host: config.host!,
          port: config.port!,
        );
        break;
      case ConnectionType.bluetooth:
        return false;
      case ConnectionType.serial:
        return false;
    }

    final success = await connection.connect();
    if (success) {
      _currentConnection = connection;
      _currentConfig = config;
      _isConnected = true;
      
      if (getIt.isRegistered<IConnection>()) {
        getIt.unregister<IConnection>();
      }
      getIt.registerSingleton<IConnection>(connection);
      
      return true;
    }
    return false;
  }

  @override
  Future<void> disconnect() async {
    _currentConnection?.disconnect();
    _currentConnection = null;
    _currentConfig = null;
    _isConnected = false;
    
    if (getIt.isRegistered<IConnection>()) {
      getIt.unregister<IConnection>();
    }
  }
}