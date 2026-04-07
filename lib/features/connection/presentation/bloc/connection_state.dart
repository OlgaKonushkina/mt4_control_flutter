import 'package:equatable/equatable.dart';
import '../../domain/entities/connection_config.dart';

abstract class ConnState extends Equatable {
  const ConnState();

  @override
  List<Object?> get props => [];
}

class ConnInitial extends ConnState {}

class ConnConnecting extends ConnState {
  final ConnectionConfig config;

  const ConnConnecting(this.config);

  @override
  List<Object?> get props => [config.type];
}

class ConnConnected extends ConnState {
  final ConnectionConfig config;

  const ConnConnected(this.config);

  @override
  List<Object?> get props => [config.type];
}

class ConnDisconnected extends ConnState {}

class ConnError extends ConnState {
  final String message;

  const ConnError(this.message);

  @override
  List<Object?> get props => [message];
}