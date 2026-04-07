import 'package:equatable/equatable.dart';
import 'package:mt4_control/features/connection/domain/entities/connection_config.dart';

abstract class ConnectionEvent extends Equatable {
  const ConnectionEvent();

  @override
  List<Object?> get props => [];
}

class ConnectEvent extends ConnectionEvent {
  final ConnectionConfig config;

  const ConnectEvent(this.config);

  @override
  List<Object?> get props => [config.type, config.host, config.port, config.deviceName];
}

class DisconnectEvent extends ConnectionEvent {}

class ChangeConnectionTypeEvent extends ConnectionEvent {
  final ConnectionType type;

  const ChangeConnectionTypeEvent(this.type);

  @override
  List<Object?> get props => [type];
}

