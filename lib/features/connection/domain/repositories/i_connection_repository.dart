import '../../../../core/interfaces/connection.dart';
import '../entities/connection_config.dart';
import '../../presentation/bloc/connection_state.dart';

abstract class IConnectionRepository {
  Stream<IConnection?> get connectionStream;
  IConnection? get currentConnection;
  bool get isConnected;

  Future<ConnState> connect(ConnectionConfig config);
  Future<void> disconnect();
}