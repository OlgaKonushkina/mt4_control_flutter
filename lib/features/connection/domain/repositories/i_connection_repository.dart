import '../../../../core/interfaces/connection.dart';
import '../entities/connection_config.dart';

abstract class IConnectionRepository {
  Stream<IConnection?> get connectionStream;
  IConnection? get currentConnection;
  bool get isConnected;

  Future<bool> connect(ConnectionConfig config);
  Future<void> disconnect();
}